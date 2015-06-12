library(tm)
library(RWeka)
library(lda)
library(LDAvis)

#script for fitting an LDA model to the YLE Vaalikone text data
#almost exactly copied from the example at
#http://cpsievert.github.io/LDAvis/reviews/reviews.html

setwd("~/Documents/vaalikone-lda")
#read data
dat <- read.csv("data/vaalikone_data_fix.csv", encoding = "UTF-8", sep = ";", stringsAsFactors = TRUE)
#grab text columns
text_cols <- grep("Miksi.juuri.sinut|Mitä.astioita.haluat|Vaalilupaus|kommentti", names(dat), value = TRUE)
dat <- dat[, text_cols]
dat[is.na(dat)] <- ""
#concatenate text columns
docs <- do.call(paste, dat)

#pre-processing
docs <- gsub("'", "", docs) #remove apostrophes
docs <- gsub("[[:punct:]]", " ", docs) #replace punctuation with space
docs <- gsub("[[:cntrl:]]", " ", docs) #replace control characters with space
docs <- gsub("^[[:space:]]+", "", docs) #remove whitespace at beginning of documents
docs <- gsub("[[:space:]]+$", "", docs) #remove whitespace at end of documents
docs <- gsub("\\s+", " ", docs) #remove extra spaces
docs <- tolower(docs) #force to lowercase
docs <- docs[docs != ""] #remove empty strings
stop_words <- c(stopwords(kind = "fi"), stopwords(kind = "swedish")) #finnish and swedish stop words
docs <- removeWords(docs, stop_words) #remove stop words

Tokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 2)) #single tokens and bigrams
doc.list <- lapply(docs, Tokenizer)

# compute the table of terms:
term.table <- table(unlist(doc.list))
term.table <- sort(term.table, decreasing = TRUE)

#remove terms that occur fewer than 3 times:
del <- term.table < 3
term.table <- term.table[!del]
vocab <- names(term.table)

# now put the documents into the format required by the lda package:
get.terms <- function(x) {
  index <- match(x, vocab)
  index <- index[!is.na(index)]
  rbind(as.integer(index - 1), as.integer(rep(1, length(index))))
}
documents <- lapply(doc.list, get.terms)

# Compute some statistics related to the data set:
D <- length(documents)  # number of documents
W <- length(vocab)  # number of terms in the vocab
doc.length <- sapply(documents, function(x) sum(x[2, ]))  # number of tokens per document
N <- sum(doc.length)  # total number of tokens in the data
term.frequency <- as.integer(term.table)  # frequencies of terms in the corpus

# MCMC and model tuning parameters:
K <- 30
G <- 5000
alpha <- 0.02
eta <- 0.02

# Fit the model:
set.seed(357)
fit <- lda.collapsed.gibbs.sampler(documents = documents, K = K, vocab = vocab, 
                                   num.iterations = G, alpha = alpha, 
                                   eta = eta, initial = NULL, burnin = 0,
                                   compute.log.likelihood = TRUE, trace = 100L)

theta <- t(apply(fit$document_sums + alpha, 2, function(x) x/sum(x)))
phi <- t(apply(t(fit$topics) + eta, 2, function(x) x/sum(x)))

ElectionText <- list(phi = phi,
                     theta = theta,
                     doc.length = doc.length,
                     vocab = vocab,
                     term.frequency = term.frequency)

#function for exporting R models to json for visualizing with
#the pyLDAvis python port of the library
#almost exactly copied from
#https://github.com/bmabey/pyLDAvis/blob/master/tests/data/export_data.R
#with only a minor addition of utf-8 encoded output files
export <- function(data, name, out.dir='.') {
  input.name <- paste0(name, "_input.json")
  if(!file.exists(input.name))
  {
    cat(paste0('Exporting ', name, '...\n'))
    input <- jsonlite::toJSON(data, digits=50)
    f_in <- file(file.path(out.dir, input.name), "w", encoding = "UTF-8")
    cat(input, file = f_in)
    close(f_in)
  }
  output.name <- paste0(name, "_output.json")
  if(!file.exists(output.name))
  {
    # roundtrip the JSON so both libraries are using the same precision
    data <- jsonlite::fromJSON(input)
    output <- createJSON(data$phi, data$theta, data$doc.length, data$vocab, data$term.frequency)
    f_out <- file(file.path(out.dir, output.name), "w", encoding = "UTF-8")
    cat(output, file = f_out)
    close(f_out)
    cat(paste0(input.name, ' and ', output.name, ' have been written.\n'))
  }
}

export(ElectionText, "vaalikone_lda", out.dir = "data")