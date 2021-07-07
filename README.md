# project_sinatra_dashboard
let's go for a job hunt!

## Bideo Wego

## Usage

1. In order to use the scraper you must create a `env.yaml` file with the following credentials
	- NOTE: the IP address is only used in development mode

	```yaml
	---
	ip: YOUR_IP_ADDRESS

	glassdoor_partner_id: GLASSDOOR_API_PARTNER_ID
	glassdoor_api_key: GLASSDOOR_API_KEY
	```

1. Next start up the server in the root directory

	```shell
	$ ruby app.rb
	```

1. Navigate to `'/'`
1. Enter a keyword and location for your search
1. Submit the form
	- NOTE: the server log will print the progress of the scrape as it scrapes
	- NOTE: scraping sleeps in between calls, it takes a while
1. To visit a link to a job on dice click the link under 'link'
1. To visit a page with the Glassdoor API info of the company, click the link under 'company_name'

[A Ruby and Sinatra project that uses web scraping with the Mechanize gem from the Viking Code School](http://www.vikingcodeschool.com)
