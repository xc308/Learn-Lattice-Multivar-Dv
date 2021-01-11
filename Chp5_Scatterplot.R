#*********************
# Chapter 5 
#*************#

#========================#
# 5.5 Scatter-plot Matrix
#========================#
# splom() : matrix of pairwise scatter plots given two or more varaibles
# dataframe as its 1st arg

data("USArrests")
head(USArrests, 2)

splom(USArrests)

# conditioned on graphical regions
splom(~ USArrests[c(3, 1, 2, 4)] | state.region,
      pscales = 0, type = c("g", "p", "smooth"))

# g: grid reference
# p: points
# smooth: LOWESS smooth line

## scatter-plot matrices are useful for 
# continuous multivariate data
# but only show pairwise associations and not
# particularly helpful in detecting higer-dimensional relationship











