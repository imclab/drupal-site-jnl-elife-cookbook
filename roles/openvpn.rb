#
# Cookbook Name:: elife-chef-dev-template
# Recipe:: localgit
#
# Copyright 2013, eLifeSciences
#
# All rights reserved - Do Not Redistribute
#

name "openvpn"
description "The OpenVPN connection for eLifeSciences/Highwire"
run_list("recipe[openvpn]")
override_attributes(
  "openvpn" => {
    "gateway" => "vpn.example.com",
    "subnet" => "10.8.0.0",
    "netmask" => "255.255.0.0",
    "key" => {
      "country" => "US",
      "province" => "CA",
      "city" => "SanFrancisco",
      "org" => "Fort-Funston",
      "email" => "me@example.com"
    }
  }
)