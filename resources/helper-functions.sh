# GRAFANA HELPER FUNCTIONS

#####################
# START GRAFANA DEV #
#####################

# based on plugin dev helper by Marcus Olssson
# https://community.grafana.com/t/how-i-use-docker-for-plugin-development/58533/

# Spin up quick Grafana instances with chosen version and port

# how to use:
# 1) open a terminal app. make sure you have docker installed 
# 2) add these lines to your terminal profile (zshrc, bashrc, etc) and source the file
# 3) type start_grafana_dev with no args and press enter. this will run the latest version on port 3000
# 4) pass in a version number as first arg and optionally a specific port as a second arg:
#    example: `start_grafana_dev 9.0.1 3001` will run Grafana v. 9.0.1 on port 3001

start_grafana_dev() {
  docker run --rm \
    -e GF_DEFAULT_APP_MODE=development \
    -e GF_LOG_LEVEL=debug \
    -e GF_LOG.CONSOLE_LEVEL=debug \
    -p "${2:=3000}:3000" \
    grafana/grafana:"${1:=latest}"
}

##############################
# GRAFANA CHANGELOG SEARCHER #
##############################

# by matt abrams (https://github.com/zuchka)

# how to use:
# 1) open a terminal app. make sure you have docker installed
# 2) add these lines to your terminal profile (zshrc, bashrc, etc) and source the file
# 3) enter gflog 'your-string-here' and press enter. For example: type: gflog 'template variable'. it will return every changelog item that includes the string 'template variable'

gflog() {
  curl -fsSL https://raw.githubusercontent.com/grafana/grafana/main/CHANGELOG.md | \
  grep -niE --color=always "($@|[0-9].[0-9].[0-9].*\sEND)" | \
  less -RFX
}