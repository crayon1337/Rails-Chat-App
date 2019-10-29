# Rails 5 Chat System
## Introduction
I have successfully completed the BE Engineer Challenge. Please keep in mind, I never coded in Ruby in my entire IT-life as I used to code in PHP (Laravel & Zend Framework). Therefore, I have bold knowledge of MVC Web-Frameworks so the concept is the same I only struggled a little bit with the new environment/syntax. But, I always find it challenging to learn new technologies so I could expand my knowledge. One week ago, I did not know how to setup Rails/Gem/Bundler. But, with a little bit of search I managed to do that and then I started to design the system **(brainstorming)** and I structured the application as the very first thing I would do. 
## Application Structure
I used the `--api` tag because I wanted to skip unnecessary files as long as all we need is an API *No GUI Required*
### Controllers
 - Applications Controller
 - Chats Controller
 - Messages Controller 
### Models
 - Application 
 - Chat
 - Message
### Workers
 - ChatsWorker
 - MessagesWorker
## Dependencies
 - [Ruby version 2.5.7](https://rubyinstaller.org/downloads/)
 - [Rails version 5.2.3](https://rubygems.org/gems/rails/versions/5.2.3)
 - Gem version 2.7.6.2
 - Bundler version 2.0.2
 - [MariaDB v10.4.6](https://mariadb.com/kb/en/library/mariadb-1046-release-notes/) 
 - [Elastic Search Rails](https://github.com/elastic/elasticsearch-rails) to build the search engine for messages
 - [Sidekiq](https://github.com/mperham/sidekiq) to process background jobs for messages/chats creation endpoints
 - [Sidekiq::Status](https://github.com/utgarda/sidekiq-status) to get the status of previously ran worker
 - [Redis](https://redis.io/) to store Sidekiq processes
 ## Softwares
The following softwares I used during the development of this application:
- [VS Code](https://code.visualstudio.com/)
- [Postman](https://www.getpostman.com/)
- [Navicat](https://www.navicat.com/en/)
- [Hyper Terminal](https://hyper.is/)
- [Github Desktop](https://desktop.github.com/)
- [Git](https://git-scm.com/)
- [Google Chrome](https://www.google.com/chrome/)
- [Virtualbox]([Virtualbox.org]) I like to have a local dev-servers
## Development Deployment
 - Navigate to [Ruby Installer page]([https://rubyinstaller.org/downloads/]) and download version 2.5.7 
 - Run the installer
 - Install Rails v5.2.3 using gem by executing`gem 'rails', '~> 5.2', '>= 5.2.3'` in your terminal/cmd
 - Install MariaDB for Ubuntu/CentOS use this [guide](https://computingforgeeks.com/install-mariadb-10-on-ubuntu-18-04-and-centos-7/) and for windows follow [this](https://mariadb.com/kb/en/library/installing-mariadb-msi-packages-on-windows/)
 - Download & Install [Elastic Search](https://www.elastic.co/guide/en/elasticsearch/reference/current/install-elasticsearch.html)
 - Clone the [repo]([https://github.com/crayon1337/Rails-Chat-App]) by executing `git clone https://github.com/crayon1337/Rails-Chat-App.git`
 - Change directory to the app folder `cd rails-chat-app`
 - Install gem dependencies `bundler install`
 - Create & migrate the database by executing `rails db:create db:migrate`
 - Run sidekiq using `bundle exec sidekiq`
 - Run elastic search using `elasticsearch`
 - Finally, run the built-in development server using `rails s`
 ## Deploy Using Docker
- Increase vm max cap for ElasticSearch `sudo sysctl -w vm.max_map_count=262144`
- Increase max file descriptors `ulimit -n 65536`
- Run Docker Composer `docker-compose up`
 
 Now that you can run the application let's take a look at the routes
 
 ## Routes
 The following table shows available routes in the application

| Prefix  | Verb  | URL  Pattern | Controller#Action  |
| --- | --- | --- | --- |
| root | GET | / | home#index |
| sidekiq_web |   | /sidekiq | Sidekiq::Web |
| application_chat_messages  | GET  | /applications/:application_token/chats/:chat_token/messages(.:format) | messages#index |
| application_chat_messages  | POST | /applications/:application_token/chats/:chat_token/messages(.:format) | messages#create |
| application_chat_message | GET | /applications/:application_token/chats/:chat_token/messages/:token(.:format) | messages#show |
| application_chat_message | PATCH | /applications/:application_token/chats/:chat_token/messages/:token(.:format) | messages#update |
| application_chat_message | PUT | /applications/:application_token/chats/:chat_token/messages/:token(.:format) | messages#update |
| application_chat_message | DELETE | /applications/:application_token/chats/:chat_token/messages/:token(.:format) | messages#destroy |
| application_chats | GET | /applications/:application_token/chats(.:format) | chats#index |
| application_chats | POST | /applications/:application_token/chats(.:format) | chats#create |
| application_chat | GET | /applications/:application_token/chats/:token(.:format) |  chats#show |
| application_chat | PATCH | /applications/:application_token/chats/:token(.:format) | chats#update |
| application_chat | PUT | /applications/:application_token/chats/:token(.:format) | chats#update |
| application_chat | DELETE | /applications/:application_token/chats/:token(.:format) | chats#destroy |
| applications | POST | /applications(.:format) | applications#create |
| application | GET | /applications/:token(.:format) | applications#show |
| application | PATCH | /applications/:token(.:format) | applications#update |
| application | PUT | /applications/:token(.:format) | applications#update |
| application | DELETE | /applications/:token(.:format) | applications#destroy |
| application_chat_search | GET | /applications/:application_token/chats/:chat_token/search(.:format) |  search#doFullMagic |
| job | GET | /job/:jid(.:format) | home#job |

## Consume Endpoints
### Create an application
To create an application send a `POST` request to `/applications` with the name parameter. 

Example: 
```code 
curl -d "name=test" -X POST http://localhost:3000/applications
```
Once the command above is executed you should get the following response 
```code 
{"msg":"Application has been created.","token":"2d025550899672aac1840ff1db6ddaf1f3b2d620"}
```
### Create a chat 
Now that we have an application token we can use it to create a chat. The token we just generated is: `2d025550899672aac1840ff1db6ddaf1f3b2d620`
To create a chat in an application send a `POST` request to `/applications/:token/chats` with the name parameter

Example:  
```code 
curl -d "name=chitchat" -X POST http://localhost:3000/applications/e16836e2bce1bd25b0ab3304b9f26b51acf36fd2/chats
```
Once the command above is executed you should get the following response 
```code 
{"Status":"Success","Message":"Your chat is being created by our server.","ChatNumber":1,"ApplicationToken":"2d025550899672aac1840ff1db6ddaf1f3b2d620","JobID":"d2c13480f9efe690e70ee095"}
```
### Send a message
Now that we have an application token and chat number we can use that to send a message to that chat. The chat number we just created is: `1`
To send a message to a particular chat send a `POST` request to `/applications/:app_token/chats/:chat_number/messages` with sender & body parameters

Example: 
```code 
curl -d "sender=Crayon&body=foobar" -X POST http://localhost:3000/applications/2d025550899672aac1840ff1db6ddaf1f3b2d620/chats/1/messages
```
Once the command above is executed you should get the following response
```code
{"Status":"Success","Message":"Your message is being processed by our server","MessageNumber":1,"ChatNumber":"1","ApplicationToken":"2d025550899672aac1840ff1db6ddaf1f3b2d620","JobID":"44cb8e85192f6501b76eb8fb"}
```
Now we successfully created an application, chat and a message. In order to check the jobs ran when we used chats/messages creation endpoints execute `curl http://localhost:3000/job/44cb8e85192f6501b76eb8fb` the `job_id` parameter is the one returned from the previous message creation. Once you hit that endpoint you should see 
```code
{"message":"Message has been created successfully","update_time":"1572291835","jid":"44cb8e85192f6501b76eb8fb","status":"complete","worker":"MessagesWorker","args":"[\"Crayon\",\"foobar\",1,\"2d025550899672aac1840ff1db6ddaf1f3b2d620\",\"1\"]"}
```
Again, you can browse all available request methods and routes in the routes table above.

## Flood Test
I wrote a tiny program using C# to flood the API using [System.Net.Http.HttpClient](https://docs.microsoft.com/en-us/dotnet/api/system.net.http.httpclient.postasync?view=netframework-4.8) to see how it would behave when the server is flooded by a LOT of requests and the response was satisfying for me especially after integrating Sidekiq background jobs processor

## Conclusion 
I have had a lot of fun creating this application because I had no clue what Rails is before I start. I used Trello [board](https://trello.com/b/ToakvioE/chat-system) to manage and organize the ToDos for this application. Hopefully, you will find it convenient. Also, make sure to check the commits history of this repo so you can see the progress I made. From 'just get it to work' to 'Code optimizations'
