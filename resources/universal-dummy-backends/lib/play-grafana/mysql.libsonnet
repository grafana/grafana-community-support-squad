local k = import 'ksonnet-util/kausal.libsonnet';

{
  local container = k.core.v1.container,
  local containerPort = k.core.v1.containerPort,
  local statefulset = k.apps.v1.statefulSet,
  local pvc = k.core.v1.persistentVolumeClaim,
  local volumeMount = k.core.v1.volumeMount,
  local volume = k.core.v1.volume,

  local mysql_pvc =
    pvc.new('mysql-pvc') +
    pvc.mixin.spec.resources.withRequests({ storage: $._config.mysql.diskSize }) +
    pvc.mixin.spec.withAccessModes(['ReadWriteOnce']) +
    pvc.mixin.spec.withStorageClassName($._config.mysql.storageClass),

  mysql_password_secret_name:: 'mysql-password',

  mysql_container::
    container.new('mysql', $._images.mysql) +
    container.withImagePullPolicy('Always') +
    k.util.resourcesRequests('50m', '200Mi') +
    k.util.resourcesLimits('1', '2Gi') +
    container.withPorts([
      containerPort.new('mysql', 3306) + containerPort.withProtocol('TCP'),
    ]) +
    container.withVolumeMountsMixin([
      volumeMount.new('mysql-pvc', '/var/lib/mysql'),
    ]) +
    container.withEnv([
      { name: 'MYSQL_ROOT_PASSWORD', value: 'm@FHheJhuZhEqFxFshGxEJPjJPPyFpKAZaX8y4Muotz*bf@e3qkeADi2uMXRuzEc' },
    ]) +
    container.withTerminationMessagePath('/dev/termination-log') +
    container.withTerminationMessagePolicy('File'),

  local mysql_labels = { app: 'mysql', name: 'mysql' },

  mysql_statefulset:
    statefulset.new('mysql', 1, [
      $.mysql_container,
    ]) +
    statefulset.mixin.spec.withServiceName('mysql') +
    statefulset.mixin.spec.template.spec.withVolumes([volume.fromPersistentVolumeClaim('mysql-pvc', 'mysql-pvc')]) +
    statefulset.mixin.metadata.withNamespace($._config.namespace) +
    statefulset.mixin.metadata.withLabels({ app: 'mysql' }) +
    statefulset.mixin.spec.template.metadata.withLabels({ app: 'mysql' }) +
    statefulset.mixin.spec.selector.withMatchLabels({ app: 'mysql' }) +
    statefulset.mixin.spec.template.spec.securityContext.withRunAsUser(0) +
    statefulset.mixin.spec.template.spec.withTerminationGracePeriodSeconds(30),

  local service = k.core.v1.service,
  local servicePort = k.core.v1.servicePort,
  
  mysql_service:
    service.new(
      'mysql',
      { app: $.mysql_labels.name },
      [
        servicePort.newNamed('mysql', 3306, 3306) + servicePort.withProtocol('TCP'),
      ]
    ) +
    service.mixin.spec.withType('LoadBalancer') +
    service.mixin.metadata.withNamespace($._config.namespace) +
    service.mixin.metadata.withLabels({ app: 'mysql' }) +
    k.core.v1.service.mixin.spec.withSessionAffinity('None') +
    k.core.v1.service.mixin.spec.withSelector({ app: 'mysql' }),

}
