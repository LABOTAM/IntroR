#' # AED de multivariadas {#aed-multivar}
#' 
#' Neste tutorial, vamos utilizar os pacotes abaixo.
#' Caso você não possua algum dos pacotes listados, lembre-se de instalar cada um utilizando o comando abaixo:
#' 
## ---- eval = FALSE--------------------------------------------
## # Para instalar pacotes no R, use a funcao `install.packages()`
## install.packages("ape")
## install.packages("labdsv")

#' 
#' Carregue-os todos e siga em frente.
#' 
## -------------------------------------------------------------
library("labdsv")
library("ape")
library("vegan")

#' 
#' ## Matrizes de distância
#' 
#' Matrizes de distância ou dissimilaridade são muito usadas em AEDs multivariadas.
#' Por exemplo, para estimar a similaridade entre diferentes comunidades vegetais segundo a presença ou ausência de espécies (ou um índice de similaridade que leva em conta as abundâncias relativas); para estimar a similaridade entre espécies ou a relação entre similaridade genética ou morfológica e distância geográfica etc.  
#' 
#' A função `dist()` é a mais básica do R para calcular dissimilaridades entre objetos.
#' Ela calcula dissimilaridades segundo diferentes métodos (argumento `method`).
#' Há também a função `vegdist()` do pacote `vegan` [@R-vegan] que faz a mesma coisa, mas tem índices de dissimilaridade que `dist()` não implementa, muito dos quais muito usados em ecologia de comunidades.  
#' 
#' Busque ler o `?` dessas duas funções (execute `?dist` e `?vegdist` no console), atentando para os diferentes índices de dissimilaridade.
#' Na função `vegdist()`, você encontra os principais **índices de dissimilaridade** usados em ecologia.  
#' 
#' Para entender o que essas funções fazem, vamos ver um exemplo simples de cálculo de distância euclidiana, que é o método padrão de `dist()`.  
#' 
## -------------------------------------------------------------
# usando o método euclidiano
# plota um gráfico vazio com coordenadas x e y de 1 a 10
plot(1:10, 1:10, type = "n")

# adiciona dois pontos:
# um na coordenada 4,4
points(4, 4, pch = 21, bg = "red")
# outro na coordenada x=8, y=8
points(8, 8, pch = 21, bg = "blue")
# a distancia euclidiana entre eles é dada por essa linha
segments(4, 4, 8, 8)
# essa linha é a hipotenusa do triângulo
polygon(x = c(4, 8, 8, 4), y = c(4, 8, 4, 4), density = 40)

# portanto a distancia entre os pontos, por Pitágoras, é
# sqrt(hipotenusa) = sum(catetoA^2+catetoB^2)
d <- sqrt((8 - 4)^2 + (8 - 4)^2)

# agora usando a função dist
# coloco as coordenadas dos dois pontos acima num data.frame
pontos <- data.frame(X = c(4, 8), Y = c(4, 8))
pontos

# calcula a distancia euclidiana para essas variáveis (X e Y)
dist(pontos, method = "eucl")

# entao isso é verdadeiro
d == dist(pontos, method = "eucl")

#' 
#' ## Ordenação com matrizes de distância
#' 
#' Reduzir espaços multivariados em poucas dimensões a partir de matrizes de distância é útil quando nossas variáveis não têm distribuição normal, que é uma das premissas da *Análise de Componentes Principais* (PCA) e outros métodos de ordenação paramétricos.  
#' 
#' Se você parte de uma matriz de distância, pode fazer ordenações multivariadas com dados não normais ou mesmo dados categóricos e semi-quantitativos, desde que com eles você possa calcular uma matriz de distância.  
#' 
#' ## Escalonamento Não-Métrico Multimensional (NMDS)
#' 
#' 
#' A [NMDS](https://en.wikipedia.org/wiki/Multidimensional_scaling) é uma técnica de ordenação multivariada que permite visualizar graficamente distâncias entre objetos.
#' No R há várias funções que executam isso: `isoMDS()`; `cmdscale()`; e `nmds()` e `bestnmds()` do pacote `labdsv` [@R-labdsv].
#' Vamos usar a função `bestnmds()` nos exemplos abaixo.
#' Para entender, veja um exemplo para distâncias geográficas entre cidades na região norte do Brasil. Se queremos representar graficamente distâncias geográficas, estaremos de certa forma reproduzindo um mapa:
#' 
#' Vamos utilizar o conjunto de [dados contendo coordenadas geográficas de municípios do Brasil](https://github.com/LABOTAM/IntroR/blob/main/dados/municipiosbrasil.csv) para esta prática, utilizado na seção \@ref(import-dados).  
#' 
## ---- eval = FALSE--------------------------------------------
## # visualizando distancias usando NMDS
## # Vamos usar o arquivo com coordenadas dos municipios brasileiros
## muni <- read.table(file = "municipiosbrasil.csv", header = T, as.is = T, sep = "\t", na.strings = c("NA", "", "NULL"))

