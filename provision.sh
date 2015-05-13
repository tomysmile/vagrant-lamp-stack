#!/bin/bash

# Determine if this machine has already been provisioned
# Basically, run everything after this command once, and only once
if [ -f ".vagrant_provision" ]; then 
    exit 0
fi

################################################################################
# Everything below this line should only need to be done once
# To re-run full provisioning, delete /home/vagrant/.vagrant-provision and re-run
#
#    $ vagrant provision
#
################################################################################

function notify {
    printf "\n--------------------------------------------------------\n"
    printf "\t$1"
    printf "\n--------------------------------------------------------\n"
}

# Set parameters
php_config_file="/etc/php5/apache2/php.ini"
xdebug_config_file="/etc/php5/mods-available/xdebug.ini"
mysql_config_file="/etc/mysql/my.cnf"

notify "update & upgrade server"

# Update the server
apt-get update
apt-get -y upgrade

IPADDR=$(/sbin/ifconfig eth0 | awk '/inet / { print $2 }' | sed 's/addr://')
sed -i "s/^${IPADDR}.*//" /etc/hosts
echo $IPADDR ubuntu.localhost >> /etc/hosts

apt-get -y install build-essential binutils-doc curl git-core ftp unzip imagemagick vim colordiff gettext graphviz

dpkg -s apache2 &>/dev/null || {
	notify "Installing Apache and setting it up."

	# Install apache2 
    apt-get install -y apache2      
    
    cp /vagrant/vagrant-files/config/servername.conf /etc/apache2/conf-available/

    # Enable mod_rewrite
    a2enmod rewrite   

    # Enable server name
	a2enconf servername
}

dpkg -s mysql-server &>/dev/null || {
	notify "Installing MySQL."
	
	# Install MySQL
	echo "mysql-server mysql-server/root_password password root" | sudo debconf-set-selections
	echo "mysql-server mysql-server/root_password_again password root" | sudo debconf-set-selections
	apt-get -y install mysql-client mysql-server

	sed -i "s/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" ${mysql_config_file}

	# Allow root access from any host
	echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION" | mysql -u root --password=root
	echo "GRANT PROXY ON ''@'' TO 'root'@'%' WITH GRANT OPTION" | mysql -u root --password=root
}

dpkg -s php5 &>/dev/null || {
	notify "Installing PHP5 Modules."

    # Install php5, libapache2-mod-php5, php5-mysql curl php5-curl
    apt-get install -y php5 php5-cli php5-common php5-dev php5-imagick php5-imap php5-gd libapache2-mod-php5 php5-mysql php5-curl php5-sqlite php5-xdebug

    sed -i "s/display_startup_errors = Off/display_startup_errors = On/g" ${php_config_file}
	sed -i "s/display_errors = Off/display_errors = On/g" ${php_config_file}	
}

cat << EOF > ${xdebug_config_file}
zend_extension=xdebug.so
xdebug.remote_enable=1
xdebug.remote_connect_back=1
xdebug.remote_port=9000
xdebug.remote_host=10.0.2.2
EOF

# Restart Services
service apache2 restart
service mysql restart

# Let this script know not to run again
touch .vagrant_provision