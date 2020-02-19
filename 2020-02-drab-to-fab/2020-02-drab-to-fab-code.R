library(tidyverse)
library(scales)
library(knitr)
library(patchwork)

# trends in faculty ------------------------------------------------------------

# load data --------------------------------------------------------------------------------
staff_wide <- read_csv("http://bit.ly/chance-staff")

# reformat data ----------------------------------------------------------------
staff_long <- staff_wide %>%
  pivot_longer(cols = -faculty_type, names_to = "year", values_to = "percentage")

# make year numeric ------------------------------------------------------------
staff_long <- staff_long %>% mutate(year = as.numeric(year))

# Figure 3: Improved "fab" visualisation of instructional staff employment trends 1975 - 2011
staff_long <- staff_long %>%
  mutate(part_time = fct_other(faculty_type, keep = "Part-Time Faculty"))

p <- ggplot(data = staff_long, aes(x = year, y = percentage/100,
                                   group = faculty_type, color = part_time)) +
  geom_line() +
  scale_color_manual(values = c("red", "gray"))

p +
  scale_y_continuous(labels = percent_format(accuracy = 1)) +             # %s
  labs(                                                                   # labels
    title = "Percentage of part-time faculty instructors is on the rise",
    x = "Year", y = "Percentage", color = "",
    caption = "Source: bit.ly/taking-a-chance"
  ) +
  theme_minimal() +                                                       # background
  theme(legend.position = "bottom")


# electronic skateboards -------------------------------------------------------

# load data --------------------------------------------------------------------
skateboard <- read_csv("data/skateboard.csv")

# Figure 5: Plot I: Top speed vs. range, Plot II: I + coloring by weight, Plot III: II + faceting and formatting

p1 <- ggplot(skateboard, aes(x = range, y = top_speed)) +
  geom_point()
p2 <- ggplot(skateboard, aes(x = range, y = top_speed, color = weight)) +
  geom_point()
p3 <- skateboard %>%
  mutate(is_belt = if_else(drive == "Belt", "Belt", "Hub/Gear/Direct")) %>%
  ggplot(aes(x = range, y = top_speed, color = weight)) +
  geom_smooth(method = "lm", color = "darkgray") +
  geom_point() +
  scale_color_viridis_c() +
  scale_y_continuous(breaks = c(10, 20, 30)) +
  facet_wrap(~is_belt, ncol = 1) +
  labs(title = "Specifications for electric skateboards",
       subtitle = "by drive type",
       x = "Range (miles)", y = "Top speed (mph)",
       color = "Weight
(lbs)"
  ) +
  theme_minimal() +
  theme(panel.grid.minor = element_blank())
p1 + p2 - p3 +
  plot_layout(ncol = 1, heights = c(1, 2)) +
  plot_annotation(tag_levels = "I", tag_prefix = "Plot ") &
  theme(plot.tag = element_text(size = 12))


# fisheries --------------------------------------------------------------------

# load data --------------------------------------------------------------------
fisheries <- read_csv("data/fisheries.csv")
continents <- read_csv("data/continents.csv")

# Figure 7: Continent level visualisation of fisheries data --------------------
fisheries <- fisheries %>%
  filter(total > 100000) %>%
  left_join(continents) %>%
  mutate(
    continent = case_when(
      country == "Democratic Republic of the Congo" ~ "Africa",
      country == "Hong Kong"                        ~ "Asia",
      country == "Myanmar"                          ~ "Asia",
      TRUE                                          ~ continent
    ),
    aquaculture_perc = aquaculture / total
  )

fisheries_summary <- fisheries %>%
  group_by(continent) %>%
  summarise(
    min_ap  = min(aquaculture_perc),
    mean_ap = mean(aquaculture_perc),
    max_ap  = max(aquaculture_perc)
  )

ggplot(fisheries_summary,
       aes(x = reorder(continent, mean_ap), y = mean_ap)) +
  geom_col() +
  coord_flip() +
  scale_y_continuous(labels = percent_format(accuracy = 1)) + #<<
  labs(
    x = "", y = "",
    title = "Average share of aquaculture by continent",
    subtitle = "out of total fisheries harvest, 2016",
    caption = "Source: bit.ly/chance-fishery"
  ) +
  theme_minimal()

# Figure 8: Choropleth map of percentage aquaculture ---------------------------
fisheries <- fisheries %>%
  filter(total > 100000) %>%
  left_join(continents) %>%
  mutate(
    continent = case_when(
      country == "Democratic Republic of the Congo" ~ "Africa",
      country == "Hong Kong"                        ~ "Asia",
      country == "Myanmar"                          ~ "Asia",
      TRUE                                          ~ continent
    ),
    aquaculture_perc = aquaculture / total
  )
world_map <- map_data("world") %>%
  mutate(region = case_when(
    region == "UK"           ~ "United Kingdom",
    region == "USA"          ~ "United States",
    subregion == "Hong Kong" ~ "Hong Kong",
    TRUE                     ~ region
  )
  )
fisheries_map <- left_join(fisheries, world_map,by = c("country" = "region"))

fisheries_map <- fisheries_map %>%
  mutate(
    aquaculture_perc = aquaculture / total
  )

ggplot() +
  geom_polygon(world_map,
               mapping = aes(x = long, y = lat, group = group),
               fill = "lightgray") +
  geom_polygon(fisheries_map,
               mapping = aes(x = long, y = lat, group = group,
                             fill = aquaculture_perc)) +
  scale_fill_viridis_c(labels = percent_format(accuracy = 1)) +
  theme_minimal() +
  theme(
    legend.position = "bottom",
    legend.box = "vertical"
  ) +
  labs(
    title = "Share of aquaculture by country",
    subtitle = "out of total fisheries harvest, 2016",
    caption = "Source: bit.ly/chance-fishery",
    x = "", y = "",
    fill = "Aquaculture %"
  )
