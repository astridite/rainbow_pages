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


hex <- c("#FF6663", "#FEB144", "#FDFD97", "#9EE09E", "#9EC1CF", "#995bc7", "#CC99C9", "#935218")

