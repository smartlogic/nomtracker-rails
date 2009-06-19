# load in the SLS recipes first
gem 'capistrano-extensions', '= 0.1.8'
gem 'passenger-recipes', '= 0.1.2'
set(:deployable_environments, [:production])
set(:config_structure, :sls)
require 'passenger-recipes/passenger'

set :application, "psl"

set :scm, 'git'
set :repository, "git@git.slsdev.net:sls/nomtracker.git"
ssh_options[:forward_agent] = true
set :branch, "master"
set :git_shallow_clone, 1

set(:deploy_to, "/var/vhosts/nomtracker")
set :user, "deploy"
set :apache_group, "www-data"

set(:remote_backup_expires, 1200) # 20 minutes
 
# Where uploaded content is stored
set :shared_content, {}

# lame dancing required to deploy a git subdirectory
set :copy_exclude, ["README", "air", "html_comps", "rails/test", "rails/tmp", "rails/doc", "rails/features", "rails/log", "rails/Capfile", "rails/config/deploy.rb"]

depend(:remote, :gemfile, "config/geminstaller.yml")  # ensure that all of our gems are installed

# staging do
#   set :ip, "12.167.155.8"
# end

production do
  set :ip, "12.167.155.9"
end

after :deploy, :symlink_maintenance
task :symlink_maintenance, :roles => :web, :except => { :no_release => true } do
  link = "#{shared_path}/maintenance.html"
  run("rm -f #{link} && ln -s #{link} #{current_path}/public/maintenance.html")
end

namespace :deploy do
  namespace :web do
    task :disable, :roles => :web, :except => { :no_release => true } do
      require 'erb'
      on_rollback { run "rm #{shared_path}/maintenance.html" }

      reason = ENV['REASON']
      deadline = ENV['UNTIL']

      template = File.read(File.join(File.dirname(__FILE__), "templates", "maintenance.rhtml"))
      result = ERB.new(template).result(binding)

      put result, "#{shared_path}/maintenance.html", :mode => 0644
    end

    task :enable, :roles => :web, :except => { :no_release => true } do
      run "rm #{shared_path}/maintenance.html"
    end
  end
  
end

role :app, "#{ip}"
role :db, "#{ip}", :primary => true
