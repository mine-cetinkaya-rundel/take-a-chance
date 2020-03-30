- pg. 31 - links broken in paragraph 2
	- Dialect Survey by Joshua Katz (joshkatz.co/dialect.html)
	- America’s weather-related disasters by Tim Meko (washingtonpost.com/graphics/2019/national/mapping-disasters/)
	- the Pudding (pudding.cool)
- pg. 31 - links broken in paragraph 3
	- gender tropes in film with screen direction (pudding.cool/2017/08/screen-direction)


- Table 1: Header should be "Original data"

- Table 2: Header should be "Reshaped data"

- Code box in Step 3. Line breaks as shown below:

```r
ggplot(data = staff_long, 
  aes(x = percentage, 
      y = faculty_type, 
      fill = year)) + 
  geom_col(position = "dodge")
```

- Code box in Step 4. Line breaks as shown below:

```r
ggplot(data = staff_long, 
  aes(x = year,
      y = percentage, 
      fill = faculty_type)) + 
  geom_col(position = "dodge")
```

- Caption for Figure 3: "Bar plot with dodged, horizontal bars"

- Caption for Figure 4: "Bar plot with dodged, vertical bars"

- Caption for Figure 5: "Bar plot with segmented bars"

- Code box at the bottom of page 35. Line breaks as shown below:

```r
ggplot(data = staff_long, 
  aes(x = year, 
      y = percentage, 
      fill = faculty_ type)) +
  geom_col(position = "fill")
```
- Caption for Figure 6: "Line plot where the years on the x-axis is encoded as character strings"

- Caption for Figure 6: "Line plot where the years on the x-axis is encoded as numerical values"

- End of 1st paragraph of Step 5, but "(Figure 6)" before the period. - "...so they are worth a try (Figure 6)."

- First code box in Step 5. Line breaks as shown below:

```r
ggplot(staff_long, 
  aes(x = year,
      y = percentage/100, 
      group = faculty_ type,
      color = faculty_type)) + 
  geom_line()
```

- Second code box in Step 5. Line breaks as shown below:

```r
staff_long <- staff_long %>% 
  mutate (year = as.numeric(year))
```

- Third code box in Step 5. Line breaks as shown below:

```r
ggplot(staff_long, 
  aes(x = year,
      y = percentage, 
      group = faculty_type, 
      color = faculty_type)) +
  geom_line()
```

- Caption for Figure 8: "Line plot with Part-time faculty highlighted"

- Code box on page 37

```r
staff_long <- staff_long %>% 
  mutate(part_time = 
    fct_other(faculty_ type, 
              keep = "Part-Time Faculty"))

ggplot(staff_long, 
  aes(x = year,
      y = percentage/100, 
      group = faculty_ type, 
      color = part_time)) + 
  geom_line() +
  scale_color_manual(
    values = c(“red,” “gray”)
    )
```

- Code box on page 38

```r
library(scales)

p +
  scale_y_continuous(
    labels = percent_format(accuracy = 1)    # %s
  ) + 
  labs(                                      # labels
    title = "Percentage of part-time faculty 
            instructors is on the rise",
    x = "Year", y = "Percentage", 
    color = "", 
    caption = "Source: bit.ly/taking-a- chance"
    ) +
  theme_minimal() +                           # background
  theme(legend.position = "bottom")           # legend
```

- pg. 40 - For "ggplot2" use the same font used for "tidyverse" on pg. 33


