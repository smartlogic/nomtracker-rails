
desc 'Lazy load net/ssh'
task :net_ssh do
  gem 'net-ssh', '~> 2.0.11'
  require 'net/ssh'  
end

desc 'Full production deployment'
task :deploy => ['deploy:package', 'deploy:apply']

namespace :deploy do  
  desc "Tarballs up the necessary files, uploads to /releases directory on server"
  task :package do  
    local = <<-SHELL
[ -d /tmp/nomtracker ] || (cd /tmp && git clone git@git.slsdev.net:nomtracker.git);
cd /tmp/nomtracker && git pull origin master && \
cd /tmp/nomtracker/rails && tar czf nomtracker.tar.gz app config/*.yml config/*.rb config/initializers config/locales config/production db lib public Rakefile script vendor && \
scp nomtracker.tar.gz deploy@production.slsdev.net:/var/vhosts/nomtracker/releases
    SHELL

    output = system(local)
    puts "Local command completed"
    puts "======================="
    puts output

    raise "Non-zero exit status: #{$?.exitstatus}: #{$?.inspect}" if $?.exitstatus != 0
  end
  
  desc "Tarball has been uploaded, now we want to actually perform the server dance"
  task :apply => :net_ssh do
  
    remote_path = "/var/vhosts/nomtracker"
  
    remote = <<-REMOTE
last_build=`ls -l /var/vhosts/nomtracker/releases | awk '$1 ~ /^d/ && $8 ~ /^[0-9]+$/ { max = $8 }; END { printf "%04d", max }'` && \
new_build_num=`expr $last_build + 1` && \
build=`printf "%04d" $new_build_num` && \
mkdir -p /var/vhosts/nomtracker/releases/$build && tar xzf /var/vhosts/nomtracker/releases/nomtracker.tar.gz -C /var/vhosts/nomtracker/releases/`expr $build` && \
mysqldump -u nomtracker --password=n0mTr@ck3r nomtracker | gzip - > /var/vhosts/nomtracker/backups/`expr $last_build`.sql.gz && \
tar czf /var/vhosts/nomtracker/backups/$last_build.tar.gz /var/vhosts/nomtracker/shared && \
cd /var/vhosts/nomtracker/releases/$build && rake db:migrate RAILS_ENV=production && \
rm -f /var/vhosts/nomtracker/current && ln -s /var/vhosts/nomtracker/releases/$build /var/vhosts/nomtracker/current && \
ln -s /var/log/nomtracker /var/vhosts/nomtracker/current/log && \
rm -f /var/vhosts/nomtracker/shared/passenger.conf && ln -s /var/vhosts/nomtracker/current/config/production/apache.conf /var/vhosts/nomtracker/shared/passenger.conf && \
mkdir -p /var/vhosts/nomtracker/current/tmp && touch /var/vhosts/nomtracker/current/tmp/restart.txt
    REMOTE
  
    Net::SSH.start('production.slsdev.net', 'deploy') do |ssh|
      output = ssh.exec!(remote)
      puts "Remote command completed"
      puts "========================"
      puts output
    end
  end

end

task :sync => ['sync:db', 'sync:content']

namespace :sync do
  task :db => :net_ssh do
    # check local cache
      # check remote cache
        # generate dump
    remote = <<-REMOTE
      mkdir -p /var/vhosts/nomtracker/snapshots && \
      mysqldump -u nomtracker --password=n0mTr@ck3r nomtracker | gzip - > /var/vhosts/nomtracker/snapshots/db.sql.gz
    REMOTE
    
    Net::SSH.start('production.slsdev.net', 'deploy') do |ssh|
      output = ssh.exec!(remote)
      puts "Remote command completed"
      puts "========================"
      puts output
    end
    
    # download
    # restore
    local = <<-LOCAL
      mkdir -p tmp && \
      scp deploy@production.slsdev.net:/var/vhosts/nomtracker/snapshots/db.sql.gz tmp/db.sql.gz && \
      gunzip tmp/db.sql.gz && \
      rake db:drop db:create && \
      mysql -u root nomtracker < tmp/db.sql && \
      rake db:migrate
    LOCAL
    
    output = system(local)
    puts "Local command completed"
    puts "======================="
    puts output

    raise "Non-zero exit status: #{$?.exitstatus}: #{$?.inspect}" if $?.exitstatus != 0
    
  end
  
  task :content do 
    
  end
end