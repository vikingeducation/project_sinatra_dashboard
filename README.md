# project_sinatra_dashboard
[A Ruby and Sinatra project that uses web scraping with the Mechanize gem from the Viking Code School](http://www.vikingcodeschool.com)

by Sia Karamalegos

Job Hunt Sinatra application that allows the user to search for jobs based on keywords and location (or use current location), and returns results from Dice.com using a web scraper.

Also provides rating and review information on each company returned from the search using the Glassdoor API.

## Instructions to Run Locally

Obtain API keys from Glassdoor and put in a file called *env.yml*, like so:

```
GLASSDOOR_PARTNER_ID: [your id]
GLASSDOOR_KEY:  [your key]
```

Run the Sinatra server: `ruby app.rb`.
