posts_csv  <- "data/toy_posts.csv"          # columns: post_id, account_id, content, created_at
out_dir    <- "data"
out_prefix <- "toy_sample_"                 # file becomes <out_prefix><model>.h5
model_name <- "Twitter/twhin-bert-base"

library(data.table)

tweets_df <- as.data.table(read.csv(posts_csv, colClasses = "character", encoding = "UTF-8"))
tweets_df[, created_at := as.POSIXct(created_at, format = "%Y-%m-%d %H:%M:%OS", tz = "UTC")]

reticulate::py_require(c("torch==2.11.0", "torchvision==0.26.0", "torchaudio==2.11.0",
                         "transformers==4.57.6"))
coorsim::initialize_coorsim()
coorsim::save_embeddings(tweets_df,
                         post_id = "post_id",
                         time = "created_at",
                         content = "content",
                         batch_size = 16L,
                         max_length = 512L,
                         use_fp16 = TRUE,
                         model_name = model_name,
                         save_dir = out_dir,
                         h5_fileprefix = out_prefix)

h5_file <- file.path(out_dir, paste0(out_prefix, basename(model_name), ".h5"))
emb <- coorsim::load_h5_embeddings(h5_file, verbose = FALSE)


torch <- reticulate::import("torch")
transformers <- reticulate::import("transformers")
writeLines(c(
  paste("created:", format(Sys.time(), tz = "UTC", usetz = TRUE)),
  paste("input:", posts_csv, "md5", unname(tools::md5sum(posts_csv))),
  paste("model:", model_name, "(Hugging Face, default revision)"),
  paste("coorsim:", as.character(utils::packageVersion("coorsim"))),
  paste("torch:", torch$`__version__`),
  paste("transformers:", transformers$`__version__`),
  paste("torchvision:", reticulate::import("torchvision")$`__version__`),
  paste("torchaudio:", reticulate::import("torchaudio")$`__version__`),
  paste("torch CUDA build:", if (is.null(torch$version$cuda)) "none (CPU)" else torch$version$cuda),
  paste("cuda used:", torch$cuda$is_available()),
  paste("embedding dim:", ncol(emb)),
  paste("md5 of .h5:", unname(tools::md5sum(h5_file))),
  "", utils::capture.output(utils::sessionInfo())
), file.path(out_dir, "embeddings_provenance.txt"))
message("Done: ", h5_file)
