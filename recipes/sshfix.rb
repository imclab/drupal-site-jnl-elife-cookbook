#
# Cookbook Name:: elife-chef-dev-template
# Recipe:: localgit
#
# Copyright 2013, eLifeSciences
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
