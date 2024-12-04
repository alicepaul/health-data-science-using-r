library(HDSinRdata)
library(tidyverse)

# load data and remove negative numbers
load("/Users/Alice/Dropbox/HDSinRdata/data/covidcases.rda")

covidcases$date <- as.Date("2019-12-29") + weeks(covidcases$week - 1)

# add division information, update DC
state_df <- data.frame(state = state.name,
                       division = state.division,
                       state.abb = state.abb)
covidcases <- left_join(covidcases, state_df)
covidcases$division[is.na(covidcases$division)] <- "Middle Atlantic"

# Order levels
covidcases$division <- factor(covidcases$division,
                              levels = c("New England",
                                         "Middle Atlantic",
                                         "East North Central",
                                         "West North Central",
                                         "South Atlantic",
                                         "East South Central",
                                         "West South Central",
                                         "Mountain",
                                         "Pacific"))

# sum over division
covidcases_div <- covidcases %>%
  group_by(division, week) %>%
  summarize(weekly_cases = sum(weekly_cases, na.rm=TRUE)) %>%
  ungroup()

covidcases_state <- covidcases %>%
  group_by(state.abb, week) %>%
  summarize(weekly_cases = sum(weekly_cases, na.rm=TRUE)) %>%
  ungroup()



fill_colors <-c("white",
                "#d5e9f7",
                "#98bcd4",
                "#19244f")
vals <- c("0", "1000", "5000", "50000")
quants <- ecdf(covidcases_state$weekly_cases)(vals)
covidcases_state$tile_val <- ecdf(covidcases_state$weekly_cases)(covidcases_state$weekly_cases)

ggplot(covidcases_state, aes(y = state.abb, x = week, fill = tile_val)) +
  geom_tile(color = 'white') +
  scale_fill_gradientn(labels = c("0", "1k", "5k", "50k"),
                       colors = fill_colors,
                       breaks = quants,
                       name = "",  
                       na.value = "lightgray") +
  scale_y_discrete(position = 'left', name = "", limits=rev) +
  coord_equal() +
  scale_x_continuous(expand = c(0,0.5), 
                     breaks = c(10, 15, 19, 24, 28, 32), 
                     labels = c("Mar", "Apr", "May", "June", "July", "Aug"),
                     name = "") +
  theme_minimal() +
  theme(legend.position = 'right',
        plot.title = element_text(size = 10),
        panel.grid = element_blank(),
  ) +
  ggtitle('Weekly COVID-19 Early 2020')


fill_colors <-c("white",
                "#d5e9f7",
                "#98bcd4",
                "#19244f")
vals <- c("2", "10000", "25000", "100000")
quants <- ecdf(covidcases_div$weekly_cases)(vals)
covidcases_div$tile_val <- ecdf(covidcases_div$weekly_cases)(covidcases_div$weekly_cases)

p2 <- ggplot(covidcases_div, aes(y = division, x = week, fill = tile_val)) +
  geom_tile(color = 'white') +
  scale_fill_gradientn(labels = c("0", "10k", "25k", "100k"),
                       colors = fill_colors,
                       breaks = quants,
                       name = "Number of Cases",  
                       na.value = "lightgray") +
  scale_y_discrete(position = 'left', name = "", limits=rev) +
  coord_equal() +
  scale_x_continuous(expand = c(0,0.5), 
                     breaks = c(10, 15, 19, 24, 28, 32), 
                     labels = c("March", "April", "May", "June", "July", "Aug"),
                     name = "") +
  theme_minimal() +
  theme(legend.position = 'bottom',
        legend.text = element_text(size=8),
        legend.title = element_text(size=8),
        legend.key.height = unit(0.35, 'cm'),
        plot.title = element_text(size = 10),
        panel.grid = element_blank(),
  ) 

covidcases_us <- covidcases %>%
  group_by(week) %>%
  summarize(weekly_cases = sum(weekly_cases, na.rm=TRUE)) %>%
  ungroup()

p1 <- ggplot(covidcases_us, aes(x=week, y = weekly_cases), color = "#19244f") +
  scale_x_continuous(expand = c(0,0.5), 
                     breaks = c(10, 15, 19, 24, 28, 32), 
                     labels = c("March", "April", "May", "June", "July", "Aug"),
                     name = "") +
  theme_minimal()+
  scale_y_continuous(breaks = c(0, 100000,200000,300000,400000),
                     labels = c("0", "100k", "200k", "300k", "400k"),
                     name = "") +
  theme(legend.position = 'bottom',
        plot.title = element_text(size = 10),
        panel.grid = element_blank(),
  ) +
  geom_line() 

library(patchwork)
p1/free(p2, "label") + 
  plot_layout(heights = c(1,2))+
  plot_annotation(title = 'Weekly Reported COVID-19 Cases, March - August 2020')

