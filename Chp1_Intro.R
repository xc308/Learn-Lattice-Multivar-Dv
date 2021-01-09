##########################################
# Lattice
# Multivaraite Data Visualization with R
# author: Deepayan Sarkar
##########################################

#************************#
# Chapter 1 Introduction
#************************#

#===============================#
# 1.1 Mutlipannel Conditioning
#===============================#
install.packages("mlmRev")
data(Chem97, package = 'mlmRev')
xtabs(~ score, data = Chem97)
#    0    2    4    6    8   10 
# 3688 3627 4619 5739 6668 6681 
# A-level score is discrete grade with possible values 0, 2, 4, 6, 8

#----------------------------------#
# 1.1.1 A histogram for every group
#----------------------------------#
# Q: whether the final A-level score depends on the 
# average GCSE score?
# == is the dist of A-Level score different for differnt
# values of score?
# popular plot to summarize dist is the histomgram

install.packages("lattice")
library(lattice)

histogram(~ gcsescore | factor(score), data = Chem97)

head(Chem97, 2)

histogram(~ gcsescore | score, data = Chem97)



#---------------------------#
# 1.1.3 Kernel density plots
#---------------------------#
# densityplot() can be used to graph kernel density estimates
densityplot(~ gcsescore | factor(score), data = Chem97,
            plot.points = FALSE, ref = TRUE)
# ref: plot a ref line at 0
# plot.points: apart from the density line, the original points 

densityplot(~ gcsescore | factor(score), data = Chem97,
            plot.point = TRUE, ref = TRUE)

# displaying points can be useful for small datasets



#=====================#
# 1.2 Superposition 
#=====================#
# pattern would be easier to judge if the density
# were superposed within the same panel
# achieved by using score as a grouping variable 
# instead of a conditioning variable

densityplot(~ gcsescore, data = Chem97, groups = score,
            plot.points = FALSE, ref = TRUE, 
            auto.key = list(columns = 3))

# auto.key automatically adds a suitable legend to the plot


#==========================#
# 1.3 The "trellis" object
#==========================#
# high-level functions in the lattice package 
# do not draw anything, but return an object of 
# class "trellis"
# An actual graphic is created when such obj are printed
# by the print()


tp1 <- histogram(~ gcsescore | factor(score), data = Chem97)
tp2 <- densityplot(~ gcsescore, data = Chem97, groups = score, 
            plot.points = FALSE, 
            auto.key = list(space = "right", title = "score"))


class(tp1)
# [1] "trellis"

class(tp2)
# [1] "trellis"

summary(tp1)

# the actual plot can be drawn by calling print()
# or plot(tp1)

plot(tp1, split = c(1, 1, 1 ,2))
plot(tp2, split = c(1, 2, 1, 2), newpage = FALSE)

# the 2nd graph shows the pattern of varaince decreasing
# with mean, which is easy to be missed in the histgram




































































