sudo apt-get update;
sleep 600
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
docker run --name atlantis -d -p 4141:4141 -v /usr/local/share/dm-terraform:/usr/local/share/dm-terraform runatlantis/atlantis server --gh-user=dmalicia --gh-token=$GH_token --repo-allowlist github.com/dmalicia/dm-terraform --repo-config=/usr/local/share/dm-terraform/seed/bootstrap/repos.yaml
docker restart atlantis
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip /
unzip /ngrok-stable-linux-amd64.zip 
./ngrok start atlantis --config /usr/local/share/dm-terraform/seed/bootstrap/config.yml -log=/tmp/klog > /dev/null &
wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb /
sleep 10
sudo dpkg -i /puppetlabs-release-trusty.deb
sudo apt-get update
sudo apt-get install puppetmaster-passenger -yq
#sudo puppet master
gpg --decrypt /usr/local/share/dm-terraform/seed/bootstrap/ecreds.json.gpg > /usr/local/share/dm-terraform/seed/bootstrap/creds.json
docker cp /usr/local/share/dm-terraform/seed/bootstrap/creds.json atlantis:/
docker restart atlantis
sudo puppet module install garethr-docker
