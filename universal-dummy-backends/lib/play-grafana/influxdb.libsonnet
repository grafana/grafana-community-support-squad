local k = import 'ksonnet-util/kausal.libsonnet';

{
  local container = k.core.v1.container,
  local containerPort = k.core.v1.containerPort,
  local configMap = k.core.v1.configMap,
  local statefulset = k.apps.v1.statefulSet,
  local pvc = k.core.v1.persistentVolumeClaim,
  local volumeMount = k.core.v1.volumeMount,
  local volume = k.core.v1.volume,

  influxdb_configmap:
    configMap.new('influxdb-config') +
    configMap.mixin.metadata.withNamespace($._config.namespace) +
    configMap.withData({
      'influxdb.conf': importstr 'files/influxdb.conf',
    }),

  local influxdb_pvc =
    pvc.new('influxdb-pvc') +
    pvc.mixin.spec.resources.withRequests({ storage: $._config.influxdb.diskSize }) +
    pvc.mixin.spec.withAccessModes(['ReadWriteOnce']) +
    pvc.mixin.spec.withStorageClassName($._config.influxdb.storageClass),

  influxdb_container::
    container.new('influxdb', $._images.influxdb) +
    container.withImagePullPolicy('Always') +
    k.util.resourcesRequests('50m', '200Mi') +
    k.util.resourcesLimits('1', '5Gi') +
    container.withVolumeMountsMixin([
      volumeMount.new('influxdb-pvc', '/var/lib/influxdb2'),
    ]) +
    container.withEnv([
      { name: 'INFLUXDB_CONFIG_PATH', value: '/etc/influxdb/influxdb.conf' },
      { name: 'INFLUXDB_ADMIN_USER', value: 'grafana' },
      { name: 'INFLUXDB_ADMIN_PASSWORD', value: 'grafana001' },
      { name: 'INFLUXDB_DB', value: 'grafana' },
      { name: 'INFLUXDB_USER', value: 'gf-user' },
      { name: 'INFLUXDB_USER_PASSWORD', value: 'grafana001' },
    ]) +
    container.withTerminationMessagePath('/dev/termination-log') +
    container.withTerminationMessagePolicy('File'),

  local influxdb_labels = { app: 'influxdb', name: 'influxdb' },

  influxdb_statefulset:
    statefulset.new('influxdb', 1, [
      $.influxdb_container,
    ]) +
    statefulset.mixin.spec.withServiceName('influxdb') +
    statefulset.mixin.spec.template.spec.withVolumes([volume.fromPersistentVolumeClaim('influxdb-pvc', 'influxdb-pvc')]) +
    statefulset.mixin.metadata.withNamespace($._config.namespace) +
    statefulset.mixin.metadata.withLabels({ app: 'influxdb' }) +
    statefulset.mixin.spec.template.metadata.withLabels({ app: 'influxdb' }) +
    statefulset.mixin.spec.selector.withMatchLabels({ app: 'influxdb' }) +
    k.util.configVolumeMount('influxdb-config', '/etc/influxdb') +
    statefulset.mixin.spec.template.spec.withTerminationGracePeriodSeconds(30),

  local service = k.core.v1.service,
  local servicePort = k.core.v1.servicePort,
  influxdb_service:
    service.new(
      'influxdb',
      { app: $.influxdb_labels.name },
      [
        servicePort.newNamed('influxdb', 8086, 8086) + servicePort.withProtocol('TCP'),
      ]
    ) +
    service.mixin.spec.withType('NodePort') +
    service.mixin.metadata.withNamespace($._config.namespace) +
    service.mixin.metadata.withLabels({ app: 'influxdb' }) +
    k.core.v1.service.mixin.spec.withSessionAffinity('None') +
    k.core.v1.service.mixin.spec.withSelector({ app: 'influxdb' }),

}
