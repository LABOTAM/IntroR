#' # AED de bivariadas {#aed-bivar}
#' 
#' ::: {.infobox .question data-latex="question"}
#' 
#' Existe alguma relação entre as variáveis?
#' A relação é linear?
#' Há colinearidade?
#' Ou seja, diferentes variáveis tem o mesmo padrão?
#' 
#' :::
#' 
#' ## Dados do tutorial
#' 
#' Vamos importar novamente os conjuntos de dados de [avistamento de aves do cerrado](https://github.com/LABOTAM/LABOTAM.github.io/blob/main/dados/aves_cerrado.csv) (utilizado no capítulo \@ref(aed-checa-dados)) e de [parcelas em caixetais](https://github.com/LABOTAM/LABOTAM.github.io/blob/main/dados/caixeta.csv) (utilizado no capítulo \@ref(sumar-dados)):
#' 
## ---- eval = FALSE---------------------
## ## Lendo a planilha com read.table
## avesc <- read.table("aves_cerrado.csv", row.names = 1, header = T, sep = ";", dec = ",", as.is = T, na.strings = c("NA", "", "NULL"))

#' 
## ---- include = FALSE------------------
load("dados/aves_cerrado.rda")

#' 
## ---- eval = FALSE---------------------
## caixeta <- read.csv("caixeta.csv") ## arquivo caixeta.csv deve estar no diretorio de trabalho
## # note que mantemos todos os argumentos padrão (veja o formato do arquivo caixeta)

#' 
## ---- include = FALSE, message=FALSE----
load("dados/caixeta.rda")

#' 
#' ## Fatores e contagens
#' 
#' Já vimos a função `table()` para contar valores em fatores e vetores em casos de [univariados](#aed-univar).
#' Podemos usar a mesma função para gerar tabelas de contingência entre dois ou mais fatores.  
#' 
#' 
## --------------------------------------
## Numero de fustes de cada especie por local
tb <- table(caixeta$especie, caixeta$local)
class(tb)
tb
# convertemos num data.frame
tb <- as.data.frame.matrix(tb)
class(tb)

# calculo o total de individuos por especie
total <- apply(tb, 1, sum)
total

# ordeno minha tabela orginal pelo total em ordem decrescente de abundância
tb <- tb[order(total, decreasing = T), ]
head(tb)

# se eu quiser uma tabela de presença e ausência
# bastaria substituir os valores>0 por 1
tb[tb > 0] <- 1
head(tb)

# assim, agora eu posso saber quantas especie por localidade
apply(tb, 2, sum)

#' 
#' A função `xtabs()` tabula dados de frequência.  
#' 
## ---- eval = FALSE---------------------
## ## xtabs: tabulacao de dados de frequencia
## ## Vamos usar  Dataframe dos sobreviventes dos sobreviventes e mortos do Titanic
## ?Titanic # veja o que são esses dados

#' 
#' 
## --------------------------------------
data("Titanic") # puxamos esse dado
class(Titanic)
tit <- as.data.frame(Titanic) # converte em data.frame
head(tit)

# classe de passageiros
names(tit)
str(tit)

## Quanto sobreviventes por sexo?

#' 
#' 
## ---- eval = FALSE---------------------
## ## Precisamos da funcao xtabs
## ?xtabs # veja o help dessa funcão:

#' 
#' 
## --------------------------------------
xtabs(Freq ~ Sex + Survived, data = tit)
# em porcentagem
tb <- xtabs(Freq ~ Sex + Survived, data = tit)
prop.table(tb, margin = 1)
# ou, se preferir
round(prop.table(tb, margin = 1) * 100)

# Quanto sobreviventes por classe de viagem?
xtabs(Freq ~ Class + Survived, data = tit)
# note que na primeira classe 203 sobreviveram
# eu poderia ter perguntado isso assim:
sum(tit[tit$Class == "1st" & tit$Survived == "Yes", "Freq"])
# ou seja, a funcao xtabs calculou a soma da frequencia
# porcentagem
prop.table(xtabs(Freq ~ Class + Survived, data = tit), margin = 1)

## E para combinacoes de mais de duas variaveis
tb2 <- xtabs(Freq ~ Class + Survived + Sex, data = tit)
tb2 # veja o resultado e observe duas virgulas
tb2[, , 1] # para Female
tb2[, , 2] # para Male
# note que não vimos isso antes, tb2, neste caso é um array, que um objeto que pode ter múltiplas dimensões, por isso as duas vírgulas, porque tem 3 dimensoes

