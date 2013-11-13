#
# Cookbook Name:: elife-chef-dev-template
# Recipe:: localgit
#
# Copyright 2013, eLifeSciences
#
# All rights reserved - Do Not Redistribute
#

webroot_dir = "#{node[:www_root]}"
sitename = "http://#{node[:drupal][:site_name]}"

# disable the CDN static content delivery network, which won't work for us, so
# that the built-in files are used instead.

execute "disable-highwire-cdn" do
  command "/usr/bin/drush -l '#{sitename}' -r '#{webroot_dir}' --yes pm-disable cdn"
  action :run

  # set to false or remove once the database matches the code properly...
  ignore_failure true
end
