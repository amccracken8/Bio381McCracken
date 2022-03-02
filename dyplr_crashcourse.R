### dyplr Crash Course
# 3/2/22
# Andrew McCracken

### Core Verbs
# filter(): pick/subset observations by their values (rows)
# arrange(): reordering rows
# select(): choose variables (columns) by names
# mutate(): creating a new variable with functions of existing variables
# smmarize(): and group_by(): collapse many values down to a single sumary. 

library(tidyverse)
data(starwars)
class(starwars)

# tbl = tibble
# modern take on data frames which keeps great aspects of data fromames and drops frustrating ones. 

str(starwars)
glimpse(starwars)
head(starwars)

# complete cases to clean up our data
starwarsClean <- starwars[complete.cases(starwars[,1:10]),]
is.na(starwarsClean)
anyNA(starwarsClean)

head(starwarsClean)


###############
# Filter(): subset by rows
# use logistical booleans > < <= >= == != | & !
# filter automatically excludes NA's and have to explicitly ask for them if you want them

# commas can be used or the `&` sign for multiple criteria 
filter(starwarsClean, gender == "masculine" & height < 180)

# the `\` or  the %in% function can be used to filter multiple disjunct criteria

filter(starwarsClean, eye_color %in% c("blue", "brown"))

#############
# arrange(): Reordering rows
arrange(starwarsClean, by=height) # arranges from shortest to tallest
arrange(starwarsClean, by=desc(height)) # arranges tallest to shortest

arrange(starwarsClean, by=height, desc(mass)) # orders by height and then by mass


##########
# select(): choose variables by their names (columns) -> great for subsetting by names
## these all do the same
starwarsClean[,1:10]
select(starwarsClean, 1:10)
select(starwarsClean, name:homeworld)
select(starwarsClean, !(films:starships))

### Rearrange columns
select(starwarsClean, name, gender, species, everything()) # everything() helper functon: everything else goes after

select(starwarsClean, contains('color')) # gets names containing certain attributes such as "color"

# other helper functions: ends_with(), starts_with(), matches(), num_range()

### Rename Columns
select(starwarsClean, haircolor = hair_color, everything())


###################
# mutate(): create new variables with functions of existing variabls
## *new name always goes first*

mutate(starwarsClean, ratio = height / mass)
starwars_lbs <- mutate(starwarsClean, mass_lbs = mass*2.2)

# move order of names around
select(starwars_lbs, 1:3, mass_lbs, everything())


##################
# transmute(): just returns the new column without the rest of the data
transmute(starwarsClean, ratio = height / mass)



###################
# summarize(): collapses values and probides summary

summarize(starwarsClean, meanHeight = mean(height)) # does not work with NA's
summarize(starwars, meanHeight = mean(height, na.rm=T), TotalN=n()) # if you have NA's

#group_by()
starwarsGender <- group_by(starwars, gender)
summarize(starwarsGender, meanHeight = mean(height, na.rm=T), TotalN=n())


######## Piping %>% #########
# used to emphasize a sequence of actions
### lets you pass a intermediate result onto the next function without assigning a variable
# takeks the output of 1 function and uses it as the input of the next
# avoid when manipulting more than 1 object or if you have a meaningful intermediate object
# formatting: a;ways have a space before pipe %>% and usually is followed by a new line (eih auto. indent)

# using piping to summarize and group_by -> group first then summarize
starwars %>%
  group_by(gender) %>%
  summarize(meanHeight = mean(height, na.rm=T), TotalN=n())


########### case_when ##########
# useful for ifelse statements or multiple ifelse statements

ifelse(starwarsClean$gender == 'feminine', "F", "M")

starwarsClean$sexID <- ifelse(starwarsClean$gender == 'feminine', "F", "M")

starwarsClean %>%
  mutate(sp = case_when(species == "Human" ~ "Humanoid", TRUE ~ "Non-human")) %>%
  select(name, sp, everything())


############## converting long to wide and vise vera ######
glimpse(starwarsClean)

#wide format
wideSW <- starwarsClean %>%
  select(name,sex,height) %>%
  pivot_wider(names_from = sex , values_from = height, values_fill = NA)

## long format
longSW <- wideSW %>%
  pivot_longer(cols  = male : female,  # Old Columns you are lengthening
               names_to = 'sex', # new columns you are making
               values_to = 'height',  # new columns you are making
               values_drop_na = TRUE)

#
starwars %>%
  select(name, homeworld) %>%
  group_by(homeworld) %>%
  mutate(rn = row_number()) %>%
  ungroup() %>%
  pivot_wider(names_from = homeworld, values_from = name)




