## dummy databases

If you want to set up a datasource plugin and test it with some dummy data, there are several methods:

1) You can build from source and [use these instructions to launch dummy backends locally inside docker containers](https://github.com/grafana/grafana/tree/main/devenv#developer-dashboards-and-data-sources).

2) Or you can connect to one of the dummy backends that this squads maintains in an isolated cluster. All of these datasources are available on play.grafana.org, but you can connect them to any grafana instance with internet access. See this repo and the repo's readme for details and credential information:

https://github.com/grafana/universal-dummy-backends