########## some manipulation of the dataset

# remove the why column for easier reading
newdata <- df5[,-3]

# throw out id R_7ONSkE1nz3KoRFO
# it appears this person closed the browser window before completing the task; 
# this is probably Professor Dixon who informed us of his choice to not participate
newdata <- newdata[newdata$id != "R_7ONSkE1nz3KoRFO",]

# create an answer key
key <- data.frame(dataset = rep(LETTERS[1:3], each = 3), qid = rep(1:3, 3), correct = NA)

## Crew, 1st, 3rd, 2nd
key[key$dataset == "A" & key$qid == 1,]$correct <- "1_2_4_3"
## 1st, 2nd, 3rd, crew 
key[key$dataset == "A" & key$qid == 2,]$correct <- "4_1_2_3"
## Crew, 3rd, 2nd, 1st
key[key$dataset == "A" & key$qid == 3,]$correct <- "1_4_3_2"

## receivers E & B show progression that matches emitter order
key[key$dataset == "B" & key$qid == 1,]$correct <- 1
## 
key[key$dataset == "B" & key$qid == 2,]$correct <- "1_4_3_2"
## 0.15 vs 0.13 true or too close
## 0.20 vs 0.16 true
## 0.20 vs 0.10 false
## 0.20 vs 0.27 true
key[key$dataset == "B" & key$qid == 3,]$correct <- "1_1_2_1" # or "1_4_2_1"


# > ddply(.data = newDataC[newDataC$chrom == "chrX",], .variables = "path", .fun = nrow)
      # path V1
# 1 hsa00230 12
# 2 hsa03010 11
# 3 hsa03410  1
# 4 hsa04012 13
# 5 hsa04110 14
# 6 hsa04380 26
# 7 hsa04620 17
# 8 hsa04972  6
key[key$dataset == "C" & key$qid == 1,]$correct <- "1_2_4_3"
# > nrow(newDataC[newDataC$chrom == "chr4" & newDataC$path == "hsa04620",])
# [1] 36
# > nrow(newDataC[newDataC$chrom == "chr1" & newDataC$path == "hsa04972",])
# [1] 59
# > nrow(newDataC[newDataC$chrom == "chr7" & newDataC$path == "hsa04110",])
# [1] 26
# > nrow(newDataC[newDataC$chrom == "chr21" & newDataC$path == "hsa00230",])
# [1] 28
key[key$dataset == "C" & key$qid == 2,]$correct <- "4_1_2_3"
# > ddply(.data = newDataC[newDataC$chrom == "chr1",], .variables = "path", .fun = function(x){nrow(x)/280})
      # path         V1
# 1 hsa00230 0.20000000
# 2 hsa03010 0.04285714
# 3 hsa03410 0.05000000
# 4 hsa04012 0.10000000
# 5 hsa04110 0.12857143
# 6 hsa04380 0.19285714
# 7 hsa04620 0.07500000
# 8 hsa04972 0.21071429
key[key$dataset == "C" & key$qid == 3,]$correct <- 3

#############################################
## question 0: what type of chart is most preferred
test0 <- ddply(.data = newdata, .variables = "pref", .fun = function(x){length(unique(x$id))})
rownames(test0) <- c("none", "bar", "circle", "hammock", "equal")
test0

#        pref V1
# none          1
# bar        1 16
# circle     2  4
# hammock    3 10
# equal      4  1

#############################################################
# question 1: does order of chart display affect preference?
#############################################################
test1 <- ddply(.data = newdata, .variables = c("id", "pref"), .fun = function(x){as.character(unique(x[x$dataset == "A",]$plottype))})

## number of individuals who preferred bar graphs if they were shown bar first
nrow(test1[test1$pref == 1 & test1$V1 == "bar",])
#[1] 11
## percentage of those shown bar first who prefer bar
100 * nrow(test1[test1$pref == 1 & test1$V1 == "bar",]) / nrow(test1[test1$V1 == "bar",])
[1] 100

## number of indiv who preferred hammock plots if they were shown hammocks first
nrow(test1[test1$pref == 3 & test1$V1 == "hammock",])
# [1] 10
## percentage of those shown hammock first who prefer hammock
100 * nrow(test1[test1$pref == 3 & test1$V1 == "hammock",]) / nrow(test1[test1$V1 == "hammock",])
# [1] 76.92308

## number of indiv who preferred circle if they were shown circle first
nrow(test1[test1$pref == 2 & test1$V1 == "circos",])
#[1] 4
## percentage
100 * nrow(test1[test1$pref == 2 & test1$V1 == "circos",]) / nrow(test1[test1$V1 == "circos",])
#[1] 50

############################################################
# question 2: what dataset and question has the best accuracy?
############################################################

test2 <- ddply(.data = newdata, .variables = c("dataset", "qid"), .fun = function(x){c(nrow(x[which(key[key$dataset == unique(x$dataset) & key$qid == unique(x$qid), ]$correct == x$response),]), nrow(x))})
cbind(test2,test2$V1/test2$V2)

  # dataset qid V1 V2 test2$V1/test2$V2
