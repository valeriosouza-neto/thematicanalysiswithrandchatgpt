### Thematic analysis with R ###
# Install Required Packages
install.packages(c("httr", "tidyverse"))

# Load Required Libraries
library(httr)
library(tidyverse)

#########################
##### GPT prompting #####
#########################

# Function to Access GPT API and Prompt GPT
hey_chatGPT <- function(answer_my_question) {
  chat_GPT_answer <- POST(
    url = "https://api.openai.com/v1/chat/completions",
    add_headers(Authorization = paste("Bearer", my_API)),
    content_type_json(),
    encode = "json",
    body = list(
      model = "gpt-3.5-turbo",  # Specify the correct model version
      temperature = 0,
      messages = list(
        list(
          role = "user",
          content = answer_my_question
        )
      )
    )
  )
  str_trim(content(chat_GPT_answer)$choices[[1]]$message$content)
}

# Replace my_API with your GPT API key
my_API <- "" # Add y our ChatGPT API key

# Sample dataset, replace with your data
data <- read.csv("", stringsAsFactors = FALSE) # Add the path of your file .csv (If you have excel or other, change the command to read).

# Create a "themes" column
data$themes <- NA

# Run a loop over your dataset and prompt ChatGPT. 
for (i in 1:nrow(data)) {
  print(i)
  prompt <- paste("You should perform a thematic analysis. Can you suggest themes for future studies based on the following statement?  Answer only with a short potential theme for the suggestions of future studies. If it has more than one suggestion, give themes for all of them.", data$Suggestion[i])
  result <- hey_chatGPT(prompt)
  
  while (length(result) == 0) {
    result <- hey_chatGPT(prompt)
    print(result)
  }
  
  print(result)
  data$themes[i] <- result
}

# Output the dataset with themes
write.csv(data, "thematic_analysis_results.csv", row.names = FALSE)