#' 
#' ## Variável numérica vs. fator
#' 
#' A função `tapply()` faz uso de uma função sobre sobre um vetor numérico para cada categoria de um fator.
#' A função `aggregate()` faz o mesmo, mas permite múltiplos fatores e retorna um `data.frame`.  
#' 
## ---- eval = FALSE---------------------
## ## tapply: resumo de uma variavel numerica, separada por niveis de um ou mais fatores
## ?tapply # veja o help dessa função

#' 
#' 
## --------------------------------------
head(avesc) # se nao tem isso, importe novamente o arquivo aves_cerrado
# número de individuos de carcara por fisionomia
tapply(avesc$carcara, avesc$fisionomia, sum)
# numero de individuos de urubo por fisionomia
tapply(avesc$urubu, avesc$fisionomia, sum)
# numero médio de seriemas por localidade+fisionomia
tapply(avesc$seriema, avesc$fisionomia, mean)

## "Tabelas dinamicas": funcao aggregate
## Criar data.frame com altura media dos fustes por especie e por local

#' 
#' 
## ---- eval = FALSE---------------------
## ?aggregate # veja o help dessa função

#' 
#' 
## --------------------------------------
names(caixeta)
# circunferencia máxima por especie
ob1 <- aggregate(caixeta$cap, by = list(especie = caixeta$especie), FUN = max)
class(ob1) # obtenho um data frame
head(ob1)

# neste caso também poderia fazer assim
ob2 <- tapply(caixeta$h, caixeta$especie, max)
class(ob2) # mas neste caso nos temos um array (um vetor unidimensional)
ob2[1:10]

# mas se eu quiser por localidade e por especie, preciso usar aggregate
caixeta.alt <- aggregate(caixeta$h, by = list(local = caixeta$local, especie = caixeta$especie), FUN = max)
head(caixeta.alt)

## Vamos calcular a area basal (soma da area de todo os fustes)
## calculando a area basal de cada fuste, considerando o fuste um círculo perfeito, poderíamos usar:
caixeta$ab <- caixeta$cap^2 / 4 * pi
## e agora criamos a planilha, com aggregate, somando as areas basais dos fustes
caixeta.2 <- aggregate(caixeta$ab, by = list(local = caixeta$local, parcela = caixeta$parcela, especie = caixeta$especie), FUN = sum)
class(caixeta.2)
head(caixeta.2)

#' 
#' ## Variável numérica vs. numérica
#' 
#' 
#' ::: {.infobox .question data-latex="question"}
#' 
#' Qual a relação entre as variáveis? É linear? 
#' Que hipóteses ou interpretação biológica eu faço das relações entre as variáveis?
#' Qual a colinearidade dos meus dados?
#' 
#' :::
#' 
#' 
#' Para entender a razão e a importância dessas perguntas, veja a definição na [WikiPedia](https://en.wikipedia.org/wiki/Multicollinearity) sobre o efeito de colinearidade em regressões múltiplas.  
#' 
#' A função `pairs()` mostra as correlações das variáveis par a par de maneira gráfica, que podem ser estimadas por meio da função `cor()`.  
#' 
## --------------------------------------
## Exemplos de Graficos bivariados
## boxplot (já vimos o que isso significa)
# mostra a variacao do avistamento de urubus nas diferentes fisionomias
boxplot(cap ~ local, data = caixeta)
# ou poderia escrever assim
boxplot(caixeta$cap ~ caixeta$local)
# note o valor extremo em jureia
vl <- caixeta$local == "jureia" & caixeta$cap > 1500
caixeta[vl, ]

## espalhagrama
plot(h ~ cap, data = caixeta) # usando formula e especificacao dos dados
# apenas para jureia
plot(h ~ cap, data = caixeta, subset = local == "jureia")
plot(caixeta$h ~ caixeta$cap) # usando formula sem especificacao dos dados
plot(caixeta$cap, caixeta$h) # especificando eixos separadamente (veja inversao)
names(caixeta)
# mostra linha de tendencia da relacao
scatter.smooth(caixeta$cap, caixeta$h)

