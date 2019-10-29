#!bin/bash
set -e

#Remove a potentially pre-existing server.pid for Rails
rm -f /Instabug-Rails-Chat-App/tmp/pids/server.pid

# Then exec the container's main process (What's set as CMD in the Dockerfile)
exec "$@"

#Start sideqie
bundle exec sidekiq