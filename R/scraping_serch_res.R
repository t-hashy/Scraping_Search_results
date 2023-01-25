# Base settings ---------------------------------------------------------------------------

# Set search words
src.word <- "SDGs" # If you set multiple words, connect with "+"; e.g. "scraping+with+R"
src.country <- "us" # jp or us
src.lang <- "en" # jp or en
src.pages <- 1:100

# Set crawling basics
url.base <- "https://www.google.com/search?"
param.src <- "&q="
param.start <- "&start=" # index of the words, one page in every 10 words; starts with 0-9
param.country <- "&gl="
param.lang <- "&hl="

# Crawling ------------------------------------------------------------------------------------

# Set basics
df.titles <- data.frame()

# Crawling each page
pb <- create_new_pb(length = length(src.pages))
for(page.this in src.pages){

  # Progress
  pb$tick()

  # Set basics
  start.this <- (page.this - 1)*10

  # Get url
  url.this <- paste(url.base, param.src, src.word, param.start, start.this, param.lang, src.lang, param.country, src.country, sep = "")

  # Get contents
  html.this<- read_html(url.this)

  # Get titles and description
  titles.this <- html.this %>%
    html_nodes("h3") %>%
    html_text()

  # Make data frame this
  len <- length(titles.this)
  df.this <- data.frame(
    ts = rep(Sys.time(), len),
    page = rep(page.this, len),
    title = titles.this
  )

  # Push into the main
  if(length(df.titles) == 0){
    df.titles <- df.this
  }else{
    df.titles <- bind_rows(df.titles, df.this)
  }
}

saveRDS(df.titles, paste(conf$DATA_DIR, "/srctitles_", src.word, "_",src.lang, "_", format(Sys.time(), format = "%Y%m%d"), ".Rds", sep = ""))
