## Application deployment configuration
set :server,      'QA_SERVER'
set :user,        'QA_USER'
set :deploy_to,   -> { "/srv/services/#{fetch(:user)}" }
set :branch,      'qa'
set :application, fetch(:user)

## Server configuration
server fetch(:server), user: fetch(:user), roles: %w{web app db}, ssh_options: { forward_agent: true }

## Additional tasks
namespace :deploy do
  task :seed do
    on primary :db do within current_path do with rails_env: fetch(:stage) do
      execute :rake, 'db:seed'
    end end end
  end
end