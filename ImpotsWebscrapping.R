# Web scrapping the Impots.govu.fr website 
# Data available from https://cfsmsp.impots.gouv.fr/secavis/
# 12-06-2018
# Sharma Kanika


# Libraries ----
library(rvest) #scrapping web pages
library(httr) #useful for working with Https and urls
# Libraries Maybe required in future
library(devtools)
library(XML)
library(plyr)
library(RCurl)



# Setting parameters-----
url <- "https://cfsmsp.impots.gouv.fr/secavis/"
fiscalnumero="0325557931342"  #can be set to runtime parameter
reference= "1783A30436889" #can be set to runtime parameter
#keeping the code for debugging in future
# response <- GET(url,authenticate(fiscalnumero,reference))
# response
# response$status_code
# response$handle
# read_html(response) 
#  html_session(url) 
#   #response$cookies
# suf <- response$cookies$value[1]
# suf
# mid <- ";jsessionid="
# newurl <- paste0(url,mid,suf, sep='')
# newurl


# Submit form----
# for submitting form ,Variables are retreived from deubbger tab in browser developer console under response headers.
# static values needed to be passed # took me one day to figure out what was the problem
login <- list(
  'action' = 'login',
  'j_id_7:spi' = fiscalnumero,
  'j_id_7:num_facture' = reference,
  'j_id_7:j_id_l' = 'Valider',
   j_id_7_SUBMIT = 1,
   javax.faces.ViewState ="RxJe/1JKTJSr3aiM3H9DqZq0DrwqEXsY7Rw4eLRgEBsCF1IALJGqVgWTaQkiKbbdcGDWW774BWUCa/+j2CDznhw1/3bxJteY6ZCui66yNevhkej4xuyrFMte5KQnKORt9JZrOQ=="
)

# login #finally its working # to check the values passed in above step
# sending the information to receive the response
res <- POST(url, body = login, encode = "form",verbose())
text<-content(res,as='text')
text

# Reading the response---- 
ht<- read_html(res)

#fetching the Html table
tables <- html_nodes(ht, css = "table")
tables
httable <- html_table(tables, header = T,fill=TRUE)

# creating data frame
df <- as.data.frame(httable)
df

# Writing Response in CSV ----
write.table(df, file = 'S:\\DG\\DMS\\D_Strategieclient\\POC Data Science\\ImpotsWebscrapping\\Impots.csv',  row.names=FALSE, col.names=TRUE,  quote = FALSE)
