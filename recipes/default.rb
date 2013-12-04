#
# Cookbook Name:: drupal-site-jnl-elife-cookbook
# Recipe:: default
#
# Copyright 2013, eLifeSciences
#
# All rights reserved - Do Not Redistribute
#

include_recipe  "drupal-site-jnl-elife-cookbook::sshfix"
include_recipe  "drupal-site-jnl-elife-cookbook::drupaldb"
include_recipe  "drupal-site-jnl-elife-cookbook::sitefiles"

# Sometimes we don't want to set up the VPN client...
if node[:elifejnl][:setup_vpn_client]
  include_recipe  "drupal-site-jnl-elife-cookbook::openvpnc"
end

# The apache config file.
include_recipe  "elife-drupal-cookbook::site_config"

# EOF
