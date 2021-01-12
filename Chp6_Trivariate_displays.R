#****************************#
# Chapter 6 Trivaraite plot
# ***************************#

# 4 high-level functions in lattice produce
# trivariate displays:
# cloud(): 3 dim scatter plots of unstructured trivariate data
# levelplot(), contouplot(), wireframe() render
# surfaces 


#=============================#
# 6.1 Three-dim scatter plots
#==============================#
library(lattice)

data('quakes')
head(quakes, 2)

quakes$Magnitude <- equal.count(quakes$mag, 4) # convert mag into 4 intervals shingle
range(quakes$Magnitude)

cloud(depth ~ lat * long | Magnitude,
      data = quakes, 
      zlim = rev(range(quakes$depth)),
      screen = list(z = 105, x = -70),
      panel.aspect = 0.75, # length of each side
      xlab = "Longitude", ylab = "Latitude",
      zlab = "Depth")


# > range(quakes$depth)
# [1]  40 680

# > rev(range(quakes$depth))
#[1] 680  40




# --------------------------------------------#
# 6.1.1 Dynamic manipulation vs stereo viewing
#---------------------------------------------#
state.info <- data.frame(name = state.name, area = state.x77[, "Area"],
           long = state.center$x, lat = state.center$y,
           population = 1000 * state.x77[, "Population"])

state.info$density <- with(state.info, population / area)

cloud(density ~ long + lat, data = state.info, 
      subset = !(name %in% c("Alaska", "Hawaii")),
      type = "h", lwd = 2, zlim = c(0, max(state.info$density)),
      scales = list(arrows = FALSE))



#=================================#
# 6.2 Surfaces and two-way tables
#=================================#

# surfaces and array-like data, where z-values
# are evaluated on a regular rectangular grid 
# defined by x- and y- values. 
# z values form a matrix and x- y- values rerpesent
# rows and columns of that matrix


#-----------------------#-
# 6.2.1 Data preparation
#-----------------------#
# Surfaces are in principle smooth, or at least continuous
# and can be abstractly represented as a function of two varaiables


# But they are conveniently represented as matricses
# containting evalutaiotns of the function on a grid

# although 2-d table is natrually presented as matrices
# it has inherent discreteness

# so be careful to preprocess the data to get them in a suitable form

# the most convenient situation is when the data is already evalutated on a grid
# in the form of a matrix

# volcano data, records the elevation of MTEDEN
# on a 10m by 10m grid. 
# the data is in the form of a matrix, no conditioning varaible

data("volcano") # 1:87, 1:61


# next example: a correlation matrix, derived from data on car models
data("Cars93", package = "MASS")
Cars93[, !sapply(Cars93, is.factor)]

corr_Cars93 <- cor(Cars93[, !sapply(Cars93, is.factor)], 
    use = "pair")


# the 3rd example is a mutlitway frequency table
# create a frequency table of score by gcsescore
# discretized into ten equally sized group and gender
data(Chem97, package = "mlmRev")

Chem97$gcd <- with(Chem97, cut(gcsescore, breaks = quantile(gcsescore, 
                                 ppoints(11, a = 1))))

ChemTab <- xtabs(~ score + gcd + gender, Chem97)
# natrually creates a 3-d array, with gender be a natrual conditioning variable

# to convert this table to a helpful data.frame
ChemTab_df <- as.data.frame(ChemTab)


# Last example: evaluating fitted regression surfaces
# on a regular grid. 

data("environmental")
# consists of daily measurements of ozone concentration
# with speed, temp, solar radiation in NY for 111 days i 1973

# we fit regression models which predict ozone concentration
# an indicator of smog, using other measurements as predictores

# use cube root of ozone concentration as the response

env <- environmental
env$cub_ozone <- env$ozone ^ (1 / 3)
hist(env$ozone) # right skewed
hist(env$cub_ozone) # much close to normal

# for the purpose of conditioning, create shingles from the continous predictors
# Radiation is used as conditioning varaible to create a 3-d scatter plot
env$radiation_4cut <- equal.count(env$radiation, 4)
cloud(cub_ozone ~ wind + temperature | radiation_4cut, data = env)


