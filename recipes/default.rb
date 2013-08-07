#
# Cookbook Name:: elife-chef-dev-template
# Recipe:: localgit
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "git"

# where to put our repositories
localgit = "/home/vagrant/localgit"

directory localgit do
  owner "root"
  group "root"
  mode 0755
  action :create
end

# install git repos to our local path
git_repos = Array.new
git_repos.push ["git://github.com/elifesciences/", "elife-api-prototype"]
git_repos.push ["git://github.com/elifesciences/", "elife-bot"]
git_repos.push ["git://github.com/elifesciences/", "drupal-site-jnl-elife"]
#git_repos.push ["git@github.com:highwire/", "drupal-highwire"]
#git_repos.push ["git@github.com:highwire/", "drupal-webroot"]


git_repos.each do |repos|
  base_uri = repos[0]
  repos_name = repos[1] 
  repos_uri = base_uri + repos_name + ".git"
  repos_dir = localgit + "/" + repos_name
  git repos_dir do
    repository repos_uri
    reference "master"
    action :sync
  end
end