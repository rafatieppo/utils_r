#=================================================================
#                                             Rafael Tieppo
#                                             tiepporc@unemat.br
#                                             19-09-2015
# Cálculo Sistemas de Amortização SAC, PRICE
#=================================================================

library(ggplot2)
library(reshape2)
library(xtable)
library(gridExtra)
library(knitr)

a <- AMORT(383000, 0.92, 240)

AMORT <- function(PV, i, n)
 {
 #     PV <- 130000
 #     n <- 120          #months
 #     i <- 0.72         # interest month (%)
       
      #============================================================
      # SAC SYSTEM
      #============================================================
       
      # Building matrix
      MATRIX_SAC <- matrix(0, n + 1, 5)
      # Assign first row
      MATRIX_SAC [1,5] <- PV 
       
      # For the  periodo ZERO balance is equal PV
      BAL_SAC <- PV
       
      # AMORTization is constant
      AMORT_SAC <- (PV / n) 
       
      for (s in (2:(n+1)))
      {
          INT_SAC <- BAL_SAC * (i / 100)
          PAY_SAC <- AMORT_SAC + INT_SAC
          BAL_SAC <- BAL_SAC- AMORT_SAC
          MATRIX_SAC[s,1] <- s - 1
          MATRIX_SAC[s,2] <- INT_SAC
          MATRIX_SAC[s,3] <- AMORT_SAC
          MATRIX_SAC[s,4] <- PAY_SAC
          MATRIX_SAC[s,5] <- BAL_SAC
      }
       
      FRAME_SAC <- data.frame(PERIOD = MATRIX_SAC[,1],
                              INTEREST = MATRIX_SAC[,2],
                              AMORTIZATION = MATRIX_SAC[,3],
                              PAYMENT      = MATRIX_SAC[,4],
                              BALANCE      = MATRIX_SAC[,5])
       
      #============================================================
      # PRICE SYSTEM
      #============================================================
       
      # Building matrix
      MATRIX_PRIC <- matrix(0, n + 1, 5)
      # Assign first row
      MATRIX_PRIC [1,5] <- PV 
       
      # For the  periodo ZERO balance is equal PV
      BAL_PRIC <- PV
       
      # PAYMENT is constant
      PAY_PRIC <-  (PV * i/100) / (1 - (1 / (1 + i/100)^n ))
       
      for (s in (2:(n+1)))
      {
          INT_PRIC   <- BAL_PRIC * (i / 100)
          PAY_PRIC   <- PAY_PRIC
          AMORT_PRIC <- PAY_PRIC - INT_PRIC
          BAL_PRIC   <- BAL_PRIC- AMORT_PRIC
          MATRIX_PRIC[s,1] <- s - 1
          MATRIX_PRIC[s,2] <- INT_PRIC
          MATRIX_PRIC[s,3] <- AMORT_PRIC
          MATRIX_PRIC[s,4] <- PAY_PRIC
          MATRIX_PRIC[s,5] <- BAL_PRIC
      }
       
       
      FRAME_PRIC <- data.frame(PERIOD       = MATRIX_PRIC[,1],
                               INTEREST     = MATRIX_PRIC[,2],
                               AMORTIZATION = MATRIX_PRIC[,3],
                               PAYMENT      = MATRIX_PRIC[,4],
                               BALANCE      = MATRIX_PRIC[,5])

      FRAME_ALL <- rbind(FRAME_PRIC, FRAME_SAC)
##print(FRAME_ALL)


      ID <- data.frame(SIST = rep(c('PRICE', 'SAC'), each = n + 1))
      
      FRAME_ALL <- cbind(ID, FRAME_ALL)

##      print(head(FRAME_ALL))

      ##============================================================
      ## REPORTS
      ##============================================================
      TABLE <- data.frame(INDEX = c('Amount', 'Interest Rate',
                              'Period','Total Interest', 'Total Payment'),
                          PRICE = c(PV, i, n,  sum(FRAME_PRIC$INTEREST),
                              sum(FRAME_PRIC$PAYMENT)) ,
                          SAC   = c(PV, i, n,  sum(FRAME_SAC$INTEREST),
                              sum(FRAME_SAC$PAYMENT)))
      
      TABLE_MELT <- melt(TABLE)
      TABLE_MELT <- subset(TABLE_MELT, TABLE_MELT$INDEX == 'Total Interest' |
                          TABLE_MELT$INDEX == 'Total Payment' )
      ## print data in
      print(kable(TABLE))



     PAY_MAX_MIN <- rbind(
                   head(FRAME_SAC, 2),
                   tail(FRAME_SAC, 2)
                   )
     row.names(PAY_MAX_MIN) <- NULL
     print(kable(PAY_MAX_MIN[, c(1, 4, 5)],  format = 'markdown'))

     
      #============================================================
      # PLOTS
      #============================================================
      
      PLOT_TOTALS <- ggplot() +
          geom_bar(data = TABLE_MELT, aes(x = INDEX, y = value, fill =
                       variable), stat = 'identity') + facet_grid(.~variable) +
                          xlab(NULL) + ylab('Value') +
                scale_y_continuous(limits=c(0, sum(FRAME_PRIC$PAYMENT * 1.15))) +
                guides(fill = guide_legend(title = NULL)) +
          geom_text(data = TABLE_MELT, aes(x = INDEX,
                                           y = value * 1.043,
                                           label = round(value,2)), size = 3.8) +
          guides(fill = FALSE)

     TEXT_FRAME <- data.frame(X = max(FRAME_ALL$PERIOD),
                              Y = max(FRAME_ALL$PAYMENT))

      PLOT_PAY <- ggplot() +
          geom_point(data = FRAME_ALL,
                     aes(x = PERIOD, y = PAYMENT, colour = SIST),
                     size = 1.4) +
                     xlab('Period') + ylab('Value') +
                     scale_x_continuous(limits=c(1, n),
                                        breaks=seq(0,n,12)) +
                     scale_y_continuous(limits=c(0, max(FRAME_SAC$PAYMENT * 1.15)),
                                        breaks=seq(0, max(FRAME_SAC$PAYMENT * 1.15), floor(0.1*max(FRAME_SAC$PAYMENT))))+ 
                     theme(axis.text.x = element_text(angle = 90))+
                     theme(legend.position = 'top') +
                     guides(colour = guide_legend(title = NULL)) +
          geom_text(data = TEXT_FRAME,
                    aes(x=X*0.1, y=Y*0.15),
                    label=paste('n', '=', n, sep = " "), size = 3.6) + 
          geom_text(data = TEXT_FRAME,
                    aes(x=X*0.1, y=Y*0.25),
                    label=paste('i', '=', i, '%m', sep = " "), size = 3.6) +
          geom_text(data = TEXT_FRAME,
                    aes(x=X*0.1, y=Y*0.35),
                    label=paste('PV', '=', as.numeric(PV), sep = " "), size = 3.6) 


    
      PLOT_PRINT <- grid.arrange (PLOT_TOTALS, PLOT_PAY, ncol = 2)
      #xtable(TABLE)

     png('PLOT_SIMUL.png', width = 650, height = 330, units = 'px')
     grid.arrange (PLOT_TOTALS, PLOT_PAY, ncol = 2)
     dev.off()
     
      #============================================================
      # RETURN
      #============================================================

      return(FRAME_ALL)
      
 }















