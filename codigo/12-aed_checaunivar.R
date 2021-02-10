#' # AED de univariadas {#aed-univar}
#' 
#' ## Qual a distribuição dos valores numéricos?
#' 
#' ::: {.infobox .question data-latex="question"}
#' 
#' Onde os dados estão centrados?
#' Como eles estão espalhados?
#' Eles são simétricos, i.e., a distribuição é normal? São enviesados, bi-modais?
#' Existem [valores extremos](https://en.wikipedia.org/wiki/Outlier|outlier)?
#' 
#' :::
#' 
#' Já vimos [algumas operações matemáticas com vetores](#vetores) e também [como usar as funções `hist()` e `boxplot()`](#graf-alto-nivel) para gerar figuras de distribuição de variáveis numéricas individualmente.
#' Vimos também como fazer iterações usando [funções da família `apply()`](#func-apply).
#' Também já aprendemos sobre a função `summary()`, que faz um resumo de todas as variáveis nos seus dados e aqui vamos entender isso melhor, apresentando a função `quantile()`, que permite extrair os [quantis](https://en.wikipedia.org/wiki/Quantile), que são valores que dividem uma distribuição probabilística em intervalos iguais de probabilidade.
#' Com essas ferramentas, podemos descrever a distribuição de nossas variáveis numéricas.  
#' 
#' ### Dados do tutorial
#' 
#' Vamos importar novamente os conjuntos de dados de [avistamento de aves do cerrado](https://github.com/LABOTAM/LABOTAM.github.io/blob/main/dados/aves_cerrado.csv) (utilizado no capítulo \@ref(aed-checa-dados)) e de [parcelas em caixetais](https://github.com/LABOTAM/LABOTAM.github.io/blob/main/dados/caixeta.csv) (utilizado no capítulo \@ref(sumar-dados)):
#' 
## ---- eval = FALSE------------------------------------------------------------
## ## Lendo a planilha com read.table
## avesc <- read.table("aves_cerrado.csv", row.names = 1, header = T, sep = ";", dec = ",", as.is = T, na.strings = c("NA", "", "NULL"))

#' 
## ---- include = FALSE---------------------------------------------------------
load("dados/aves_cerrado.rda")

#' 
## ---- eval = FALSE------------------------------------------------------------
## caixeta <- read.csv("caixeta.csv") ## arquivo caixeta.csv deve estar no diretorio de trabalho
## # note que mantemos todos os argumentos padrão (veja o formato do arquivo caixeta)

#' 
## ---- include = FALSE, message=FALSE------------------------------------------
load("dados/caixeta.rda")

#' 
## -----------------------------------------------------------------------------
## Resumo estatistico: medias, media truncada e mediana, quantis
# pegando apenas as variáveis numéricas
head(avesc[, 2:4])

# podemos fazer um resumo estatístico da distribuição de cada uma dessas colunas
summary(avesc[, 2:4])

# essa função me retorna várias estatísticas da distribuição de cada variável
# os valores mínimos e máximos
# a tendência central pela média e pela mediana
# e o 1 e o 3 quartil, que juntamente com o mínimo, o máximo e mediana,
# indicam as divisões dos dados em quatro partes identicas (vamos ver isso melhor abaixo)

# funcao summary, mas não retorna por, exemplo, o desvio padrão ou a variância das colunas.

#' 
#' 
## ---- eval = FALSE------------------------------------------------------------
## # e não podemos fazer isso apenas com a função sd para todas as colunas
## sd(avesc[, 2:4]) # ops deprecado (eu estou trabalhando com uma matriz)

#' 
#' 
## -----------------------------------------------------------------------------
# mas posso usar a funcao apply (para cada coluna, argumento MARGIN)
apply(avesc[, 2:4], 2, sd, na.rm = TRUE)

# summary já retorna isso, mas eu poderia usar para qualquer funcao
apply(avesc[, 2:4], 2, median, na.rm = TRUE)
apply(avesc[, 2:4], 2, mean, na.rm = TRUE)
apply(avesc[, 2:4], 2, min, na.rm = TRUE)
apply(avesc[, 2:4], 2, max, na.rm = TRUE)
apply(avesc[, 2:4], 2, quantile, na.rm = TRUE)

