# AccountNewsApp
 
 
**Using firebase.google.com for backend.**

**Using newsapi.org for news.**

**Using apixu.com for weather.**

**Application should remember user. If you close the application and open it you will not have to re-sign in.**


-	**Account registration(sign in / sign up)**

-	**First setup(first name, last name, mobile number, date of birth)**

-	**Navigation(left menu with these rows):**
	- News
	- News sources
	- Weather
	- Profile
	- Logout

-	**News ( main view ):**
	- Showing news headlines according to selected news sources with endless scrolling
	- Pull to refresh
	- When clicking the news headline - transition to detailed view with full news text and image
	- In detailed view ability to return to news headline list or show next / previous news

-	**News sources:** 
	- Showing news sources
	- Ability to choose several sources
	- New user should have 4-5 news sources(of your choice) by default
	- Save news sources for every user on server.

-	**Weather:**
	- View with detailed information about weather according to the city set up in profile 

-	**Profile:**
	- View with ability to change information about user(password, first name, last name, country, city, mobile number)
	- Three countries to choose from(Ukraine, Poland, Germany)
	- List of cities is limited and depends on the selected country.
	- Ukraine(Kyiv, Kharkiv, Dnipro, Lviv)
	- Poland(Warsaw, Krakow, Lodz, Poznan)
	- Germany(Berlin, Munich, Cologne, Hamburg)

-	**Logout:**
	- Logout user from the app and show sign in view
