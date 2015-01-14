#' ---
#' title: "dplyr and tidyr demonstration"
#' author: "Brian High and Raphael Gottardo"
#' date: "Jan. 14th, 2015"
#' output:
#'      ioslides_presentation:
#'          fig_caption: yes
#'          fig_retina: 1
#'          fig_width: 6.5
#'          keep_md: yes
#'          smaller: yes
#' ---

#+ create-rmd, echo=FALSE, eval=FALSE
suppressMessages(library(knitr))
spin(report = TRUE, hair = "dplyr_and_tidyr_demo.R", format = "Rmd")
file.rename("dplyr_and_tidyr_demo.md", "dplyr_and_tidyr_demo.Rmd")

#' ## Load packages and data

#' Load ggplot2 and iris data

#+ library-ggplot2-data, echo=TRUE
suppressMessages(library(ggplot2))
data(iris)

#' Load dplyr and tidyr

#+ library-dplyr-tidyr, echo=TRUE
suppressMessages(library(dplyr))
suppressMessages(library(tidyr))

#' ## Add id column to data table

#' Coerce the iris data frame into a data table (not required).

#+ tbl_dt, echo=TRUE
iris_dt <- tbl_dt(iris)

#' Add a column to keep track of the flower

#+ mutate-flower_id, echo=TRUE
iris_id <- mutate(iris_dt, flower_id = rownames(iris))
head(iris_id)

#' ## dplyr and tidyr: gather

#' Convert wide data format to long format

#+ gather-Species-and-flower_id, echo=TRUE
iris_gathered <- gather(iris_id, variable, value, c(-Species, -flower_id))
head(iris_gathered)

#' ## dplyr and tidyr: mutate and gsub

#' Add new columns for the parsed values, remove the variable column

#+ parse, echo=TRUE
iris_parsed <- mutate(iris_gathered, 
    flower_part = gsub("(\\w*)\\.\\w*", "\\1", variable), 
    measurement_type = gsub("\\w*\\.(\\w*)", "\\1", variable),
    variable = NULL)
head(iris_parsed)

#' ## dplyr and tidyr: spread

#' Convert measurement_types to columns in wide format

#+ spread, echo=TRUE
iris_spread <- spread(iris_parsed, measurement_type, value)
head(iris_spread)

#' ## Plot with ggplot2

#' Produce faceted plot with ggplot2's qplot 

#+ ggplot-iris-spread, echo=TRUE, fig.height=4
qplot(x=Width, y=Length, data=iris_spread, geom=c("point","smooth"), 
      color=Species, method="lm", facets= flower_part~Species)

#' ## Repeat using a pipe

#' All of the data tidying could be done in one "pipe line"

#+ pipe, echo=TRUE
iris_spread <- tbl_dt(iris) %>% 
    mutate(flower_id = rownames(iris)) %>%
    gather(variable, value, c(-Species, -flower_id)) %>%
    mutate(flower_part = gsub("(\\w*)\\.\\w*", "\\1", variable), 
           measurement_type = gsub("\\w*\\.(\\w*)", "\\1", variable),
           variable = NULL) %>%
    spread(measurement_type, value)

#' ## Plot with ggplot2 again

#' Produce the faceted plot again with ggplot2's qplot 

#+ ggplot-iris-spread-pipe, echo=TRUE, fig.height=4
qplot(x=Width, y=Length, data=iris_spread, geom=c("point","smooth"), 
      color=Species, method="lm", facets= flower_part~Species)