#' 
#' 
## -----------------------------------------------------------------------------
# note que os valores dos quartis:
quantile(avesc$urubu, na.rm = TRUE)
# aparecem também quando usamos summary, que no entanto, retorna a média artimética,
# que é o único valor que não é um quartil.
summary(avesc$urubu)

# para entender melhor isso vamos graficar:
# primeiro num histograma
hist(avesc$urubu, main = "Avistamentos de Urubu", xlab = "Número de aves observadas por local")
# melhorando um pouco
hist(avesc$urubu, main = "Avistamentos de Urubu", xlab = "Número de aves observadas por local", breaks = 22, col = "gray")
# agora adicionamos em azul os quartis
abline(v = quantile(avesc$urubu, na.rm = TRUE), col = "blue", lwd = 5)
# note que as barras azuis estão igualmente espaçadas no eixo X, pois elas dividem a distribuição em partes iguais
# vamos plotar a média
abline(v = mean(avesc$urubu, na.rm = TRUE), col = "red", lty = "dotted", lwd = 6)
# e a mediana
abline(v = median(avesc$urubu, na.rm = TRUE), col = "green", lty = "dotted", lwd = 6)
# note como a mediana é equivalente ao quartil que indica 50% na divisão simétrica dos dados e que neste caso a diferença entre média e mediana é muito pequena, pois os dados são bem simétricos em relação à tendência central
# vamos adicionar o desvio padrão:
v1 <- sd(avesc$urubu, na.rm = TRUE) + mean(avesc$urubu, na.rm = TRUE)
v2 <- mean(avesc$urubu, na.rm = TRUE) - sd(avesc$urubu, na.rm = TRUE)
abline(v = c(v1, v2), col = "yellow", lty = "solid", lwd = 4)

# agora com um box plot:
boxplot(avesc$urubu)
abline(h = quantile(avesc$urubu, na.rm = TRUE), col = "blue", lwd = 2)

#' 
#' 
## ---- eval = FALSE------------------------------------------------------------
## # Média truncada = e.g. TIRANDO 10% DOS VALORES NOS EXTREMOS (posso ver como muda, caso tenha valores extremos, vai mudar muito)
## ?mean # veja o argumento trim

#' 
#' 
## -----------------------------------------------------------------------------
apply(avesc[, 2:4], 2, mean, trim = 0.1, na.rm = TRUE) # truncando
apply(avesc[, 2:4], 2, mean, trim = 0, na.rm = TRUE) # sem truncar

# valores de quantils em outras probabilidades
quantile(avesc$urubu, probs = seq(from = 0, to = 1, by = 0.1), na.rm = TRUE) # a cada 10%

#' 
#' 
#' 
#' 
## -----------------------------------------------------------------------------
dim(caixeta) # dimensões
names(caixeta) # colunas
head(caixeta) # cabeça
str(caixeta)
# vamos calcular o DAP a partid o CAP (circunferencia a altura do peito)

# se cap = 2*pi*dap/2   portanto  dap = cap/pi
dap <- caixeta$cap / pi
hist(dap) # veja  distribuição diametrica desses dados (é uma típica log-normal)
# adicionando a nova coluna aos dados
caixeta$dap <- dap
head(caixeta, 2)

# resume localidade
levels(caixeta$local)
# altura das arvore em cada localidade
chauas.h <- caixeta[caixeta$local == "chauas", "h"]
jureia.h <- caixeta[caixeta$local == "jureia", "h"]
retiro.h <- caixeta[caixeta$local == "retiro", "h"]
# para a localidade chauas
hist(chauas.h, breaks = 20)
# ops tem um valor extremo, que era um erro
chauas.h[chauas.h > 300]
# deveria ser 48
hist(caixeta$h) # um valor extremo de todo o conjunto de dados
chauas.h[chauas.h > 300] <- 48 # corrigimos esse valor
hist(chauas.h)
hist(jureia.h)
hist(retiro.h)
range(chauas.h) # aplitude de variacao
range(jureia.h)
range(retiro.h)
xl <- c(0, 250) # limitando o grafico aos extremos de todo o conjunto de dados
yl <- c(0, 150)
hist(chauas.h, breaks = 30, xlim = xl, ylim = yl)
hist(jureia.h, add = TRUE, breaks = 30, col = "blue")
hist(retiro.h, add = TRUE, breaks = 30, col = "green")

