library(tmaptools)
library(googlesheets4)
library(tidyverse)
library(janitor)
library(gargle)

#responses comes from a googlesheet (not shown for security reasons)
#cleaning and wrangling
curated <- responses %>% 
  row_to_names(1) %>% 
  select(id, contact_person, email, website, class, business, organisation, individual, 
         address, location, extra_info, sector, twitter, instagram, facebook, linkedin) %>% 
  arrange(id) %>% 
  rowwise() %>% 
  mutate(online_presence = paste(ifelse(is.na(facebook), "", paste("Facebook: ", facebook, " ")),
                                 ifelse(is.na(instagram), "", paste("Instagram: ", instagram, " ")),
                                 ifelse(is.na(twitter), "", paste("Twitter: ", twitter, " ")),
                                 ifelse(is.na(linkedin), "", paste("Linkedin: ", linkedin, " ")),
                                 ifelse(is.na(website), "", paste("Website: ", website, " ")))) %>% 
  rowwise() %>% 
  mutate(detail = ifelse(class=="An individual", individual, 
                         ifelse(class=="A business", business, 
                                ifelse(class=="A NGO/NPO/Community Organisation", organisation, NA)))) %>% 
  select(-(twitter:linkedin)
         #, -(business:individual)) 
         )%>% 
  mutate(address=ifelse(class=="An individual", NA, address)) %>% #removed addresses for individuals 
  data.frame() %>% 
  mutate(colours=rep_len(1:8, length.out = nrow(.))) %>% 
  mutate(class = str_replace(class, "A business", "Businesses")) %>% 
  mutate(class = str_replace(class, "An individual", "People")) %>% 
  mutate(class = str_replace(class, "A NGO/NPO/Community Organisation", "Organisations")) %>% 
  mutate(layer = sector) %>% 
  mutate(layer = str_replace_all(layer, "Science|Technology", "Science & Technology")) %>% 
  mutate(layer = str_replace_all(layer, "Arts|Performing Arts|Entertainment", "Arts & Entertainment")) %>% 
  mutate(layer = str_replace_all(layer, "Film & Media|Photography", "Film, Media & Photography")) %>% 
  mutate(layer = str_replace_all(layer, "Food and Drink|Hospitality|Tourism","Hospitality & Tourism")) %>% 
  mutate(layer = str_replace_all(layer, "Community|Activism & Social Services","Community & Activism")) %>% 
  mutate(layer = str_replace_all(layer, "Medical|Counsel(l?)ing","Medical & Counselling")) %>%
  mutate(layer = str_replace_all(layer, "Fashion|Beauty","Fashion & Beauty")) %>%
  mutate(layer = str_replace_all(layer, "Marketing|Social Media","Marketing & Social Media")) %>%
  mutate(layer = str_replace_all(layer, "Manufacturing|Engineering","Manufacturing & Engineering")) %>%
  mutate(layer = str_replace_all(layer, "Automotive|Transport","Automotive & Transport")) %>%
  select(id, contact_person, detail, online_presence, email, website,
         class, address, location, extra_info, layer,
         sector,  colours, business, organisation)

# Only add marker locations where we have an actual address
locations <- curated %>%
  filter(!is.na(address)) %>%
  select(address)

# Geocode addresses
coords <- map_dfr(locations, geocode_OSM)

# Create a dataframe of marker coordinates and labels
markers <- curated %>%
  inner_join(coords, by = c('address' = 'query')) %>%
  mutate(entity = paste0(business, organisation),
         label = paste(sep = "<br/>",
                       sprintf("<b>%s</b>", id),
                       entity, 
                       address)) %>%
  select(lat, lon, label, layer)



write.csv(curated, "curated_data.csv", row.names = F)
write.csv(markers, "markers.csv", row.names = F)


hex <- c("#FF6663", "#FEB144", "#FDFD97", "#9EE09E", "#9EC1CF", "#995bc7", "#CC99C9", "#935218")

sample_text <- "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

welcome_text <- "Hi! Welcome to the RainbowPages, a repository of all things openly and enthusiastically LGBTQIA+ in Cape Town, South Africa!"
welcome_para1 <- "RainbowPages is a repository of businesses, organisations and individuals in Cape Town created to highlight and center the activities, connections and needs of people in the LGBTQIA+ community in our city."
welcome_para2 <- "This is a passion project and relies on the input of volunteers. If you would like to contribute your time and skill, please get in touch!"

business_text1 <- "LGBTQIA+ business listings in Cape Town:"

organisation_text1 <- "Organisations in Cape Town that support LGBTQIA+ people:"

individual_text1 <- "LGBTQIA+ entrepreneurs, professionals, artists and side-hustlers:"

map_text1 <- "Explore LGBTQIA+ activities in the city:"

work_in_progress <- "Rome was not built in a day, hunty. Check back in a few!"

resources_text1 <- "Want some more information about the LGBTQIA+ experience in South Africa?"
resources_text2 <- "Want to check out how this app was built using R Shiny?"

signup_text1 <- "Want to see yourself in the RainbowPages? Sign up here:"
signup_text2 <- "Responses will be added to the app in a few days."

suggestion_text1 <- "We want to hear from you:"
