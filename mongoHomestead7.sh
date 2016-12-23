#!/usr/bin/env bash

echo "MongoDB install  script with PHP7 & nginx [Laravel Homestead]"
echo "By Zakaria BenBakkar, @zakhttp, zakhttp@gmail.com"

echo "Importing the public key used by the package management system";
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927;

echo "Creating a list file for MongoDB.";
echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list;

echo "Updating the packages list";
sudo apt-get update;

echo "Install the latest version of MongoDb";
sudo apt-get install -y mongodb-org;

echo "Fixing the pecl errors list";
sudo sed -i -e 's/-C -n -q/-C -q/g' `which pecl`;

echo "Installing OpenSSl Libraries";
sudo apt-get install -y autoconf g++ make openssl libssl-dev libcurl4-openssl-dev;
sudo apt-get install -y libcurl4-openssl-dev pkg-config;
sudo apt-get install -y libsasl2-dev;

echo "Installing PHP7 mongoDb extension";
sudo pecl install mongodb;

echo "adding the extension to mods-available directory if it's not already there"
mongoDbIni="/etc/php/7.0/mods-available/mongodb.ini"
if [ ! -e $mongoDbIni ]; then
    echo "; configuration for php mongodb module" | sudo tee $mongoDbIni
    #it has to load after json module, otherwise it breaks
    echo "; priority=30" | sudo tee -a $mongoDbIni
    echo "extension = mongodb.so" | sudo tee -a $mongoDbIni
fi

echo "creating symbolic links for the ini file"
sudo ln -s $mongoDbIni /etc/php/7.0/cli/conf.d/30-mongodb.ini
sudo ln -s $mongoDbIni /etc/php/7.0/fpm/conf.d/30-mongodb.ini

echo "Add mongodb.service file"
cat >/etc/systemd/system/mongodb.service <<EOL
[Unit]
Description=High-performance, schema-free document-oriented database
After=network.target

[Service]
User=mongodb
ExecStart=/usr/bin/mongod --quiet --config /etc/mongod.conf

[Install]
WantedBy=multi-user.target
EOL

sudo systemctl start mongodb
sudo systemctl status mongodb
sudo systemctl enable mongodb

echo "restarting The nginx server";
sudo service nginx restart && sudo service php7.0-fpm restart