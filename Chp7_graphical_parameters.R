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










































