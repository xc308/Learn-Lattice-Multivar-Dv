#**********************************************#
# Chp 7 Graphical Parameters and Other Settings
#***********************************************#

# feartures that are common to all high-level lattice fucntion

# start from the user settable graphical parameters and other global options


#=========================#
# 7.1 The Parameter System
#=========================#

#--------------#
# 7.1.1 Themes
#--------------#
data("VADeaths")
head(VADeaths, 2)

VADeaths_tab <- as.data.frame.table(VADeaths)
head(VADeaths_tab, 10)
#    Var1         Var2 Freq
# 1 50-54   Rural Male 11.7
# 2 55-59   Rural Male 18.1


reorder(x, y)
# reorder the level of categorical x by numercial y
with(VADeaths_tab, reorder(Var2, Freq))

VAD_plot <- dotplot(reorder(Var2, Freq)  ~ Freq | Var1, 
        data = as.data.frame.table(VADeaths),
        origin = 0, type = c("p", "h"),
        main = "Death Rates in Virginia  1940",
        xlab = 'Number of deaths per 100')

VAD_plot


# to remove the reference line
dot_lint_settings <- trellis.par.get("dot.line")
str(dot_lint_settings)
# List of 4
#$ alpha: num 1
#$ col  : chr "#e6e6e6"
#$ lty  : num 1
#$ lwd  : num 1

# change the color to transparent

dot_lint_settings$col <- "transparent"
trellis.par.set("dot.line", dot_lint_settings)

# double the thinkness of the line shown
plot_line_setttings <- trellis.par.get("plot.line")
str(plot_line_setttings)
# List of 4
#$ alpha: num 1
#$ col  : chr "#0080ff"
#$ lty  : num 1
#$ lwd  : num 1

plot_line_setttings$lwd <- 2
trellis.par.set("plot.line", plot_line_setttings)

VAD_plot



#----------------------------------#
# 7.1.5 Usage and alternative forms
#----------------------------------#
# both trellis.par.get() and trellis.par.set()
# apply to the theme associated with the currently active device

# trellis.par.get(), called with a name arg
# returns the assocaited parameters as a list
# trellis.par.set() can be called with name and value

# more than one parameter can be set at once as named arg
# so
trellis.par.set(dot.line = dot.line.settings,
                plot.line = plot.line.settings)

# where the dot.line.settings <- trellis.par.get("dot.line")
# and str(dot.line.settings) is a list: 
  # alpha, col, lty, lwd

# in fact, the replacement may be incomplete,
# in the sense that only components being modified
# need to be supplied. 

trellis.par.set(dot.line = list(col = "transparent"),
                plot.line = list(lwd = 2))


# finally, any number of parameters can be supplied 
# together as a list
trellis.par.set(list(dot.line = list(col = "transparent"),
                     plot.line = list(lwd = 2)))



#--------------------------------#
# 7.1.6 The par.settings argument
#--------------------------------#

# trellis.par.set() modifies the current theme

# often, one wants to associate specific parameter values with 
# a particula call rather than globally modify the settings
# this can be achieved by using par.settings arg in any high-level lattice call

# these new settings are temporarily in effect for the duration of the plot
# after which the settings revert to whatever they were before

update(VAD_plot,
       par.settings = list(dot.line = list(col = "transparent"),
                           plot.line = list(lwd = 2)))


# this paradigm is particularly useful, in conjunction with auto.key arg
# for grouped displays with non-default graphical pareameters


#==================================#
# 7.2 Availabe graphical paramters
#==================================#
# the graphical parameter system can be viewed as
# a collection of named settings, each controlling 
# certain elements in lattice dispalys

# the user must know the names and structures of the setting available
# the full list is subject to change, 
# but the most current list can always be obtained by inspecting 
# the contects of a theme,
names(trellis.par.get())

# common pattern: their value is simply a list of 
# standard graphical parameters e.g. col, pch, etc


show.settings()

names(trellis.par.get())
str(trellis.par.get("layout.heights"))
# List of 19
# all the components ending with "padding" can be setting to 0
# to make the layout as little wasteful



#===========================#
# 7.3 Non-graphical options
#===========================#
# a 2nd set of settings can be queried and modified 
# using lattice.getOption(), lattice.options()
# theses are global (not device-specific) and not graphical in nature

