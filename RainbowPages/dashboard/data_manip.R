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
busi$email <- sapply(busi$email,function(x) {x <- gsub("@"," @", x)})
busi$sector <- sapply(busi$sector,function(x) {x <- gsub("/","/ ", x)})


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

