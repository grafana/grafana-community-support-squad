local k = import 'ksonnet-util/kausal.libsonnet';

{
  local container = k.core.v1.container,
  local containerPort = k.core.v1.containerPort,
  local configMap = k.core.v1.configMap,
  local statefulset = k.apps.v1.statefulSet,
  local pvc = k.core.v1.persistentVolumeClaim,
  local volumeMount = k.core.v1.volumeMount,
  local volume = k.core.v1.volume,

  graphite_configmap:
    configMap.new('graphite-config') +
    configMap.mixin.metadata.withNamespace($._config.namespace) +
    configMap.withData({
      'carbon.conf': importstr 'files/carbon.conf',
      'storage-aggregation.conf': importstr 'files/storage-aggregation.conf',
      'storage-schemas.conf': importstr 'files/storage-schemas.conf',
    }),

  local graphite_pvc =
    pvc.new('graphite-pvc') +
    pvc.mixin.spec.resources.withRequests({ storage: $._config.graphite.diskSize }) +
    pvc.mixin.spec.withAccessModes(['ReadWriteOnce']) +
    pvc.mixin.spec.withStorageClassName($._config.graphite.storageClass),

  graphite_container::
    container.new('graphite', $._images.graphite) +
    container.withImagePullPolicy('Always') +
    k.util.resourcesRequests('100m', '200Mi') +
    k.util.resourcesLimits('1', '1Gi') +
    container.withPorts([
      containerPort.new('web', 80) + containerPort.withProtocol('TCP'),
      containerPort.new('carbon', 2003) + containerPort.withProtocol('TCP'),
    ]) +
    container.withVolumeMountsMixin([
      volumeMount.new('graphite-pvc', '/var/lib/graphite/storage/whisper'),
    ]) +
    container.withTerminationMessagePath('/dev/termination-log') +
    container.withTerminationMessagePolicy('File'),

  graphite_fake_data_container::
    container.new('graphite-fake-data', $._images.graphite_fake_data_gen) +
    container.withImagePullPolicy('IfNotPresent') +
    container.withEnv([
      { name: 'FD_DATASOURCE', value: 'graphite' },
      { name: 'FD_SERVER', value: '127.0.0.1' },
      { name: 'FD_PORT', value: '2003' },
      { name: 'FD_IMPORT', value: ' ' },
    ]),

  local graphite_labels = { app: 'graphite', name: 'graphite' },

  graphite_statefulset:
    statefulset.new('graphite', 1, [
      $.graphite_container,
      $.graphite_fake_data_container,
    ]) +
    statefulset.mixin.spec.withServiceName('graphite') +
    statefulset.mixin.spec.template.spec.withVolumes([volume.fromPersistentVolumeClaim('graphite-pvc', 'graphite-pvc')]) +
    statefulset.mixin.metadata.withNamespace($._config.namespace) +
    statefulset.mixin.metadata.withLabels({ app: 'graphite' }) +
    statefulset.mixin.spec.template.metadata.withLabels({ app: 'graphite' }) +
    statefulset.mixin.spec.selector.withMatchLabels({ app: 'graphite' }) +
    k.util.configVolumeMount('graphite-config', '/var/lib/graphite/conf') +
    statefulset.mixin.spec.template.spec.withTerminationGracePeriodSeconds(30),

  local service = k.core.v1.service,
  local servicePort = k.core.v1.servicePort,
  graphite_service:
    service.new(
      'graphite',
      { app: $.graphite_labels.name },
      [
        servicePort.newNamed('web', 8080, 80) + servicePort.withProtocol('TCP'),
        servicePort.newNamed('carbon', 2003, 2003) + servicePort.withProtocol('TCP'),
      ]
    ) +
    service.mixin.spec.withType('NodePort') +
    service.mixin.metadata.withNamespace($._config.namespace) +
    service.mixin.metadata.withLabels({ app: 'graphite' }) +
    service.mixin.spec.withSessionAffinity('None') +
    service.mixin.spec.withSelector({ app: 'graphite' }),

}
