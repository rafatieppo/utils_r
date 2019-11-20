###======================================================================
###                                        Rafael Tieppo
###                                        rafaelt@unemat.br
###                                        https://rafatieppo.github.io/
###                                        25-06-2017
### Script to get data from ANA www.ana.gov.br/
###======================================================================

###------------------------------------------------------------
### Packages

library(httr)
library(XML)

###------------------------------------------------------------
### Getting date from ANA
### From https://pt.stackoverflow.com/questions/60124/gerar-e-baixar-links-programaticamente?newreg=d7d854b02f654d1c8b9d705b075d3e23

baseurl <-
    c("http://hidroweb.ana.gov.br/Estacao.asp?Codigo=", "&CriaArq=true&TipoArq=1")

estacoes <-
    c(2851050, 2751025)#, 2849035, 2750004, 2650032, 2850015, 123)

for (est in estacoes)
{
    r <- POST(url = paste0(baseurl[1],
                           est,
                           baseurl[2]),
              body = list(cboTipoReg = "10"),
              encode = "form")
    if (r$status_code == 200) {
        cont <- content(r,
                        as = "text",
                        encoding="ISO-8859-1")
        arquivo <- unlist(regmatches(cont,
                                     gregexpr("ARQ.+/CHUVAS.ZIP",
                                              cont)))
        arq.url <- paste0("http://hidroweb.ana.gov.br/",
                          arquivo)
        download.file(arq.url,
                      paste0(est,
                             ".zip"),
                      mode = "wb")
        cat("Arquivo",
            est,
            "salvo com sucesso.\n")
    }
    else {
        cat("Erro no arquivo", est, "\n")
    }
}

