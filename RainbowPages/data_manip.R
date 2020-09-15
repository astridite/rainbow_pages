library(tmaptools)

curated <- responses %>% 
  row_to_names(1) %>% 
  select(id, contact_person, email, social_media, business, individual, 
         organisation, class, address, location, sector) %>% 
  arrange(id) 

busi <- curated %>% 
  filter(class=="A business") %>% 
  select(-organisation, -individual) %>% 
  rename(detail = 'business') %>% 
  rename(business='id') %>% 
  mutate(colours = rep_len(1:8, length.out = (nrow(.)))) %>% 
  mutate(email = str_replace(email, '@', " @")) %>% 
  mutate(sector = str_replace(sector, '@', " @"))

orgs <- curated %>% 
  filter(class=="A NGO/NPO/Community Organisation") %>% 
  select(-business, -individual) %>% 
  rename(detail = 'organisation') %>% 
  rename(organisation='id') %>% 
  mutate(colours = rep_len(1:8, length.out = (nrow(.))))

indiv <- curated %>% 
  filter(class=="An individual") %>% 
  select(-business, -organisation, -address) %>% 
  rename(detail = 'individual') %>% 
  rename(individual='id') %>% 
  mutate(colours = rep_len(1:8, length.out = (nrow(.)))) 

# Only add marker locations where we have an actual address
locations <- curated %>%
  filter(!is.na(address)) %>%
  select(address)

# Geocode addresses
coords <- map_dfr(locations, geocode_OSM)

# Create a dataframe of marker coordinates and labels
markers <- curated %>%
  inner_join(coords, by = c('address' = 'query')) %>%
  mutate(label = paste(sep = "<br/>",
                       sprintf("<b>%s</b>", id),
                       business,
                       address)) %>%
  select(lat, lon, label)

hex <- c("#FF6663", "#FEB144", "#FDFD97", "#9EE09E", "#9EC1CF", "#995bc7", "#CC99C9", "#935218")

library(tmaptools)

curated <- responses %>% 
  row_to_names(1) %>% 
  select(id, contact_person, email, social_media, business, individual, 
         organisation, class, address, location, sector) %>% 
  arrange(id) 

busi <- curated %>% 
  filter(class=="A business") %>% 
  select(-organisation, -individual) %>% 
  rename(detail = 'business') %>% 
  rename(business='id') %>% 
  mutate(colours = rep_len(1:8, length.out = (nrow(.))))

orgs <- curated %>% 
  filter(class=="A NGO/NPO/Community Organisation") %>% 
  select(-business, -individual) %>% 
  rename(detail = 'organisation') %>% 
  rename(organisation='id') %>% 
  mutate(colours = rep_len(1:8, length.out = (nrow(.))))

indiv <- curated %>% 
  filter(class=="An individual") %>% 
  select(-business, -organisation, -address) %>% 
  rename(detail = 'individual') %>% 
  rename(individual='id') %>% 
  mutate(colours = rep_len(1:8, length.out = (nrow(.)))) 

# Only add marker locations where we have an actual address
locations <- curated %>%
  filter(!is.na(address)) %>%
  select(address)

# Geocode addresses
coords <- map_dfr(locations, geocode_OSM)

# Create a dataframe of marker coordinates and labels
markers <- curated %>%
  inner_join(coords, by = c('address' = 'query')) %>%
  mutate(label = paste(sep = "<br/>",
                       sprintf("<b>%s</b>", id),
                       business,
                       address)) %>%
  select(lat, lon, label)

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
