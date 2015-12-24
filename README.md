# Job Hunt
[A Ruby and Sinatra project that uses web scraping with the Mechanize gem from the Viking Code School](http://www.vikingcodeschool.com) for the project_sinatra_dashboard

by Sia Karamalegos

Job Hunt is a Sinatra application that allows the user to search for jobs based on keywords and location (or use current location based on IP address through the [freegeoip API](http://freegeoip.net/)), and returns results from [Dice.com](http://www.dice.com/) using a web scraper.

Job Hunt also provides rating and review information on each company returned from the search using the [Glassdoor API](https://www.glassdoor.com/developer/index.htm).

You can find the deployed app here:
[Job Hunt Central](https://jobhuntcentral.herokuapp.com/)

## Instructions to Run Locally

Obtain API keys from Glassdoor and put in a file called *env.yml*, like so:

```
GLASSDOOR_PARTNER_ID: [your id]
GLASSDOOR_KEY:  [your key]
```

Run the Sinatra server: `ruby app.rb`.
