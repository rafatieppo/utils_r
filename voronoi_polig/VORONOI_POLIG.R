# FUNCAO PARA FAZER MATRIZ DE 1 POL do tile.list(VORONOI)
FUN_VOR_MAT <- function (A,TT) #TT é  o arquivo, N o número do POL
    {
        AA <- 1
        BB <- 2
        NROW <- length (A[[TT]]$x) + 1 #add primeiro ponto


        VORONOI_MATRIX <- matrix(0,NROW,2)
        VORONOI_MATRIX[1:NROW,AA] <- A[[TT]]$x[1:NROW]
        VORONOI_MATRIX[1:NROW,BB] <- A[[TT]]$y[1:NROW]
        VORONOI_MATRIX[NROW,AA]   <- A[[TT]]$x[1] #+ 1 add primeiro ponto
        VORONOI_MATRIX[NROW,BB]   <- A[[TT]]$y[1] #+ 1 add primeiro ponto

        if(TT == NROW){
        print("17/10/2014, rafaeltieppo@yahoo.com.br ")}
        return(VORONOI_MATRIX)

    }

