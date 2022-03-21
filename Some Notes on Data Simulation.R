
library(boot)

### normally distrubuted data simulation
#start with groups of data (used in t-test or annova)

# simulate groups with 20 observations
group1 <- rnorm(n=20, mean=2, sd=1)
hist(group1)

#chamge some parameters
group2 <- rnorm(n=20, mean=5, sd=1)
group3 <- rnorm(n=20, mean=2, sd=3)
hist(group2)
hist(group3)


### simulate data for linear regression
# twp continuous normal variables
# start really simle and assume a interept of 0
# call the slope beta1
# x is the predictor variable
beta1 <- 1

# our predictor variable that is normally distrubuted
x <- rnorm(n = 20)

#linear model:
y <- beta1*x

# you can also play with differet slopes
beta1 <- 1.5
y <- beta1*x

# add intercepts
beta0 <- 2
y <- beta1*x + beta0

# make things more complex: 
# adding covariates
# draw covariate orm a different distribution



##### Part 2: Abundance and Count Data

# option 1: data are normal-sih
# use round() to remove decimals
abund1 <- round(rnorm(n=20, mean=50, sd = 10))
hist(abund1)

# option 2: Poisson Distribution
abund2 <- rpois(n=20, lambda=3)
barplot(table(abund2))

# sometimes the environment affects counts
#log-link function (co-variate)
# to account for this, first create our lambdas (one for each site) 

# use a regression to get initial values
pre.lambda <- beta0 + beta1*x
# inverse log to make all lambda's positive
lambda <- exp(pre.lambda)
#use lambda values we created to get counts
abund3 <- rpois(n=20, lambda = lambda)
hist(abund3)


### Occupancy, presence/absence data

# option 1: getting probabilitis from a beta distribution
probs <- rbeta(n=20, shape1=1, shape2=1)
occ1 <- rbinom(n=20, size=1, prob=probs)
print(occ1)

# option2 : occupancy with a coariate
# similar to above except we are generating probs, not lambdas
pre.probs <- beta0+beta1*x
#convert them to 0-1 scale (all positive)
psi <- inv.logit(pre.probs)
# create new occupancy values
occ2 <- rbinom(n=20, size=1, prob=psi)
print(occ2)


##########################################################

### Starfish size data simulations ###
library(tidyverse)


arm_length <- rnorm(n=30, mean=54, sd=11.5)
start_weight <- rnorm(n=30, mean=33.5, sd=11)
delta_weight <- rnorm(n=30, mean=2.9, sd=4.6)
end_weight <- start_weight + delta_weight


S <- data.frame(arm_length, start_weight, delta_weight, end_weight)

L <- lm(data = S, start_weight ~ end_weight)

G <- ggplot(data=S) + 
  aes(x=start_weight,y=end_weight) +
  geom_point() +
  stat_smooth(method=lm,se=0.95) # default se=0.95 

print(G)








