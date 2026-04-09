# This file covers how to obtain college football data using the cfbfastR package
# The data needed for the source code is also provided as a csv in the data folder

#install.packages('cfbfastR', repos = c('https://sportsdataverse.r-universe.dev', 'https://cloud.r-project.org'))

library(cfbfastR)

# run the line below and follow the instructions to get an API key (easy and free)
?register_cfbd

# once you have an API key, replace "MY-API-KEY" with your API key (as a string)
Sys.setenv(CFBD_API_KEY = "MY-API-KEY")

first_round_qbs <- data.frame()

for (year in 2015:2025){
  cfb_qb <- cfbd_draft_picks(year = year, position = 'QB') %>% filter(round == 1)
  first_round_qbs <- rbind(first_round_qbs, cfb_qb)
}

experience_missing <- list(baker_mayfield = 1,
                           kyler_murray = 1,
                           trey_lance = 1,
                           kenny_pickett = 1,
                           anthony_richardson_sr = 1,
                           jayden_daniels = 1,
                           drake_maye = 1,
                           michael_penix_jr = 2,
                           bo_nix = 1,
                           cam_ward = 1)

qb_stats <- data.frame()

# looping through 37 first round QB, failed requests are expected
for (i in 1:nrow(first_round_qbs)) {
  print(i)
  qb_cfb_id <- first_round_qbs$college_athlete_id[i]
  draft_year <- first_round_qbs$year[i]
  season_stats <- try(espn_cfb_player_stats(athlete_id = qb_cfb_id,
                                            year = draft_year-1,
                                            season_type = "postseason"))
  if (nrow(season_stats) > 0){
    slug <- gsub('-', '_', season_stats$slug)
    experience <- season_stats$experience_years[1]
    if (is.numeric(experience_missing[[slug]])){
      experience <- experience + experience_missing[[slug]]
    }
    qb_stats <- rbind(qb_stats, season_stats, fill = TRUE)
    check_seasons <- seq(draft_year-2, draft_year-experience)
    
    for (j in check_seasons){
      season_stats <- try(espn_cfb_player_stats(athlete_id = qb_cfb_id,
                                                year = j,
                                                season_type = "postseason"))
      if (nrow(season_stats) > 0){
        qb_stats <- rbind(qb_stats, season_stats, fill = TRUE)
      }
    }
  }
}

qb_stats <- qb_stats[-2]

career_stats <- qb_stats %>% group_by(full_name) %>%
  summarise(seasons = n(),
            logo_href = max(logo_href),
            completions = sum(passing_completions),
            interceptions = sum(passing_interceptions),
            pass_attempts = sum(passing_passing_attempts),
            passing_tds = sum(passing_passing_touchdowns),
            passing_yards = sum(passing_passing_yards),
            sacks = sum(passing_sacks),
            games_played = sum(passing_team_games_played),
            total_offensive_plays = sum(passing_total_offensive_plays),
            rush_attempts = sum(rushing_rushing_attempts),
            rushing_tds = sum(rushing_rushing_touchdowns),
            rushing_yards = sum(rushing_rushing_yards)
  )

career_stats <- career_stats %>% mutate(
  completion_percentage = round(100*(completions/pass_attempts), 2),
  td_int_ratio = round(passing_tds/interceptions, 2),
  yards_per_attempt = round(passing_yards/pass_attempts, 2),
  pass_yards_per_game = round(passing_yards/games_played, 1),
  rush_yards_per_game = round(rushing_yards/games_played, 1),
  yards_per_carry = round(rushing_yards/rush_attempts, 2)
)

# move this csv file to the data folder to be used for the source code
write.csv(career_stats, file = 'qb_collge_career_stats.csv', row.names = FALSE)