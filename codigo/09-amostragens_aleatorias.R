#' # Amostragens aleatórias {#amost-aleat}
#' 
#' ## Funções para gerar permutações e simular dados
#' 
#' A função `sample()` aleatoriza valores em um vetor, com ou sem repetição, ou amostra um certo número de valores aleatoriamente de um vetor de valores.  
#' 
## ----opts.label='evalF'-------------------------------------------------------
# ALEATORIZANDO DADOS SEM AMOSTRAGEM
?sample

#' 
#' 
## -----------------------------------------------------------------------------
# suponha um vetor de numeros
v1 <- 1:20
v1 # os numeros sao sequenciais

# se quiser embaralhar aleatoriamente
sample(v1)
sample(v1) # cada vez será diferente
sample(v1) # diferente de novo

# no exemplo acima, os numeros sao apenas embaralhados
table(v1) # cada valor só aparece uma vez
table(sample(v1)) # aqui tambem

# se eu quiser amostras com repeticao
table(sample(v1, replace = TRUE))
# ele repetiu alguns valores aleatoriamente
table(sample(v1, replace = TRUE)) # vai ser diferente toda vez que voce executa

# mas o comprimento é sempre o mesmo
length(v1)
length(sample(v1))
length(sample(v1, replace = T))

# agora com textos
table(LETTERS)
table(sample(LETTERS, replace = T))

#' 
#' Amostraremos `N` valores de um vetor qualquer:  
#' 
## -----------------------------------------------------------------------------
# agora amostra um número qualquer de valores de um vetor qualquer:
umvetor <- seq(from = 0, to = 1000, by = 0.1)
length(umvetor)
head(umvetor, 10) # primeiros 10 elementos
# agora amostra 100 valores desse vetor que tem 9991 valores
umaamostra <- sample(umvetor, size = 100, replace = T)
# entao isso deve ser verdadeiro
length(umaamostra) == 100
# primeiros 10 valores amostrados
head(umaamostra, 10)
# histograma da amostra
hist(umaamostra, col = "red")
# note que a distribuição é uniforme, qualquer valor tem a mesma chance de ser amostrado
# faco outra vez e adiciono
outraamostra <- sample(umvetor, size = 100, replace = T)
# adiciono ao histograma anterior
hist(outraamostra, density = 10, add = T, col = "black")
# cada vez é diferente a sequencia de valores amostrados

#' 
#' ## Distribuições aleatórias
#' 
#' O R disponibiliza um conjunto um conjunto de funções para gerar densidade, distribuição cumulativa, quantis e geração aleatória de variáveis com diferentes distribuições de probabilidade (veja a seção [Para saber mais](#sabermais-distribuicoes) para mais informações).  
#' 
#' Aqui vamos conhecer as funções que geram variáveis aleatórias para duas distribuições probabilísticas:
#' 
#' * [Distribuição normal](https://en.wikipedia.org/wiki/Normal_distribution);
#' 
#' * [Distribuição log-normal](https://en.wikipedia.org/wiki/Log-normal_distribution).  
#' 
#' 
## ----opts.label='evalF'-------------------------------------------------------
# veja no R o help para as funções para as diferentes distribuições disponíveis no R.
?Distributions

#' 
#' ### Distribuição Normal
#' 
#' Segundo as companhias aéreas dos EUA, a largura dos quadris dos homens norte-americanos segue uma curva normal, com média de 14.4 polegadas, e desvio-padrão de 1 polegada.
#' 
#' #### `rnorm()`
#' 
#' Esta função permite gerar essa distribuição de valores aleatórios que seguem uma distribuição normal se soubermos a média e o desvio padrão.  
#' 
## ----eval = FALSE-------------------------------------------------------------
## ?rnorm # veja o help da função

#' 
## -----------------------------------------------------------------------------
amedia <- 14.4
osd <- 1
# vamos gerar 1000 valores aleatórios com essa distribuição
quadris <- rnorm(n = 1000, mean = amedia, sd = osd)
# visualizando essa distribuição de valores
hist(quadris)

# ou visualizando a densidade probabilística dessa distribuição
hist(quadris, probability = T)
# a linha da densidade
lines(stats::density(quadris), col = "red", lwd = 2)

