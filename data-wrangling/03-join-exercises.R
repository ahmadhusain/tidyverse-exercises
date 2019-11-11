# Import Libraries --------

library(tidyverse)
library(nycflights13)

# Generate data dummy ------

band <- tribble(
  ~name,     ~band,
  "Mick",  "Stones",
  "John", "Beatles",
  "Paul", "Beatles"
)
instrument <- tribble(
  ~name,   ~plays,
  "John", "guitar",
  "Paul",   "bass",
  "Keith", "guitar"
)
instrument2 <- tribble(
  ~artist,   ~plays,
  "John", "guitar",
  "Paul",   "bass",
  "Keith", "guitar"
)


# Mutating Joins --------

## Left join
### All rows from x, and all columns from x and y. 
### Rows in x with no match in y will have NA values in the new columns.

band %>% 
  left_join(instrument, by = "name")

## Right join
### All rows from y, and all columns from x and y. 
### Rows in y with no match in x will have NA values in the new columns.

band %>% 
  right_join(instrument, by = "name")

## Full join
### All rows and all columns from both x and y. 
### Where there are not matching values, returns NA for the one missing.

band %>% 
  full_join(instrument, by = "name")

## Inner join
### All rows from x where there are matching values in y, 
### and all columns from x and y.

band %>% 
  inner_join(instrument, by = "name")

# Working with data `flight` and `airlines` --------

# Dive deeper 1
## Which airlines had the largest arrival delays?
### 1. Join `airlines` and `flights`
### 2. Compute and order the average arrival delays by airline. Display full names, no codes.

## quick check na values

flights %>% 
  is.na() %>% 
  colSums()

## Answer

flights %>% 
  drop_na(arr_delay) %>% 
  inner_join(airlines, by = "carrier") %>% 
  group_by(name) %>% 
  summarise(average_delay = mean(arr_delay)) %>% 
  arrange(name)


# Dive deeper 2
##  Join `flights` and `airports` by `dest` and `faa`. 
## Then for each `name`, compute the `distance` from NYC and the average `arr_delay`.  
## *Hint: use `first()` to get the first value of distance.*
## Order by average delay, worst to best.

flights %>% 
  drop_na(arr_delay) %>% 
  inner_join(airports, by = c("dest" = "faa")) %>%
  group_by(name) %>% 
  summarise(distance = first(distance),
            delay = mean(arr_delay)) %>% 
  arrange(desc(delay))


# Dive deeper 3
## How many airports in `airports` are serviced by flights in `flights`? 
## (i.e. how many places can you fly to direct from New York?) 
### Notice that the column to join on is named `faa` in the **airports** data set 
### and `dest` in the **flights** data set.

airports %>% 
  inner_join(flights, by = c("faa" = "dest")) %>% 
  select(faa) %>% 
  distinct() %>% 
  nrow()
