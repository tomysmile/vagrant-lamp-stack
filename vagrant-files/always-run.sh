#!/bin/bash

cp /vagrant/vagrant-files/config/default.vhost /etc/apache2/sites-available/000-default.conf

service apache2 reload

printf "\nMySql root username = root"
printf "\nMySql root password = root"
printf "\Web Root directory = /var/www or [vagrant-dir]/www\n"
printf "\n--build v1.0.0--\n\n"