#' 
## ---- include = FALSE-----------------------------------------
load("dados/municipiosbrasil.rda")

#' 
#' Para simplificar, vamos filtrar apenas algumas cidades da região Norte:
#' 
## -------------------------------------------------------------
cids <- c("Rio Branco", "Cruzeiro do Sul", "Tabatinga", "São Gabriel da Cachoeira", "Manaus", "Santarém", "Porto Velho", "Humaitá", "Belém", "Macapá", "Marabá", "Boa Vista")

# filtrando os dados
vl <- muni$Municipio %in% cids
muni <- muni[vl, ]

# calcula a distancia geografica entre essas cidades (em graus de latitude).
# Idealmente deveríamos converter latitude e longitude em décimos de graus para UTM para obter distancias em km ou m.
mdist <- dist(muni[, c("Longitude", "Latitude")], method = "euclidean")

#' 
#' 
## ---- eval = FALSE--------------------------------------------
## # calculando um nmds em dois eixos (reduzindo a variação na matriz em dois eixos)
## ?bestnmds

#' 
#' Vamos utilizar a função `bestnmds` do pacote `labdsv`
#' Vamos agora instalar o pacote e carregar o pacote `labdsv`:
#' 
## -------------------------------------------------------------
onmds <- bestnmds(mdist, k = 2)
# veja a estrutura do resultado
str(onmds)
# o valor do stress indica o ajuste. Se o stress for 0, o ajuste é perfeito:
# a posição dos pontos é proporcional a distância entre eles
onmds$stress

# quanto da variação foi explicada?
# essa pergunta a gente faz com PCA, não faz sentido fazer com NMDS.
# Mas, se você quer ter uma ideia de quanto um eixo capturou da variação,
# pode correlacionar a matriz de distancia original com uma matriz de distancia
# gerada pelos valores dos eixos nmds

# pega os valores dos eixos NMDS
ptsnmds <- onmds$points
# calcula a distancia
adist <- dist(ptsnmds)
# qual a correlacao entre essas matrizes de distancia?
cor(mdist, adist)
# por isso o stress é baixo

# vamos comparar graficamente:
# divide o dispositivo em duas partes
par(mfrow = c(2, 1), mar = c(5, 5, 1, 1))
# adiciona limite no eixo X e y
xl <- range(ptsnmds[, 1]) + c(-1, 10)
yl <- range(ptsnmds[, 2]) + c(-2, 2)
# plota pontos
plot(ptsnmds, type = "p", pch = 21, bg = "red", xlab = "NMDS 1", ylab = "NMDS 2", xlim = xl, ylim = yl, cex = 0.5)
# adiciona o nome das cidades
text(ptsnmds, labels = muni$Municipio, cex = 0.8, pos = 4)

xl <- range(muni$Longitude) + c(-2, 5)
yl <- range(muni$Latitude) + c(-2, 2)
plot(muni$Longitude, muni$Latitude, type = "p", xlab = "Longitude", ylab = "Latitude", xlim = xl, ylim = yl, pch = 21, cex = 0.5, col = "blue")
text(muni$Longitude, muni$Latitude, labels = muni$Municipio, cex = 0.8, pos = 4)

