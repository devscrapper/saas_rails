#---------------------------------------------------------------------------------------------------------------------
# deploy Rail 4 avec capistrano V3
#---------------------------------------------------------------------------------------------------------------------
#
# first deploy :
# -------------
# install rvm :
# install ruby :
# install mysql :
# install passenger/nginx :

# Next deploy :
# -------------
# avant tout deploy, il faut publier sur https://devscrapper/statupweb.git avec la commande
# git push origin master
#
# pour deployer dans un terminal avec ruby 223 dans la path : cap production deploy
# cette commande prend en charge :
# la publication des sources vers le serveur cible
# les migration mysql
# la publication des fichiers de param�rage : database.yml, secret.yml(n'est pas utilis�, car on lit la var d'enviroennemnt
# dans le fichier application.config.rb => la var est defini dans le fichier /etc/profile : EXPORT SECRET_KEY_BASE="la cl�")
# les liens vers les repertoires partag�s et le current vers les relaease
# le redemarrage de passenger
# le redemraage de delay_job (en production)
#---------------------------------------------------------------------------------------------------------------------

lock '3.4.1'

set :application, 'saas_rails'
set :repo_url, "git@github.com://github.com/devscrapper/#{fetch(:application)}.git/"
set :repo_url, "https://github.com/devscrapper/#{fetch(:application)}.git/"
set :github_access_token, '64c0b7864a901bc6a9d7cd851ab5fb431196299e'
set :default, 'master'
set :user, 'eric'
set :pty, true
set :use_sudo, false
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :rvm_ruby_version, '2.2.3'
set :passenger_rvm_ruby_version, '2.2.3'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/captcha.yml', 'config/secrets.yml', 'config/mail_sender.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/images', 'public/licenses')

# Default value for default_env is {}
set :default_env, {path: "/opt/ruby/bin:$PATH"}

# Default value for keep_releases is 5
set :keep_releases, 3


set :passenger_roles, :app
set :passenger_restart_runner, :sequence
set :passenger_restart_wait, 5
set :passenger_restart_limit, 2
set :passenger_restart_with_sudo, false
set :passenger_environment_variables, {}
set :passenger_restart_command, 'passenger-config restart-app'
set :passenger_restart_options, -> { "#{fetch(deploy_to)} --ignore-app-not-running" }

#----------------------------------------------------------------------------------------------------------------------
# task list : git push
#----------------------------------------------------------------------------------------------------------------------
namespace :git do
  task :push do
    on roles(:all) do
      run_locally do
        system 'git push origin master --force'
      end
    end
  end
end
#----------------------------------------------------------------------------------------------------------------------
# task list : log
#----------------------------------------------------------------------------------------------------------------------
namespace :log do
  task :down do
    on roles(:app) do
      begin
        capture("ls #{File.join(current_path, 'log', '*.*')}").split(/\r\n/).each { |log_file|
          get log_file, File.join(File.dirname(__FILE__), '..', 'log', File.basename(log_file))
        }
      rescue Exception => e
        p "dont down log : #{e.message}"
      end
    end
  end
  task :delete do
    on roles(:app) do
      begin
        execute :rm, "-rf", "#{File.join(current_path, 'log', '*.*')}"
      rescue Exception => e
      end
    end
  end
end

namespace :images do
  task :up do
    on roles(:app) do
      begin
        upload! File.join(File.dirname(__FILE__), '..', 'public', "images"),
                File.join(current_path, 'public'),
                :recursive    => true
      rescue Exception => e
        p "dont up image : #{e.message}"
      end
    end
  end
end
namespace :deploy do
  task :bundle_install do
    on roles(:app) do
      within release_path do
        execute :bundle, "--gemfile Gemfile --path #{shared_path}/bundle  --binstubs #{shared_path}bin --without [:development]"
      end
    end
  end
end
before 'deploy:updating', "git:push"
after "deploy:updating", "log:delete"
after "deploy:updating", "images:up"
after 'deploy:updating', 'deploy:bundle_install'