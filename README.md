# project_sinatra_dashboard
let's go for an apartment hunt!
by Steven Chang
-------------------------------

[A Ruby and Sinatra project that uses web scraping with the Mechanize gem from the Viking Code School](http://www.vikingcodeschool.com)

Getting Started

1. Fork and clone the project repo on Github
2. Add a .gitignore file that excludes your outputted CSV files from git (e.g. *.csv)
3. Add your name to the README file, commit the change, and push to your fork.

Helpful Tips

1. Add the Reloader functionality to Sinatra to make it much easier to develop with (you won't have to refresh your server so much). You can use the development? method to ask whether you're in development and only include it if you are. (DONE - USING RERUN)

2. To use Mechanize with Sinatra, you'll typically need to switch from using the default web server to using another like Thin. It should be enough to add gem 'thin' to your Gemfile. (DONE)

3. To deploy a Sinatra app to Heroku, you'll need to add a config.ru file so Heroku knows how to start it up. More information here. Note that we'll cover deployment in much more depth in the future, so don't sweat this. (DIDN'T DO)
