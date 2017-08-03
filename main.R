library(crandb)
library(magrittr)

current_date <- Sys.Date()

if(!dir.exists("./data/")){
  dir.create("./data/", showWarnings = FALSE)
  anniversary_data <- NULL
} else {
  load("./data/cranniversary.RData")
}

backlog_run <- function(){
  
  crandb_entries <- crandb::list_packages(limit = 30000, format = "full")
  
  anniversary_data <- lapply(crandb_entries, function(entry){
    
    publish_date <- substring(entry$timeline[[1]], 0, 10) %>%
      strsplit(split = "-", fixed = TRUE) %>%
      unlist %>%
      as.integer
    
    return(data.frame(package = entry$name,
                      year = publish_date[1],
                      month = publish_date[2],
                      day = publish_date[3],
                      stringsAsFactors = FALSE))
  }) %>%
    do.call("rbind", .) %>%
    save(file = "./data/cranniversary.RData")
}