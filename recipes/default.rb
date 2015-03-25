#
# Cookbook Name:: cybera_grafana
# Recipe:: default
#
# Copyright (c) 2015 All Rights Reserved.

# install Grafana source and create config
directory node[:grafana][:path] do
  recursive true
  mode "0775"
  action :create
end

remote_file "#{node[:grafana][:path]}/grafana-#{node[:grafana][:version]}.tar.gz" do
  source "#{node[:grafana][:package][:base_url]}grafana-#{node[:grafana][:version]}.tar.gz"
  action :create
end

execute "untar-grafana" do
  cwd   node[:grafana][:path]
  command  "tar xf #{node[:grafana][:path]}/grafana-#{node[:grafana][:version]}.tar.gz"
end

link "#{node[:grafana][:path]}/current" do
  to "#{node[:grafana][:path]}/grafana-#{node[:grafana][:version]}"
end

template "#{node[:grafana][:path]}/current/config.js" do
  source "grafana_config.js.erb"
  variables({
    :grafana => {
      :host => node[:grafana][:host],
      :port => node[:grafana][:port]
    },
    :metrics_database => node[:grafana][:metrics_database],
    :grafana_database => node[:grafana][:grafana_database],
  })
  action :create
end

# set up webserver
package "nginx"

if node[:influxdb]
  influx_node = node[:influxdb]
else
  influx_node = search(:node, "role:influxdb").first
end

template "/etc/nginx/sites-available/grafana" do
  source "grafana_nginx.erb"
  variables({
    :bind_port => node[:grafana][:port],
    :influxdb => {
      :host => influx_node[:ipaddress],
      :port => influx_node[:influxdb][:config][:api][:port]
    },
    :ssl => node[:ssl]
  })
  action :create
end

link "/etc/nginx/sites-enabled/grafana" do
  to "/etc/nginx/sites-available/grafana"
end

service "nginx" do
  supports :status => true, :restart => true, :start => true, :stop => true
  action [:enable, :start]
end

