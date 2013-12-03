# The OpenVPN connection for eLifeSciences/Highwire
# Copyright 2013, eLifeSciences
#
# All rights reserved - Do Not Redistribute
#

package 'openvpn' do
  action :install
end

service 'openvpn' do
  action :stop
end

node.default["openvpnc"]["proto"] = "udp"
node.default["openvpnc"]["type"] = "client-bridge"
node.default["openvpnc"]["remote"] = "171.67.125.14"
node.default["openvpnc"]["ns_cert_type"] = "server"
node.default["openvpnc"]["tls_cipher"] = "DHE-RSA-AES256-SHA"
node.default["openvpnc"]["cipher"] = "AES-256-CBC"

# Use root not nobody as openvpn owner or you get problems shutting down the routes.
node.default["openvpnc"]["user"] = "root"
node.default["openvpnc"]["group"] = "root"

key_source_dir  = node["git_root"]
key_source_dir  =  "/opt/public"
key_dir = "/etc/openvpn"

directory key_dir do
  owner 'root'
  group 'root'
  mode  '0755'
end

remote_file "Copy certificate file" do
  path "#{key_dir}/client.crt"
  source "file://#{key_source_dir}/client.crt"
  owner 'root'
  group 'root'
  mode 0750
end

remote_file "Copy TLS certificate file" do
  path "#{key_dir}/ta.crt"
  source "file://#{key_source_dir}/ta.crt"
  owner 'root'
  group 'root'
  mode 0750
end

remote_file "Copy key file" do
  path "#{key_dir}/client.key"
  source "file://#{key_source_dir}/client.key"
  owner 'root'
  group 'root'
  mode 0700
end

remote_file "Copy CA file" do
  path "#{key_dir}/ca.crt"
  source "file://#{key_source_dir}/ca.crt"
  owner 'root'
  group 'root'
  mode 0750
end

openvpnc_ovpnclient 'client' do
  port node['openvpnc']['port']
  proto node['openvpnc']['proto']
  type node['openvpnc']['type']
  local node['openvpnc']['local']
  remote node['openvpnc']['remote']
  mssfix node['openvpnc']['mssfix']
  fragment node['openvpnc']['fragment']
  ns_cert_type node['openvpnc']['ns_cert_type']
  tls_cipher node['openvpnc']['tls_cipher']
  tls_key node['openvpnc']['tls_key']
  cipher node['openvpnc']['cipher']
  routes node['openvpnc']['routes']
  script_security node['openvpnc']['script_security']
  key_dir "#{key_dir}"
  subnet node['openvpnc']['subnet']
  netmask node['openvpnc']['netmask']
  user node['openvpnc']['user']
  group node['openvpnc']['group']
  log node['openvpnc']['log']

  notifies :restart, 'service[openvpn]', :immediately
end