#' 
#' ### Exemplo com dados morfológicos
#' 
#' Um exemplo de NMDS para mostra a similaridade entre indivíduos de *Iris* a partir de uma matriz de distância morfológica usando os dados de `iris` do R.  
#' 
## -------------------------------------------------------------
data(iris) # #carrega o conjunto de dados de iris para a area de trabalho
head(iris)

#' 
#' 
## ---- eval = FALSE--------------------------------------------
## # calcula a distancia morfológica
## ?dist

#' 
#' 
## -------------------------------------------------------------
dmorfo <- dist(iris[, 1:4], method = "eucl")

#' 
#' 
## ---- eval = FALSE--------------------------------------------
## # calculando um nmds em dois eixos
## onmds <- bestnmds(dmorfo, k = 2)

#' 
## -------------------------------------------------------------
# ops objetos 102 e 143 devem ser identificos
iris[c(102, 143), ]

#' 
#' 
## -------------------------------------------------------------
# entao eliminamos 1, porque senao nao funciona
iris2 <- iris[-102, ]

#' 
#' 
## ---- eval = FALSE--------------------------------------------
## # calculamos novamente a distancia
## dmorfo <- dist(iris2[, 1:4], method = "eucl")
## # calculando um nmds em dois eixos
## onmds <- bestnmds(dmorfo, k = 2)

#' 
## ---- include = FALSE-----------------------------------------
load(file = "dados/onmds1.rda")

#' 
#' 
## -------------------------------------------------------------
# veja a estrutura do resultado
str(onmds)
# o valor do stress indica o ajuste. Se stress for 0, o ajuste é perfeito
onmds$stress

# quanto da variação foi explicada?
# essa pergunta a gente faz com PCA, não faz sentido fazer com NMDS.
# Mas, se você quer ter uma ideia de quanto um eixo capturou da variação,
# pode correlacionar a matriz de distancia original
# com uma matriz de distancia gerada pelos valores dos eixos nmds

# pega os valores dos eixos NMDS
ptsnmds <- onmds$points
# cada linha nessa tabela corresponde
# à mesma linha na tabela iris2
head(ptsnmds)
# essas colunas são os dois eixos NMDS

# isso deve ser verdadeiro
nrow(ptsnmds) == nrow(iris2)

# calcula a distancia entre os pontos pelos eixos NMDS
adist <- dist(ptsnmds)
# qual a correlacao entre essa matriz e a original?
cor(dmorfo, adist)
# por isso o stress é baixo, a correlação é alta

#' 
#' 
#' Agora vamos fazer com outro índice de distância chamado *gower*, por exemplo, que é um bom índice quando se tem dados semiquantitativos na matriz (não é o caso aqui).
#' Vamos utilizar a função `vegdist()` do pacote `vegan` [@R-vegan].
#' 
#' 
## -------------------------------------------------------------
data(iris)
iris2 <- iris[-102, ]

#' 
#' 
## ---- eval = FALSE--------------------------------------------
## dmorfo2 <- vegdist(iris2[, 1:4], method = "gower")
## onmds2 <- bestnmds(dmorfo2, k = 2)

#' 
## ---- include = FALSE-----------------------------------------
load(file = "dados/onmds2.rda")

#' 
## -------------------------------------------------------------
# pega os valores dos eixos NMDS
ptsnmds2 <- onmds2$points
# cada linha nessa tabela corresponde
# à mesma linha na tabela iris2
head(ptsnmds2)
# essas colunas são os dois eixos NMDS
# isso deve ser verdadeiro
nrow(ptsnmds2) == nrow(iris2)

# calcula a distancia entre os pontos pelos eixos NMDS
adist2 <- dist(ptsnmds2)
# qual a correlacao entre essa matriz e a original?
cor(dmorfo2, adist2)
# por isso o stress é baixo, a correlação é alta

#' 
## -------------------------------------------------------------
# vamos visualizar os dois resultados, onmds e onmds2, graficamente
# divide o dispositivo em dois
par(mfrow = c(2, 1), mar = c(5, 5, 1, 1))
cores <- c("red", "green", "blue")[as.numeric(iris2$Species)]
plot(ptsnmds, pch = 21, bg = cores, cex = 0.8, xlab = "NMDS 1", ylab = "NMDS 2", main = "Objeto: ptsnmds")
plot(ptsnmds2, pch = 21, bg = cores, cex = 0.8, xlab = "NMDS 1", ylab = "NMDS 2", main = "Objeto: ptsnmds2")

