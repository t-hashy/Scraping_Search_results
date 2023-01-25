# Import the data ---------------------------------

# Read the file
file.name <- "srctitles_SDGs_jp_20230125.Rds"
df.text <- readRDS(paste(conf$DATA_DIR, file.name, sep = "/"))

# Get vecter data
text <- df.text$title

# Shape the data -----------------------------------------

# Create a corpus
docs <- Corpus(VectorSource(text))

# Check the data, and clean it if needed.
docs <- tm_map(docs, content_transformer(tolower))

# Create a document term matrix (dtm)
dtm <- TermDocumentMatrix(docs)
matrix <- as.matrix(dtm)
words <- sort(rowSums(matrix), decreasing = TRUE)
df <- data.frame(
    word = names(words),
    freq = words
  )

# Generate word clound --------------------------------
set.seed(1234) # for reproductivity
# wordcloud(
#   words = df$word,
#   freq = df$freq,
#   min.freq = 1,
#   max.words = 200,
#   random.order = FALSE,
#   rot.per = 0.35,
#   colors = brewer.pal(8, "Dark2")
# )

wc <- wordcloud2(
  data = df,
  size = 1.6,
  color = 'random-dark',
  shape = "heart"
)
