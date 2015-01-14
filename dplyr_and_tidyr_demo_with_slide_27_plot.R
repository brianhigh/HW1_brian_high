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
spin(report = TRUE, hair = "dplyr_and_tidyr_demo_with_slide_27_plot.R", format = "Rmd")
file.rename("dplyr_and_tidyr_demo_with_slide_27_plot.md", "dplyr_and_tidyr_demo_with_slide_27_plot.Rmd")

#' ## Load packages and data

#' Load ggplot2 and iris data.

#+ library-ggplot2-data, echo=TRUE
suppressMessages(library(ggplot2))
data(iris)

#' Load dplyr and tidyr.

#+ library-dplyr-tidyr, echo=TRUE
suppressMessages(library(dplyr))
suppressMessages(library(tidyr))

#' ## Add id column to data table

#' Add a column to keep track of the flower id.

#+ mutate-flower_id, echo=TRUE
iris_id <- mutate(iris, flower_id = rownames(iris))
head(iris_id)

#' ## dplyr and tidyr: gather

#' Convert wide data format to long format.

#+ gather-Species-and-flower_id, echo=TRUE
iris_gathered <- gather(iris_id, variable, value, c(-Species, -flower_id))
head(iris_gathered)

#' ## dplyr and tidyr: mutate and gsub

#' Add new columns for the parsed values, remove the variable column.

#+ parse, echo=TRUE
iris_parsed <- mutate(iris_gathered, 
                      flower_part = gsub("(\\w*)\\.\\w*", "\\1", variable), 
                      measurement_type = gsub("\\w*\\.(\\w*)", "\\1", variable),
                      variable = NULL)
head(iris_parsed)

#' ## dplyr and tidyr: spread

#' Convert measurement_types to columns in wide format.

#+ spread, echo=TRUE
iris_spread <- spread(iris_parsed, measurement_type, value)
head(iris_spread)

#' ## Plot with ggplot2's `qplot`

#' Produce faceted plot with ggplot2's `qplot`.

#+ qplot-iris-spread, echo=TRUE, fig.height=4
qplot(x=Width, y=Length, data=iris_spread, geom=c("point","smooth"), 
      color=Species, method="lm", facets= flower_part~Species)

#' ## Repeat using a pipe

#' All of the data tidying could be done in one "pipe line".

#+ pipe, echo=TRUE
iris_spread <- mutate(iris, flower_id = rownames(iris)) %>%
    gather(variable, value, c(-Species, -flower_id)) %>%
    mutate(flower_part = gsub("(\\w*)\\.\\w*", "\\1", variable), 
           measurement_type = gsub("\\w*\\.(\\w*)", "\\1", variable),
           variable = NULL) %>%
    spread(measurement_type, value)

#' ## Plot with ggplot2's `qplot` again

#' Produce the faceted plot again with ggplot2's `qplot`.

#+ qplot-iris-spread-pipe, echo=TRUE, fig.height=4
qplot(x=Width, y=Length, data=iris_spread, geom=c("point","smooth"), 
      color=Species, method="lm", facets= flower_part~Species)

#' ## Plot with `ggplot`

#' Produce a faceted plot with `ggplot2` instead of `qplot`.

#+ ggplot-iris-spread-pipe, echo=TRUE, fig.height=4
ggplot(data=iris_spread, aes(x=Width, y=Length))+ 
    # Add points and use free scales in the facet
    geom_point()+facet_grid(Species~flower_part, scale="free")+
    # Add a regression line
    geom_smooth(method="lm")+
    # Use the black/white theme and increase the font size
    theme_bw(base_size=18)