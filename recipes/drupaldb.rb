#
# Cookbook Name:: elife-chef-dev-template
# Recipe:: localgit
#
# Copyright 2013, eLifeSciences
#
# All rights reserved - Do Not Redistribute
#

# the settings file is referenced on the host and is not in git for security.
sqldump_gzfile = "#{node[:drupal][:shared_folder]}/#{node[:drupal][:drupal_sqlfile]}.gz"
sqldump_sqlfile = "/tmp/#{node[:drupal][:drupal_sqlfile]}"

# Add an admin user to mysql
# execute "add-admin-user" do
#   command "/usr/bin/mysql -u root -p -e \"" +
#       "GRANT ALL PRIVILEGES ON *.* TO '#{node[:mysql][:server_root_userid]}'@'localhost' IDENTIFIED BY '#{node[:mysql][:server_root_password]}' WITH GRANT OPTION;" +
#       "GRANT ALL PRIVILEGES ON *.* TO '#{node[:mysql][:server_root_userid]}'@'%' IDENTIFIED BY '#{node[:mysql][:server_root_password]}' WITH GRANT OPTION;\" " +
#       "mysql"
#   action :run
# end

log "create-drupal-database" do
  message "create the drupal-database: #{node[:mysql][:server_database]}"
  level :info
end

# create a drupal db
execute "create-drupal-database" do
  command "/usr/bin/mysql -u root -p#{node[:mysql][:server_root_password]} -e \"" +
      "CREATE DATABASE IF NOT EXISTS #{node[:mysql][:server_database]};\""
  action :run
end

log "load-drupal-database" do
  message "load the drupal-database: #{node[:mysql][:server_database]}  from #{sqldump_gzfile}:"
  level :info
end

# unpack the database
execute "unpack-drupal-database" do
  command "/bin/gunzip -c #{sqldump_gzfile} > #{sqldump_sqlfile}" 
  creates "#{sqldump_sqlfile}"
  action :run
end

# load the drupal db
execute "load-drupal-database" do
  command "/usr/bin/mysql -u root -p#{node[:mysql][:server_root_password]} #{node[:mysql][:server_database]} < #{sqldump_sqlfile}"
  action :run
end
