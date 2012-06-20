### package and code dependencies
require(reshape)
require(ggplot2)
require(plyr)
library(RColorBrewer)
source('hammock.R')


### some aesthetic choices
cols <- colorRampPalette(brewer.pal(3,"Reds"))(3)
fill_colors <- rep(cols, 2)
bar_thickness <- 0.25
alpha <- 0.5 # set transparancy of connections between 0 and 1 [opaque]
text_angle <- 0 # 0 for horizontal plot orientation, 90 for vertical plot orientation
legend <- 'none'
outline_color <- NA

## Data is given as a list of frequencies
dat <- c(62, 18, 5, 31, 39, 14, 8, 36, 42)

## NOTE2: the categorical nature of CRP & HDL measures are due to arbitrary cutoffs of 
##        continuous data and reflect clinical context
data.tert <- data.frame(baseCRP=rep(1:3, each = 3), followCRP=rep(1:3, 3), Freq=dat)
data.tert$baseCRP <- factor(data.tert$baseCRP, labels = c('low', 'med', 'high'))
data.tert$followCRP <- factor(data.tert$followCRP, labels = c('low', 'med', 'high'))

### data & display variables
variables <- list('baseCRP', 'followCRP') # variables, as named in data.frame
connect_weight <- 'Freq' # variable that stores the connector width
ordering <- 0 # set to -1 or 1 for ordering within bar by freq


#### NOTE: additional ggplot2 commands may be used to modify the display

## vertical

theme_set(theme_bw())

gghammock(vars = variables, data = data.tert, weight = connect_weight, order = ordering,
          angle = text_angle, color = outline_color) + 
            ylab("No. of Participants") +
            opts(panel.grid.minor=theme_blank(),
                 plot.margin=unit(c(1, 1, 0, 1), "lines"),
                 axis.title.y=theme_text(size=18, vjust=0.25, angle=90),
                 axis.text.x=theme_text(size=18), legend.position=legend) + 
            scale_x_discrete(labels=c("Baseline CRP", "Follow-up CRP")) +
            scale_fill_manual(values = fill_colors) +
            annotate("text", y = 42.5, x = 1, 
                     label = "''<' 0.77 mg/L'", parse=TRUE, angle=90, size=6) +
            annotate("text", y = 127.5, x = 1, 
                     label = "'0.77 - '<' 1.91 mg/L'", parse=TRUE, angle=90, size=6) +
            annotate("text", y = 212.5, x = 1, 
                     label = "''>= ' 1.91 mg/L'", parse=TRUE, angle=90, size=6)