## pairs
## Matriz de espalhagramas das medidas das arvores no dataframe iris
data(iris)
names(iris)
pairs(iris) # todas as variaveis
pairs(iris[, -ncol(iris)], ) # menos a ultima coluna = especie
# colorindo por especie
pairs(iris[, -ncol(iris)], pch = 21, bg = c("red", "green", "blue")[unclass(iris$Species)])

#' 
#' 
## ---- eval = FALSE---------------------
## ?unclass # remove o atributo classe do objeto, então especies viram números

#' 
#' 
## --------------------------------------
# poderia fazer assim, tendo em vista que iris$Species é um fator:
pairs(iris[, -ncol(iris)], pch = 21, bg = c("red", "green", "blue")[as.numeric(iris$Species)])
## Essa figura é basicamente a expressao grafica da matriz de correlações entre todas as variáveis:
cor(iris[, -ncol(iris)])
# veja que essa matriz é simétrica e a diagonal tem valores =1, pois a correlação entre a variável e ela mesma é 100%
tbcor <- cor(iris[, -ncol(iris)])
# na diagnoal
diag(tbcor)
# acima da diagonal
vacima <- tbcor[upper.tri(tbcor)]
# abaixo da diagonal
vabaixo <- tbcor[lower.tri(tbcor)]
# entao, se é simétrica, os vetores contém os mesmos valores (a ordem não é a mesma por isso o sort)
sort(vacima) == sort(vabaixo)

#' 
#' ## Outros gráficos bivariados
#' 
#' As funções `xyplot()` e `bwplot()` são oriundas do pacote `lattice` [@R-lattice] e permitem visualizar rapidamente relações entre variáveis por subgrupos de forma simples e rápida.  
#' 
## ---- eval = FALSE---------------------
## # muitas funções do R interpretam formulas, que é uma forma simbólica curta para designar coisas complexas
## ?formula # leia com atenção a sessão de detalhes de como você pode especificar formulas, se ainda não fez isso, pois isso é uma forma de indicar ao R um modelo para graficar

#' 
#' 
## --------------------------------------
# no objeto iris
plot(Sepal.Length + Sepal.Width ~ Species, data = iris, ylim = c(0, 13))
plot(Sepal.Length ~ Species, data = iris, add = T, col = "red", xlab = "", ylab = "", xaxt = "n", yaxt = "n")
plot(Sepal.Width ~ Species, data = iris, add = T, col = "blue", xlab = "", ylab = "", xaxt = "n", yaxt = "n")
# ou seja a primeira figura é o mesmo que fazer:
tt <- iris$Sepal.Length + iris$Sepal.Width
plot(tt ~ iris$Species, add = T, col = "green")
# pois neste caso estamos plotando boxplots e a distribuicao dos valores da interacao entre comprimento e largura é basicamente a soma dos valores

#' 
#' 
## --------------------------------------
## Graficos condicionados com o pacotec lattice
library("lattice") # carregue o pacote

#' 
#' 
## ---- eval = FALSE---------------------
## # qual a relacao entre comprimento de sepalas e comprimento de petalas por especie?
## ?xyplot # veja o help dessa funcao

#' 
#' 
## --------------------------------------
xyplot(Sepal.Length ~ Petal.Length | Species, data = iris)

# ou mais complexo. Qual a relação entre as quatro variaveis em iris, por especie?
xyplot(Sepal.Length + Sepal.Width ~ Petal.Length + Petal.Width | Species, data = iris, scales = "sliced", auto.key = T)
# note que neste caso as correlacoes estao individualizadas por espécie e que as cores representam as relações das variáveis par par

#' 
#' 
## ---- eval = FALSE---------------------
## ?bwplot # para multiplos boxplots

#' 
#' 
## --------------------------------------
## um data.frame com as duas especies mais abundantes do caixetal
head(caixeta)
tb <- table(caixeta$especie)
maisabund <- names(tb[order(tb, decreasing = T)][1:2])
maisabund
# filtra os dados orginais para essas especies
caixeta2 <- caixeta[caixeta$especie %in% maisabund, ]

# distribuicao dos valores de altura por local para cada especie
bwplot(h ~ local | especie, data = caixeta2)
# distribuicao dos valores de cap por classes de altura, por especie
bwplot(h ~ cap | especie, data = caixeta2)

# relacao altura vs cap por especie e por local
xyplot(h ~ cap | especie + local, data = caixeta2, auto.key = T)

