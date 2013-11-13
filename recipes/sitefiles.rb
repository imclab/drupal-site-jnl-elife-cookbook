#
# Cookbook Name:: elife-chef-dev-template
# Recipe:: localgit
#
# Copyright 2013, eLifeSciences
#
# All rights reserved - Do Not Redistribute
#

# drupal_dir is the implied parent of webroot_dir, and webroot_dir's
# folder is created by cloning the drupal-webroot git repo.
drupal_dir = "#{node[:git_root]}"
webroot_dir = "#{node[:www_root]}"

# this folder is created on the VM and the elife module (linked to below)
# 
elife_module_dir = "/shared/elife_module"

# the settings file is referenced on the host and is not in git for security.
settings_file = "#{drupal_dir}/settings.php"

directory drupal_dir do
  owner "root"
  group "root"
  mode 0755
  action :create
end

# add private repos
# add private repos
git_private_repos = Array.new
# push [repo base, repo name, reference] 

d_hiwr_rev="7.x-1.x-dev"
d_root_rev="7.x-1.x-dev"

d_hiwr_rev=node[:elifejnl][:hiwire_rev]
d_root_rev=node[:elifejnl][:webroot_rev]


# This isn't necessary because we reference the elife repo checked out on the host instead
# so that the webserver uses the host's files, not local VM files.
##git_private_repos.push ["git@github.com:elifesciences/", "drupal-site-jnl-elife", "elife-dev"] 

# The master repo is in  "git@github.com:highwire/" but use "git@github.com:elifesciences/" for testing
##git_private_repos.push ["git@github.com:elifesciences/", "drupal-highwire", "db87c2df3563d395f995936bb5288fefaae9e08a"]
##git_private_repos.push ["git@github.com:elifesciences/", "drupal-webroot", "8be75ad655443485f866558840ee939781482f73"] 

git_private_repos.push ["git@github.com:elifesciences/", "drupal-highwire", d_hiwr_rev]
git_private_repos.push ["git@github.com:elifesciences/", "drupal-webroot", d_root_rev] 

git_private_repos.each do |repos|
  base_uri = repos[0]
  repos_name = repos[1] 
  repos_ref = repos[2]
  repos_uri = base_uri + repos_name + ".git"
  repos_dir = drupal_dir + "/" + repos_name
  git repos_dir do
    depth 1
    repository repos_uri
    revision repos_ref
    action :sync
  end 
end 

# KEEP:
# Unnecessary as  the  drupal webroot already contains these links
#%w{ modules themes }.each do |d|
#  link "#{drupal_dir}/drupal-webroot/sites/all/#{d}" do
#		to "#{drupal_dir}/drupal-highwire/#{d}"
#	end
#end
#
#link "#{drupal_dir}/drupal-webroot/profiles/highwire_profile" do
#  to "#{drupal_dir}/drupal-highwire/profiles/highwire_profile"
#end
#

# set up symlinks into vagrant shared folder
# drupal-webroot/sites/default/
%w{ modules themes }.each do |d|
	link "#{webroot_dir}/sites/default/#{d}" do
	  to "#{elife_module_dir}/#{d}"
	end
end

# Link the settings.php file on the host to the right place in the VM
link "#{webroot_dir}/sites/default/settings.php" do
  to "#{settings_file}"
end

# web_app call and template is in the elife-drupal-cookbook
