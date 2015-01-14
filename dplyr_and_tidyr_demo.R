# R script to demonstrate using dplyr and tidyr with iris data.
# Coding by: Brian High and Raphael Gottardo
# Last Modified: Jan. 14th, 2015

# Load ggplot2 and iris data
library(ggplot2)
data(iris)

# Load dplyr and tidyr
library(dplyr)
library(tidyr)

# Add a column to keep track of the flower
iris_id <- mutate(iris, flower_id = rownames(iris))
head(iris_id)

# Convert wide data format to long format
iris_gathered <- gather(iris_id, variable, value, c(-Species, -flower_id))
head(iris_gathered)

# Add new columns for the parsed values, remove the variable column
iris_parsed <- mutate(iris_gathered, 
    flower_part = gsub("(\\w*)\\.\\w*", "\\1", variable), 
    measurement_type = gsub("\\w*\\.(\\w*)", "\\1", variable),
    variable = NULL)
head(iris_parsed)

# Convert measurement_types to columns in wide format
iris_spread <- spread(iris_parsed, measurement_type, value)
head(iris_spread)

# Produce faceted plot with ggplot2's qplot 
qplot(x=Width, y=Length, data=iris_spread, geom=c("point","smooth"), 
      color=Species, method="lm", facets= flower_part~Species)

# All of the data tidying could be done in one piped "line"
iris_spread <- mutate(iris, flower_id = rownames(iris)) %>%
    gather(variable, value, c(-Species, -flower_id)) %>%
    mutate(flower_part = gsub("(\\w*)\\.\\w*", "\\1", variable), 
           measurement_type = gsub("\\w*\\.(\\w*)", "\\1", variable),
           variable = NULL) %>%
    spread(measurement_type, value)

# Produce the faceted plot again with ggplot2's qplot 
qplot(x=Width, y=Length, data=iris_spread, geom=c("point","smooth"), 
      color=Species, method="lm", facets= flower_part~Species)
