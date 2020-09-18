sudo apt-get update;
sudo apt-get install -yq build-essential python-pip rsync software-properties-common apt-transport-https unzip;
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -;
A=`lsb_release -cs`;
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $A stable";
sleep 3
sudo apt-get update
sudo apt-get -yq install docker-ce docker-ce-cli containerd.io;
sleep 10;
echo "sleep 10" >> /tmp/meio;
docker run -d --name atlantis -p 4141:4141 runatlantis/atlantis server --gh-user=dmalicia --gh-token=672d727d71584c0ab17e6bc5a80ca77298a99147 --repo-allowlist github.com/dmalicia/dm-terraform --repo-config=/repos.yaml;

echo "sleep docker is up?" >> /tmp/meio;
git clone https://github.com/dmalicia/dm-terraform.git /usr/local/share/dm-terraform/
docker cp /usr/local/share/dm-terraform/seed/bootstrap/initdm.sh atlantis:/
docker cp /usr/local/share/dm-terraform/seed/bootstrap/repos.yaml atlantis:/
docker restart atlantis
cat >> /config.yml <<EOF
web_addr: localhost:41414
tunnels:
  atlantis:
    addr: 4141
    bind_tls: true
    proto: http
EOF
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip /
unzip /ngrok-stable-linux-amd64.zip 
./ngrok start atlantis --config /config.yml -log=/tmp/klog > /dev/null &
wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb /
sleep 10
sudo dpkg -i /puppetlabs-release-trusty.deb
echo "instalou?" >> /tmp/meio;
sudo apt-get update
sudo apt-get install puppetmaster-passenger
sudo puppet master
