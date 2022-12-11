library(tidyverse)
library(scales)
library(showtext)

# Style guide: https://github.com/ajstarks/dubois-data-portraits/blob/master/dubois-style.pdff

font_add_google("Public Sans", "public_sans")
font_add_google("Big Shoulders Display", "shoulders")

# Activity 1: "Income and Expenditure of 150 Negro Families in Atlanta, GA, USA "

# load data---------------------------------------------------------------------
income_wide <- read_csv(here::here("2023-02-dubois-challenge", "data/income.csv")) |>
  rename(class = Class,
         average_income = Actual_Average)

# reformat data-----------------------------------------------------------------
income_long <- income_wide |>
  pivot_longer(cols = -c(class, average_income),
               names_to = "expenditure",
               values_to = "percentage")

#order expenditure categories-----------------------------------------
# ensures the categories are in the same order as original in the plot
income_long <- income_long |>
  mutate(expenditure = factor(expenditure, levels = c("Other", "Tax", "Clothes",
                                         "Food", "Rent")),
         percent_label = if_else(percentage < 1, "", paste0(percentage, "%")),
         class_income = paste(class, paste0("$", average_income), sep = " | "),
         class_income = factor(class_income, levels = c("$100-200 | $139.1",
                                                        "$200-300 | $249.45",
                                                        "$300-400 | $335.66",
                                                        "$400-500 | $433.82",
                                                        "$500-750 | $547",
                                                        "$750-1000 | $880",
                                                        "$1000 AND OVER | $1125"))
  )


# full code---------------------------------------------------------------------
ggplot(data = income_long, aes(x = class_income, y = percentage, fill = expenditure)) +
  geom_col(color = "black", size = 0.25, alpha = 0.6, position = "stack", width  = 0.5) +
  labs(x = "",
       y = "",
       fill = "",
       title = "INCOME AND EXPENDITURE OF 150 NEGRO FAMILIES IN ATLANTA, GA, U.S.A") +
  scale_fill_manual(labels = c("RENT.", "FOOD.", "CLOTHES.", "DIRECT TAXES.", "OTHER EXPENSES AND SAVINGS."),
                    values = c("Rent" = "#000000", "Food" = "#b19cd9",
                               "Clothes" = "#ffc0cb", "Tax" = "#4682B4",
                               "Other" = "#E9E9E9")) +
  coord_flip() +
  scale_x_discrete(limits = rev) +
  geom_text(aes(label = percent_label, color = expenditure == "Rent"),
            position = position_stack(0.5),
            family = "shoulders",
            size = 4,
            fontface = "bold"
  ) +
  scale_color_manual(values = c("black", "white"))+
  guides(color = "none") +
  theme_void() +
  theme(legend.position = "top",
        axis.text.y  = element_text(hjust = 0.5, family = "shoulders"),
        plot.title = element_text(family = "shoulders", size = 20),
        plot.background = element_rect(fill = "#e4d2c1"))





