library(tidyverse)
library(rvest)
library(stringr)

#set directory
setwd("C:/Users/Riley B/Desktop/Data Project/Hamilton Cardinals Project/TeamByTeam_Season_Scrape")

LeagueID <- "111"
TeamID <- "6409"  #Welland Jackfish

#Season Reference - 2020 Season omitted as it was cancelled
name <- c("Season 2023",
          "Season 2022",
          "Season 2021",
          "Season 2019")

#Season html ID - Welland began in 2019 after moving from Burlington
id <- c("33729",
        "33384",
        "32979",
        "32194")

season <- data.frame(name, id)

WellandJackfish <- NULL
single_season <- NULL

for (i in 1:nrow(season)) {
  content3 <- read_html(paste("https://baseball.pointstreak.com/team_schedule.html?leagueid=",LeagueID,"&seasonid=",season$id[i],"&teamid=",TeamID,sep = ""))
  tables <- content3 %>%
    html_table()
  single_season <- as.data.frame(tables[[1]])
  single_season$SeasonName <- season$name[i] #this creates a column that adds the season name
  WellandJackfish <- rbind(WellandJackfish, single_season)

}

WellandJackfish

#break apart the "Result" column into a home score and away score
WellandJackfish <- WellandJackfish %>%
  mutate(HomeScore = as.numeric(str_extract(Result, "^\\d+")),
         VistorScore = as.numeric(str_extract(Result, "\\d+$")),
         CombinedScore = HomeScore + VistorScore
  )

write_csv(WellandJackfish, "WellandJackfishScores.csv")
