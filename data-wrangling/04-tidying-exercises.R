# Import Libraries --------

library(tidyverse)
library(babynames)

# Generate data dummy

cases <- tribble(
  ~Country, ~"2011", ~"2012", ~"2013",
  "FR",    7000,    6900,    7000,
  "DE",    5800,    6000,    6200,
  "US",   15000,   14000,   13000
)
pollution <- tribble(
  ~city, ~size, ~amount,
  "New York", "large",      23,
  "New York", "small",      14,
  "London", "large",      22,
  "London", "small",      16,
  "Beijing", "large",     121,
  "Beijing", "small",     121
)

names(who) <- str_replace(string = names(who), 
                          pattern = "newrel",
                          replacement =  "new_rel")


table1
table2
table3
table4a
table4b
table5

# tidyr ------

# Dive deeper 1
## reorganize `table4a` into three columns:
## **country**, **year**, and **cases**.

table4a %>% 
  gather(key = "year", value = "cases", -country)

# Dive deeper 2
## reorganize `table2` into four columns: 
## **country**, **year**, **cases**, and **population**.

table2 %>% 
  spread(key = type, value = count)

# Working with `who` dataset -----

## Dive deeper 1
### Gather the 5th through 60th columns of `who` into a pair of
### key:value columns named `codes` and `n`.
### Then select just the `county`, `year`, `codes` and `n` variables.

who %>% 
  gather(key = "codes", value = "n", 5:60) %>% 
  select(country, year, codes, n)

## Dive deeper 2
### Separate the `sexage` column into `sex` and `age` columns.

who %>%
  gather("codes", "n", 5:60) %>%
  select(-iso2, -iso3) %>% 
  separate(codes, c("new", "type", "sexage"), sep = "_") %>%
  select(-new) %>% 
  separate(col = sexage, into = c("sex", "age"), sep = "0")

# Reshaping Final Exam -------

## Dive deeper
## Extend this code to reshape the data into a data set with three columns:
## 1. `year`
## 2. `M`
## 3. `F


babynames %>%
  group_by(year, sex) %>% 
  summarise(n = sum(n)) %>% 
  spread(key = sex, value = n) %>% 
  select(year, M, F)

## Calculate the percent of male (or female) children by year. 
## Then plot the percent over time.

babynames %>%
  group_by(year, sex) %>% 
  summarise(n = sum(n)) %>% 
  spread(key = sex, value = n) %>% 
  select("year", "M", "F") %>% 
  mutate(total = M + F,
         M = M / total,
         F = F / total) %>% 
  select(year, M, F) %>% 
  gather(key = "gender", value = "percent", - year) %>% 
  ggplot(mapping = aes(x = year, y = percent, color = gender)) +
  geom_line() + 
  labs(title = "The percent of male vs female children by year",
       x = NULL, 
       y = NULL) +
  theme_minimal() 
