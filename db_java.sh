#!/bin/bash

get_temporary_password() {

        string_with_passw=$(sudo cat /var/log/mysqld.log | grep "A temporary")
        temp_pass="${string_with_passw#*localhost: }"
}

setup_mysql() {

root_db_pass="kk3iDhwFEZYtJW8="
user_db_pass="cFGc0ulFPkwPyyk="
echo -e "[client]\npassword=$temp_pass" > ~/.my.cnf
mysql -u root --connect-expired-password <<SQL_QUERY
SET PASSWORD = PASSWORD("$root_db_pass");
CREATE DATABASE eschool character set UTF8mb4 collate utf8mb4_bin;
CREATE USER 'eschool_user'@'%' IDENTIFIED BY "$user_db_pass";
GRANT ALL PRIVILEGES ON eschool.* TO 'eschool_user'@'%';
FLUSH PRIVILEGES;
SQL_QUERY
rm ~/.my.cnf

}

install_requirements() {

        sudo yum update -y
        sudo yum install wget yum-utils -y
        wget https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
        sudo yum localinstall mysql57-community-release-el7-11.noarch.rpm -y
        sudo yum-config-manager --enable mysql57-community
        sudo yum install mysql-community-server -y
        sudo service mysqld start

}

install_requirements
get_temporary_password
setup_mysql

