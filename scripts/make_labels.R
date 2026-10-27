source("scripts/make_toy_data.R")

# Get embedding file path
emb_file <- list.files(path = "data/emb", pattern = ".h5$", full.names = T)[1]

# Detect Posting similarites
sim_dt <- coorsim::detect_cosimilarity(
  data = tweets_df,
  embeddings = emb_file,
  time_window = 180, # 3 Minutes 
  min_simil = 0.925, 
  min_participation = 1,
  post_id = "post_id",
  account_id = "account_id",
  time = "created_at",
  content = "content",
  verbose = TRUE,
)

# Detect groups of accounts
coord <- coorsim::coorsim_detect_groups(
  simdt = sim_dt,
  user_data = users_df,
  account_id = "account_id",
  verbose = TRUE
)

# Sampe users and posts
coord <- coorsim::sample_user_text( 
  groups_data = coord, 
  sampling_ratio_posts = .33,  # 33% of the post of that user
  sampling_ratio_users = .5 # 50% of the users of a community
)  

# Generate user descriptions
coord <- coorsim::label_users(coord, model = "llama3.1:8b") # small model for readme only

# Generate community labels
coord <- coorsim::label_communities(coord, model = "llama3.1:8b")

saveRDS(coord[c("node_list", "user_labels", "community_labels")], "data/llm_labels.rds")
