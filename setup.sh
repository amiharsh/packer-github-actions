sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update
sudo apt install docker-ce -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ${USER}
newgrp docker
wget https://get.helm.sh/helm-v3.6.3-linux-amd64.tar.gz
tar -zxvf helm-v3.6.3-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/helm
sudo mv /tmp/ingress-nginx.yaml /opt/ingress-nginx.yaml
sudo mv /tmp/user-data.sh /var/lib/cloud/scripts/per-instance/user-data.sh
sudo cp /var/lib/cloud/scripts/per-instance/user-data.sh /var/lib/cloud/scripts/per-boot/user-data.sh
sudo chmod a+x /var/lib/cloud/scripts/per-instance/user-data.sh
sudo chmod a+x /var/lib/cloud/scripts/per-boot/user-data.sh
sudo mv /tmp/rfnchart /opt/rfnchart
