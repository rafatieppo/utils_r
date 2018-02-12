###======================================================================
###                                        Rafael Tieppo
###                                        rafaelt@unemat.br
###                                        https://rafatieppo.github.io/
###                                        17-01-2018
###======================================================================

###------------------------------------------------------------
### BRIEFING
###------------------------------------------------------------
### CREATING WEATHER (.WTH) FILES from .dat file (AgMIP full scenarios) 
### ATTENTION - THE OUTPUT REQUIRES ONE FILE FOR 30 YEARS
### Output file: TGXX1030
### * 1-2 th char = id
### * 3-4 th char = check AgMIP guide
### * 5-6 th char = initial year
### * 7-8 th char = final year
###------------------------------------------------------------

###------------------------------------------------------------
### Required packages
###------------------------------------------------------------

#install.packages("Dasst")
library(Dasst)

###------------------------------------------------------------
### Assign 2 characters for file name (id) 
###------------------------------------------------------------

local_name <- "TG"

###------------------------------------------------------------
### Reading data from full scenario folder

vector_filenames <- data.frame(FILE = dir('./FULL_SCENARIO'))
vector_filenames$EXT <- substr(vector_filenames$FILE, 10,12)
vector_filenames <- subset(vector_filenames,
                           EXT == 'dat')


###------------------------------------------------------------
### Preparing data.frame for data table
###------------------------------------------------------------
### reading data

listofdf_fullscen <-
    vector(mode = "list",
           length = length(vector_filenames$FILE))

for (i in seq(1:(length(vector_filenames)))) {
    df <-
        read.table(paste('./FULL_SCENARIO/',
                         vector_filenames$FILE[[i]],
                         sep = ""),
                   header = FALSE,
                   dec = ".",
                   skip = 5)
    df$FILENAME <-
        substr(vector_filenames[1], 1, 8)
    colnames(df) <-
        c("DDS", "YYYY", "MM", "DD",
          "SRAD","TMAX", "TMIN", "RAIN",
          "WIND",  "DEWP", "VPRS",  "RHUM",
          "FILENAME")
    df$DDS <-
        substr(df$DDS, 3,7)
    listofdf_fullscen[[i]] <- df
}

###------------------------------------------------------------
### Creating DSSAT OBJ  for each year - class DASST
### Only one DSSAT OBJ with several Tables (one for each year)
###------------------------------------------------------------

###------------------------------------------------------------
### number of slots in list_hist_byyear
n_slot <- length(vector_filenames$FILE)


dim(listofdf_fullscen[[1]])

###------------------------------------------------------------
### Creating Dasst object
dssat_obj_fullscen <- Dasst()

###------------------------------------------------------------
### Filling tables in dssat_obj_hist

for (i in seq(1:n_slot)) {
    df <-
        listofdf_fullscen[[i]]
    df <-
        df[,c(-2, -3, -4, -13)]
    dssat_obj_fullscen[i] <- 
       buildContents("HIST.OUT",
                              "*TestSec",
                              "@DATE  SRAD  TMAX  TMIN  RAIN  WIND  DEWP  VPRS  RHUM",
                              "  1   one 1.100",
                              df)
}

###------------------------------------------------------------
### Creating and Writing Files
###------------------------------------------------------------

###------------------------------------------------------------
### releasing max print
options(max.print=999999)

for (i in seq(1:n_slot)) {
### Preparing data for write the out put file header
    df_header <-
    readLines(file(paste('./FULL_SCENARIO/',
                         vector_filenames$FILE[[i]],
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

    c3 <- substr(vector_filenames$FILE[i], 5,5)
    c4 <- substr(vector_filenames$FILE[i], 6,6)
# writing file
    sink(paste("./FULL_SCENARIO/",
               local_name,
               c3,
               c4,
               "1030.WTH",
               sep = "")) 
    cat("*WEATHER DATA :", paste(df_header[1,2]))
    cat("\n \n")
    cat("@" , paste(df_header$VAR, sep = " "))
    cat("\n")
    cat("  " , paste(df_header$VALUE, sep = " "))
    cat("\n")
    cat("@DATE",  "SRAD",  "TMAX",  "TMIN",  "RAIN",  "WIND",  "DEWP",  "VPRS",  "RHUM", sep = " ")
    cat("\n")
    print(dssat_obj_fullscen[[i]], ix =1, row.names = FALSE)
    sink()
    closeAllConnections()
}

summary(dssat_obj_hist)
length (dssat_obj_hist)
head   (dssat_obj_hist)
#print(x[[1]], ix =1, row.names = FALSE)
