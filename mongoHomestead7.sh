echo "MongoDB install  script with PHP7 & nginx [Laravel Homestead]
echo "By Zakaria BenBakkar, @zakhttp, zakhttp@gmail.com"

echo "Importing the public key used by the package management system";
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927;

echo "Creating a list file for MongoDB.";
echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list;

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

echo "Installing PHP7 mongoDb extenstion";
sudo pecl install mongodb;

echo "adding the extenstion to your php.ini file";
sudo echo  "extenstion = mongodb.so" >> /etc/php/7.0/cli/php.ini;
sudo echo  "extenstion = mongodb.so" >> /etc/php/7.0/fpm/php.ini;

echo "restarting The nginx server";
sudo service nginx restart && sudo service php7-fpm restart



