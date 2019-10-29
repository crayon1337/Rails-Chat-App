
#Create docker image (Ruby)
FROM ruby:2.5.7

#Copy the application files to container
COPY . /Instabug-Rails-Chat-App

WORKDIR /Instabug-Rails-Chat-App


RUN apt-get update -y \
    && apt-get install rubygems -y \
    && gem install bundler \
    && gem install rails -v 5.2.3 \
    && bundle lock --add-platform ruby \
    && bundle lock --add-platform x86_64-linux \
    && bundle install --deployment --without development test

#Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
ENV RAILS_ENV production

#Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]