#*************************************************#
# Chapter 10 Data Manipulation and Related Topics
#*************************************************#
# revist the boxcox exapmle from chapter 2

# now don't choose the optimal Box-Cox transformation
# for gcsescore anaylitically, but try out several choicse
# and visualize the results


# define a function implementing the Box-Cox transformation

boxcox.trans <- function(x, lambda) {
  if (lambda == 0) log(x) else (x ^ lambda - 1) / lambda
}

for (p in seq(1, 3, by = 0.5)) {
  plot(qqmath(~ boxcox.trans(gcsescore, p) | gender, 
         data = Chem97, groups = score, 
         f.value = ppoints(100), 
         main = as.expression(substitute(lambda == v, list(v = p)))))
}


Titanic # a table
Titanic[, , "Adult", ] # a subsetted table

Titanic1 <- as.data.frame(Titanic[, , "Adult", ])

barchart(Class ~ Freq | Sex, data = Titanic1,
         groups = Survived, stack = TRUE,
         auto.key = list(title = "Survived", columns = 2))




#================#
# 10.4 Subsetting
#================#
# one can supply a subset arg to choose a subset of rows
# to use in display
# it should be an expression, possibly invoving 
# variables in data, that evaluates to a logical vector

# Titanic[, , "Adult", ] can be directly used in full Titanic data
barchart(Class ~ Freq | Sex, as.data.frame(Titanic),
         subset = (Age == "Adult"), groups = Survived,
         stack = TRUE, auto.key = list(title = "Survived", columns = 2))



# subsetting is more important for larger datasets
data(USAge.df, package = "latticeExtra")
# records estimated population of the us by age and sex
# for 1900 to 1979

head(USAge.df, 3)

# plot the population distr for every tenth year
# starting from 1905

xyplot(Population ~ Age | factor(Year), data = USAge.df,
       groups = Sex, type = c("l", 'g'),
       auto.key = list(lines = TRUE, points = FALSE, column = 2),
       aspect = "xy", ylab = "Population (millions)",
       subset = Year %in% seq(1905, 1975, by = 10))



xyplot(Population ~ Year | factor(Age), data = USAge.df,
       groups = Sex, type = "l", strip = FALSE, strip.left = TRUE,
       layout = c(1, 3), ylab = "Population (millions)",
       auto.key = list(lines = TRUE, points = FALSE, columns = 2),
       subset = Age %in% c(0, 10, 20)
       )



# to understand the dip in the male population in 1918
# plot conditioned on the year of birth
xyplot(Population ~ Year | factor(Year - Age),
       data = USAge.df, groups = Sex, 
       subset = (Year - Age) %in% 1894:1905,
       type = c("l", "g"),
       ylab = "Population (millions)",
       auto.key = list(lines = TRUE, points = FALSE, 
                       columns = 2))



#====================================#
# 10.5 Shingles and related utilites
#=====================================#

xyplot(stations ~ mag, data = quakes, 
       jitter.x = TRUE, type = c("p", 'smooth'),
       xlab = "Magnitude (Richter)",
       ylab = "Number of stations reporting")

# to understand whether variance of counts increase with mean
# use shingle to investigate
# use equal.count() to construct a shingle from 
# the numeric mag 


#  shingle is a data structure used in Trellis, 
# and is a generalization of factors to ‘continuous’ variables.
quakes$mag_shingle <- equal.count(quakes$mag, number = 10, overlap = 0.2)
# creates a shingle with 10 levels, a numeric intervals

# overlap: determines the % of overlap between successive levels
# 20% of the data in each interval should belong to the next
# if overlap is negative, then there are gaps in the coverage

summary(quakes$mag_shingle)
# a character representation of levels
as.character(levels(quakes$mag_shingle))

# a visual representation can be produced by plot
# creates a trellis obj, which we store in a variable for now
ps.mag <- plot(quakes$mag_shingle, ylab = "Level",
     xlab = "Magnitude (Richter)")


bwp.quakes <- bwplot(stations ~ mag_shingle, data = quakes, 
       xlab = "Magnitude", ylab = "Number of stations reporting")


# now plot the trellis objs
plot(bwp.quakes, position = c(0, 0, 1, 0.65))
plot(ps.mag, postion = c(0, 0.65, 1, 1))




































































