###======================================================================
###                                        Rafael Tieppo
###                                        rafaelt@unemat.br
###                                        https://rafatieppo.github.io/
###                                        25-06-2017
### Script to tidy data from ANA www.ana.gov.br/
###======================================================================


###------------------------------------------------------------
### Reading zip file and getting data file

ZIPFILES_LIST <-
    list.files(pattern="*.zip")

ZIPFILES_LIST_len <-
    length(ZIPFILES_LIST)

TIDY_ANA()

###------------------------------------------------------------
### Function

TIDY_ANA <-
    function()
{
    for(z in 1:ZIPFILES_LIST_len)
    {
        DF_RAIN <-
            read.table(unz(paste(ZIPFILES_LIST[z]),
                           "CHUVAS.TXT",
                           encoding = "ISO-8859-1" ),
                       skip = 15,
                       sep = ";",
                       header = TRUE,
                       dec = ",")

###------------------------------------------------------------
#### Reading file from ANA - MANUAL MODE ATTENTION
#DF_RAIN <-
#    read.csv("CHUVAS.TXT", skip = 15,
#             sep = ";",
#             header = TRUE,
#             dec = ",") 

###------------------------------------------------------------
### Creating a list for allocate data frames

        LISTOFDATAFRAME  <-
            vector(mode = "list",
                   length = nrow(DF_RAIN))

###------------------------------------------------------------
### Looping to read each row


        for (DD in (1:(nrow(DF_RAIN)))) {

###------------------------------------------------------------
### Transposing rows of interest

            DF_RAIN_T <- (t(DF_RAIN[DD, 14:76]))
            VARNAMES <- rownames(DF_RAIN_T)
            VARNAMES <- VARNAMES[c(-63)]
            rownames(DF_RAIN_T) <- NULL
            colnames(DF_RAIN_T) <- NULL
            #View(DF_RAIN_T)
            #dim(DF_RAIN_T)
###------------------------------------------------------------
### New Tidy data frame 

            DF_RAIN_TIDY <-
                cbind(STATION = rep(DF_RAIN[DD,1],
                                    31),
                      DATE = rep(paste(as.Date(DF_RAIN[DD,3],
                                               format = "%d/%m/%Y")),
                                 31),
                      RAIN_MONTH = DF_RAIN[DD,6],
                      VARS = VARNAMES[1:31],
                      VALUE = DF_RAIN_T[1:31,1],
                      CONSIST_LEV = rep(DF_RAIN[DD,2],
                                        31),
                      RAIN_STATUS = DF_RAIN_T[32:62,1])

            LISTOFDATAFRAME[[DD]] <- DF_RAIN_TIDY
        } ### end looping

###------------------------------------------------------------
### Allocate in only one list
        DF_RAIN_TIDY_DAYLY <-
            do.call(rbind, LISTOFDATAFRAME)

###------------------------------------------------------------
### Convert to data.frame

        DF_RAIN_TIDY_DAYLY <-
            data.frame(STATION = as.numeric(DF_RAIN_TIDY_DAYLY[,1]),
                       DATE = as.Date(DF_RAIN_TIDY_DAYLY[,2]),
                       RAIN_MONTH = as.numeric(DF_RAIN_TIDY_DAYLY[,3]),
                       VARS = DF_RAIN_TIDY_DAYLY[,4],
                       VALUE = DF_RAIN_TIDY_DAYLY[,5],
                       CONSIST_LEV = as.numeric(DF_RAIN_TIDY_DAYLY[,6]),
                       RAIN_STATUS = as.numeric(DF_RAIN_TIDY_DAYLY[,7]))

###------------------------------------------------------------
### Eliminating Feb 29-31
        DF_RAIN_TIDY_DAYLY <-
            subset(DF_RAIN_TIDY_DAYLY,
                   format.Date(DATE, "%m") != "02" |
                   VARS != "Chuva29")

        DF_RAIN_TIDY_DAYLY <-
            subset(DF_RAIN_TIDY_DAYLY,
                   format.Date(DATE, "%m") != "02" |
                   VARS != "Chuva30")
        
        DF_RAIN_TIDY_DAYLY <-
            subset(DF_RAIN_TIDY_DAYLY,
                   format.Date(DATE, "%m") != "02" |
                   VARS != "Chuva31")

###------------------------------------------------------------
### Column for continuos date

        DATE_CONT <-
            data.frame(DATE_CONT = rep(NA,
                                       nrow(DF_RAIN_TIDY_DAYLY)))

        DATE_CONT[1,1] <-
            paste(as.Date(DF_RAIN_TIDY_DAYLY[1,2],
                          format = "%Y-%m-%d"))

        ONEDAY <- 0

        for (i in (seq(2, nrow(DF_RAIN_TIDY_DAYLY))))
        {
            if(as.Date(DF_RAIN_TIDY_DAYLY[i,2]) ==
               as.Date(DF_RAIN_TIDY_DAYLY[i-1,2]))
            {
                ONEDAY <- ONEDAY + 1
                DATE_CONT[i,1] <-
                    paste((as.Date(DF_RAIN_TIDY_DAYLY[i-1,2],
                                   format = "%Y-%m-%d") + ONEDAY))
            }
            else
            {
                ONEDAY <- 0
                DATE_CONT[i,1] <-
                    paste((as.Date(DF_RAIN_TIDY_DAYLY[i,2],
                                   format = "%Y-%m-%d")))
            }
        }
        
        DF_RAIN_TIDY_DAYLY <-
            cbind(DF_RAIN_TIDY_DAYLY,
                  DATE_CONT)

###------------------------------------------------------------
### Sorting columns

        DF_RAIN_TIDY_DAYLY <-
            DF_RAIN_TIDY_DAYLY[,c(1, 2, 8, 3, 4, 5, 6, 7)]

###------------------------------------------------------------
### writing csv file
        write.csv(DF_RAIN_TIDY_DAYLY,
                  paste(DF_RAIN_TIDY_DAYLY[z,1],
                        'TIDY.csv', sep = "_"),
                  row.names = FALSE)

        CHECK_FILE <-
            list.files(pattern= paste(DF_RAIN_TIDY_DAYLY[z,1],
                                     'TIDY.csv',
                                     sep = "_"))
        
        ifelse(CHECK_FILE == paste(DF_RAIN_TIDY_DAYLY[z,1],
                                   'TIDY.csv',
                                   sep = "_"),
               print(paste(DF_RAIN_TIDY_DAYLY[z,1],
                           "writed as .csv",
                           sep = " ")),
               print(paste(DF_RAIN_TIDY_DAYLY[z,1],
                           "NOT writed",
                           sep = " ")))

###------------------------------------------------------------
### end
    }
cat("Please, do not forget my name \n for the next barbecue ;)")
}





