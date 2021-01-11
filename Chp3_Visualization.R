#**********************************************#
# Chapter 3 Visualizing Univaraite Distribution
#***********************************************#
# density plots are useful for detecting bimodality
# or multimodality


#==================#
# 3.1 Density plot
#==================#
install.packages("lattice")
library(lattice)


data("faithful")
head(faithful, 3)
densityplot(~ eruptions, data = faithful, 
            plot.points = TRUE, ref = TRUE)


# the two most important args are kern and bw
  # kern: kernel ; use rectangular kernel
  # bw: bandwidth; fixed bandwidth

densityplot(~ eruptions, data = faithful, 
            kernel = "rect", bw = 0.2,
            plot.points = "rug", n = 200)



install.packages("latticeExtra")
library(latticeExtra)

data("gvhd10")
head(gvhd10, 3)

densityplot(~ FSC.H | Days, data = gvhd10,
        plot.points = FALSE, ref = TRUE, 
        layout = c(2, 4))


densityplot(~ log(FSC.H) | Days, data = gvhd10,
            plot.points = FALSE, ref = TRUE, 
            layout = c(2, 4))



#================#
# 3.3 Histograms
#================#
# histogram()
# divide up the range of data into non-overlapping
# bins, same width
# then count the number of obs fall in them
# each bin is represented by a rectangle with the bin as its base
# the height is computed to make its area equal to the proportion of obs
# in that bin
# formally, density histogram
# type = "density"
# nint = number of interval

histogram(~ log2(FSC.H) | Days, data = gvhd10,
          xlab = "log Forward Scatter",
          type = "density", nint = 50, 
          layout = c(2, 4))

# there's a fairly distinct lower bound for 
# the obs, below which the density drops quite 
# abruptly.
# which is an inherit limitation of density plot



#=====================#
# 3.4 Normal Q-Q plots
#=====================#
library(lattice)
qqmath(~ gcsescore | factor(score), data = Chem97,
       f.value = ppoints(100))

# f.value tells qqmath() to use only 100 quantiles in each panel
# instead of the defualt of as many as there are in the data

qqmath(~ gcsescore | factor(score), data = Chem97)
# from the qq plot, a left-skewed distribution


qqmath(~ gcsescore | gender, data = Chem97, 
       groups = score, aspect = "xy",
       f.value = ppoints(100), 
       auto.key = list(space = "right"),
       xlab = "Standard Normal Quantiles",
       ylab = "Average GCSE Score")


# For both gender, higher score is associated with
# higher gcsescore
# and the variance of gcsescore decreases as score, 
#  reflected in the decreasing slope of qq plot


#------------------------------------------#
# 3.4.1 Normality and Box-Cox Transformation
#-------------------------------------------#
# Nice results follow if we can assume normality
# and equal variance
# neither of which hold in example
# simple power transformations often improve the situation considerably

# The Box-Cox transformation is a scale- and location-shifted
# version of the power transfromation, given by
# f_lambda(x) = x^lambd - 1 / lambda

  # lambda != 0
  # f0(x) =  logx

# adv: being continuous with respect to the power lambda as lambda = 0

# The optimal BOX-COX transformation can be computed by boxcox() in MASS package

install.packages("MASS")
library(MASS)

Chem97_postive <- subset(Chem97, gcsescore > 0)
bc_lg <- with(Chem97_postive, boxcox(gcsescore ~ score * gender, 
       lambda = seq(0, 5, 1/10)))

locator(1)
# $x
#[1] 2.326493

#$y
#[1] -92571.14


# so here optimal lambda (power) is compuated as 2.33
# now transform the skewed Chem97 data
Chem97_mod <- transform(Chem97, gcsescore.trans = gcsescore ^ 2.33)
Chem97_mod2 <- transform(Chem97, gcsescore.trans = (gcsescore ^ 2.33 - 1) / 2.33)

# now check the normality after transformation
head(Chem97_mod, 2)
head(Chem97_mod2, 3)

QQ_function <- function(data = data) {
  qqmath(~ gcsescore.trans | factor(score), data = data,
         f.value = ppoints(100),
         aspect = "xy", 
         auto.key = list(space = "right"),
         xlab = 'Standard Normal Quantitles',
         ylab = 'Transformed GCSE Score')
  
  qqline(y = x, add = TRUE)
  
}

QQ_function(data = Chem97_mod2)
QQ_function(data = Chem97_mod)

# pretty much the same, so just use power 2.33
# no need to use standard box-cox transformation
