#' 
#' ## Análises de agrupamento
#' 
#' A função `hclust()` faz uma análise de agrupamento a partir de uma matriz de distância e segundo um método.
#' Gera um objeto de classe `hclust` que contem a estrutura hierárquica da similaridade entre os seus dados (a hierarquia dada pela distância mais o método de agrupamento).  
#' 
#' Em análises de agrupamento, é normal lidar com objetos de classe `dendrogram`.
#' Podemos converter alguns objetos para esta classe usando a função `as.dendrogram()`, que facilita a geração de gráficos.
#' 
#' Outra classe importante é `phylo`, utilizada em objetos que contenham árvores filogenéticas (pacote `ape` de @R-ape).
#' Há a função `as.phylo()` que pode converter um objeto `hclust` para classe `phylo` e manipular o dendrograma como se fosse uma filogenia.
#' Também facilita a geração de gráficos.
#' 
#' 
## ---- eval = FALSE--------------------------------------------
## # Vamos usar o arquivo com coordenadas dos municipios brasileiros
## muni <- read.table(file = "municipiosbrasil.csv", header = T, as.is = T, sep = "\t", na.strings = c("NA", "", "NULL"))

#' 
## ---- include = FALSE-----------------------------------------
load("dados/municipiosbrasil.rda")

#' 
## -------------------------------------------------------------
cids <- c("Rio Branco", "Cruzeiro do Sul", "Tabatinga", "São Gabriel da Cachoeira", "Manaus", "Santarém", "Porto Velho", "Humaitá", "Belém", "Macapá", "Marabá", "Boa Vista")

# filtrando os dados
vl <- muni$Municipio %in% cids & muni$Regiao == "Norte"
muni <- muni[vl, ]
rownames(muni) <- muni$Municipio

# calcula a distancia geografica entre essas cidades (em graus de latitude)
mdist <- dist(muni[, c("Longitude", "Latitude")], method = "euclidean")

#' 
#' 
## ---- eval = FALSE--------------------------------------------
## # veja o help de hclust e também
## # os diferente métodos de agrupamento
## ?hclust

#' 
#' ### Agrupamento pelo método da mínima variância
#' 
## -------------------------------------------------------------
gp <- hclust(mdist, method = "ward.D2")
# visualizando
plot(gp, main = "Cidades da região norte", ylab = "Distância geográfica (dd)")

#' 
#' ### Agrupamento por UPGMA
#' 
## -------------------------------------------------------------
gp2 <- hclust(mdist, method = "average")
plot(gp2, hang = 0.1, main = "Cidades da região norte", ylab = "Distância geográfica (dd)")

#' 
#' ### Agrupamento por centróides
#' 
## -------------------------------------------------------------
gp3 <- hclust(mdist, method = "centroid")
plot(gp3, hang = 0.1, main = "Cidades da região norte", ylab = "Distância geográfica (dd)")
# teste outros métodos (entenda-os)

#' 
#' Vamos converter nossos objetos `gp` e `gp3` para objetos de classe `phylo`, e gerar um gráfico para cada um.  
#' 
## ---- eval = FALSE--------------------------------------------
## ?plot.phylo

#' 
#' 
## -------------------------------------------------------------
plot(as.phylo(gp), type = "phylogram", label.offset = 0.1, cex = 0.8)
axis(side = 1)
mtext(side = 1, line = 2.5, text = "Distância geográfica")

#' 
#' 
## -------------------------------------------------------------
# ou entao, como cladograma, e nao usando o comprimento dos ramos (i.e. as distancias)
plot(as.phylo(gp), type = "cladogram", label.offset = 0.1, cex = 0.8, use.edge.length = F)

#' 
#' 
## -------------------------------------------------------------
# ou entao, radial, com distancias
plot(as.phylo(gp), type = "radial", label.offset = 0.1, cex = 0.8, use.edge.length = T)

