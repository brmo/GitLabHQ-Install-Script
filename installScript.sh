#!/bin/sh

sudo apt-get update -y
sudo apt-get upgrade -y

sudo apt-get install -y git-core wget curl gcc checkinstall libxml2-dev libxslt1-dev sqlite3 libsqlite3-dev libcurl4-openssl-dev libreadline-gplv2-dev libc6-dev libssl-dev libmysql++-dev make build-essential zlib1g-dev libicu-dev redis-server openssh-server python-dev python-pip p7zip-full s3cmd

cd /tmp
wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p194.tar.gz
tar xfvz ruby-1.9.3-p194.tar.gz
cd ruby-1.9.3-p194
./configure
sudo make
sudo make install

sudo adduser --system --shell /bin/sh --gecos 'git version control' --group --disabled-password --home /home/git git
sudo adduser --disabled-login --gecos 'gitlab system' gitlabhq
sudo usermod -a -G git gitlabhq
ssh-keygen -q -N '' -t rsa -f /home/gitlabhq/.ssh/authorized_keys
sudo -H -u gitlabhq ssh-keygen -q -N '' -t rsa -f /home/gitlabhq/.ssh/id_rsa
sudo service ssh restart
ssh -q -o "StrictHostKeyChecking no" gitlabhq@localhost

cd /home/git
sudo -H -u git git clone git://github.com/gitlabhq/gitolite /home/git/gitolite

sudo -u git -H /home/git/gitolite/src/gl-system-install
sudo cp /home/gitlabhq/.ssh/id_rsa.pub /home/git/gitlabhq.pub
sudo chmod 777 /home/git/gitlabhq.pub

sudo -u git -H sed -i 's/0077/0007/g' /home/git/share/gitolite/conf/example.gitolite.rc
sudo -u git -H sh -c "PATH=/home/git/bin:$PATH; gl-setup -q /home/git/gitlabhq.pub"

sudo chmod -R g+rwX /home/git/repositories/
sudo chown -R git:git /home/git/repositories/

git config --global user.email "brian.morris.personal@gmail.com"
git config --global user.name "Brian Morris"