#' 
#' 
#' #### `pnorm()`
#' 
#' Esta função permite responder à pergunta:
#' 
## 
## Qual percentual de pessoas não cabe em um assento de 15 polegadas?
## 
#' 
#' 
## ----opts.label='evalF'-------------------------------------------------------
# veja o help dessa função
?pnorm

#' 
#' 
## -----------------------------------------------------------------------------
# qual o percentil/quantil da distribuição que é maior que 15 polegadas
# quem não cabe no assento?
qMaior15in <- pnorm(q = 15, mean = 14.4, sd = 1, lower.tail = F)
# note o argumento lower.tail=F (você quer apenas o percentil que está acima desse valor)
# ca. de 27%
qMaior15in
print(paste(round(qMaior15in * 100, 0), "% dos americanos não cabem em um assento de 15 polegadas", sep = ""))

# vamos visualizar isso
x <- sort(quadris) # ordenamos os quadris
y <- dnorm(x, mean = amedia, sd = 1) # calculamos a densidade probabilística desses valores
plot(x, y, type = "l", lwd = 2, col = "black", ylab = "Densidade Probabilística", xlab = "Quadris de americanos (inches)") # plotamos isso e temos nossa curva normal
# agora fazemos o mesmo para os quadris que satisfazem a condicao
abline(v = 15, lwd = 2, col = "blue") # o quadril da pergunta
xx <- sort(quadris[quadris >= 15])
yy <- dnorm(xx, mean = amedia, sd = 1)
# adicionamos isso na forma de um polígono
# coordenadas X do polígono (note que adicionei valores para poder fechar o polígono)
xxp <- c(15, xx, max(xx), 15)
# e adiciono também no eixo y
yyp <- c(0, yy, 0, 0)
# desenho o polígono correspondente
polygon(xxp, yyp, col = "red")
## a area desse polígono representa esse quantil
# (i.e. a porcentagem da população que tem quadril >= 15)

#' 
#' #### `qnorm()`
#' 
#' Esta função permite responder à pergunta:
#' 
## 
## Qual largura de assento garante que 95% da população caberá?
## 
#' 
#' 
## -----------------------------------------------------------------------------
# agora fazemos o inverso da função pnorm, ao inves de informar o quantil,
# informamos o percentil
qnorm(p = 0.95, mean = 14.4, sd = 1)
# este é o tamanho do assento que inclui 95% dos valores
# numa distribuição normal com essa média e esse desvio padrão
tamanho95 <- qnorm(p = 0.95, mean = 14.4, sd = 1)
# graficando isso?
hist(quadris, prob = T)
# limite de tamanho
abline(v = tamanho95, col = "blue", lwd = 2, lty = "dashed")
# plota valores que estao dentro dessa distribuicao
hist(quadris[quadris < tamanho95], prob = T, add = T, col = "red")

#' 
#' #### `dnorm()`
#' 
#' A função `dnorm()` gera a densidade probabilística para um conjunto de valores, tendo em vista uma distribuição normal de mesma média e mesmo desvio padrão.
#' Podemos responder à pergunta:
#' 
#' 
## 
## Qual a densidade probabilística para um valor de quadril de 12 polegadas? Ou seja, qual a probabilidade de amostrar na população uma pessoa com quadril de 12 polegadas?
## 
#' 
#' 
## -----------------------------------------------------------------------------
dq12 <- dnorm(x = 12, mean = 14.4, sd = 1)
dq12
# mostra na figura
# plota a densidade probabilística
hist(quadris, prob = T)
# coloca a linha
lines(stats::density(quadris), col = "red", lwd = 2)
# adicona um ponto que mostra a probabilidade do valor
points(x = 12, y = dq12, pch = 21, bg = "blue")
segments(0, dq12, 12, dq12, lty = "dotted", col = "blue", lwd = 2)
axis(side = 2, at = dq12, labels = paste(round(dq12 * 100, 0), "%", sep = ""), line = NULL, las = 2, col = "blue")

#' 
#' ## Para saber mais: {#sabermais-distribuicoes}
#' 
#' (1) [Probability distributions](http://www.r-tutor.com/elementary-statistics/probability-distributions).  
#' 
#' ## Exercícios
#' 
#' * Resolva o exercício [103.7 Cara ou coroa](http://notar.ib.usp.br/exercicio/34).
#' * Resolva o exercício [103.9 Lembrando matrizes e listas](http://notar.ib.usp.br/exercicio/37).
