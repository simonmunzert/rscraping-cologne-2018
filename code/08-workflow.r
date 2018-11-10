### -----------------------------
### simon munzert
### workflow and good practice
### -----------------------------

## peparations -------------------

source("packages.r")


## Staying friendly on the web ------

# work with informative header fields
# don't bombard server
# respect robots.txt

# add header fields with rvest + httr
url <- "http://spiegel.de/schlagzeilen"
session <- html_session(url, add_headers(From = "my@email.com", User-Agent = "R Scraper"))
headlines <- session %>% html_nodes(".schlagzeilen-headline") %>%  html_text()


# don't bombard server
for (i in 1:length(urls_list)) {
  if (!file.exists(paste0(folder, names[i]))) {
    download.file(urls_list[i], destfile = paste0(folder, names[i]))
    Sys.sleep(runif(1, 0, 1))
  }
}

# respect robots.txt
browseURL("https://www.google.com/robots.txt")
browseURL("http://www.nytimes.com/robots.txt")

library(robotstxt)
# more info see here: https://cran.r-project.org/web/packages/robotstxt/vignettes/using_robotstxt.html

paths_allowed("/", "http://google.com/", bot = "*")
paths_allowed("/", "https://facebook.com/", bot = "*")

paths_allowed("/imgres", "http://google.com/", bot = "*")
paths_allowed("/imgres", "http://google.com/", bot = "Twitterbot")


r_text <- get_robotstxt("https://www.google.com/")
r_parsed <- parse_robotstxt(r_text)
names(r_parsed)
table(r_parsed$permissions$useragent, r_parsed$permissions$field)




## Scheduling scraping tasks on Windows -------

browseURL("https://cran.r-project.org/web/packages/taskscheduleR/vignettes/taskscheduleR.html")


## Scheduling scraping tasks on a Mac ---------

browseURL("https://developer.apple.com/library/content/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/ScheduledJobs.html")

# 1. create script (e.g., "spiegel_scraper.R")
# 2. add "#!/usr/local/bin/Rscript" to the top of the script
# 3. create plist file
# 4. load plist file into launchd scheduler and start it (via Terminal):
system("launchctl load ~/Library/LaunchAgents/spiegelheadlines.plist")
system("launchctl start spiegelheadlines")
system("launchctl list")

# 5. stop and unload it when desired
system("launchctl stop spiegelheadlines")
system("launchctl unload ~/Library/LaunchAgents/spiegelheadlines.plist")



## EXERCISE -------


# go to the following webpage.
url <- "http://www.cses.org/datacenter/module4/module4.htm"
browseURL(url)

# the following piece of code identifies all links to resources on the webpage and selects the subset of links that refers to the survey questionnaire PDFs.
library(rvest)
page_links <- read_html(url) %>% html_nodes("a") %>% html_attr("href")
survey_pdfs <- str_subset(page_links, "/survey")

# a) set up folder data/cses-pdfs.

# b) download a sample of 10 of the survey questionnaire PDFs into that folder using a for loop and the download.file() function.

# c) check if the number of files in the folder corresponds with the number of downloads and list the names of the files.

# d) inspect the files. which is the largest one?

# e) zip all files into one zip file.
