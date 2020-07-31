#!/bin/bash

install_soft() {

	sudo yum update -y
	sudo yum install java-1.8.0-openjdk wget git -y
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

build_app_run() {

	cd /home/Java/eSchool/
	sudo mvn package -DskipTests
	cd target/
	sudo java -jar eschool.jar &
}


install_soft
install_maven
setup_maven
clone_edit_config
build_app_run
