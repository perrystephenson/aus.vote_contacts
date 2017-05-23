library(httr)
library(readr)
library(dplyr)
library(jsonlite)

# Get Federal MPs
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

# Get Senators
senator_request <- GET(url = "http://www.aph.gov.au/~/media/03%20Senators%20and%20Members/Address%20Labels%20and%20CSV%20files/allsenel.csv?la=en")
senators <- read_csv(content(senator_request)) %>% 
  select(Surname, 
         `First Name`, 
         `Preferred Name`,
         `Political Party`,
         State,
         ElectorateTelephone,
         `Parliamentary Title`)

# Build a JSON
x <- list(members  = vector(mode = "list", length = nrow(members)), 
          senators = vector(mode = "list", length = 8))
# names(x$members) <- members$Electorate
for (i in 1:nrow(members)) {
  x$members[[i]] <- 
    list(electorate           = members[[i, "Electorate"]],
         surname              = members[[i, "Surname"]], 
         first_name           = members[[i, "First Name"]], 
         preferred_name       = members[[i, "Preferred Name"]],
         telephone_canberra   = members[[i, "Telephone"]],
         political_party      = members[[i, "Political Party"]],
         state                = members[[i, "State"]],
         telephone_electorate = members[[i, "ElectorateTelephone"]],
         parliamentary_title  = members[[i, "Parliamentary Title"]])
}

states <- unique(senators$State)
names(x$senators) <- states
for (i in 1:8) {
  num_senators <- sum(senators$State == states[i])
  senators_state <- filter(senators, State == states[i])
  x$senators[[i]] <- vector(mode = "list", length = num_senators)
  for (j in 1:num_senators) {
    x$senators[[i]][[j]] <- 
      list(state                = senators_state[[j, "State"]],
           surname              = senators_state[[j, "Surname"]], 
           first_name           = senators_state[[j, "First Name"]], 
           preferred_name       = senators_state[[j, "Preferred Name"]],
           political_party      = senators_state[[j, "Political Party"]],
           telephone_electorate = senators_state[[j, "ElectorateTelephone"]],
           parliamentary_title  = senators_state[[j, "Parliamentary Title"]])
  }
}
json.out <- toJSON(x, pretty = TRUE, auto_unbox = TRUE)
write_json(json.out, "federal.json")
