## Application configuration
set :application,             'Project'
set :branch,                  -> { fetch(:stage) }
set :repo_url,                ''
set :linked_files,            fetch(:linked_files,  fetch(:env_links, [])).push('config/database.yml', 'config/secrets.yml')
set :linked_dirs,             fetch(:linked_dirs, []).push('log', 'tmp/pids', 'public/packs', 'node_modules', 'storage')

## Ruby configuration
set :rvm_type,                    :system
set :rvm_ruby_version,            'ruby-3.1'
set :rvm_path,                    '/usr/local/rvm'

# Currently Passenger is installed against the 'default' Ruby version
# This may change in future, but can be customised here
set :passenger_rvm_ruby_version,  'default'

## Capistrano configuration
set :log_level,     :info
set :pty,           true
set :keep_releases, 2

set :monit_processes, %w(delayed_job)
set :monit_roles, %w(db)

namespace :monit do
  task :config do
    on roles(fetch(:monit_roles, :db)) do
      execute :mkdir, '-p', shared_path.join('monit')
      fetch(:monit_processes).each do |process_name|
        filename = File.expand_path("../deploy/monit_templates/#{process_name}.monitrc.erb", __FILE__)
        erb = File.read(filename)
        upload! StringIO.new(ERB.new(erb, nil, '-').result(binding)), File.join(shared_path, 'monit', "#{process_name}.monitrc")
      end
      sudo 'monit', 'reload'
    end
  end

  task :monitor do
    on roles(fetch(:monit_roles, :db)) do
      sudo 'monit', '-g', fetch(:user), 'monitor'
    end
  end

  task :unmonitor do
    on roles(fetch(:monit_roles, :db)) do
      begin
        sudo 'monit', '-g', fetch(:user), 'unmonitor'
      rescue
      end
    end
  end
end

## Update monit configuration during deployment
before 'deploy:updating', 'monit:unmonitor'
after  "deploy:updated", 'monit:config'
after 'deploy:finished', 'monit:monitor'

## Whenever configuration
set :whenever_command,        [:bundle, :exec, :whenever]
set :whenever_roles,          [:db]
set :whenever_environment,    -> { (fetch(:rails_env) || fetch(:stage)) }
set :whenever_identifier,     -> { "#{fetch(:application)}-#{fetch(:whenever_environment)}" }
set :whenever_variables,      -> { "\"environment=#{fetch(:whenever_environment)}&delayed_job_args_p=#{fetch(:delayed_job_identifier)}&delayed_job_args_n=#{fetch(:delayed_job_workers)}\"" }

## Delayed Job configuration
set :delayed_job_roles,       [:db]
set :delayed_job_environment, -> { (fetch(:rails_env) || fetch(:stage)) }
set :delayed_job_identifier,  -> { "#{fetch(:application)}-#{fetch(:delayed_job_environment)}" }
set :delayed_job_workers,     -> { (fetch(:dj_workers) || '1') }
set :delayed_job_args,        -> { "-p #{fetch(:delayed_job_identifier)} -n #{fetch(:delayed_job_workers)}" }

namespace :delayed_job do
  def args
    fetch(:delayed_job_args, '')
  end

  def delayed_job_roles
    fetch(:delayed_job_roles, :db)
  end

  desc 'Stop the delayed_job process'
  task :stop do
    on roles(delayed_job_roles) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, :'bin/delayed_job', :stop
        end
      end
    end
  end

  desc 'Start the delayed_job process'
  task :start do
    on roles(delayed_job_roles) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, :'bin/delayed_job', args, :start
        end
      end
    end
  end

  desc 'Restart the delayed_job process'
  task :restart do
    on roles(delayed_job_roles) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, :'bin/delayed_job', args, :restart
        end
      end
    end
  end
end

namespace :deploy do
  ## Capistrano has removed the task deploy:migrations which epiDeploy calls
  task :migrations do
    invoke 'deploy'
  end
end

Rake::Task["deploy:assets:backup_manifest"].clear_actions

## Restart delayed_job during the deployment process
after  'deploy:updated',  'delayed_job:stop'
before 'deploy:finished', 'delayed_job:start'
