
source("scripts/make_toy_data.R")

# Python versions fixed: newer transformers (5.x) no longer run Twitter/twhin-bert-base
reticulate::py_require(c("torch==2.11.0", "torchvision==0.26.0", "torchaudio==2.11.0",
                         "transformers==4.57.6"))

# Install/initialize conda environment to run embedding model
coorsim::initialize_coorsim()

# Create dir to store embeddings
if(!dir.exists("data/emb")) dir.create("data/emb", recursive = T)


# For larger datasets this works best with a CUDA GPU
emb_matrix <- coorsim::save_embeddings(tweets_df,
                                  post_id = "post_id", 
                                  time = "created_at",
                                  content = "content",
                                  batch_size = 16L, 
                                  max_length = 512L, 
                                  use_fp16 = T,
                                  model_name = "Twitter/twhin-bert-base", # "sentence-transformers/paraphrase-TinyBERT-L6-v2", 
                                  save_dir = "data/emb", 
                                  h5_fileprefix = "toy_sample_"
                                )
