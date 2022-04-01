echo "Creating dev user... "
EXPECTED_ARGS=1
USERNAME=$1
adduser $USERNAME --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo "added $USERNAME to users"
echo $USERNAME:$USERNAME | chpasswd
echo "set password"
usermod -a -G sudo $USERNAME
echo "added  $USERNAME to sudo group"
echo "$USERNAME ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME