# This mini-project is based on the K-Means exercise from 'R in Action'
# Go here for the original blog post and solutions
# http://www.r-bloggers.com/k-means-clustering-from-r-in-action/

# Exercise 0: Install these packages if you don't have them already

install.packages(c("cluster", "rattle","NbClust"))


# Now load the data and look at the first few rows
data(wine, package="rattle")
head(wine)
str(wine) #178 obs. of  14 variables

# Exercise 1: Remove the first column from the data and scale
# it using the scale() function

winescale <- scale(wine[2:14])  # could also use wine[-1] or assign wine to winescale first then NULL column 1 then scale
winescale


# Now we'd like to cluster the data using K-Means. 
# How do we decide how many clusters to use if you don't know that already?
# We'll try two methods.

# Method 1: A plot of the total within-groups sums of squares against the 
# number of clusters in a K-means solution can be helpful. A bend in the 
# graph can suggest the appropriate number of clusters. 

wssplot <- function(data, nc=15, seed=1234){
	              wss <- (nrow(data)-1)*sum(apply(data,2,var))
               	      for (i in 2:nc){
		        set.seed(seed)
	                wss[i] <- sum(kmeans(data, centers=i)$withinss)}
	                
		      plot(1:nc, wss, type="b", xlab="Number of Clusters",
	                        ylab="Within groups sum of squares")
	   }

wssplot(winescale)


# Exercise 2:
#   * How many clusters does this method suggest? 3
#   * Why does this method work? What's the intuition behind it?
#   * Look at the code for wssplot() and figure out how it works

# Method 2: Use the NbClust library, which runs many experiments
# and gives a distribution of potential number of clusters.

library(NbClust)
set.seed(1234)
nc <- NbClust(winescale, min.nc=2, max.nc=15, method="kmeans")

barplot(table(nc$Best.n[1,]),
	          xlab="Numer of Clusters", ylab="Number of Criteria",
		            main="Number of Clusters Chosen by 26 Criteria")


# Exercise 3: How many clusters does this method suggest? 3


# Exercise 4: Once you've picked the number of clusters, run k-means 
# using this number of clusters. Output the result of calling kmeans()
# into a variable fit.km

# fit.km <- kmeans( ... )
head(winescale)

set.seed(1234)
fit.km <- kmeans(winescale, centers=3, nstart=25, iter.max=1000) #adding nstart=25 seemed to make no difference, seed set does though
fit.km


# Now we want to evaluate how well this clustering does.

# Exercise 5: using the table() function, show how the clusters in fit.km$clusters
# compares to the actual wine types in wine$Type. Would you consider this a good
# clustering?

ct.km <- table(wine$Type, fit.km$cluster)
ct.km # rows = wine$type, cols = fit.km$cluster

  # Custering looks good since most of the cluster values fit the actual wine$type. 
  # Only 6 of the 178 were put into a neighboring cluster.


# Exercise 6:
# * Visualize these clusters using  function clusplot() from the cluster library
# * Would you consider this a good clustering?

#clusplot( ... )

library(cluster)
clusplot(winescale, fit.km$cluster, color=TRUE, shade=FALSE, labels=4, lines=0, plotchar=TRUE)

  # Clustering looks good. There are only a few data points that look like they could belong in one
  # of two clusters. These must be the 6 that we see from the table() function where the true type 
  # and the cluster value did not match.


# try this with the original dataset: wine, which still has the actual Type column
clusplot(wine, fit.km$cluster, color=TRUE, shade=FALSE, labels=4, lines=0, plotchar=TRUE)
  # with actual Type included, produces the similar clusters, 
  # but has a 1.97% higher point variance explained by Component 1 and 2

