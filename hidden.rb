module HiddenInfo

  PARTNER_ID = # enter your Partner ID from Glassdoor.com
  PARTNER_KEY = # enter your Partner Key from Glassdoor.com 
  WEBSITE =  "http://api.glassdoor.com/api/api.htm"

  PARAMETERS = { :partner_id => PARTNER_ID,
                 :partner_key => PARTNER_KEY,
                 :useragent => "chrome",
                 :format => "json",
                 :v => 1,
                 :action => "employers",
               }

end
