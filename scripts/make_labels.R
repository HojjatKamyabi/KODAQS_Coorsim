# README steps 5-6; needs Ollama and rollama
library(data.table)

tweets_df <- as.data.table(read.csv("data/toy_posts.csv", colClasses = "character"))
tweets_df[, created_at := as.POSIXct(created_at, format = "%Y-%m-%d %H:%M:%OS", tz = "UTC")]
users_df <- as.data.table(read.csv("data/toy_users.csv"))
set.seed(42)

sim_dt <- coorsim::detect_cosimilarity(tweets_df, "data/toy_sample_twhin-bert-base.h5",
                                       time_window = 180, min_simil = 0.925,
                                       min_participation = 1, time = "created_at")
coord <- coorsim::coorsim_detect_groups(sim_dt, users_df)

coord <- coorsim::sample_user_text(coord, sampling_ratio_posts = .33, sampling_ratio_users = .5)
coord <- coorsim::label_users(coord, model = "llama3.1:8b")
coord <- coorsim::label_communities(coord, model = "llama3.1:8b")

saveRDS(coord[c("node_list", "user_labels", "community_labels")], "data/llm_labels.rds")
