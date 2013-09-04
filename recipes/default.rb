#
# Cookbook Name:: elife-chef-dev-template
# Recipe:: localgit
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# add a .ssh directory
Directory "/root/.ssh" do
  action :create
  mode 0700
end

# don't check for hosts
File "/root/.ssh/config" do
  action :create
  content "Host *\nStrictHostKeyChecking no"
  mode 0600
end

ruby_block "Give root access to the forwarded ssh agent" do
  block do
    # find a parent process' ssh agent socket
    agents = {}
    ppid = Process.ppid
    Dir.glob('/tmp/ssh*/agent*').each do |fn|
      agents[fn.match(/agent\.(\d+)$/)[1]] = fn
    end
    while ppid != '1'
      if (agent = agents[ppid])
        ENV['SSH_AUTH_SOCK'] = agent
        break
      end
      File.open("/proc/#{ppid}/status", "r") do |file|
        ppid = file.read().match(/PPid:\s+(\d+)/)[1]
      end
    end
    # Uncomment to require that an ssh-agent be available
    # fail "Could not find running ssh agent - Is config.ssh.forward_agent enabled in Vagrantfile?" unless ENV['SSH_AUTH_SOCK']
  end
  action :create
end

include_recipe "git"

# where to put our repositories
localgit = "/home/vagrant/localgit"

directory localgit do
  owner "root"
  group "root"
  mode 0755
  action :create
end

# prove that we can add a couple of public repositories
git_public_repos = Array.new
git_public_repos.push ["git://github.com/elifesciences/", "elife-api-prototype"]

git_public_repos.each do |repos|
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


# add private repos
git_private_repos = Array.new
# push [repo base, repo name,reference] 
git_private_repos.push ["git@github.com:elifesciences/", "drupal-site-jnl-elife", "elife-dev"] 
git_private_repos.push ["git@github.com:highwire/git@github.com:highwire/", "drupal-highwire", "7.x-1.x-dev"]
git_private_repos.push ["git@github.com:highwire/git@github.com:highwire/", "drupal-webroot", "7.x-1.x-dev"]
                        
git_private_repos.each do |repos|
  base_uri = repos[0]
  repos_name = repos[1] 
  repos_ref = repos[2]
  repos_uri = base_uri + repos_name + ".git"
  repos_dir = localgit + "/" + repos_name
  git repos_dir do
    repository repos_uri
    reference repos_ref
    action :sync
  end 
end 

# attempt to add highwire core drupal repositories
#git_repos.push ["git@github.com:highwire/", "drupal-highwire"]
#git_repos.push ["git@github.com:highwire/", "drupal-webroot"]

