
FROM ruby:2.5.7

COPY . /Instabug-Rails-Chat-App

WORKDIR /Instabug-Rails-Chat-App

RUN bundle install --deployment --without development test \
    && apt-get update \
    && apt-get install redis-server \
    && apt-get install mariadb \ 
    && rails db:create \
    && rails db:migrate

ENV RAILS_ENV production

#Start Sidekiq
CMD bundle exec sidekiq
