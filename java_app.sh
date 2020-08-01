#!/bin/bash

install_soft() {

	sudo yum update -y
	sudo yum install java-1.8.0-openjdk wget git httpd -y
	sudo systemctl enable httpd
	sudo yum install maven -y
}

install_maven() {

	wget https://www-us.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz -P /tmp
	sudo tar xf /tmp/apache-maven-3.6.3-bin.tar.gz -C /opt
	sudo ln -s /opt/apache-maven-3.6.3/ /opt/maven
}

setup_maven() {

FILE="/etc/profile.d/maven.sh"

/bin/cat <<EOM >$FILE
export JAVA_HOME=/usr/lib/jvm/jre-openjdk
export M2_HOME=/opt/maven
export MAVEN_HOME=/opt/maven
export PATH=${M2_HOME}/bin:${PATH}
EOM
	sudo chmod +x /etc/profile.d/maven.sh	
	source /etc/profile.d/maven.sh
}

clone_edit_config() {
	
	ext_ip=$(curl ifconfig.me)
	mkdir /home/Java
	cd /home/Java
	sudo git clone https://github.com/protos-kr/eSchool.git

	sudo sed -i -e "s|localhost:3306/eschool|10.156.0.11:3306/eschool|g" /home/Java/eSchool/src/main/resources/application.properties
	sudo sed -i -e "s/DATASOURCE_USERNAME:root/DATASOURCE_USERNAME:eschool_user/g" /home/Java/eSchool/src/main/resources/application.properties
	sudo sed -i -e "s/DATASOURCE_PASSWORD:root/DATASOURCE_PASSWORD:cFGc0ulFPkwPyyk=/g" /home/Java/eSchool/src/main/resources/application.properties
	sudo sed -i -e "s|https://fierce-shore-32592.herokuapp.com|http://$ext_ip|g" /home/Java/eSchool/src/main/resources/application.properties

	sudo sed -i -e "s|35.240.41.176:8443|$ext_ip:8080|g" /home/Java/eSchool/src/main/resources/application-production.properties
	sudo sed -i -e "s/DATASOURCE_USERNAME:root/DATASOURCE_USERNAME:eschool_user/g" /home/Java/eSchool/src/main/resources/application-production.properties
	sudo sed -i -e "s/DATASOURCE_PASSWORD:CS5eWQxnja0lAESd/DATASOURCE_PASSWORD:cFGc0ulFPkwPyyk=/g" /home/Java/eSchool/src/main/resources/application-production.properties
	sudo sed -i -e "s|35.242.199.77:3306/ejournal|10.156.0.11:3306/eschool|g" /home/Java/eSchool/src/main/resources/application-production.properties
}

build_backend_and_run() {

	cd /home/Java/eSchool/
	sudo mvn package -DskipTests
	cd target/
	sudo java -jar eschool.jar &
}

install_and_build_frontend() {

	cd /home/Java/
	sudo su
	sudo git clone https://github.com/protos-kr/final_project
	cd final_project/
	sudo sed -i -e "s|https://fierce-shore-32592.herokuapp.com|http://$ext_ip:8080|g" /home/Java/final_project/src/app/services/token-interceptor.service.ts
	sudo curl -sL https://rpm.nodesource.com/setup_12.x | sudo bash -
	sudo yum clean all && sudo yum makecache fast
	sudo yum install -y gcc-c++ make
	sudo yum install -y nodejs
	sudo npm install -g @angular/cli@7.0.7
	sudo npm install --save-dev  --unsafe-perm node-sass

	sudo npm install
	sudo rm -rf package-lock.json
	sudo ng build --prod

}

setup_virtual_host() {
	

	setenforce 0
	sudo mkdir /var/www/eSchool
	sudo cp -r /home/Java/final_project/dist/eSchool/* /var/www/eSchool
	sudo cp /home/Java/final_project/.htaccess /var/www/eSchool/

	sudo mkdir /etc/httpd/sites-available /etc/httpd/sites-enabled /var/log/httpd/eSchool
	sudo echo "IncludeOptional sites-enabled/*.conf" >> /etc/httpd/conf/httpd.conf
	sudo ln -s /etc/httpd/sites-available/eSchool.conf /etc/httpd/sites-enabled/eSchool.conf


sudo cat <<_EOF > /etc/httpd/sites-available/eSchool.conf
<VirtualHost *:80>
    #    ServerName www.example.com
    #    ServerAlias example.com
    DocumentRoot /var/www/eSchool
    ErrorLog /var/log/httpd/eSchool/error.log
    CustomLog /var/log/httpd/eSchool/requests.log combined
    <Directory /var/www/eSchool/>
            AllowOverride All
    </Directory>
</VirtualHost>
_EOF


	sudo chown -R apache:apache -R /var/www/eSchool/
	sudo chmod 766 -R /var/www/eSchool/
	sudo systemctl restart httpd

}




install_soft
install_maven
setup_maven
clone_edit_config
build_backend_and_run
install_and_build_frontend
setup_virtual_host