# a scatter-plot matrix is another useful viz
splom(env[, 3:6])
head(env, 2)
head(env[, 3:6], 3)


# fit 4 regression models. 
# 1st: parametric
# the remaining: non-parametric loess, and local fit


# 1st: 
fm1_env <- lm(cub_ozone ~ radiation * temperature * wind, data = env)

# 2nd:
fm2_env <- loess(cub_ozone ~ wind * temperature * radiation, data = env,
      span = 0.75, degree = 1L)


# 3rd:
fm3_env <- loess(cub_ozone ~ wind * temperature * radiation, data = env, 
      parametric = c("radiation", "wind"), 
      span = 0.75, degree = 2)


# 4th:
install.packages("locfit")
library(locfit)

fm4_env <- locfit(cub_ozone ~ wind * temperature * radiation, data = env)


# eventual goal is to display the fitted regression surfaces
# so first, need to evaluate the predicted ozone concentrations 
# on a regular grid of predictor values

# there are 3 predictors, but can only use 2 to define a surface
# so use one as conditioning varaible. 

# we first create the vectors of values for 
# each predictor which defines the margins of the 2-d grid

install.packages("lattice")
library(lattice)

with(env, range(wind)) # [1]  2.3 20.7

w.mesh <- with(env, do.breaks(range(wind), 50)) # draw histgram and kernel density
# do.breaks(end.point, nint)


marginal_mesh <- function(Var, nint) {
  with(env, do.breaks(range(Var), nint = nint))
}

wind_mesh <- marginal_mesh(env$wind, 50)
temp_mesh <- marginal_mesh(env$temperature, 50)
rad_mesh <-marginal_mesh(env$radiation, 3)

# the expand.grid() can construct a full grid
# in the form of a data frame from these margins

# eventual goal is to display the fitted regression surfaces
# so first, need to evaluate the predicted ozone concentrations 
# on a regular grid of predictor values
Grid_predictors <- expand.grid(wind = wind_mesh, 
            temperature = temp_mesh,
            radiation = rad_mesh)


pred1 <- predict(fm1_env, newdata = Grid_predictors)
# a vecotr 10404 elements

# so final step is to add columns of each fitted model into the 
# Grid_predictors df
Grid_predictors[["fit_lm"]] <- predict(fm1_env, newdata = Grid_predictors)

pd2 <- predict(fm2_env, newdata = Grid_predictors)
# an array, need to vectorize it

Grid_predictors[["fit_loess1"]] <- as.vector(predict(fm2_env, newdata = Grid_predictors))
Grid_predictors[["fit_loess2"]] <- as.vector(predict(fm3_env, newdata = Grid_predictors))

pd4 <- predict(fm4_env, newdata = Grid_predictors)
# a vector

Grid_predictors[["fit_locfit"]] <- predict(fm4_env, newdata = Grid_predictors)

# now use these examples to create some plots

#----------------------------#
# 6.2.2 Visualizing surfaces
#----------------------------#
par(mai = c(0.1, 0.1, 0.1, 0.1))
wireframe(fit_lm  + fit_loess1 + fit_loess2 + fit_locfit
          ~ wind * temperature | radiation, data = Grid_predictors,
          outer = TRUE, shade = TRUE, zlab = "") 
# draw 3d scatter plot and surfaces



# levelplot has an interface identical to that of wireframe
# but it uses a false-color gradient to encode the z variable


levelplot(fit_lm  + fit_loess1 + fit_loess2 + fit_locfit
          ~ wind * temperature | radiation, data = Grid_predictors)


# contour plot labels the level (z values) using cols and contour line
# disadvantage: can not use too many levels, tend to overlap

contourplot(fit_locfit ~ wind * temperature | radiation,
            data = Grid_predictors, aspect = 0.7, 
            layout = c(1, 4), cuts = 15, label.style = "align")




# all of these method can be directly used onto a matrix
levelplot(volcano)
contourplot(volcano, cuts = 20, label = TRUE)
wireframe(volcano, panel.aspect = 0.7, zoom = 1, lwd = 0.5)



























































