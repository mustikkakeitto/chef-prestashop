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

	def prestashop_deploy(username) 
		execute "unzip -o /tmp/prestashop152.zip -d #{node.set['prestashop']['web_folder']}/#{username]}" do
		not_if "test -f /var/www/#{username]}/prestashop/index.php"
	end

end