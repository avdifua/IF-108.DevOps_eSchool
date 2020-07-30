Vagrant.configure("2") do |config|

	config.vm.box = "google/gce"

	config.vm.define :db1 do |db1|
	  db1.vm.provider :google do |google, override|
		google.google_project_id = "sofserv-if"
		google.google_json_key_location = "/home/al/Vagrant/sofserv-if-1b4df71ea618.json"
		google.zone = "europe-west3-a"
		
		
		override.vm.provision :shell, path: "db_java.sh"				
		override.ssh.username = "al"
		override.ssh.private_key_path = "~/.ssh/virtual_home"
		
		google.zone_config "europe-west3-a" do |db1_zone|
			db1_zone.name = "java-data-base-mysql"
			db1_zone.image_family = "centos-7"
			db1_zone.disk_size = "20"
			db1_zone.network_ip = "10.156.0.11"
			db1_zone.machine_type = "e2-standard-2"
			db1_zone = "europe-west4-a"
    
			end
		end
	end

	config.vm.define :app1 do |app1|
	  app1.vm.provider :google do |google, override|
		google.google_project_id = "sofserv-if"
		google.google_json_key_location = "/home/al/Vagrant/sofserv-if-1b4df71ea618.json"
		google.zone = "europe-west3-a"
		google.tags = ['http-server', 'https-server']

		override.vm.provision :shell, path: "java_app.sh"	
		override.ssh.username = "al"
		override.ssh.private_key_path = "~/.ssh/virtual_home"
		
		google.zone_config "europe-west3-a" do |app1_zone|
			app1_zone.name = "java-eschool-app"
			app1_zone.image_family = "centos-7"
			app1_zone.disk_size = "20"
			app1_zone.network_ip = "10.156.0.21"
			app1_zone.machine_type = "e2-standard-2"
			app1_zone = "europe-west4-a"
    			
			end
		end
	end

end