#' 
#' 
## -------------------------------------------------------------
# usando comprimento dos ramos (distancias+relacoes)
plot(as.phylo(gp), type = "phylogram", label.offset = 0.1, cex = 0.8, use.edge.length = T)
axis(side = 1)
mtext(side = 1, line = 2.5, text = "Distância geográfica")

#' 
#' 
## -------------------------------------------------------------
# nao usando o comprimento dos ramos (relacoes apenas)
plot(as.phylo(gp), type = "phylogram", label.offset = 0.1, cex = 0.8, use.edge.length = F, edge.color = "red", edge.width = 2)

#' 
#' ### Exemplo florístico
#' 
#' Vamos explorar a similaridade florística entre parcelas com os dados de caixetais novamente.  
#' 
#' 
## ---- eval = FALSE--------------------------------------------
## caixeta <- read.table("caixeta.csv", sep = ",", header = T, na.strings = c("NA", "", "NULL"))

#' 
## ---- include = FALSE, message=FALSE--------------------------
load("dados/caixeta2.rda")

#' 
## -------------------------------------------------------------
head(caixeta)
names(caixeta)

# vamos visualizar a similaridade florística entre parcelas
# entao geramos uma tabela de parcela vs. especies
# primeiro um vetor com valores únicos para local+parcela
# porque o número da parcela repete entre locais
parcelas <- paste(caixeta$local, caixeta$parcela, sep = "-")
tb <- table(parcelas, especies = caixeta$especie)
tb[, 1:5]
dim(tb)
# essa tabela contém o número de indivíduos de cada espécie
# em cada parcela

# calculando um índice de distancia de Jaccard para dados de presença e ausência

# transformando em uma tabela de presença e ausencia
tb2 <- tb
tb2[tb2 > 0] <- 1

#' 
#' 
#' Vamos utilizar a função `vegdist()` do pacote `vegan`.   
#' 
## ---- eval = FALSE--------------------------------------------
## ?vegdist

#' 
#' 
## -------------------------------------------------------------
djac <- vegdist(tb2, method = "jaccard")
class(djac)
# é uma matriz de distancia entre parcela
as.matrix(djac)[1:4, 1:4]

#' 
#' 
#' Podemos fazer um NMDS com esse resultado:
#' 
## ---- eval = FALSE--------------------------------------------
## onmds <- bestnmds(djac, k = 2)
## # parcelas 3 e 5 tem exatamente as mesmas espécies
## # vamos com colocar um valor super pequeno para essa distancia (quase zero)

#' 
#' 
## -------------------------------------------------------------
djac[djac == 0] <- 0.0000000000000000001

#' 
#' 
## ---- eval = FALSE--------------------------------------------
## # agora funciona
## onmds <- bestnmds(djac, k = 2)

#' 
## ---- include = FALSE-----------------------------------------
load("dados/exemplo_floristico1.rda")

#' 
#' 
## -------------------------------------------------------------
# plotando o resultado
# pega cores e simbolos segundo o local
ll <- data.frame(local = caixeta$local, parcelas)
ll <- unique(ll)
rownames(ll) <- ll$parcelas
ll

#' 
#' 
## -------------------------------------------------------------
rn <- rownames(as.matrix(tb2))
locais <- as.factor(ll[rn, "local"])

cores <- c("red", "green", "blue")[as.numeric(locais)]
pchs <- (21:23)[as.numeric(locais)]
plot(onmds$points, pch = pchs, bg = cores, xlab = "NMDS1", ylab = "NMDS2", cex = 1.5)
legend("bottomright", legend = levels(locais), pch = 21:23, pt.bg = c("red", "green", "blue"), inset = 0.05, bty = "n", cex = 1, pt.cex = 1.5, y.intersp = 1.5)

#' 
#' Agora vamos visualizar o resultado na forma de um agrupamento:
#' 
## -------------------------------------------------------------
cluster <- hclust(djac, method = "ward.D2")
plot(cluster, ylab = "Dissimilaridade Florística (Jaccard)")

