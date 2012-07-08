
sudo -u gitlabhq -H git clone git@localhost:gitolite-admin.git /tmp/gitolite-admin
sudo rm -rf /tmp/gitolite-admin

sudo gem install charlock_holmes
sudo pip install pygments
sudo gem install bundler
cd /home/gitlabhq
sudo -H -u gitlabhq git clone git://github.com/gitlabhq/gitlabhq.git gitlabhq
cd gitlabhq

sudo -u gitlabhq cp config/gitlab.yml.example config/gitlab.yml

sudo -u gitlabhq cp config/database.yml.sqlite config/database.yml

sudo -u gitlabhq -H bundle install --without development test --deployment

sudo -u gitlabhq bundle exec rake gitlab:app:setup RAILS_ENV=production

sudo -u gitlabhq bundle exec rake gitlab:app:status RAILS_ENV=production

