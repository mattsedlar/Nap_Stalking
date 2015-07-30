# README for Daycare Naps Data

## Origin of the data

This data set is pulled from the website Daily Childcare Report, a site that works with daycares to post reports on feeding, sleeping, and other various activities. The site is password protected for privacy, so this data can only be obtained by the family of a child.

## How is this data obtained?

Obtaining data requires:

* Access to Daily Childcare Report
* R (v. 3.2.0)

The following R packages.

* dplyr (v. 0.4.2)
* tidyr (v. 0.2.0)
* httr (v. 1.0.0)
* XML (v. 3.98.1.3)

## Scraping the data

The data is obtained using the __access.R__ and __scrape.R__ scripts. __access.R__ loads the httr package and uses the GET function to open the site and authenticate access. You'll have to copy the script below and create your own version since I'm obviously not posting my access information here. Replace the __USERNAME__ and __PASSWORD__ with your own.

```{r}
library(httr)

pg <- GET("https://www.dailychildcarereport.com",
          authenticate("USERNAME","PASSWORD"))
```

The script also requires you knowing how many pages of reports are available, so you can create handles for each. Below is an example (Note: ID in the path is your account ID): 

```{r}
reports1 <- GET(handle=pg,path="/minors/ID/all_reports?page=1")
reports2 <- GET(handle=pg,path="/minors/ID/all_reports?page=2")
```

The __scrape.R__ script parses the content for each report identified in the __access.R__ (some modification necessary), converts each to a data frame, then binds them together.

There's a little bit of cleaning before it gets to the __cleaning_script.R__ script because the parsed content is difficult to read. Finally it gets written to a csv file in the data folder.

## Getting tidy data from the OutWit Hub data

The __cleaning_script.R__ creates a tidy data set from the OutWit Hub CSV.

More to come...

## Variables in tidy data

*__Date__: Date of the naps

The day is broken into three groups: morning, midday, and afternoon. Morning is any time between 7 a.m. and 10 a.m. Midday is between 10 p.m. and 1 p.m. Afternoon is between 1 p.m. and 4 p.m. 

*__morningstart__: Start of morning nap.
*__morningend__: End of morning nap.
*__middaystart__: Start of midday nap.
*__middayend__: End of midday nap.
*__afternoonstart__: Start of afternoon nap.
*__afternoonend__: End of afternoon nap.

## Areas of improvement

The complicated method of pulling data is a weak aspect of this script as it:

* Limits access to data to members of a closed site.
* Requires knowledge of how many pages of reports are available, leading to modification of the __scrape.R__ script.
