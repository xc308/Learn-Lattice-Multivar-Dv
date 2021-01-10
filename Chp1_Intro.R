##########################################
# Lattice
# Multivaraite Data Visualization with R
# author: Deepayan Sarkar
##########################################


#************************#
# Chapter 1 Introduction
#************************#
install.packages("lattice")
install.packages(c("latticeExtra", "copula", "ellipse", "gridBase",
                   "locfit", "logspline", "mapproj", "maps", "MEMSS",
                   "mlmRev", "RColorBrewer"))
source("http://bioconductor.org/biocLite.R")
biocLite(c("flowCore", "flowViz", "hexbin"))

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install(version = "3.12")


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


#*****************************************#
# Chapter2 A technical overview of lattic
#*****************************************#

# describe the most important features shared by all high-level functions



#================#
# 2.1 Basic usage
#=================#
# all high-level functions in lattice are generic 
# functions, meaning the code that gets executed 
# when a user calls such a function
# will depend on the arg supplied to the function
# the 1st arg supplied to the excuted function is a "formula"


#---------------------------#
# 2.1.1 The Trellie formula
#---------------------------#

# A typical Trellis formula looks like 
# y ~ x | a * b 

# the ~ is what makes it a "formula" object
# and is essential in any trellis fomula

# equally important is |: denotes the conditioning

# variables to the right of |: conditioning varaibles
# variables to the left of  |: primary variable

# A trellis formula msut contain at least one primary variable
# conditioning variables are optional
# the conditioning bar | must be omitted when no conditoning variable

# no limit on the number of conditioning variables
# may be seperated by * or  + 

densityplot(~ gcsescore | factor(score) + gender, data = Chem97,
            plot.points = FALSE, ref = TRUE)



#-------------------#
# 2.1.2 The data arg
#-------------------#
# data arg can be df, list, environment


#-------------------#
# 2.1.3 Conditionting
#-------------------#
# each unique combination of the levels of conditioning variables
# determines a packet, consisting of the subeset of the 
# primary variables that corresponds to that combination

# the packet is possible to be empty, 
# each packet is potentially provides that data 
# for a single panel in the Trellis display, 
# which consists of such panels laid out in an array of col, row, and pages



#-----------------#
# 2.1.4 Shingles
# ----------------#
# Multivariate relationships often involves continuous variates
# shingles can do so
  # simpliest approach: using each unique values as a distinct level
  # but unuseful when large amount of unique values
  # another standard way to convert continous variate into ordinal categorical
  # vairable is to discretize it and replace each value by only one indicator of 
  # the interval to which it belonged. 
  # such discretization is performed by cut()


#==================================#
# 2.2 Dimension and physical layout
#==================================#
# each conditoning variable defines a dimension
# with extends given by the number of levels it has

library(lattice)
data(Oats, package = "MEMSS")

tp1.oats <- xyplot(yield ~ nitro | Variety + Block, data = Oats, type = "o")
# two conditioning variables (dimensions)
# with 3 and 6 levels 
dim(tp1.oats)
# [1] 3 6
dimnames(tp1.oats)
# $Variety
#[1] "Golden Rain" "Marvellous" 
#[3] "Victory"    

#$Block
#[1] "I"   "II"  "III" "IV"  "V"   "VI" 

# these properties are shared by the cross-tabutlation 
# defining the conditioning

xtabs(~ Variety + Block, data = Oats)

#Block
#Variety       I II III IV V VI
#  Golden Rain 4  4   4  4 4  4
#  Marvellous  4  4   4  4 4  4
#  Victory     4  4   4  4 4  4


summary(tp1.oats[1, ])
summary(tp1.oats[, 1])


#--------------------#
# 2.2.1 Aspect Ratio
#--------------------#
# A.R: the ratio of its physical height and weight
# choice of A.R determines the effectiveness of a display
# arrive at one by trial and error


# when line segement is close to 45 deg, the change
# of values is most obvious in graph,
# so aspect = "xy", then 45deg banking rule is used to 
# compute the aspect ratio

# aspect can also be a string, indicating the number of units per cm
# suitable when two scales have the same units
# in plots of spatial data










































































































































































