library(httr)
library(readr)
library(dplyr)

member_request <- GET(url = "http://www.aph.gov.au/~/media/03%20Senators%20and%20Members/Address%20Labels%20and%20CSV%20files/SurnameRepsCSV.csv?la=en")
members <- read_csv(content(member_request)) %>% 
  select(Surname, 
         `First Name`, 
         `Preferred Name`,
         Telephone,
         `Political Party`,
         State,
         Electorate,
         ElectorateTelephone,
         `Parliamentary Title`)

senator_request <- GET(url = "http://www.aph.gov.au/~/media/03%20Senators%20and%20Members/Address%20Labels%20and%20CSV%20files/allsenel.csv?la=en")
senators <- read_csv(content(senator_request)) %>% 
  select(Surname, 
         `First Name`, 
         `Preferred Name`,
         `Political Party`,
         State,
         ElectorateTelephone,
         `Parliamentary Title`)