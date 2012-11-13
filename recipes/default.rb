#
# Cookbook Name:: prestashop
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "mysql::server"

class Chef::Recipe
  include PrestashopLibrary
end


node["prestashop_sites"].each do |key, site| 
	
	Chef::Log.debug("Found a server: name: #{key}, #{site['username']}, #{site['URL']}")
	
	# Create User Account on System
	prestashop_createuser "#{site['username']}", "#{site['password']}"
	
	# Fetch the latest release --TODO ask for version
	prestashop_fetchrelease()

	# Deploy site
	prestashop_deploysite "#{site['username']}"
	
	# Deploy Database
	prestashop_deployDatabase "#{site['username']}"
	
end