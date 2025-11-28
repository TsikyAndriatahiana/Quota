#!/bin/bash
sudo mkdir -p /var/www/html/debs
sudo cp /var/cache/apt/archives/*.deb /var/www/html/debs/
sudo chmod 755 /var/www/html/debs
sudo a2enmod autoindex
sudo systemctl restart apache2



   