# 1       A   1 13 32           0.40625
# 2       A   2 25 32           0.78125
# 3       A   3 27 32           0.84375
# 4       B   1 30 32           0.93750
# 5       B   2  8 32           0.25000
# 6       B   3  2 32           0.06250
# 7       C   1  0 32           0.00000
# 8       C   2  1 32           0.03125
# 9       C   3 20 32           0.62500

############################################################
# question 3: what dataset and question has the best accuracy, by chart type
############################################################
test3 <- ddply(.data = newdata, .variables = c("dataset", "qid", "plottype"), .fun = function(x){c(nrow(x[which(key[key$dataset == unique(x$dataset) & key$qid == unique(x$qid), ]$correct == x$response),]), nrow(x))})


cbind(test3, Freq = round(test3$V1/test3$V2, 3))
   # dataset qid plottype V1 V2  Freq
# 1        A   1      bar  7 11 0.636
# 2        A   1   circos  6  8 0.750
# 3        A   1  hammock  0 13 0.000
# 4        A   2      bar  9 11 0.818
# 5        A   2   circos  5  8 0.625
# 6        A   2  hammock 11 13 0.846
# 7        A   3      bar  9 11 0.818
# 8        A   3   circos  7  8 0.875
# 9        A   3  hammock 11 13 0.846
# 10       B   1      bar 10 10 1.000
# 11       B   1   circos 13 13 1.000
# 12       B   1  hammock  7  9 0.778
# 13       B   2      bar  5 10 0.500
# 14       B   2   circos  3 13 0.231
# 15       B   2  hammock  0  9 0.000
# 16       B   3      bar  1 10 0.100
# 17       B   3   circos  1 13 0.077
# 18       B   3  hammock  0  9 0.000
# 19       C   1      bar  0 11 0.000
# 20       C   1   circos  0 11 0.000
# 21       C   1  hammock  0 10 0.000
# 22       C   2      bar  0 11 0.000
# 23       C   2   circos  1 11 0.091
# 24       C   2  hammock  0 10 0.000
# 25       C   3      bar  7 11 0.636
# 26       C   3   circos  7 11 0.636
# 27       C   3  hammock  6 10 0.600

test3a <- ddply(.data = newdata, .variables = c("dataset", "plottype"), .fun = function(x){c(nrow(x[which(key[key$dataset == unique(x$dataset) & key$qid == unique(x$qid), ]$correct == x$response),]), nrow(x))})
cbind(test3a, freq = test3a$V1/test3a$V2)

  # dataset plottype V1 V2       freq
# 1       A      bar 10 33 0.30303030
# 2       A   circos  6 24 0.25000000
# 3       A  hammock 10 39 0.25641026
# 4       B      bar  8 30 0.26666667
# 5       B   circos  7 39 0.17948718
# 6       B  hammock  3 27 0.11111111
# 7       C      bar  1 33 0.03030303
# 8       C   circos  2 33 0.06060606
# 9       C  hammock  4 30 0.13333333

############################################################
# question 4: looking at trends of time per page, responder type
############################################################

##note: V1 = reported time per page[dataset] in seconds

# some response
ddply(.data = newdata[newdata$response != "No Response",], .variables = c("dataset", "plottype"), .fun = function(x){median(as.numeric(as.character(x$pagetime)))})
  # dataset plottype     V1
# 1       A      bar 183.02
# 2       A   circos 245.94
# 3       A  hammock 103.53
# 4       B      bar 312.92
# 5       B   circos 332.15
# 6       B  hammock 248.85
# 7       C      bar 287.48
# 8       C   circos 199.63
# 9       C  hammock 157.32

# correct response
 ddply(.data = newdata, .variables = c("dataset",  "plottype"), .fun = function(x){median(as.numeric(as.character(x[which(key[key$dataset == unique(x$dataset) & key$qid == unique(x$qid), ]$correct == x$response), "pagetime"])))})
  # dataset plottype      V1
# 1       A      bar 198.595
# 2       A   circos 198.670
# 3       A  hammock  85.970
# 4       B      bar 396.165
# 5       B   circos 388.280
# 6       B  hammock  43.040
# 7       C      bar 510.350
# 8       C   circos  25.265
# 9       C  hammock 138.355


# no response
ddply(.data = newdata[newdata$response == "No Response",], .variables = c("dataset", "plottype"), .fun = function(x){median(as.numeric(as.character(x$pagetime)))})
  # dataset plottype      V1
# 1       A      bar 190.420
# 2       A  hammock  89.680
# 3       B      bar 111.470
# 4       B   circos  82.240
# 5       B  hammock  41.655
# 6       C      bar 178.680
# 7       C   circos  44.260
# 8       C  hammock  21.690

# all participants
ddply(.data = newdata, .variables = c("dataset", "plottype"), .fun = function(x){median(as.numeric(as.character(x$pagetime)))})
  # dataset plottype     V1
# 1       A      bar 183.02
# 2       A   circos 245.94
# 3       A  hammock 103.53
# 4       B      bar 304.80
# 5       B   circos 322.81
# 6       B  hammock 248.85
# 7       C      bar 287.48
# 8       C   circos 150.66
# 9       C  hammock 155.94
