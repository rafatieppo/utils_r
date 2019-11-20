 #=================================================================
#                          Rafael Tieppo
#                          rafaelt@unemat.br
#                          http://docente.unemat.br/rafaeltieppo/
#                          29-08-2016
#=================================================================


##### Goal 1  
### Script to sign in - INMET
### Historical Data
### Original Source:
### http://r-br.2285057.n4.nabble.com/R-br-r-baixando-dados-inmet-td4660459.html
### http://r-br.2285057.n4.nabble.com/R-br-RCurl-td4659610.html
##### Goal 2
### Ordering and filtering DATA from INMET
### use oneline() function from
### from rafatieppo/INMET_DATA_ORDER


#************************************************************
#************************************************************
                                        # GOAL 1
#************************************************************
#************************************************************


#------------------------------------------------------------
### Packages
library(RCurl)
library(bitops)
library(dplyr)

#------------------------------------------------------------


#------------------------------------------------------------
### Logging INMET

### Login link
myURL1 <- "http://www.inmet.gov.br/projetos/rede/pesquisa/inicio.php"
### Data link
myURL2 <- "http://www.inmet.gov.br/projetos/rede/pesquisa/gera_serie_txt.php?&mRelEstacao=83309&btnProcesso=serie&mRelDtInicio=01/01/1940&mRelDtFim=30/07/2017&mAtributos=,,1,1,,,,,,1,1,,1,1,1,1,"

#------------------------------------------------------------


#------------------------------------------------------------
### Access Data

myParams=list(
  mCod="login", ### alterar!
  mSenha="senha", ### alterar!
  btnProcesso = " Acessar ")
#------------------------------------------------------------


#------------------------------------------------------------
### Getting Data

myCurl <- getCurlHandle()
curlSetOpt(cookiejar="cookies.txt", useragent="Chrome/10.0.648.133" , followlocation=TRUE, curl=myCurl)
###"Mozilla/5.0"

login <- postForm(myURL1, .params=myParams, curl=myCurl)

DATA <- getURLContent(myURL2, curl=myCurl)

writeLines(DATA, "ESTACAO_83309_.html")
#------------------------------------------------------------



#************************************************************
#************************************************************
                                        # GOAL 2
#************************************************************
#************************************************************

#------------------------------------------------------------
### Tiding Data

### Using shell script to separate DATA from text
#### grep "^83309" < ESTACAO_83309.html > ESTACAO_83303_DATA.csv
### Shell script, get all lines that starts with "83309" (station number)

SHELL_FUN = paste("grep", "^83309", "<", "ESTACAO_83309_.html",
                  ">", "ESTACAO_83309_DATA_.csv",
                  sep = ' ')
### 
system(SHELL_FUN)

DATA_83309_<- read.csv("ESTACAO_83309_DATA_.csv", sep = ";", dec = ".")

names(DATA_83309_)

colnames(DATA_83309_) <-  c("Estacao", "Data", "Hora", "Precipitacao",
                           "TempMaxima", "TempMinima", "Insolacao",
                           "Evaporacao_Piche", "Temp_Comp_Media",
                           "UR_Media", "Vel_Vent_Media")

names(DATA_83309_)
#------------------------------------------------------------


#------------------------------------------------------------
### Organizing DATA
### Data from INMET has two lines for each
### To put one line for each day, use oneline() function 
### Calling ONE_LINE function
### from https://github.com/rafatieppo/INMET_DATA_ORDER

### ATTENTION
### Original data from html has no usefull data, as follows
### Estacao;Data;Hora;Precipitacao;TempMaxima;TempMinima;Insolacao;Evaporacao
### Piche;Temp Comp Media;Umidade Relativa Media;Velocidade do Vento Media; 

### To use oneline() is mandatory a data.frame with a specific cols data
### order, as follow (names doen not matter, only sequence):

### Estacao; Data; Hora; Precipitacao; TempMaxima; TempMinima;
### Insolacao; Umidade Relativa Media; Velocidade do Vento Media; 

### To eliminate no usefull cols
DATA_83309_<- DATA_83309_[c(1:7,10:11)]
names(DATA_83309_)
head(DATA_83309_)
write.csv(DATA_83309_, "DATA_83309_GROSS_.csv")


### Ordering with oneline() function
DATA_83309_one_line_<- one_line(DATA_83309_)

head(DATA_83309_one_line_,30)
tail(DATA_83309_one_line_,30)

write.csv(DATA_83309_one_line_, "DATA_83309_one_line_.csv", row.names = FALSE)

#------------------------------------------------------------

###------------------------------------------------------------
### Analysis

DATA_DIAMANTINO <- read.csv("DATA_83309_one_line.csv", header = TRUE)
names(DATA_DIAMANTINO)
DATE_DIAMANT <- as.POSIXlt(DATA_DIAMANTINO$DATE,
                           format ="%d/%m/%Y")
#weekdays.POSIXt(DATE_DIAMANT)
##head(format(as.POSIXct(DATE_DIAMANT), "%U")) ##melhor para extrair semana
##strftime(DATE_DIAMANT,format="%W")

DATA_DIAMANTINO <- data.frame(STATION = DATA_DIAMANTINO$STATION,
                              DATE = DATE_DIAMANT,
                              YEAR = as.POSIXlt(DATE_DIAMANT)$year + 1900,
                              MONTH = as.POSIXlt(DATE_DIAMANT)$mon + 1,
                              DAY = as.POSIXlt(DATE_DIAMANT)$mday,
                              WEEK =  format(as.POSIXct(DATE_DIAMANT), "%U"),
                              TEMP_MIN = DATA_DIAMANTINO$TEMP_MIN,
                              TEMP_MAX = DATA_DIAMANTINO$TEMP_MAX,
                              UR =   DATA_DIAMANTINO$UR,
                              PRECI =DATA_DIAMANTINO$PRECI)
names(DATA_DIAMANTINO)
head(DATA_DIAMANTINO,8)
tail(DATA_DIAMANTINO)
