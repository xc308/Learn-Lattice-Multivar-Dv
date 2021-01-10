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




























