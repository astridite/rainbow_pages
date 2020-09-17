library(gargle)
library(googlesheets4)
#set up once per project
# designate project-specific cache
options(gargle_oauth_cache = ".secrets")

# check the value of the option, if you like
gargle::gargle_oauth_cache()

# trigger auth on purpose --> store a token in the specified cache
gs4_auth()

# see your token file in the cache, if you like
list.files(".secrets/")

#run in app.R followed by
options(
  gargle_oauth_cache = ".secrets",
  gargle_oauth_email = TRUE
)

# now use googledrive with no need for explicit auth

