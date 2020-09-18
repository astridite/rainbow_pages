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
         sector,  colours, business, organisation, individual)

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
  select(id, lat, lon, label)

# Add marker data to curated dataframe
curated <- curated %>%
  full_join(markers, by = 'id')

write.csv(curated, "curated_data.csv", row.names = F)