#' 
#' Para aprimorar a figura, vamos utilizar a função `as.phylo()` do pacote `ape` [@R-ape] para converter o objeto `cluster` de classe `dendrogram` para um de classe `phylo`.
#' 
## ---- eval = FALSE--------------------------------------------
## pcl <- as.phylo(cluster)
## par(mar = c(5, 4, 3, 3))
## plot(pcl, tip.color = cores, label.offset = 0.02, cex = 0.8)
## # pontos
## tiplabels(pch = 21, frame = NULL, bg = cores)
## # eixo
## axisPhylo()
## # nome do eixo
## mtext(text = "Jaccard índice (0 ou 1)", side = 1, line = 2.5)
## legend("topleft", legend = levels(locais), pch = 21:23, pt.bg = c("red", "green", "blue"), inset = 0.01, bty = "n", cex = 1, pt.cex = 1.5, y.intersp = 1.5)

#' 
#' Vamos repetir essa operação considerando a abundância de espécies por parcelas contidos no objeto `tb` (usamos o índice de Sorensen).
#' 
## -------------------------------------------------------------
tb[1:4, 1:5]

#' 
## -------------------------------------------------------------
# sorensen (bray na convencao do R)
dsor <- vegdist(tb, method = "bray")

#' 
#' 
## ---- eval = FALSE--------------------------------------------
## onmds2 <- bestnmds(dsor, k = 2)

#' 
## ---- include = FALSE-----------------------------------------
load("dados/exemplo_floristico2.rda")

#' 
#' Plota o NMDS:
#' 
## -------------------------------------------------------------
plot(onmds2$points, pch = pchs, bg = cores, xlab = "NMDS1", ylab = "NMDS2", cex = 1.5)
legend("bottomright", legend = levels(locais), pch = 21:23, pt.bg = c("red", "green", "blue"), inset = 0.05, cex = 0.8, pt.cex = 1.5, y.intersp = 1.5, bty = "n")

#' 
#' Agora, vamos plotar o agrupamento:
#' 
## -------------------------------------------------------------
cluster2 <- hclust(dsor, method = "ward.D2")
pcl2 <- as.phylo(cluster2)
par(mar = c(5, 4, 3, 3))
plot(pcl2, tip.color = cores, label.offset = 0.02, cex = 0.8)
tiplabels(pch = 21, frame = NULL, bg = cores)
axisPhylo()
mtext(text = "Sorensen índice (com abundância)", side = 1, line = 2.5)
legend("topleft", legend = levels(locais), pch = 21:23, pt.bg = c("red", "green", "blue"), inset = 0.01, bty = "n", cex = 1, pt.cex = 1.5, y.intersp = 1.5)

#' 
#' ### Análise de Coordenadas Principais (PCoA)
#' 
#' A função `capscale()`faz uma análise de coordenadas principais (ou escalonamento multidimensional métrico ou clássico).
#' É parecida com uma Análise de Componentes Principais (PCA), mas é baseada em matrizes de distância.
#' Indica os efeitos das variáveis (parâmetro ''species'') sobre os eixos.
#' Já a função `ordiplot()` do pacote `vegan` [@R-vegan] permite graficar uma ordenação e os efeitos das variáveis (`sites` vs. `species`).
#' 
#' Leiam aqui uma [comparação entre PCA e PCoA](http://occamstypewriter.org/boboh/2012/01/17/pca_and_pcoa_explained/)
#' 
#' 
## -------------------------------------------------------------
# análise de coordenadas principais
data(iris) # carrega o conjunto de dados iris
dt <- iris[, 1:4]
mypcoa <- capscale(dt ~ 1, distance = "gower", add = F)

# quando da variação está explicado pelos eixos
resumo <- summary(mypcoa)
var.expl <- resumo$cont$importance
# veja a proporção cumulativa dos primeiros cinco eixos
var.expl["Cumulative Proportion", ][1:5]
# pega a proporção explicada por cada eixo
tt <- var.expl["Proportion Explained", ][1:5]
tt <- tt * 100
# gera um gráfico de barras com isso
barplot(tt, xlab = "Eixos MDS", ylab = "Variação explicada %")

