require "bundler/capistrano"
require 'fast_git_deploy/enable'

set :application, "rails_app"
set :repository,  "https://github.com/brunosoab/rails_app.git"
set :deploy_to, "/u/apps/#{application}"
set :scm, :git

set :user, "vagrant"
set :branch, "master"
set :deploy_type, 'deploy'
set :use_sudo, false

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
ssh_options[:keys] = [File.join(ENV["HOME"], ".vagrant.d", "insecure_private_key")]

role :app, "brunosbarros.test"
role :web, "brunosbarros.test"
role :db,  "brunosbarros.test", :primary => true

after "deploy:setup" do
  deploy.fast_git_setup.clone_repository
  run "cd #{current_path} && bundle install"
end

namespace :unicorn do
  desc "Start unicorn for this application"
  task :start do
    run "cd #{current_path} && bundle exec unicorn -c /etc/unicorn/rails_app.conf.rb -D"
  end
end

namespace :deploy do
  task :symlink do
  # no-op to remove default symlink task, not needed by fast_git_deploy
  end
end