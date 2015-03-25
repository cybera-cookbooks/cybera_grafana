default[:grafana][:version] = "1.9.1"
default[:grafana][:package][:base_url] = "http://grafanarel.s3.amazonaws.com/"
default[:grafana][:path] = "/opt/grafana"

default[:grafana][:host] = "localhost"
default[:grafana][:port] = 8080

default[:grafana][:metrics_database][:database] = "metrics"
default[:grafana][:metrics_database][:user] = "metrics"
default[:grafana][:metrics_database][:password] = "metricsRfun"

default[:grafana][:grafana_database][:database] = "grafana"
default[:grafana][:grafana_database][:user] = "grafana"
default[:grafana][:grafana_database][:password] = "metricsRfun"

default[:ssl][:enabled] = false
default[:ssl][:certificate_path] = "/etc/ssl/certificate.ca.pem"
default[:ssl][:key_path] = "/etc/ssl/certificate.key.pem"
