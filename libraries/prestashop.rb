module PrestashopLibrary
	def prestashop_createuser(username, password)
    		puts "you gave me #{username} and #{password}"
    end
	
	def prestashop_fetchrelease()
	    remote_file "/tmp/prestashop152.zip" do
	  		source "http://www.prestashop.com/download/old/prestashop_1.5.2.0.zip"
	    	mode "0644"
	      	checksum "37aee9ef5388376e4377aeb240ab027e"
	      	backup false
	      	not_if "test -f /tmp/prestashop152.zip"
	    end
	end

	def prestashop_deploySite(username) 

		execute "unzip -o /tmp/prestashop152.zip -d #{node.set['prestashop']['web_folder']}/#{username}" do
			not_if "test -f /var/www/#{username}/prestashop/index.php"
		end

		directory "/var/www/#{username}/prestashop" do
			owner "www-data"
			group "www-data"
			recursive true
		end

		%w{config cache log img mails modules translations upload download}.each do |dir|
			directory "/var/www/#{username}/prestashop/#{dir}" do
				owner "www-data"
				group "www-data"
				recursive true
			end
		end

	end

	def prestashop_deployDatabase (username)
	
		sql_path = '/tmp/prestashop_create_tables.sql'

		template sql_path do
			source "prestashop152.sql.erb"
			owner "root"
			group node['mysql']['root_group']
			mode "0600"
			action :create
		end

		execute "prestashop-create-tables" do
  			command "\"#{node['mysql']['mysql_bin']}\" -u root #{node['mysql']['server_root_password'].empty? ? '' : '-p' }\"#{node['mysql']['server_root_password']}\" < \"#{sql_path}\""
		end

		file sql_path do
  			action :nothing
  			only_if { File.exists?(sql_path) }
		end

	end

end