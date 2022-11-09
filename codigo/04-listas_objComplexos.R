#' # Objeto III - Listas e objetos complexos {#lista-objcompl}
#' 
#' ## Listas {#listas}
#' 
#' O resultado de muitas análises são objetos de classe `list` e você precisa entender o que isso significa.
#' Listas permitem organizar diferentes classes de objetos numa estrutura hierárquica organizada.
#' Uma mesma lista pode incluir elementos que são vetores de qualquer classe, matrizes, data.frames etc.
#' Listas são criadas pela função `list()`.
#' A indexação de listas é dado pelo operador `[[indice_ou_nome]]` ou `lista$` seguida do nome (se os elementos da lista tem nome; e.g. `lista$nomeDeUmElementoDaLista`).  
#' 
## ---- eval = FALSE, echo = TRUE----------------------------------------
## ?list # veja o help

#' 
#' 
## ----------------------------------------------------------------------
# um vetor simples
v1 <- 1:10
class(v1)
# outro vetor simples
v2 <- LETTERS
class(v2)
# uma matriz simples
mm <- matrix(1:9, nrow = 3, ncol = 3)
class(mm)
# um data.frame
dd <- iris
dd
class(dd)

# criamos uma lista simples
v1
v2
mm
dd
ml <- list(v1, v2, mm, dd)
class(ml) # deve ser lista
length(ml) # número de elementos
names(ml) # os elementos dessa lista não tem nome
str(ml) # veja a estrutura do objeto
ml[[1]] # o elemento 1 é o vetor
ml[[2]] # o segundo também
ml[[1:2]] # note que retorna apenas o segundo... nao funciona como vetor para pegar mais de um elemento, pois a estrutura é complexa
ml[[1]][3] # terceiro elemento do vetor que está no elemento 1 da lista


ml[[3]] # é uma matrix
ml[[3]][1, 3] # valor da primeira linha e da terceira coluna da matrix que o objeto 2 da lista

ml[[4]] # é uma data.frame
ml[[4]][, 1] # a primeira coluna deste data.frame
ml[[4]]$Sepal.Length # mesma coisa

# uma lista pode conter listas
mll <- list(list(v1, v2), mm, dd) # o primeiro elemento virou uma lista com dois vetores
class(mll[[1]]) # é uma lista agora
mll[[1]][[1]] # a sublista 1 do elemento 1 da lista
mll[[1]][[2]] # a sublista 2 do elemento 1 da lista

# criamos uma lista com nomes
ml <- list(VETOR1 = v1, MATRIZ = mm, TABELA = dd)
class(ml)
str(ml)
names(ml) # nome dos elementos
ml[["VETOR1"]]
ml$VETOR1 # ou assim, da mesma forma que uma coluna de um data.frame

ml[["TABELA"]][, "Sepal.Length"] # coluna do data.frame em TABELA
ml[["TABELA"]]$Sepal.Length # idem
ml$TABELA$Sepal.Length # idem também

#' 
#' 
#' ## Objetos complexos {#obj-complexos}
#' 
#' Em alguns casos como, por exemplo, em arquivos de dados espaciais (shapefiles), que apresentam estruturas complexas que incluem as especificações dos polígonos, pontos ou linhas, a projeção espacial e os dados associados, exige-se um objeto que possua uma estrutura de complexidade similar.  
#' 
#' Nestes casos, é importante que você conheça o operador `@`, que permite extrair elementos desses objetos.
#' Em alguns casos você terá que usá-lo para entender o objeto ou para pegar elementos dos mesmos objetos.  
#' 
#' A função `slotNames()` permite ver os elementos que podem ser extraídos com o operador `@`.
#' Abaixo mostramos um exemplo através de um mapa dos municípios brasileiros.
#' Para isso, vamos precisar baixar um arquivo (https://github.com/LABOTAM/IntroR/blob/main/dados/municipiosshape.zip).
#' Baixe este arquivo comprimido que contem os arquivos de um único *shapefile*.
#' Descomprima-o na sua pasta de trabalho e você perceberá que haverá vários arquivos associados.
#' Para trabalhar com esses arquivos, vamos utilizar os pacotes `maps` [@R-maps] e `rgdal` [@R-rgdal].  
#' 
## ---- opts.label='evalF'-----------------------------------------------
# vamos precisar de dois pacotes para dados espaciais
# se não tiver instalado, instale com as dependencias
# install.packages(c("maps", "rgdal"), dependencies = TRUE)
library("maps")
library("rgdal")

# agora mudem o diretorio para pasta que contem os arquivos shape
# lembre que voces podem tanto utilizar a funcao `setwd()` quanto clicar em Ferramentas/Tools na barra de opcoes do RStudio para mudar o diretorio de trabalho
dir(pattern = "shp") # lista arquivos shape na pasta
# veja o help da função para ler shapefiles
?readOGR

# le o shape file com objeto espacial no R
mp <- readOGR(dsn = "MUNICIPIOS.shp", layer = "MUNICIPIOS", encoding = "UTF-8")
plot(mp) # veja o mapa

class(mp) # é um objeto de classe SpatialPolygonsDataFrame
str(mp) # a estrutura é complexa

# tem elementos definidos por $, que interpretado diretamente, é corresponde a um data.frame que é o dado associado à cada polígono no arquivo (attribute table do shapefile).
names(mp)
mp$NOME_MUNI
dim(mp)

# tem elementos definidos por @
# ver o help da função
# ?slot
# slotNames(mp) #lista quais são esses elementos


mp@data # é o mesmo data.frame que é automaticamente reconhecido na expressão acima
dim(mp) == dim(mp@data)
names(mp) == names(mp@data)

# area do mapa dos municipios (os limites em latitude e longitude da área)
mp@bbox
plot(mp@bbox)
# adicionamos o mapa mundi sobre isso
map(add = T)

# mp@polygons define cada poligono individualmente numa lista
class(mp@polygons)
mp@polygons[[1]] # um elemento qualquer
class(mp@polygons[[1]])
str(mp@polygons[[1]])

# veja que este objeto tem vários elementos definidos por @
# slotNames(mp@polygons[[1]]) #slots desse objeto
mp@polygons[[1]]@labpt # o centroid do polígono 1 que é o municipio de:
mp@data$NOME_MUNI[1] # Chuí

# qual elemento é manaus?
gp <- grep("Manaus", mp@data$NOME_MUNI)
# pega o polígono de manaus
manaus <- mp@polygons[[gp]]
class(manaus)
str(manaus)

# plota manaus
# dev.off() #fecha dispositivos gráficos podes precisar disso
map(xlim = mp@bbox["x", ], ylim = mp@bbox["y", ])
polygon(manaus@Polygons[[1]]@coords, col = "red")
# centroides do poligono de manaus
ctro <- manaus@Polygons[[1]]@labpt
ctro[2] <- ctro[2] + 1.5 # adiciona 1.5 graus na latitude para não plotar sobre o poligono do municipio
# plota no nome
text(x = ctro[1], y = ctro[2], labels = "Manaus", cex = 0.8)

