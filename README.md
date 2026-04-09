# Football-Analytics-CSAS-2026

Date: April 10, 2026

Time: 4:05 - 5:15

Location: McHugh 206, University of Connecticut, Storrs, CT

Workshop Leader: [Nicholas Pfeifer](https://www.linkedin.com/in/nicholaspfeifer0/)

[Conference Website](https://statds.org/events/csas2026/)

## Overview

This workshop looks to provide a framework for conducting football analysis in R. Football specific packages will be leveraged to answer football related questions. This involves collecting data, making visualizations, and building models.

## Prerequisites

Familiarity with R and Football is recommended.

If you would like to follow along you are encouraged to bring your laptop.

## Running the Source Code

The source_code.qmd file, found in the code folder, can render multiple outputs: 1. The presentation and 2. an article style html file. The source_code.qmd file can also be used to run the individual code chunks. The following steps are recommended:

1.  clone this repository to an accessible location on your computer and open RStudio (or other IDE)
2.  install the following R packages: tidyverse, nflverse, ggplot2, gt, gridExtra, ggrepel, gtExtras, ggh4x, ggimage, ggforce, randomForest, fastshap, shapviz
3.  navigate to the code folder in the terminal and run this command to render the presentation (install [quarto](https://quarto.org/docs/get-started/) on your computer if you haven't already):

``` bash
quarto render source_code.qmd
```

This may take a few minutes. When completed, two files will be produced named presentation.html and handout.html respectively. The presentation is ready to go, but the handout is not.

4.  navigate to the code folder in the terminal and run this command to render the handout:

``` bash
quarto render source_code.qmd --to html
```

Both output files should now be properly rendered.

## Additional Info

Some of the data used in this workshop needs an API key to be accessed. This data has been stored as a csv file in the data folder for convenience. The college career stats data can be recreated with the cfb_career_stats.R file located in the code folder. The file will not run properly if you do not have an API key. You can get your own CFBD API key for free [here](https://collegefootballdata.com/key). This is not a requirement.
