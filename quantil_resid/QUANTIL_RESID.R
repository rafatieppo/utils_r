library(ggplot2)

# q-q vs histograma vs ecdf

y <- rnorm(50)
par(mfrow=c(1,3))
qqnorm(y); qqline(y)
plot(density(y))
curve(dnorm(x, mean(y), sd(y)), add=TRUE, col=2)
plot(ecdf(y))
curve(pnorm(x, mean(y), sd(y)), add=TRUE, col=2)



# função para fazer o gráfico quantil-quantil da normal
 
qqn <- function(x, ref.line=TRUE){
  x <- na.omit(x)               # remove NA
  xo <- sort(x)                 # ordena a amostra
  n <- length(x)                # número de elementos
  i <- seq_along(x)             # índices posicionais
  pteo <- (i-0.5)/n             # probabilidades teóricas
  qteo <- qnorm(pteo)           # quantis teóricos sob a normal padrão
  plot(xo~qteo)                 # quantis observados ~ quantis teóricos
  if(ref.line){
    qrto <- quantile(x, c(1,3)/4) # 1º e 3º quartis observados
    qrtt <- qnorm(c(1,3)/4)       # 1º e 3º quartis teóricos
    points(qrtt, qrto, pch=3)     # quartis, passa uma reta de referência
    b <- diff(qrto)/diff(qrtt)    # coeficiente de inclinação da reta
    a <- b*(0-qrtt[1])+qrto[1]    # intercepto da reta
    abline(a=a, b=b)              # reta de referência
  }
}
 
x <- rnorm(20)
par(mfrow=c(1,2))
qqn(x)
qqnorm(x); qqline(x)
layout(1)


#-----------------------------------------------------------------------------
# envelope para o gráfico de quantis (simulated bands)


  X <- rnorm(200)
  X <- na.omit(X)               # remove NA
  X0 <- sort(X)                 # ordena a amostra
  N <- length(X)                # número de elementos
  I <- seq_along(X)             # índices posicionais
  PROB_TEOR <- (I-0.5)/N        # probabilidades teóricas
  QUAN_TEOR <- qnorm(PROB_TEOR, mean = 0, sd = 1)
  DATA <- data.frame(AMOSTRA = X0, QUAN_TEOR = QUAN_TEOR)

ggplot() +
  geom_point(data = DATA, aes(x= AMOSTRA, y = QUAN_TEOR))

  QUART_OBS  <- quantile(X, c(1,3)/4)       # 1º e 3º quartis observados
  QUART_TEOR <- qnorm( c(1/4, 3/4) , mean = 0, sd = 1)
DATA1 = data.frame(x= as.matrix(QUART_OBS), y = as.matrix(QUART_TEOR))


ggplot() +
  geom_point(data = DATA, aes(x= AMOSTRA, y = QUAN_TEOR))+
  geom_point(aes(x= QUART_OBS, y =  QUART_TEOR), colour = 'red')

b <- diff(QUART_TEOR)/diff(QUART_OBS)    # coeficiente de inclinação da reta
a <- b*(0-QUART_TEOR[1])+QUART_OBS[1]    # intercepto da reta


ggplot() +
  geom_point(data = DATA, aes(x= AMOSTRA, y = QUAN_TEOR))+
  geom_point(aes(x= QUART_OBS, y =  QUART_TEOR), colour = 'red')+
      geom_abline(aes(a,b))


RDIST <- sub("q", "r",       # função que gera números aleatórios
                  deparse(substitute(qnorm)))

AA <- replicate(500,         # amostra da distribuição de referência
                    sort(do.call(RDIST, c(list(n=n), mean = 0, sd = 1))))

LIM <- apply(AA, 1,           # limites das bandas 100*alpha%
                 quantile, probs=c((1-0.95)/2,(0.95+1)/2))

DATA3 <- data.frame(X = QUAN_TEOR, Y1 = LIM[1,], Y2 = LIM[2,])
head(DATA3)

ggplot() +
  geom_point(data = DATA, aes(x= AMOSTRA, y = QUAN_TEOR))+
  geom_point(aes(x= QUART_OBS, y =  QUART_TEOR), colour = 'red')+
      geom_abline(aes(a,b)) +
          geom_line(data = DATA3, aes(x = X, y = Y1), colour = 'green') +
          geom_line(data = DATA3, aes(x = X, y = Y2), colour = 'green') 



# função para fazer o gráfico quantil-quantil da normal
 
qqn <- function(x, ref.line=TRUE){
  x <- na.omit(x)               # remove NA
  xo <- sort(x)                 # ordena a amostra
  n <- length(x)                # número de elementos
  i <- seq_along(x)             # índices posicionais
  pteo <- (i-0.5)/n             # probabilidades teóricas
  qteo <- qnorm(pteo)           # quantis teóricos sob a normal padrão
  plot(xo~qteo)                 # quantis observados ~ quantis teóricos
  if(ref.line){
    qrto <- quantile(x, c(1,3)/4) # 1º e 3º quartis observados
    qrtt <- qnorm(c(1,3)/4)       # 1º e 3º quartis teóricos
    points(qrtt, qrto, pch=3)     # quartis, passa uma reta de referência
    b <- diff(qrto)/diff(qrtt)    # coeficiente de inclinação da reta
    a <- b*(0-qrtt[1])+qrto[1]    # intercepto da reta
    abline(a=a, b=b)              # reta de referência
  }
}
 
x <- rnorm(20)
par(mfrow=c(1,2))
qqn(x)
qqnorm(x); qqline(x)
layout(1)


# envelope para o gráfico de quantis (simulated bands)
 
qqqsb <- function(x, ref.line=TRUE, distr=qnorm, param=list(mean=0, sd=1),
                  sb=TRUE, nsim=500, alpha=0.95, ...){
  x <- na.omit(x)               # remove NA
  xo <- sort(x)                 # ordena a amostra
  n <- length(x)                # número de elementos
  i <- seq_along(x)             # índices posicionais
  pteo <- (i-0.5)/n             # probabilidades teóricas
  qteo <- do.call(distr,        # quantis teóricos sob a distribuição
                  c(list(p=pteo), param))
  plot(xo~qteo, ...)            # quantis observados ~ quantis teóricos
  if(ref.line){
    qrto <- quantile(x, c(1,3)/4) # 1º e 3º quartis observados
    qrtt <- do.call(distr,        # 1º e 3º quartis teóricos
                    c(list(p=c(1,3)/4), param))
    points(qrtt, qrto, pch=3)     # quartis, passa uma reta de referência
    b <- diff(qrto)/diff(qrtt)    # coeficiente de inclinação da reta
    a <- b*(0-qrtt[1])+qrto[1]    # intercepto da reta
    abline(a=a, b=b)              # reta de referência
  }
  if(sb){
    rdistr <- sub("q", "r",       # função que gera números aleatórios
                  deparse(substitute(distr)))
    aa <- replicate(nsim,         # amostra da distribuição de referência
                    sort(do.call(rdistr, c(list(n=n), param))))
    lim <- apply(aa, 1,           # limites das bandas 100*alpha%
                 quantile, probs=c((1-alpha)/2,(alpha+1)/2))
    matlines(qteo, t(lim),        # coloca as bandas do envelope simulado
             lty=2, col=1)
  }
}
 
x <- rnorm(20)
 
#png("f047.png", 400, 300)
qqqsb(x, xlab="Quantis teóricos da distribuição normal padrão",
      ylab="Quantis observados da amostra",
      main="Gráfico quantil-quantil da normal")
#dev.off()
 
x <- rpois(50, lambda=20)
qqqsb(x, distr=qpois, param=list(lambda=20))
