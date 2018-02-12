###======================================================================
###                                        Rafael Tieppo
###                                        rafaelt@unemat.br
###                                        https://rafatieppo.github.io/
###                                        17-01-2018
###======================================================================

###------------------------------------------------------------
### BRIEFING
###------------------------------------------------------------
### CREATING WEATHER (.WTH) FILES from .AGMIP file (HISTORICAL)
### IT IS FOR HISTORICAL DATA
### ATTENTION - THE OUTPUT REQUIRES ONE FILE FOR EACH YEAR
### Output file: MTTA8001
### * 1-4 th char = id
### * 5-6 th char = initial year
### * 7-8 th char = number of sequential years
###------------------------------------------------------------

###------------------------------------------------------------
### Required packages
###------------------------------------------------------------

#install.packages("Dasst")
library(Dasst)

###------------------------------------------------------------
### Assign 4 characters for file name (id) 
###------------------------------------------------------------
# note: that 4 characters must be the same of `.AgMIP` file in
# `./HISTORICAL` folder

local_name <- "MTTA"

###------------------------------------------------------------
### Preparing data.frame for data table
###------------------------------------------------------------
### reading data

df_hist <-
    read.table(paste('./HISTORICAL/',
                     local_name,
                     '0XXX.AgMIP',
                     sep = ""),
               header = FALSE,
               dec = ".",
               skip = 5)

###------------------------------------------------------------
### assigning col names
colnames(df_hist) <- c("DDS", "YYYY", "MM", "DD",
                       "SRAD","TMAX", "TMIN", "RAIN",
                       "WIND",  "DEWP", "VPRS",  "RHUM")

###------------------------------------------------------------
### Fix day of the year to DSSAT format e.g. 80001

df_hist$DDS <- substr(df_hist$DDS, 3,7)

###------------------------------------------------------------
### Creating a list of data frame, each slot is a year

year_seq <- (unique(df_hist$YYYY))
list_hist_byyear <- lapply(year_seq,
                           function(i) subset(df_hist,
                                              YYYY == i))

###------------------------------------------------------------
### Creating DSSAT OBJ  for each year - class DASST
### Only one DSSAT OBJ with several Tables (one for each year)
###------------------------------------------------------------

###------------------------------------------------------------
### number of slots in list_hist_byyear
n_slot <- length(year_seq)

###------------------------------------------------------------
### Creating Dasst object
dssat_obj_hist <- Dasst()

###------------------------------------------------------------
### Filling tables in dssat_obj_hist

for (i in seq(1:n_slot)) {
    df_hist <-
        list_hist_byyear[[i]]
    df_hist <-
        df_hist[,c(-2, -3, -4)]
    head(df_hist)
    dssat_obj_hist[i] <- 
       buildContents("HIST.OUT",
                              "*TestSec",
                              "@DATE  SRAD  TMAX  TMIN  RAIN  WIND  DEWP  VPRS  RHUM",
                              "  1   one 1.100",
                              df_hist)
}

###------------------------------------------------------------
### Preparing data for write the out put file header
###------------------------------------------------------------
### read file

df_header <-
    readLines(file(paste('./HISTORICAL/',
                     local_name,
                     '0XXX.AgMIP',
                     sep = ""),
                   "r",
                   blocking = FALSE), 4)
df_header <- c(a=df_header[4])
df_header
df_header <- gsub("[ ]", ",",  df_header)
df_header <- gsub(",,,", ",,",  df_header)
df_header <- gsub(",,", ",",  df_header)
df_header <- substring(df_header, 2)
df_header <- (strsplit(df_header, split= ","))
VAR = c("INSI", "LAT", "LONG", "ELEV",
        "TAV", "AMP", "REFHT", "WNDHT")
VALUE = c(df_header[[1]][1],
          df_header[[1]][2],
          df_header[[1]][3],
          df_header[[1]][4],
          -99, -99, -99, -99)

df_header <- data.frame(VAR = VAR,
                        VALUE = VALUE)

###------------------------------------------------------------
### Creating and Writing Files
###------------------------------------------------------------


###------------------------------------------------------------
### Creating vector to initial year for file name
### MTTA8001

vec_year_ini <-
    substr(year_seq, 3,4)

###------------------------------------------------------------
### releasing max print
options(max.print=999999)

for (i in seq(1:n_slot)) {
    sink(paste("./HISTORICAL/", local_name,
               vec_year_ini[i],
               "01.WTH",
               sep = ""))    # Desired output file
    cat("*WEATHER DATA :", paste(df_header[1,2]))
    cat("\n \n")
    cat("@" , paste(df_header$VAR, sep = " "))
    cat("\n")
    cat("  " , paste(df_header$VALUE, sep = " "))
    cat("\n")
    cat("@DATE",  "SRAD",  "TMAX",  "TMIN",  "RAIN",  "WIND",  "DEWP",  "VPRS",  "RHUM", sep = " ")
    cat("\n")
    print(dssat_obj_hist[[i]], ix =1, row.names = FALSE)
    sink()
}

summary(dssat_obj_hist)
length (dssat_obj_hist)
head   (dssat_obj_hist)
#print(x[[1]], ix =1, row.names = FALSE)
