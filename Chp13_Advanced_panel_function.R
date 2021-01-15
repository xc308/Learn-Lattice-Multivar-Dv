#****************************************#
# Chapter 11 Manipulating the trellis Obj
#****************************************#

# high-level plotting function in Lattice produce
# objs rather than actual graphical outputs

# these objs can be assigned to varaibles, stored on disk, 
# or manipulated in various ways. 

# object-based design

#==============================#
# 11.1 Methods for trellis obj
#==============================#

# two versions of obj-oriented programing:
  # S3 and S4 (newer and more formal)

# the tools used to get the info about a class 
# or methods of generic function are different


# The obj returned by high-level function have trellis class
# can obtain a list of methods that act on treliss objs

methods(class = "trellis")
# [1] [          dim       
# [3] dimnames   dimnames<-
# [5] plot       print     
# [7] summary    t         
# [9] tmd        update 


# to look for help documentations 
help("dimnames.trellis")

help("[.trellis")
# Update method for objects of class "trellis", 
# and a way to retrieve the last printed trellis object (that was saved).


methods(class = "shingle")
# [1] [             as.data.frame
# [3] plot          print        
# [5] summary      


# a list of all methods for generic function barchart()
methods(generic.function = "barchart")
#  [1] barchart.array*  
#  [2] barchart.default*
#  [3] barchart.formula*
#  [4] barchart.matrix* 
#  [5] barchart.numeric*
#  [6] barchart.table*  



# split(col, row, ncol, nrow)
# divides up the region into ncol, and nrow,
# and palce s the plot in col and row (counting from upper left)


# update() the most useful method for trellis obj
# often used in conjunction with trellis.last.obj()

# everytime a trellis obj is printed, a copy of the obj
# is retained in an internal env
# trellis.last.object() can retrieve the last obj saved

update(trellis.last.object(), layout = c(1, 1)) [2]
# update the last trellis obj with new layout
# the extract the 2nd packet


#------------------------------#
# 10.6 Manipulating the display
#------------------------------#
# lattic displays can automatically allocate teh 
# space required for long axis labels, legends, etc
# as the labels or legends are known before plotting begin



#===========#
# 13.5 Maps
#===========#

# Choropleth maps use color to encode a continuous
# or categorical varaible on a map
# effective in conveying spatial info

# simply polygons with fill col derived from an 
# external variable

# more practical ones: obtaining boundaries
# of the polygons defining the geographical units
# and the associated data

# tools to work with map data are available in the maps package
# which contains predefined boundary databases, among other things 
# for several geographical units

# map(): draws a map of a specified database
# also to retrieve info about the polygons that 
# defined the map


install.packages("maps")
library(maps)

county_map <- map("county", plot = FALSE, fill = TRUE)
# the fill arg: causes the return value to be 
# in a form that is suitable for use in polygon(), then panel.polygon()
# contains components x, y which are numeric vectors defining the boundaries
# with NA values separating polygons. 
# also contains a vector of names for the polygons, e.g. name of counties


str(county_map)

# external data can be matched with polygons using these names

# 1st example: ancestry data in latticeExtra

data(ancestry, package = "latticeExtra") # 3219 obs
head(ancestry, 2)

ancestry_sub <- subset(ancestry, !duplicated(county))
  #subset # subset an vector/df
  #duplicated # return logical values indicating which element/row are duplicated
  # 3212 obs

rownames(ancestry_sub) <- ancestry_sub$county
head(ancestry_sub)


freq <- table(ancestry_sub$top)
freq
keep <- names(freq)[freq > 10] # vectro of chr 1:7

# create a vector of ancestry values matching the map database
ancestry_sub$mode <- with(ancestry_sub, factor(ifelse(top %in% keep, top, 'other')))

modal_ancestry <- ancestry_sub[county_map$names, "mode"]
modal_ancestry # factor with 8 levels


install.packages("RColorBrewer")
library(RColorBrewer)

map_col <- brewer.pal(n = nlevels(ancestry_sub$mode), name = "Pastel1")
# nlevels() # return the number of levels it arg has
# a vector of chr [1:8]

xyplot(y ~ x, data = county_map, aspect = "iso",
       scales = list(draw = FALSE), xlab = "", ylab = "",
       par.settings = list(axis.line = list(col = "transparent")),
       col = map_col[modal_ancestry], border = NA,
       panel = panel.polygon, 
       key = list(text = list(levels(modal_ancestry), adj = 1),
                  rectangles = list(col = map_col),
                  x = 1, y = 0, corner = c(1, 0)))


# panel.polygon?



#------------------------------#
# 13.5.2 Maps with conditioning
#------------------------------#

# multipanel choropleth maps: panel.polygon() does not work

# a natrual approach: mapplot() in latticeExtra package

# obtain a multipanel choropleth map,
# visualizing a continuous response, 
# ie. the rate of death from cancer among males and females
# mapproj package is used to apply a projection directly in the call to map()

install.packages("mappproj")
library(mapproj)
library(latticeExtra)

data(USCancerRates, package = "latticeExtra")

head(USCancerRates, 2)

rng <- with(USCancerRates, range(rate.male, rate.female, finite = TRUE))
# big difference, can do log transformation

nbreaks <- 50
breaks <- exp(do.breaks(log(rng), nbreaks))

breaks2 <- do.breaks(rng, nbreaks)

#histogram(exp(do.breaks(log(rng), nbreaks)))
#histogram(do.breaks(rng, nbreaks))

mapplot(row.names(USCancerRates) ~ rate.male + rate.female, 
        data = USCancerRates, breaks = breaks, 
        map = map("county", plot = FALSE, fill = TRUE,
                  projection = "tetra"),
        scales = list(draw = FALSE), xlab = "", 
        main = "Average yearly deaths due to cancer per 100000")


mapplot(row.names(USCancerRates) ~ rate.male + rate.female, 
        data = USCancerRates, breaks = breaks2, 
        map = map("county", plot = FALSE, fill = TRUE,
                  projection = "tetra"),
        scales = list(draw = FALSE), xlab = "", 
        main = "Average yearly deaths due to cancer per 100000")


# The extended form of conditioning using y ~ x1 + x2 etc. is also allowed. 
# The formula might be interpreted as in a dot plot, 
# except that y is taken 
# to be the names of geographical units in map.

















































































