# mas seria melhor ver cada distribuicao individualmente por localidade
# dividimos o dispositivo em 3 linhas e uma coluna
par(mfrow = c(3, 1))
hist(chauas.h, breaks = 20, xlim = xl, ylim = yl, col = "green")
hist(jureia.h, breaks = 20, xlim = xl, ylim = yl, col = "blue")
hist(retiro.h, breaks = 20, xlim = xl, ylim = yl, col = "red")
par(mfrow = c(1, 1)) # retorna o dispositivo

#' 
#' ## Tabelas de variáveis categóricas
#' 
#' A função `table()` permite contar valores em fatores e vetores e você pode [relembrar como usar a função `barplot()`](#graf-alto-nivel) para gerar gráficos de barra simples:
#' 
## -----------------------------------------------------------------------------
# continuando com os dados de caixeta.csv
head(caixeta)
# tem a coluna especie

# podemos resumir quantos individuos tem de cada espécie (considerando que cada linha é um individuo)
table(caixeta$especie)
sort(table(caixeta$especie), decreasing = T)[1:3] # quais são as tres especies mais abundantes
table(caixeta$local) # quantas localidades?

## Graficos de barra para representar uma tabela
op <- par(no.readonly = TRUE) # pega parametros gráficos atual
par(mar = c(10, 3, 0, 0)) # mudando as margens
vv <- sort(table(caixeta$especie), decreasing = T)
vv[1:5] # cinco especies mais abundantes
# gráfico de barras disso
barplot(vv, cex.names = 0.5)
par(las = 2, mar = c(10, 5, 5, 1)) # mudando margens e orientacao dos eixos
barplot(sort(table(caixeta$especie), decreasing = T), cex.names = 0.8)
# muita coisa, pegando apenas as especies mais abundantes
barplot(sort(table(caixeta$especie), decreasing = T)[1:10], cex.names = 0.8)
# note como Tabebuia cassonoides é muito mais abundante que qualquer outra espécie nessas comunidades

par(op) # volta aos parametros
# numero de individuos por localidade
barplot(table(caixeta$local), ylab = "Número de indivíduos")

#' 
#' ### Resumo de gráficos univariados
#' 
#' Além das funções gráficas apresentadas acima, vamos ver aqui as funções `dotchart()` e `stripchart()`, úteis para visualizar dados brutos.
#' 
## -----------------------------------------------------------------------------
# para visualizar dados brutos
head(caixeta)

# plotar a coluna altura (h)
plot(caixeta$h, xlab = "Observações", ylab = "Altura (m)")
# note que o único valor extremos fica super evidente

# poderíamos usar a função dotchart para isso
dotchart(caixeta$h, ylab = "Observações", xlab = "Altura (m)")

# inversão dos eixos..
# vamos corrigir o valor extremo
caixeta[which(caixeta$h > 300), "h"] <- 48

# faz um boxplot disso
boxplot(caixeta$h) # já vimos isso, mas note os pontos isolados dos boxes (caixas), esses são valores isolados, meio fora da distribuicao
summary(caixeta$h) # ve os quartis e média
# plota a mediana
abline(h = median(caixeta$h), col = "red", lwd = 3)
# plota todos os quartis
abline(h = quantile(caixeta$h), col = "blue", lwd = 2)

# ve em forma de histograma
hist(caixeta$h, breaks = 20)
# plota os quartis
abline(v = quantile(caixeta$h), col = "blue", lwd = 2)

dim(caixeta)

#' 
#' 
## ---- eval = FALSE------------------------------------------------------------
## # ve o histograma na forma de pontos:
## ?stripchart

#' 
#' 
## -----------------------------------------------------------------------------
stripchart(caixeta$h, method = "stack", jitter = 0, offset = 1, ylim = c(0, nrow(caixeta)), xlab = "altura (cm)")

## Numa tela só boxplot, histograma, densidade e stripchart
olp <- par(no.readonly = TRUE)
par(mfrow = c(2, 2), mar = c(3, 3, 3, 0))
boxplot(caixeta$h)
hist(caixeta$h)
plot(stats::density(caixeta$h))
stripchart(caixeta$h, method = "stack")
par(olp) # resgata parametros graficos originais