# and primarily intended as a developer tool that allows
# experimentation with minimal code change



#******************************************#
# Chp8 Plot Coordinates and Axis Annotation
#*******************************************#

# how the coordinate system for each panel is determeind
# hwo axes are annotated


#===================================#
# 8.1 Packets and prepanel function
#===================================#

# each combination of levels of the conditioning varaible
# defining a trellis obj gives rise to a packet

# a packet is the data subset goes into a panel representing a
# particular combination


#===================#
# 8.2 The Scales arg
#===================#

#----------------#
# 8.2.1 Relation
#----------------#
# 3 alterantive schemes, depending on how the panels
# are relate to each other in the Trelllis display, 
# how the set of minimal rectangles collectively determines the final rectangele
# for each packet

# The most common situation : all panels have the same rectangles
  # scales = "same"

# 2nd situation: allow completely independent rectangles
  # scales = "free"

# the 3rd option: allow seperate rectangles for each packet, 
# but their widths and heights to be the same, with 
# with the intent of making the differences comparable across panels
  # scales = "sliced"



# if want to specify the relation between panels separately
# for horizontal and vertical axes
# can also be achieved through scales arg
scales = list(x = "same", y = "free")
# leads to a common horizontal range
# and independent vertical ranges

# In general form, scales can be a list containing 
# components called x and y, affecting the horizontal and vertical axes
# each of which in turn can be lists containing parameters 
# in name = value form

# both scales and its x, y components can be a 
# character string specifying the rule used to determine
# the packet rectangles

# most other componenets of scales affect the drawing 
# of tick marks and labels to annotate the axes

#-----------------------------------------#
# 8.2.2 Axis annotation: Ticks and labels
#-----------------------------------------#
# Axis annotation is performed by axis function
# which defaults to axis.default(), but can overide by user

# log: data will be log-transfromed, scaler logical, default = FALSE
# draw: logical, if FALSE, the axes are not drawn, adn parameters below have no effect

# alternating: applicable only if relation = "same"
  # the tick marks are always drawn, but lables can be omitted using alternating parameter
  # a numeric vector, for each row, 
    # 0: not label on both end
    # 1, on the left, 
    # 2, on the right, 
    # 3 on both ends

  # for a col, 1 label at the bottom, 2 at the top, 3, both, 0 non

data(biocAccess, package = "latticeExtra")
head(biocAccess, 2)


eqc_time <- with(biocAccess, equal.count(as.numeric(time), 9, overlap = 0.01))
# shingle 
head(eqc_time)

xyplot(counts / 1000 ~ time | equal.count(as.numeric(time), 9, overlap = 0.01),
       data = biocAccess, type = "l", aspect = "xy",
       strip = FALSE, 
       ylab = "Number of accesses (per 1000)",
       xlab = "",
       scales = list(x = list(relation = "sliced", axs = "i"),
                     y = list(alternating = FALSE)))

# the use of a date-time obj as a primary variable
# affects how the x-axis is annotated


axis.CF <- function(side, ...) {
  if (side == "right") {
    F2C <- function(f) 5 * (f - 32) / 9
    C2F <- function(c) 32 + 9 * c / 5
    
    ylim <- current.panel.limits()$ylim
    prettyF <- pretty(ylim)
    prettyC <- pretty(F2C(ylim))
    
    panel.axis(side = side, outside = TRUE, 
               at = prettyF, tck = 5, 
               line.col = "grey65", 
               text.col = "grey35")
    
    panel.axis(side = side, outside = TRUE, 
               at = C2F(prettyC), 
               labels = as.character(prettyC),
               tck = 1, line.col = "black", 
               text.col = "black")
  } else axis.default(side = side, ...)
}


# alternating = 2, label on the right, 3 on both end

xyplot(nhtemp ~ time(nhtemp), aspect = "xy",
       type = "o", 
       scales = list(y = list(alternating = 2, tck = c(1, 5))),
       axis = axis.CF, xlab = "Year", 
       ylab = "Temperature",
       main = "Yearly temperature in New Haven, CT",
       key = list(text = list(c("Celcius", "Fahrenheit"),
                              col = c("black", "grey35")),
                              columns = 2,
                  space = "top"))












#===========================================#
# 8.4 Scale components and the axis function
#===========================================#
# axis annotation is in principle distinct from the determination
# of panel coordinates

# 




















































































































































