local play_grafana = import 'play-grafana/play-grafana.libsonnet';

{
  _config+:: {
    cluster_name: 'raintank-dev-gke',
    namespace: 'play-grafana',
  },

  play_grafana: play_grafana {
    _config+:: $._config {
      graphite+: {
        diskSize: '10Gi',
        storageClass: "",
      },
      influxdb+: {
        diskSize: '10Gi',
      },
      prometheus+: {
        diskSize: '10Gi',
      },
      mysql+: {
        diskSize: '10Gi',
      },
    },
  },
}
