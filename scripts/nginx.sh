#!/bin/bash
echo "Creating a new user: "
EXPECTED_ARGS=2
DOMAIN=$1
USERNAME=${DOMAIN//./_}

sudo adduser $USERNAME --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo "added $USERNAME to users"
echo "$USERNAME:$USERNAME" | sudo chpasswd
echo "set password"
sudo usermod -a -G dev $USERNAME
echo "added  $USERNAME to dev group"
sudo usermod -a -G $USERNAME dev
echo "added  dev to $USERNAME group"
sudo usermod -a -G www-data $USERNAME
echo "added $USERNAME to www-date group"
#sudo mkdir /home/$USERNAME/ftp
sudo mkdir -p /home/$USERNAME/ftp/{files,logs}
echo "created /home/$USERNAME/ftp/files|logs folder"
sudo chmod -R 777 /home/$USERNAME/ftp/files
echo "/home/$USERNAME/ftp permission changed to 777"
echo "/home/$USERNAME/ftp assigned to nobody:nogroup"
sudo chown nobody:nogroup /home/$USERNAME/ftp
mkdir /var/www/$DOMAIN
echo "/var/www/$DOMAIN created"
mkdir /var/www/$DOMAIN/public_html
echo "/var/www/$DOMAIN/public_html created"
sudo chown $USERNAME:$USERNAME /var/www/$DOMAIN 
echo "/var/www/$DOMAIN/ owned by $USERNAME:$USERNAME"
echo '<center>created by <a href="http://websm.uz/"><b>websm</b></a></center>' >> /var/www/$DOMAIN/public_html/index.html
echo "index.html added to public_html folder"
sudo chown -R $USERNAME:$USERNAME /var/www/$DOMAIN/public_html
echo "/var/www/$DOMAIN/public_html changed ownership to $USERNAME:$USERNAME"
sudo chmod 775 /home/$USERNAME
echo "giving default permission to /home/$USERNAME"
sudo mount --bind /var/www/$DOMAIN/public_html /home/$USERNAME/ftp/files
echo "binding /var/www/$DOMAIN/public_html to /home/$USERNAME/ftp/files"
echo $USERNAME |sudo tee -a /etc/vsftpd.userlist
echo "$USERNAME added to vsftpd.userlist"
sudo systemctl restart vsftpd
echo "vsftpd restarted"

sudo cp /etc/nginx/sites-available/server-template.conf /etc/nginx/sites-available/$DOMAIN.conf
sudo sed -i 's|DOMAIN_ARG|'"$DOMAIN"'|g' /etc/nginx/sites-available/$DOMAIN.conf
DOMAIN_DIRECTORY=$DOMAIN
sudo sed -i 's|DOMAIN_DIRECTORY_ARG|'"$DOMAIN_DIRECTORY"'|g' /etc/nginx/sites-available/$DOMAIN.conf
sudo ln -s /etc/nginx/sites-available/$DOMAIN.conf /etc/nginx/sites-enabled/
sudo nginx -t
sudo service nginx reload
echo "/var/www/$DOMAIN/   /home/$USERNAME/ftp/files   none   bind   0 0" |  sudo tee -a /etc/fstab