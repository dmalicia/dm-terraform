sudo apt-get update;
sleep 120
# gpg import in the seed to decrypt creds
sudo apt-get install -yq build-essential python-pip rsync software-properties-common apt-transport-https unzip;
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -;
A=`lsb_release -cs`;
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $A stable";
sleep 3
sudo apt-get update
sudo apt-get -yq install docker-ce docker-ce-cli containerd.io;
git clone https://github.com/dmalicia/dm-terraform.git /usr/local/share/dm-terraform/
sleep 10;
echo "sleep 10" >> /tmp/meio;
docker run --name atlantis -d -p 4141:4141 -v /usr/local/share/dm-terraform:/usr/local/share/dm-terraform runatlantis/atlantis server --gh-user=dmalicia --gh-token=c4d5e72d0ce72e6dc95a966f5cdee528f8115843 --repo-allowlist github.com/dmalicia/dm-terraform --repo-config=/usr/local/share/dm-terraform/seed/bootstrap/repos.yaml
echo $token
echo "sleep docker is up?" >> /tmp/meio;
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
sudo apt-get install puppetmaster-passenger -yq
#sudo puppet master
gpg --decrypt /usr/local/share/dm-terraform/seed/bootstrap/ecreds.json.gpg > /usr/local/share/dm-terraform/seed/bootstrap/creds.json
docker cp /usr/local/share/dm-terraform/seed/bootstrap/creds.json atlantis:/tmp
docker restart atlantis
