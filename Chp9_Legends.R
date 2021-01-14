#*****************************#
# Chapter 9 Legends and labels
#******************************#
demo("labels", package = "lattice")


#============#
# 9.2 Legends
#============#

# also called keys, 
# auto.key and colorkey arg.

# to understand these args, must first discuss
# the underlying processes that generate legends


#--------------------------------------#
# 9.2.1 Legends and grid graphcial obj
#--------------------------------------#

# graphical objects: grobs
# predefined function: draw.key() and draw.colorkey()
# produce specialized and higly structured grobs

# the draw.key() function
  # accpts an arg called key and returns a grob


# the grob represents a legend containing a series of components
# can be text, points, lines, rectangles,

# all these can be achieved through key arg, 
# must be a list

# all components must be named, of which the names
# text, points, lines, rectangles may be repeated

# each component named points contributes a column of points
# each component named text contributes a column of texts
# in the order they appera in key

# each of these components must be lists,
# containing zero or more graphical parameters specified as vectors

# special case: text components, must hae a vector of character strings
# or expression s as their 1st component


# graphical components are usually specified as components of the text, points,
# lines, rectangles lists, also directly as components of key

# Valid graphical components are :
  # cex, col, lty, lwd, font, fontface, fontfamily, 
  # pch, adj, type, size



#--------------------#
# 9.2.3 The key arg
#--------------------#
# draw.key() quite general
# the key arg, accepted by all high-level functions,
# allows legend produced by draw.key() to be added to a plot

# such a key arg can be a list as accepted by draw.key()
# addtional components also allowed:

  # space: intened location of the key, "top"(default), bottom, lft, rgt

  # x, y, corner: alternative positioning of the legend inside plot region
      # common values for corner: c(0, 0), c(1, 0), c(1, 1), c(0, 1)


# in practice, most legend are associiated with a grouping variable,
# supplied as the groups arg


# one way to create standard legends (one col of text, and at most one col of points, lines, rectangles)
# is to use Rows() function, 
# useful for extracting a subset of graphical parameters suitable for use as a component in key

# 1st example: plot the mid-range price against engine size,
# conditioning on AirBags, with Cylinders as groupoing variable

data(Cars93, package = "MASS")
table(Cars93$Cylinders)


names(trellis.par.get())
super_symb <- trellis.par.get("superpose.symbol") 
# list of 6 vectors 

sup_sym <- Rows(trellis.par.get("superpose.symbol"), 1:5)
# convenient function to extract subset of a list
# usually to create key
str(sup_sym)


head(Cars93, 3)
#reorder(categoraicl_level, by_numeric_vec)

xyplot(Price ~ EngineSize | reorder(AirBags, Price),
       data = Cars93, groups = Cylinders, 
       subset = Cylinders != "rotary",
       scales = list(y = list(log = 2, tick.number = 3)),
       xlab = "Engine Size (Liters)",
       ylab = "Average Price (1000 USD)",
       key = list(text = list(levels(Cars93$Cylinders)[1:5]),
                  points = sup_sym, space = "right"))






















































