#' # Caras de Chernoff {#chernoff}
#' 
## -------------------------------------------------------------
#as carinhas de Chernoff são geradas pelo pacote TeachingDemos
library("TeachingDemos")

#uma matriz com variaveis
pessoas = paste("pessoa",1:10,sep="-")
altura = rnorm(10,mean=1.7,sd=0.2)
dedao = rnorm(10,mean=0.05,sd=0.002)
mm = data.frame(altura,dedao)
rownames(mm) = pessoas
faces(mm)

#' 