## Histograma com diferentes larguras de barras
par(mar = c(5, 4, 3, 1), mfrow = c(3, 2))
hist(caixeta$h, main = "Default")
hist(caixeta$h, breaks = 5, main = "Cinco break-points")
hist(caixeta$h, breaks = 10, main = "Dez break-points")
hist(caixeta$h, breaks = 15, main = "Quinze break-points")
hist(caixeta$h, breaks = 20, main = "Vinte break-points", col = "lightblue")
par(olp)

#' 
#' ## As variáveis têm distribuição normal?
#' 
#' A função `density()` que juntamente com `hist()`, que você já conhece, permite visualizar a densidade probabilística de uma variável numérica, ou seja descreve a [distribuição de probabilidade](https://pt.wikipedia.org/wiki/Distribui%C3%A7%C3%A3o_de_probabilidade), isto é, a chance de uma variável assumir um valor ao longo de um espaço (densidade) de valores.  
#' 
#' A função `dnorm()` permite obter a densidade probabilistica de uma distribuição normal teórica, para a mesma média e mesmo desvio padrão dos teus dados.
#' Com isso você pode visualizar a distribuição dos seus dados e sobrepor a isso como seria a distribuição se os seus dados fossem normais.
#' 
## -----------------------------------------------------------------------------
par(olp)

#' 
#' 
## ---- eval = FALSE------------------------------------------------------------
## ?density # veja o help disso

#' 
#' 
## -----------------------------------------------------------------------------
# plota a densidade probabilistica = a curva da probabilidade da variável assumir certos valores de altura
plot(stats::density(caixeta$h))
## Histograma com área = 1 e density probabilistica sobreposta (argumento prob=TRUE, muda o eixo y)
hist(caixeta$h, prob = T, breaks = 30, xlim = c(-1, max(caixeta$h) + 5))
# adiciona a linha da densidade
lines(stats::density(caixeta$h), col = "red", lwd = 2)
# adiciona a média
abline(v = mean(caixeta$h), col = "green", lwd = 2, lty = "solid")
# note que na média a densidade probabilística é maior que nas caudas da distribuição

# vamos adicionar sobre nossa distribuicao REAL a densidade probabilistica para uma distribuição normal com media e desvio igual ao dado

#' 
#' 
## ---- eval = FALSE------------------------------------------------------------
## ## Adicionando uma curva da normal aos graficos
## ?dnorm # veja o help dessa função e suas variantes. veremos isso melhor abaixo

#' 
#' 
## -----------------------------------------------------------------------------
# pega a densidade probabilística de uma distribuição normal teórica, para quantis de seu interesse, segundo uma média e um desvio padrão
dnorm(seq(0, 1, by = 0.25), mean = mean(caixeta$h), sd = sd(caixeta$h)) # esses são os valores que a distribuição probabilistica assume, numa distribuição normal que tem o mesma média e a mesmo desvio padrão que os seus dados

#' 
#' 
## ---- eval = FALSE------------------------------------------------------------
## ?curve # veja que curve depende de uma função, ela traça a curva de uma f(x), num intervalo especificado de x (que foi plotado por hist)

#' 
#' 
## -----------------------------------------------------------------------------
hist(caixeta$h, prob = T, breaks = 30, xlim = c(-1, max(caixeta$h) + 5))
# adiciona a linha da densidade
lines(stats::density(caixeta$h), col = "red", lwd = 2)
# adiciona a média
abline(v = mean(caixeta$h), col = "green", lwd = 2, lty = "solid")
# combinamos as coisas e adicionamos a distribuição
# teórica sobre os nosso dados
## Usamos a funcao curve,
curve(expr = dnorm(x, mean = mean(caixeta$h), sd = sd(caixeta$h)), add = T, col = "blue", lwd = 2)

# note que os dados neste caso seguem bem uma curva normal.
# Portanto, mesmo sem fazer um teste, essa figura sugere que os dados de altura do caixetal é normal

