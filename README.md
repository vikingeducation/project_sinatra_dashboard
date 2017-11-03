# project_sinatra_dashboard
let's go for a job hunt!

[A Ruby and Sinatra project that uses web scraping with the Mechanize gem from the Viking Code School](http://www.vikingcodeschool.com)


Anne Richardson

## Project Status

App Complete

## How to Use This App

This app is easy to install and run, however the scraping takes 30-seconds to a couple of minutes, and that's kind of janky.

### To Install

1. `fork` and `clone` the app.
2. Run `bundle`
4. Go to [Glassdoor](https://www.glassdoor.com/developer/index.htm) to get an API key
3. Generate a `.env` file and populate it with these variables
```
EX_IP_ADDRESS = '192.30.253.112'  # or any default IP address you care to use
partner_id = 'your glassdoor partner id'
api_key = 'your glassdoor api key'
```

### To Use

In terminal, run the main app file
```
ruby app.rb

# crtl + c to exit
```

Navigate to localhost
```
http://localhost:4567/
```

Enter your search parameters and click the Scrap button. Results will appear on the same page in about 1 minute after the scraping is complete. Click on the job title to see more info on that job or the company name to see more info on that company.

## Supporting Info

### FreeGeo API

Find it [here](http://freegeoip.net/)

Sample FreeGeo API Response:

```
{"ip":"192.30.253.112","country_code":"US","country_name":"United States","region_code":"CA","region_name":"California","city":"San Francisco","zip_code":"94107","time_zone":"America/Los_Angeles","latitude":37.7697,"longitude":-122.3933,"metro_code":807}
```

### Glassdoor API

Find it [here](https://www.glassdoor.com/developer/index.htm)

Required links:

- [logo](http://static.glassdoor.com/static/img/widget/gd-logo-80.png)
- [attribution link](https://www.glassdoor.com/Reviews/index.htm)
