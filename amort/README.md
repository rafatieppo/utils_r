# Motivação

Verificar se há diferença no saldo devedor após encerrar o prazo de
financiamento. 

# Função

A função `AMORT_TR` simula o financiamento de duas maneiras:

- Sem a correção da TR
- Com a correção da TR

## Arquivos do repositório

- AMORT.R - Arquivo `R` com a função de amortização (SAC e PRICE) sem considerar a **TR**. 
- AMORT_CEF_TR.Rmd - Arquivo `Rmarkdown` utilizado para executar a função, além disso, contém o script da função `AMORT_TR`.
- README.md - Orientações para uso da função
- TR.csv - Tabela com os valores de **TR**

## Como usar a função `AMORT`

A função `AMORT` está no arquvo `AMORT.R`. A referida função simula um
financiamento pelos sistemas **SAC** e **PRICE**, sem considerar a
**TR**.

Pacotes necessários:

```{r }
library(ggplot2)
library(reshape2)
library(xtable)
library(gridExtra)
library(knitr)
library(dplyr)
library(ggthemes)
```

Para a função `AMORT.R` insira os dados como o exemplo a seguir:

```{r }
a <- AMORT(383000, 0.92, 240)
```

A função entende que: 

```{r }
AMORT <- function(PV, i, n)
```

em que:  **PV** é valor do financiamento, **n** é o período em meses e
**i** é a taxa de juro (%).

Exemplo dos dados de saída:


|INDEX          |     PRICE|       SAC|
|:--------------|---------:|---------:|
|Amount         | 383000.00| 383000.00|
|Interest Rate  |      0.92|      0.92|
|Period         |    240.00|    240.00|
|Total Interest | 568291.11| 424593.80|
|Total Payment  | 951291.11| 807593.80|


| PERIOD|  PAYMENT|    BALANCE|
|------:|--------:|----------:|
|      0|    0.000| 383000.000|
|      1| 5119.433| 381404.167|
|    239| 1625.197|   1595.833|
|    240| 1610.515|      0.000|


## Como usar a função `AMORT_TR`

Para fazer um simulação considerando a **TR**, deve-se utilizar a função
`AMORT_TR`, que está no arquivo `AMORT_CEF_TR.Rmd`. Salienta-se que esta
função simula apenas o sistema **SAC**.

Pacotes necessários:

```{r }
library(ggplot2)
library(reshape2)
library(xtable)
library(gridExtra)
library(knitr)
library(dplyr)
library(ggthemes)
```

Para a função `AMORT_TR` deve-se disponibilizar uma matriz de duas
colunas, em que a primeira indica o mês a segunda os respectivos valores
da taxa de TR em **porcentagem**. Como sugestão, prepare um arquivo em uma planilha 
eletrônica e exporte no formato `.csv` com o seguinte nome `TR.csv`. Se
na planilha não constar todos os valores de **TR** dos períodos, será
será utilizado o valor de **TR** da última linha para os períodos sem
especificação da **TR**.

Exemplo de arquivo `TR.csv` (há um modelo no repositório)

|   |      |
|---|------|
| 1 | 0.85 |
| 2 | 0.87 |
| 3 | 0.65 |
| 4 | 0.37 |
| 5 | 0.58 |

 Dessa forma tem-se: 

```{r }
### Gerando uma matriz com os valores da TR

TR_1 <- as.matrix(read.csv("TR.csv", header = FALSE))

### Executando a função 
AMORT(265000, 0.92, 150, TR_1)
```

em que:  **PV** é valor do financiamento, **n** é o período em meses,
**i** é a taxa de juro (%) e **TR_1** é a matriz gerada.

**obs**. O arquivo `AMORT_CEF_TR.Rmd` já oferece um formato de relatório para
`Rmarkdown`. Dessa forma, caso use o `Rstudio` basta substituir os
valores conforme desejado e usar o pacote `knitr` e gerar seu `html` ou
`pdf`. Se preferir utilize o [PANDOC](http://pandoc.org/).

A função retorna um uma tabela com um resumo da operação e um `data
frame`, que contém o detalhamento dos valores das parcelas para o
período desejado, assim como, o saldo devedor para cada período (com e
sem TR), conforme a seguir:

|Item                   |Valor    |
|:----------------------|:--------|
|Valor do financiamento |10000    |
|Taxa de juro a.m.      |0.72 %   |
|Prazo                  |20 meses |
|Valor pago s/ TR       |10756.77 |
|Valor pago c/ TR       |10776.16 |
|Valor residual         |200.97   |

A função retorna um `data frame` com o valor do juro, valor da
parcela e o saldo devedor para cada período (com e sem TR), conforme a seguir


|  n|     I| AMORT|    PAY|    BAL|    TR| i_W_TR| PAY_W_TR| BAL_W_TR|
|--:|-----:|-----:|------:|------:|-----:|------:|--------:|--------:|
|  0|  0.00|     0|   0.00| 10,000|  0.00|   0.00|     0.00|     0.00|
|  1| 72.07|   500| 572.07|  9,500| 17.00|  72.20|   572.20| 9,517.00|
|  2| 68.47|   500| 568.47|  9,000| 18.08|  68.72|   568.72| 9,035.08|
|  3| 64.87|   500| 564.87|  8,500| 15.36|  65.23|   565.23| 8,550.44|
|  4| 61.26|   500| 561.26|  8,000| 13.68|  61.72|   561.72| 8,064.12|
|  5| 57.66|   500| 557.66|  7,500| 20.97|  58.27|   558.27| 7,585.09|
|  6| 54.05|   500| 554.05|  7,000| 12.89|  54.76|   554.76| 7,097.98|
|  7| 50.45|   500| 550.45|  6,500| 13.49|  51.25|   551.25| 6,611.47|
|  8| 46.85|   500| 546.85|  6,000| 12.56|  47.74|   547.74| 6,124.03|
|  9| 43.24|   500| 543.24|  5,500|  7.35|  44.19|   544.19| 5,631.38|
| 10| 39.64|   500| 539.64|  5,000| 12.95|  40.68|   540.68| 5,144.33|
| 11| 36.04|   500| 536.04|  4,500|  9.77|  37.15|   537.15| 4,654.11|
| 12| 32.43|   500| 532.43|  4,000|  7.91|  33.60|   533.60| 4,162.02|
| 13| 28.83|   500| 528.83|  3,500|  8.32|  30.06|   530.06| 3,670.34|
| 14| 25.23|   500| 525.23|  3,000|  7.34|  26.51|   526.51| 3,177.68|
| 15| 21.62|   500| 521.62|  2,500|  6.36|  22.95|   522.95| 2,684.04|
| 16| 18.02|   500| 518.02|  2,000|  5.37|  19.38|   519.38| 2,189.41|
| 17| 14.41|   500| 514.41|  1,500|  4.38|  15.81|   515.81| 1,693.79|
| 18| 10.81|   500| 510.81|  1,000|  3.39|  12.23|   512.23| 1,197.17|
| 19|  7.21|   500| 507.21|    500|  2.39|   8.65|   508.65|   699.57|
| 20|  3.60|   500| 503.60|      0|  1.40|   5.05|   505.05|   200.97|


## Dúvidas

Please send me an e-mail:
rafaeltieppo@yahoo.com.br

Best Regards!




