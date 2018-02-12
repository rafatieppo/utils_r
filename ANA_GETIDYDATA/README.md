## ANA_GETIDYDATA

**R** Scripts to make the work easier.

## Goal

Get and Tidy data from ANA (Agência Nacional de Águas "Brazilian Water
Control Agency"). 

## Files in repository

+ ANA_GETDATA.R (script)
+ ANA_TIDYDATA.R (script)
+ README.md A short explanation

### Script ANA_GETDATA 

The original source of this script is available on:

[STACK OVERFLOW](https://pt.stackoverflow.com/questions/60124/gerar-e-baixar-links-programaticamente?newreg=d7d854b02f654d1c8b9d705b075d3e23)

Thanks to [Molx](https://pt.stackoverflow.com/users/22235/molx).

It provides download of preciptation historical data from ANA. All files
are saved as `zip`.  Once you know the number of desired station, just
replace the numbers in the vector, for example:

```{r }
estacoes <-
    c(2851050, 2751025, 2849035)
```

Results in your work dir:

```{r }
dir()
2851050.zip 
2751025.zip 
2849035.zip 
```

### Script ANA_TIDYDATA

This script get each `.zip` file, unzip, Tidy, and write a `.csv` file
for each station.

How to use:

1) Download `.zip` files from ANA and make sure that all are in the workdir.
2) Save the function ANA_TIDYDATA in you `R` environment.
3) Run `ANA_TIDYDATA()`.
4) Results :

```{r }
dir()
1456005_TIDY.csv
2751025_TIDY.csv
```

#### Before ad after `ANA_TIDYDATA()`

Data before `ANA_TIDYDATA()`.

| EstacaoCodigo | NivelConsistencia | Data       | TipoMedicaoChuvas | Maxima | Total | DiaMaxima | NumDiasDeChuva | Chuva02 | .... | Chuva03 | Chuva31Status | X  |
|---------------|-------------------|------------|-------------------|--------|-------|-----------|----------------|---------|------|---------|---------------|----|
|       2751025 |                 1 | 01/12/2002 |                 1 |    0.0 |   0.0 |         1 |              0 |      NA |      |      NA |             1 | NA |
|       2751025 |                 1 | 01/01/2003 |                 1 |   58.0 |  86.3 |        10 |              7 |     0.0 |      |    15.9 |             1 | NA |
|       2751025 |                 1 | 01/02/2003 |                 1 |   40.0 | 148.4 |         7 |             10 |     0.0 |      |     0.0 |             0 | NA |
|       2751025 |                 1 | 01/03/2003 |                 1 |   29.7 | 161.5 |        12 |             10 |    25.4 |      |     0.0 |             1 | NA |
|       2751025 |                 1 | 01/04/2003 |                 1 |   63.5 | 155.8 |        30 |              6 |     0.0 |      |    38.3 |             0 | NA |
|       2751025 |                 1 | 01/05/2003 |                 1 |   44.5 |  46.3 |        22 |              2 |     0.0 |      |     0.0 |             1 | NA |


Data after 'ANA_TIDYDATA'  (You will find it in `STATION NUMBER.csv` file).

| STATION|DATE       |DATE_CONT  | RAIN_MONTH|VARS    |VALUE | CONSIST_LEV| RAIN_STATUS|
|-------:|:----------|:----------|----------:|:-------|:-----|-----------:|-----------:|
| 2751025|2002-12-01 |2002-12-01 |          0|Chuva01 |NA    |           1|           0|
| 2751025|2002-12-01 |2002-12-02 |          0|Chuva02 |NA    |           1|           0|
| 2751025|2002-12-01 |2002-12-03 |          0|Chuva03 |NA    |           1|           0|
| 2751025|2002-12-01 |2002-12-04 |          0|Chuva04 |NA    |           1|           0|
| 2751025|2002-12-01 |2002-12-05 |          0|Chuva05 |NA    |           1|           0|
| 2751025|2002-12-01 |2002-12-06 |          0|Chuva06 |NA    |           1|           0|


## Questions or suggestions

Please, comment in the repository or send me an e-mail:

rafaeltieppo@yahoo.com.br

Best Regards!