#' 
#' As funções `qqnorm()` e `qqline()` permitem visualizar rapidamente se uma variável qualquer segue uma distribuição normal, ao compara os valores dos quantis empíricos (observados), com valores dos quantis teóricos (i.e. esperados por uma distribuição normal).
#' A função `rnorm()` gera um conjunto de dados aleatórios que tem distribuição normal.
#' 
## ---- eval = FALSE------------------------------------------------------------
## # Teste de normalidade
## ######################################
## ## Exemplo para o qqplot
## ##########################################
## 
## # vamos simular valores
## ?rnorm # funcao que gera valores aleatórios que seguem uma distribuicao normal

#' 
#' 
## -----------------------------------------------------------------------------
## Sorteio de 100 valores de uma normal com media=30 e desvio-padrao=3
zz <- rnorm(100, 30, 3)
mean(zz)
sd(zz)
length(zz)
hist(zz, prob = T)

## Valores  arredondados para 2 casa, e ordenados
x <- sort(round(rnorm(100, 30, 3), 2))
## Inspecionando os 5 primeiros e ultimos valores
x[1:5]
x[95:100]

## Calculo do percentil de cada valor
# relembre a funcao order (ela retorna os indices dos valores ordenados)
order(x) # veja que os indices estao sequenciais, porque geramos um vetor já pre-ordenado

# calculamos o percentil de cada valor, que é uma medida que indica o valor abaixo do qual uma certa porcentagem de observações existe. Por exemplo, o vigézimo percentil tem um valor, abaixo do qual 20% das observações são encontradas
px <- order(x) / 100
px
# vejamos a correspondencia
# quantos valores são menores que o percentil 0.2 (ou 20%)?
sum(px < 0.2) # obviamente 19 se temos apenas 100 valores no nosso vetor
# quais valores são esses
x[order(x)][px <= 0.2]
# qual o valor do percentil
x[order(x)][px == 0.2]
hist(x, breaks = 20, col = "gray")
abline(v = x[order(x)][px == 0.2], col = "red")
# as barras com valores menores ou iguais que o do percentil (linha vermelha), totalizam 20% das observações.

# com os percentis dos valores do dado original, podemos pegar a densidade probabilistica esperada se a distribuicao fosse normal
q.norm.x <- qnorm(px, mean = mean(x), sd = sd(x))

## Juntando valores originais, os percentis e os valores esperados em um dataframe, para facilitar a visualizacao
qq.plot.x <- data.frame(x = x, percentil = px, q.norm = q.norm.x)
qq.plot.x[1:5, ]
qq.plot.x[95:100, ]
head(qq.plot.x)

## com isso eu posso comparar meus valores observados com os valores esperados se a distribuição fosse normal
plot(x ~ q.norm, data = qq.plot.x, xlab = "Quantis Esperados", ylab = "Valores Observados")
abline(0, 1, col = "red") # relacao esperada, caso os dados venham de uma populacao normal
# note que a correlação é fortíssima, porque os usados no exemplo eram de fato normais, portanto, nenhuma surpresa nisso

#' 
#' 
## ---- eval = FALSE------------------------------------------------------------
## ## A funcao qqnorm ja faz isto de uma vez para voce:
## ?qqnorm # veja o help

#' 
## -----------------------------------------------------------------------------
qqnorm(x)
qqline(x, col = "red")

# suponha um dado não normal
# cria um exemplo lognormal (nao é uma distribuicao normal)
xlogn <- rlnorm(nrow(avesc), meanlog = 30, sdlog = 1)
hist(xlogn, prob = T, breaks = 20)
lines(stats::density(xlogn), col = "red", lwd = 2)
# nao é uma cuva normal, certo?

# mostra o QQ Plot nessa situação (veja como os pontos saem da linha)
qqnorm(xlogn)
qqline(xlogn, col = "red")


# entao vamos ver em dados reais
# altura, já vimos antes, tem distribuição bem normal
qqnorm(caixeta$h)
qqline(caixeta$h, col = "red")

# cap por outro lado, é mais log normal
qqnorm(caixeta$cap)
qqline(caixeta$cap, col = "red")

#' 
#' ## Para saber mais: {#sabermais-aed-univariadas}
#' 
#' * [Exercicio AED Univariadas](http://www.botanicaamazonica.wiki.br/labotam/doku.php?id=disciplinas:bot89_2013:exercicio07).
