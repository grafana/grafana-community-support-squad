{
  _config+: {
    graphite+: {
      diskSize: '10Gi',
    },   
    influxdb+: {
      diskSize: '10Gi',
    },
    mysql+: {
      diskSize: '10Gi',
      storageClass: "",
    },
  },
}