#' 
#' 
## ---- eval = FALSE--------------------------------------------
## # fazendo uma figura com ordiplot
## # veja o help
## ?ordiplot

#' 
#' 
## -------------------------------------------------------------
# define cor e simbolo por especie
tx <- as.factor(iris$Species)
# simbolos para os níveis
upchs <- 21:23
# cores para os níveis
cores <- rainbow(length(levels(tx)), alpha = 0.5)

# gera a figura
fig <- ordiplot(mypcoa, type = "n")
# adiciona os pontos de cada linha
points(fig, "sites", pch = upchs[as.numeric(tx)], bg = cores[as.numeric(tx)], col = "white")

# pega os scores das variáveis
# que mostram os efeitos das variáveis usadas
mls <- scores(mypcoa, display = "species")
mls
# plota flechas para esses efeitos
arrows(0, 0, mls[, 1] * 0.8, mls[, 2] * 0.8, length = 0.05, angle = 20, col = "black", lwd = 2)
text(mls[, 1] * 0.8, mls[, 2] * 0.8, labels = rownames(mls), col = "black", cex = 0.8, pos = 4)

#' 
#' ## Componentes Principais (PCA)
#' 
#' [Análise de Componentes Principais (PCA)](https://pt.wikipedia.org/wiki/An%C3%A1lise_de_componentes_principais) é o método mais conhecido de ordenação, mas diferentemente dos métodos que se baseiam em matrizes de distância (ver abaixo) que são mais flexíveis e menos exigentes quanto à premissas estatísticas, a ordenação com PCA tem as seguintes limitações:
#' 
#' * Os componentes principais são independentes apenas se os dados possuirem **distribuição normal conjuntamente**;
#' 
#' * A PCA é sensível à escala relativa das variáveis originais.
#' 
#' Um exemplo:
#' 
## ---- eval = FALSE--------------------------------------------
## # análise de componentes principais
## ?prcomp

#' 
## -------------------------------------------------------------
data(iris) # carrega o conjunto de dados iris para a rea de trabalho
dt <- iris[, 1:4]

#' 
#' 
## -------------------------------------------------------------
meu.pca <- prcomp(dt, scale. = T, tol = 0, retx = T)
# entenda os argumentos usados

# classe gerada
class(meu.pca)
# elementos do resultado
names(meu.pca)

#' 
#' Vamos fazer uma figura utilizando a função `ordiplot()` do pacote `vegan`:
#' 
## ---- eval = FALSE--------------------------------------------
## # fazendo uma figura com ordiplot
## # veja o help
## ?ordiplot

#' 
#' 
## -------------------------------------------------------------
# quando da variação está explicado pelos eixos
resumo <- summary(meu.pca)
var.expl <- resumo$importance
# veja a proporção cumulativa dos eixos gerados
var.expl["Cumulative Proportion", ]
# quatro eixos explicam 100% da variacao
# pega a proporção explicada por cada eixo
tt <- var.expl["Proportion of Variance", ]
tt <- tt * 100
# gera um gráfico de barras com isso
barplot(tt, xlab = "Eixos PCA", ylab = "Variação explicada %")

# define cor e simbolo por especie
tx <- as.factor(iris$Species)
# simbolos para os níveis
upchs <- 21:23
# cores para os níveis
cores <- rainbow(length(levels(tx)), alpha = 0.5)

# gera a figura
fig <- ordiplot(meu.pca, type = "n")
# adiciona os pontos de cada linha
points(fig, "sites", pch = upchs[as.numeric(tx)], bg = cores[as.numeric(tx)], col = "white")

# pega os scores das variaveis
# que mostram os efeitos das variáveis usadas
mls <- scores(meu.pca, display = "species")
mls
# plota flexas para esses efeitos
ft <- 2 # para aumentar as flexas um pouco
arrows(0, 0, mls[, 1] * ft, mls[, 2] * ft, length = 0.05, angle = 20, col = "black", lwd = 2)
text(mls[, 1] * ft, mls[, 2] * ft, labels = rownames(mls), col = "black", cex = 0.8, pos = 4)

