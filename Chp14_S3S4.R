#********************************#
# Chapter 14 New Trellis Display
#********************************#
# more extensive modifications to the default panel fucntion
# can be made by writting custom panel function

# lattice provides the groundwork for further extensions
# by making use of the obj-oriented features of R

# New high-level display functions can be written
# either as new methods for existing gerneric functions
# or an entirely new function which should itself be 
# generic to allow further specialized methods

#================#
# 14.1 S3 methods
#================#
# high-level functions in lattice are generic functions
# that new methods can be written to display objects on 
# their class
# such methods usually end ep calling the coresoponding 
# formula method after preliminary processing

  # histogram(), qqmath() methods for numeric vectors
  # levelplot(), wireframe() methods for matrices
  # barchart(), dotplot() methods for contingency tables

# two other methods for xyplot() generic function
library(latticeExtra)
xyplot(sunspot.year, aspect = "xy",
       strip = FALSE, strip.left = TRUE, 
       cut = list(number = 4, overlap = 0.05))



# stl() decomposes a periodic time-series into seasonal
# trend, irregular components using LOESS

data("biocAccess", package = "latticeExtra")

ssd <- stl(ts(biocAccess$counts[1:(24 * 30 * 2)], frequency = 24), "periodic")

xyplot(ssd, xlab = "Time (Days)")


#=================#
# 14.2 S4 Methods
#=================#

# S3 scheme works well for plotting highly structured obj
# insufficient when flexible formula interface is desirable
# but data objs do not fit into the restrictive df paradigm

#
install.packages("flowViz")
library(flowViz)













































