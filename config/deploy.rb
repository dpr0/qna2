# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'qna'
set :repo_url, 'git@github.com:dimarikpro/qna2.git'
set :deploy_to, '/home/deploy/qna'
#set :deploy_user, 'deploy'
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/private_pub.yml', 'config/private_pub_thin.yml', '.env') #, 'config/secrets.yml'
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

namespace :deploy do
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end
  after :publishing, :restart
end

namespace :private_pub do
  task :start do #desk 'Start ptivate_pub server'
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec thin -C config/private_pub_thin.yml start"
        end
      end
    end
  end
  task :stop do #desk 'Stop ptivate_pub server'
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec thin -C config/private_pub_thin.yml stop"
        end
      end
    end
  end
  task :restart do #desk 'Restart ptivate_pub server'
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec thin -C config/private_pub_thin.yml restart"
        end
      end
    end
  end
end

after "deploy:restart", "private_pub:restart"