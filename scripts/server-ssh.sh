cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
cd .ssh/
chmod 600 authorized_keys
sudo chattr +i authorized_keys
cd ..
chmod 700 .ssh