# notes for for loops


# nested for loops: 

mat <- matrix(sample(1:10, size=9),
              nrow=3,
              ncol=3)
print(mat)


for(i in 1:nrow(mat)) {
  for(j in 1:ncol(mat)){ 
    print(mat[i,j])
  }
}


#simulating temp data (temperature farenheight) 
site1 <- runif(min=60,max=70, n=10) 
site2 <- runif(min=60,max=70, n=10) 
site3 <- runif(min=40,max=50, n=10) 

# put them into dataframe
temps.df <- cbind(site1, site2, site3)

# Convert these to celcius
degf.to.degc <- function(x){
  degc <- (x-32)*(5/9)
  return(degc)
}

# repeat a function using a for loop
for (i in 1:ncol(temps.df)){
  print(degf.to.degc(x = temps.df[,i]))
}






