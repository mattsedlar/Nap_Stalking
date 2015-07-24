# README for Daycare Naps Data

## Origin of the data

This data set is pulled from the website Daily Childcare Report, a site that works with daycares to post reports on feeding, sleeping, and other various activities. The site is password protected for privacy, so this data can only be obtained by the family of a child.

## How is this data obtained?

Obtaining data requires:

* Access to Daily Childcare Report
* OutWit Hub (v. 4.1.1.4)
* OutWit Hub scraper for extracting information (see below)
* R (v. 3.2.0)
* dplyr (v. 0.4.2)
* tidyr (v. 0.2.0)

## How to use the scraper

The scraper below should be imported into OutWit Hub as an XML file. Once it is installed you can execute it on any page. This particular scraper, however, will only gather data in the All Reports section of Daily Childcare Reports. You must execute the scraper after scrolling through all the reports (the content loads dynamically as you move down the page).

```{r}
<outwitAutomator>
<documentproperties>
<active>true</active>
<url>https://www.dailychildcarereport.com</url>
<masterId>{bfbf44b5-0d71-41f9-9fdb-d54daed18dc0}</masterId>
<name>dailychildcarereport.com Nap Scraper</name>
<version>1.0</version>
<versionId>{bfbf44b5-0d71-41f9-9fdb-d54daed18dc0}</versionId>
<automatorType>scraper</automatorType>
<kernelVersion>4.1.1.4</kernelVersion>
<creationOutfit>OutWit Hub</creationOutfit>
<author />
<company />
<created>2015-07-09T09:42:42-7:00</created>
<lastModified>2015-07-09T09:42:42-7:00</lastModified>
<comments />
<options>{"source":"DOM"}</options><hash>tLpDYC/Gyc8a1NWSC3mqLQ==</hash>
</documentproperties>
<data>
<line>
<ok>true</ok>
<description>Date</description>
<before>&lt;span class="wide_element"&gt;</before>
<after>&lt;/th&gt;</after>
<format></format>
<replace></replace>
<separator></separator>
<labels></labels>
</line>
<line>
<ok>true</ok>
<description>Sleep</description>
<before>Sleeps</before>
<after>Diaper changes</after>
<format></format>
<replace></replace>
<separator></separator>
<labels></labels>
</line>
</data>
</outwitAutomator>
```
The output of the scraper includes columns for id and source_url. I remove these before exporting to CSV. There is no harm in including them, but you'll have to remove them with R if you don't find them useful. The CSV is saved as OutWit\/scraped\/export.csv.

## Getting tidy data from the OutWit Hub data

The __cleaning_script.R__ creates a tidy data set from the OutWit Hub CSV.

More to come...

## Areas of improvement

The complicated method of pulling data is a weak aspect of this script as it:

* Limits access to data to members of a closed site.
* Requires access to software other than R.
* Free version of OutWit Hub restricts scraped content to 100 results.

More issues

* The __cleaning_script.R__ does not check for the data then download if it doesn't exist (see above). Potential solution is to host the data somewhere then update it frequently. But does anyone else care about _my kid's_ naps?