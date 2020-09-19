sudo apt-get update;
rm -rf /etc/motd
sudo apt-get install -yq build-essential python-pip rsync software-properties-common apt-transport-https unzip;
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -;
A=`lsb_release -cs`;
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $A stable";
sleep 3
sudo apt-get update
sudo apt-get -yq install docker-ce docker-ce-cli containerd.io;
sleep 10;
echo "sleep 10" >> /tmp/meio;
git clone https://github.com/dmalicia/dm-terraform.git /usr/local/share/dm-terraform/
wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb /
sleep 10
sudo dpkg -i /puppetlabs-release-trusty.deb
echo "instalou?" >> /tmp/meio;
sudo apt-get update
sudo apt-get install puppet -yq
cat >> /etc/default/puppet <<EOF
START=yes
EOF
cat >> /puppet.conf <<EOF
[agent]
server = seed.dmlc.pw
EOF
cat >>
cp /puppet.conf /etc/puppet/puppet.conf
sudo service stop puppet
echo "*/5 * * * * root puppet agent -t" >> /etc/crontab
