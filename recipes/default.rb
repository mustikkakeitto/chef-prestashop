#
# Cookbook Name:: prestashop
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

class Chef::Recipe
  include PrestashopLibrary
end


node["prestashop_sites"].each do |key, site| 
	Chef::Log.debug("Found a server: name: #{key}, #{site['username']}")
	prestashop_createuser "#{site['username']}", "#{site['password']}"
	
#	execute "unzip -o /tmp/prestashop152.zip -d #{node.set['prestashop']['web_folder']}/#{site[1]['username']}" do
#		not_if "test -f /var/www/#{site[1]['username']}/prestashop/index.php"
#	end
end

remote_file "/tmp/prestashop152.zip" do
  	source "http://www.prestashop.com/download/old/prestashop_1.5.2.0.zip"
    	mode "0644"
      	checksum "37aee9ef5388376e4377aeb240ab027e"
      	backup false
      	not_if "test -f /tmp/prestashop152.zip"
end



