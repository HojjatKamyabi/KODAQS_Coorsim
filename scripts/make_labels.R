posts_csv  <- "data/toy_posts.csv"
users_csv  <- "data/toy_users.csv"
emb_file   <- "data/toy_sample_twhin-bert-base.h5"
out_file   <- "data/llm_labels.rds"
llm_model  <- "llama3.1:8b"

library(data.table)

if (!isTRUE(rollama::ping_ollama())) stop("Ollama is not running. Start the Ollama app first.")

tweets_df <- as.data.table(read.csv(posts_csv, colClasses = "character"))
tweets_df[, created_at := as.POSIXct(created_at, format = "%Y-%m-%d %H:%M:%OS", tz = "UTC")]
users_df <- as.data.table(read.csv(users_csv))

sim_dt <- coorsim::detect_cosimilarity(tweets_df, emb_file,
                                       time_window = 180, min_simil = 0.925,
                                       min_participation = 1, time = "created_at",
                                       verbose = FALSE)
set.seed(42)  # same as in index.qmd
coord <- coorsim::coorsim_detect_groups(sim_dt, users_df, verbose = FALSE)

coord <- coorsim::sample_user_text(coord, sampling_ratio_posts = .33,
                                   sampling_ratio_users = .5, seed = 42)
coord <- coorsim::label_users(coord, model = llm_model, seed = 42, temp = 0)
coord <- coorsim::label_communities(coord, model = llm_model, seed = 42, temp = 0)

saveRDS(coord[c("node_list", "user_labels", "community_labels")], out_file)

writeLines(c(
  paste("created:", format(Sys.time(), tz = "UTC", usetz = TRUE)),
  paste("model:", llm_model),
  paste("ollama:", tryCatch(system("ollama --version", intern = TRUE)[1],
                            error = function(e) "unknown")),
  paste("md5 of .rds:", unname(tools::md5sum(out_file))),
  "", utils::capture.output(utils::sessionInfo())
), sub("\\.rds$", "_provenance.txt", out_file))
message("Done: ", out_file)
