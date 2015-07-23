# README for Daycare Naps Data

## What is this?

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

When navigating to the All Reports section of the site, execute the following scraper after scrolling through all the reports (the content loads dynamically as you move down the page).

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

