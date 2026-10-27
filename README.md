# coorsim: KODAQS tool

Tutorial for the R package [coorsim](https://github.com/thieled/coorsim) by Daniel Thiele,
following the steps of the coorsim README. The tutorial is `index.qmd`.

To run it: `source("install.R")`, then `quarto render index.qmd`.

Two steps need software that Binder does not have, so their results are included in `data/`:

- `emb/toy_sample_twhin-bert-base.h5`: embeddings (README Step 2), created with `scripts/make_embeddings.R`
- `llm_labels.rds`: LLM labels (README Steps 5–6), created with `scripts/make_labels.R` and Ollama
