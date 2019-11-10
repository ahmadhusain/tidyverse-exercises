# Overview --------

## this chapter aims to enhance the ability
## to prepare a data from one format or structure
## to another structure according to analysis needs.

# import libraries -----

library(tidyverse)
library(babynames)
library(nycflights13)

# working with babynames datasets-----------

## description data
## babynames is a full baby name data which contains five variables: 
## year, sex, name, n, and prop

head(babynames)
tail(babynames)

## selecting spesific or conditional columns: ---------

### single column

babynames %>% 
  select(n)

### multiple column

babynames %>% 
  select(name, prop)

### conditional select

babynames %>% 
  select(starts_with("n"))

babynames %>% 
  select(ends_with("e"))

babynames %>% 
  select_if(.predicate = is.numeric)

#### `contains` work for a single string 

babynames %>% 
  select_at(.vars = vars(contains("ame")))

#### `matches` for overcomes multiple string condition

babynames %>% 
  select_at(.vars = vars(matches("ame|rop")))

#### combine `starts_with` and `matches` is allowed

babynames %>% 
  select_at(.vars = vars(matches("ame|rop"), starts_with("s")))

## extract cases with `filter` ------

### extracting all of the names where prop is greates than or equal to 0.08

babynames %>% 
  filter(prop >= 0.08) %>% 
  pull(name)

### extracting all of the children named "Sea"

babynames %>% 
  filter_at(.vars = "name", .vars_predicate = any_vars(expr = . == "Sea"))

#### with boolean operators

babynames %>% 
  filter(name == "Sea")

#### extracting names that were used by exactly 5 or 6 children in 1880

babynames %>% 
  filter(n %in% c(5,6) & year == 1880)

### extracting Names that are one of Acura, Lexus, or Yugo

babynames %>% 
  filter(name %in% c("Acura", "Lexus", "Yugo"))

### exracting all the name that have missing value for `n`

babynames %>% 
  filter(is.na(x = n))

## Arrange -----------

### Arrange babynames by `n`. Add `prop` as a second (tie breaking) 
### variable to arrange on.
### the smallest value of `n` is:

babynames %>% 
  arrange(n, prop) %>% 
  slice(1) %>% 
  pull(n)

#### Use `desc()` to find the names with the highest prop.

babynames %>% 
  arrange(desc(prop)) %>% 
  slice(1) %>% 
  pull(name)

#### Then, use `desc()` to find the names with the highest n.

babynames %>% 
  arrange(desc(n)) %>% 
  slice(1) %>% 
  pull(name)





## sequential-condition with pipes -------

### Use `%>%` to write a sequence of functions that: 
  
### 1. Filter babynames to just the girls that were born in 2015  
### 2. Select the `name` and `n` columns  
### 3. Arrange the results so that the most popular names are near the top.

babynames %>% 
  filter(year == 2015) %>% 
  select(name, n) %>% 
  arrange(desc(n)) %>% 
  head(n = 10)

## summarise function ------

### Use summarise() to compute three statistics about the data:

### 1. The first (minimum) year in the dataset  
### 2. The last (maximum) year in the dataset  
### 3. The total number of children represented in the data

babynames %>% 
  summarise(first_year = min(year),
            last_year = max(year),
            total_number = length(name))

### extract the rows where `name == "Khaleesi"`. 
### Then use `summarise()` and `sum()` and `min()` to find:
### 1. The total number of children named Khaleesi
### 2. The first year Khaleesi appeared in the data

babynames %>% 
  filter(name == "Khaleesi") %>% 
  summarise(total = n(),
            first = min(year))

## group_by() and summarise() -------

### display the ten most popular names. 
### Compute popularity as the *total* number of children of
### a single gender given a name.

babynames %>%
  group_by(name, sex) %>% 
  summarise(total = n()) %>% 
  arrange(desc(total)) %>% 
  head(10)

### plot the number of children born each year over time.

babynames %>% 
  group_by(year) %>% 
  summarise(total = n()) %>% 
  ggplot(mapping = aes(x = year, y = total)) +
  geom_line(size = 1.2) +
  scale_y_continuous(breaks = seq(from = 0,
                                  to =  40000,
                                  by = 5000), 
                     limits = c(0, 40000), 
                     labels = scales::comma) +
  labs(title = "The number of children born",
       subtitle = "each year over time",
       x = NULL,
       y = NULL) +
  theme_minimal()
