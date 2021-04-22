echo "Creating Swap"
free -m
swapon -s
dd if=/dev/zero of=/swapfile count=1024 bs=1M
ls / | grep swapfile
chmod 600 /swapfile
ls -lh /swapfile
mkswap /swapfile
swapon /swapfile
free -m
echo "/swapfile   none    swap    sw    0   0" >> /etc/fstab

# Docker Install
echo "Installing Docker Now"
apt update
apt install -y apt-transport-https ca-certificates curl software-properties-common gnupg-agent sshguard
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update
apt-cache policy docker-ce
apt install -y docker-ce
systemctl status docker
mkdir /rotating-backups

