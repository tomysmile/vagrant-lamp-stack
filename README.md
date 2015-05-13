# Vagrant LAMP Stack
====================

LAMP Stack using Vagrant environment which enables you to test your web app but don't want to affect your current Apache / MySQL / PHP system.

If you find yourself needing quick to configure web stack, but also one that is customizable try this Vagrant project

Vagrant allows for Virtual Machines to be quickly setup, and easy to use.

Requirements
------------
* VirtualBox <http://www.virtualbox.com>
* Vagrant <http://www.vagrantup.com>
* Git <http://git-scm.com/>

Usage
-----

### Startup
	$ git clone http://www.github.com/tomysmile/vagrant-lamp-stack
	$ cd vagrant-lamp-stack
	$ vagrant up --provider virtualbox

### Accessibility

#### Apache
The Apache server is available at <http://localhost:8880>

#### MySQL
Externally the MySQL server is available at port 8806, and when running on the VM it is available as a socket or at port 3306 as usual.

Username: root
Password: root

Package list
-----------------
* Ubuntu 14.04 64-bit
* Apache 2
* PHP 5.5
* MySQL 5.5

We are using the base Ubuntu 14.04 box from Vagrant. If you don't already have it then the Vagrantfile has been configured to do it for you. This only has to be done once
for each account on your host computer.

Web root directory located at:
	/var/wwww

And like any other vagrant file you have SSH access with

	$ vagrant ssh



Any suggestion or errors please email me at tomysmile[at]gmail.com

Thanks.