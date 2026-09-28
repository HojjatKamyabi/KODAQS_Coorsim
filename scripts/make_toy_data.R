# README step 1 (verbatim)

library(data.table)

set.seed(123)

# Define time parameters
start_time <- as.POSIXct("2024-01-15 09:00:00", tz = "UTC")
end_time <- as.POSIXct("2024-01-15 12:00:00", tz = "UTC")  # Explicitly set end time

# Create 10 accounts (5 coordinated, 5 normal)
coordinated_accounts <- paste0("coord_", 1:5)
normal_accounts <- paste0("normal_", 1:5)
all_accounts <- c(coordinated_accounts, normal_accounts)

# Create users_df
users_df <- data.frame(
  account_id = all_accounts,
  account_name = c(
    "ClimateSkeptic1", "TruthSeeker99", "ScienceDebunker", 
    "FreedomFirst", "RealFacts2024",
    "EcoWarrior", "GreenFuture", "ClimateActionNow", 
    "SustainableLiving", "PlanetProtector"
  ),
  followers = sample(100:10000, 10),
  verified = sample(c(TRUE, FALSE), 10, replace = TRUE)
)

# Climate denial messages (coordinated behavior)
denial_templates <- list(
  list("Climate change is a hoax perpetrated by global elites",
       "The so-called climate crisis is manufactured by those in power",
       "Climate change claims are exaggerated by the establishment"),
  
  list("No real evidence supports human-caused warming",
       "There's insufficient proof that humans cause climate change",
       "Scientific evidence for anthropogenic warming is lacking"),
  
  list("Natural cycles explain all temperature variations we see",
       "Earth's climate has always changed through natural processes",
       "Temperature fluctuations are part of natural climate cycles"),
  
  list("CO2 is plant food, not a pollutant harming our planet",
       "Carbon dioxide benefits plants and isn't dangerous",
       "Higher CO2 levels are good for vegetation growth")
)

# Other climate topics (normal behavior)
other_topics <- c(
  "Just installed solar panels on my roof! #renewableenergy",
  "New study shows Arctic ice melting faster than predicted",
  "Electric vehicles are becoming more affordable each year",
  "Extreme weather events are increasing in frequency globally",
  "Local community starting a tree planting initiative",
  "Ocean acidification threatens marine ecosystems",
  "Wind energy now cheaper than fossil fuels in many regions",
  "Heat waves breaking records across multiple continents",
  "Sustainable agriculture practices can reduce emissions",
  "Youth climate activists organizing global strike",
  "Coral reefs dying at alarming rates due to warming",
  "Green technology investments reaching new highs",
  "Wildfires devastating forests due to drought conditions",
  "Carbon capture technology showing promising results",
  "Cities implementing bike-sharing programs",
  "Glaciers retreating at unprecedented rates",
  "Plant-based diets can reduce carbon footprint",
  "Sea levels rising faster in coastal areas",
  "Battery technology improving for energy storage",
  "Species extinction linked to habitat loss"
)

# Generate coordinated tweets (30 tweets)
coordinated_tweets <- list()
tweet_id <- 1

# Calculate time window in seconds
time_window <- as.numeric(difftime(end_time, start_time, units = "secs"))

# Create 6 coordinated events (each with 5 tweets within 10 minutes)
for (event in 1:6) {
  # Random time within the 3-hour window (leaving 10 minutes for the event)
  event_start <- start_time + runif(1, 0, time_window - 600)
  
  # Pick a random denial template
  template <- denial_templates[[sample(1:4, 1)]]
  
  for (i in 1:5) {
    coordinated_tweets[[length(coordinated_tweets) + 1]] <- data.frame(
      post_id = sprintf("tweet_%03d", tweet_id),
      account_id = coordinated_accounts[i],
      content = template[[sample(1:3, 1)]],
      created_at = event_start + runif(1, 0, 600)  # Within 10 minutes
    )
    tweet_id <- tweet_id + 1
  }
}

# Generate normal tweets (70 tweets)
normal_tweets <- list()

for (i in 1:70) {
  normal_tweets[[i]] <- data.frame(
    post_id = sprintf("tweet_%03d", tweet_id),
    account_id = sample(all_accounts, 1),
    content = sample(other_topics, 1),
    created_at = start_time + runif(1, 0, time_window)
  )
  tweet_id <- tweet_id + 1
}

# Combine all tweets
tweets_df <- rbind(
  do.call(rbind, coordinated_tweets),
  do.call(rbind, normal_tweets)
)

# Sort by time
tweets_df <- tweets_df[order(tweets_df$created_at), ]
rownames(tweets_df) <- NULL

# Convert to data.table
tweets_df <- as.data.table(tweets_df)
users_df <- as.data.table(users_df)


posts_out <- data.frame(
  post_id    = tweets_df$post_id,
  account_id = tweets_df$account_id,
  content    = tweets_df$content,
  created_at = format(tweets_df$created_at, "%Y-%m-%d %H:%M:%OS6", tz = "UTC")
)
write.csv(posts_out, "data/toy_posts.csv", row.names = FALSE, fileEncoding = "UTF-8")
write.csv(as.data.frame(users_df), "data/toy_users.csv", row.names = FALSE, fileEncoding = "UTF-8")
