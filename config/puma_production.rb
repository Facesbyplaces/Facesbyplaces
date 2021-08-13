app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}/shared"

threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

port        ENV.fetch("PORT") { 3000 }
environment ENV.fetch("RAILS_ENV") { "production" }

# Set up socket location
bind "unix://#{shared_dir}/sockets/puma.sock"

stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true

plugin :tmp_restart