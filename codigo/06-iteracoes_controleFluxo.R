#' # Iteração e controle de fluxo {#iter-cflux}
#' 
#' ## Funções da família `apply()` {#func-apply}
#' 
#' Algumas funções da família `apply()` são muito úteis na manipulação de dados e descrição de dados.
#' Essas funções são muito poderosas, porque permitem você fazer iterações de forma simples, ou seja, você pode aplicar uma função a vários objetos simultaneamente com funções dessa família.
#' O que você faz com essas funções você também faz com as iterações que fazem uso da expressão `for(){}` (veja seção \@ref(iteracoes)), mas essas funções simplificam e aceleram o processo.  
#' 
#' ### Em uma matriz
#' 
#' A função `apply()` poderia ser traduzida como: 
#' 
#' > aplique uma função (FUN) a todas as linhas ou colunas (MARGIN) de uma matriz (X):
#' 
## ---- opts.label='evalF'------------------------------------------------------
?apply # Veja o help
# os argumentos dessa função são:
# X = matrix
# MAGRIN = 1 indica linha, 2 indica colunas
# FUN = a função que você deseja aplicar
# ... ARGUMENTOS DESSA FUNCAO SE FOR O CASO

# TOTAIS MARGINAIS
# crie uma matriz

#' 
#' 
## ---- cache = TRUE------------------------------------------------------------
X <- matrix(1:36, nrow = 4, ncol = 9)
colnames(X) <- paste("col", 1:ncol(X))
rownames(X) <- paste("ln", 1:nrow(X))
head(X) # cabeça da matriz criada

# calcule para todas as linhas:
# a soma dos valores
apply(X, MARGIN = 1, FUN = sum)
# o valor máximo
apply(X, MARGIN = 1, FUN = max)
# a média
apply(X, MARGIN = 1, FUN = mean)
# o desvio padrão
apply(X, MARGIN = 1, FUN = sd)

# para todas as colunas
# a soma dos valores
apply(X, MARGIN = 2, FUN = sum)
# o valor máximo
apply(X, MARGIN = 2, FUN = max)
# a média
apply(X, MARGIN = 2, FUN = mean)
# o desvio padrão
apply(X, MARGIN = 2, FUN = sd)

#' 
#' As funções `rowSums()`, `rowMeans()`, `colSums()`, ou `colMeans()` são equivalentes à função `apply()`.
#' Elas simplificam o uso para somas (em inglês, *sum*) e médias (em inglês, *mean*) de linhas (em inglês, *rows*) e colunas (em inglês, *columns*).
#' Se você conhece bem a função `apply()`, você pode fazer o que essas funções fazem e muito mais.
#' Portanto, ao dominar a função `apply()`, você acaba por não precisar se preocupar em aprender essas funções mais específicas.
#' 
## ---- opts.label='evalF'------------------------------------------------------
?rowSums

#' 
#' 
## ---- cache = TRUE------------------------------------------------------------
rowSums(X) # soma de cada linha
rowMeans(X) # media de cada linha
colSums(X) # soma de cada coluna
colMeans(X) # média de cada coluna

#' 
#' ### Em um vetor ou lista
#' 
#' A função `lapply()` aplica uma função `FUN` para cada elemento de um vetor ou de uma lista, e retorna um objeto de classe `list`.
#' 
## ---- cache = TRUE------------------------------------------------------------
# muito simples, imprime algo linha por linha
ll <- lapply(LETTERS, print)
class(ll)
str(ll)

# suponha três vetores de tamanhos diferentes
v1 <- sample(1:1000, 50)
length(v1)
v2 <- sample(1:100, 30)
length(v2)
v3 <- sample(1000:2000, 90)
length(v3)
# imagina que isso esteja numa lista
ml <- list(v1, v2, v3)
class(ml)
length(ml)

# posso usar lapply para calcular a media desses vetores
lapply(ml, mean) # note que retorna uma lista
lt <- lapply(ml, mean) # podemos guardar
lt <- as.vector(lt, mode = "numeric") # e transformar num vetor. MODE neste caso é fundamental usar
lt

#' 
#' ### Por categoria de um fator
#' 
#' A função `tapply()` aplica uma função `FUN` em uma coluna numérica individualizando os resultados para cada categoria de um determinado fator.
#' 
## ---- opts.label='evalF'------------------------------------------------------
# vamos usar os dados de Iris novamente
?iris

#' 
#' 
## ---- cache = TRUE------------------------------------------------------------
# calculando o comprimento médio de sepálas pelas categorias de um fator (especies)
class(iris$Sepal.Length) # variavel numerica
class(iris$Species) # fator com categorias que correspondem a especies
tapply(iris$Sepal.Length, iris$Species, FUN = mean)

# calculando o comprimento máximo por especie
tapply(iris$Sepal.Length, iris$Species, FUN = max)

# a amplitude de variacao
tapply(iris$Sepal.Length, iris$Species, FUN = range)

# note que essa funcao sempre retorna um array (que é uma lista de fato, neste caso)
tm <- tapply(iris$Sepal.Length, iris$Species, FUN = min)
class(tm)
names(tm)
tm[["setosa"]] # indexadores de lista

tr <- tapply(iris$Sepal.Length, iris$Species, FUN = range)
class(tr)
names(tr)
tr[["setosa"]]

#' 
#' 
#' ## Condicionais
#' 
#' Condicionais são expressões que permitem a um programa a tomada de decisões.
#' Vamos tratar aqui das condicionais `if ()`, `if () else {}`, e `ifelse ()` (veja a seção [Para saber mais](#sabermais-condic) para mais informações).
#' 
#' ### Condicional `if ()`
#' 
#' A expressão `if ()` avalia um vetor atômico (ou de índice 1) lógico e executa o que estiver entre `{}` se o valor do vetor for verdadeiro (TRUE).
#' 
#' A estrutura básica de um `if ()` é:
#' 
#' ```
#' if (condicao) {
#'   
#'   ação a ser realizada caso a condição seja VERDADEIRA
#' }
#' ```
#' 
#' Dentro do par de parênteses, deve haver uma **condição.**
#' Condições em R são feitas com operadores lógicos: `==`, `!=`, `>`, `<` etc (veja a seção \@ref(#vetor-operador-logico) para relembrar; veja também a seção [Para saber mais](#sabermais-condic) pois apresenta *links* para vídeoaulas importantes).  
#' 
#' #### Exemplo 01
#' 
## ---- cache = TRUE------------------------------------------------------------
perdiz_estuda_breu <- TRUE
perdiz_estuda_grama <- FALSE
perdiz_estuda_breu
perdiz_estuda_grama
if (perdiz_estuda_breu) {
  print("Breu pode ser Protium, Dacryodes, Trattinnickia, e é da família Burseraceae")
}

if (perdiz_estuda_grama) {
  print("Isso não vai dar imprimir")
}

#' 
#' Reparem na condição que deve ser satisfeita dentro dos parênteses: `TRUE`, para efetuar a ação; se `FALSE`, não executa a função:
#' 
## -----------------------------------------------------------------------------
if (TRUE) {
  print("Eu executo!")
}

if (FALSE) {
  print("Eu não executo")
}

#' 
#' ### Condicional `if ()` com o `else` 
#' 
#' A condicional `if ()` pode ser expandida para `if () { } else {}`: execute em `{}` se `if ()` for VERDADEIRO, caso contrário (== else), execute o que estiver entre o segundo par `{}`.
#' 
#' #### Exemplo 01
#' 
## -----------------------------------------------------------------------------
meunumero <- 77
meunumero
if (meunumero == 76) {
  print("Meu número é o 3")
} else {

  # meu_else <- paste0("Mas pode ser o ", meunumero)
  # print(meu_else)
  # 1+1
  print(paste("Se eu somar o meu número ", meunumero, "com 3, eu vou obter ", meunumero + 3))
}

#' 
#' #### Exemplo 02
#' 
## -----------------------------------------------------------------------------
familia <- c("Burseraceae", "Solanaceae", "Sapindaceae", "Rubiaceae")
clado <- c("Malvids", "Lamiids", "Malvids", "Lamiids")
apg <- data.frame(familia = familia, clado = clado, stringsAsFactors = FALSE)
apg
str(apg)
dim(apg)

malvids <- c("Burseraceae", "Sapindaceae")

meunumero <- 4
apg$familia[meunumero]
apg$familia[meunumero] %in% malvids
if (apg$familia[meunumero] %in% malvids) {
  malv_fam <- paste(malvids, collapse = " e ")
  malv_fam
  clado <- "Malvids"
  frase <- paste(malv_fam, clado, sep = " pertencem ao clado das ")
  frase
  print(frase)
} else {
  paste("A família", apg$familia[meunumero], "pertence ao clado das", apg$clado[meunumero])
}

#' 
#' 
#' ### Condicional `ifelse()`
#' 
#' ```
#' ifelse(condicao, executa se VERDADEIRO, executa se FALSO)
#' ```
#' 
## ---- cache = TRUE------------------------------------------------------------
set.seed(333)
familia
familias <- sample(familia, 100, replace = TRUE)
familias
table(familias)
familias
ifelse(familias == "Burseraceae", TRUE, FALSE)
ifelse(familias == "Sapindaceae", "Sapindaceae é a família do guaraná", "Não é Sapindaceae")
familias[3]

familias[1:10]
ifelse(familias == "Sapindaceae", "Sapindaceae da ordem Sapindales",
  ifelse(familias == "Burseraceae", "Burseraceae também é da ordem Sapindales", "Nenhuma dessas famílias é uma Sapindales")
)


sei_qual_ordem <- ifelse(familias == "Sapindaceae", "Sapindaceae da ordem Sapindales",
  ifelse(familias == "Burseraceae", "Burseraceae também é da ordem Sapindales", "Nenhuma dessas famílias é uma Sapindales")
)

meudf <- data.frame(familias, sei_qual_ordem)
meudf

#' 
#' 
#' ## Iterações {#iteracoes}
#' 
#' Vocês usaram várias funções da família `apply`, especialmente `apply()` e `tapply()`, que são funções especiais que repetem uma mesma função `FUN` para cada objeto de um conjunto (vetores, matrizes, valores atômicos).
#' Essas funções utilizam portanto a lógica de iterações (em inglês, *loops*), ou seja, fazem a mesma ação repetidas vezes; em outras palavras, fazem *LOOPs*, dão voltas, realizam o mesmo percurso várias vezes, percorrem um circuito.  
#' 
#' As expressões `for(){}` e `while(){}` permitem fazer *LOOPs*, e *LOOPs* dentro de *LOOPS* com muita liberdade.
#' Aprendê-las é o mesmo que aprender todas as funções da família `apply` juntas (`apply()`, `tapply()`, `sapply()`, `lapply()`, `mapply()` etc).
#' Se você compreende os *LOOPS*, pode fazer o que essas funções fazem sem precisar delas (embora elas possam executar a tarefa mais rapidamente).  
#' 
#' ### Iteração com `for(){}`
#' 
#' #### Exemplo 1
#' 
#' Um exemplo simples do que seria uma iteração com o comando `for(){}`:  
#' 
## -----------------------------------------------------------------------------
# vamos imprimir na tela as letras do objeto LETTERS
for (let in 1:length(LETTERS)) {
  paraimprimir <- paste(LETTERS[let], " é a letra de índice ", let)
  print(paraimprimir)
}

#' 
#' Ou seja, para cada elemento do objeto `let`, assumindo os valores na sequência do elemento 1 ao elemento corresponden ao comprimento (== `length(LETTERS)`) do objeto LETTERS, execute o que está dentro de `{}`.  
#' 
#' #### Exemplo 2
#' 
## ---- cache = TRUE------------------------------------------------------------
# Fazendo um loop com for(){} replicando o que a função apply() faz
# criamos uma matriz
vetn <- rnorm(100, 30, 1)
mvetn <- matrix(vetn, ncol = 10, dimnames = list(paste("linha", 1:10), paste("coluna", 1:10)))
head(mvetn)
# Fazendo algo == apply(mvetn,2,mean)
# cria um objeto para salvar o resultado
resultado <- NULL
for (coluna in 1:ncol(mvetn)) {
  # pega a coluna
  cl <- mvetn[, coluna]
  # calcula a media
  mcl <- mean(cl)
  print(paste("Média da coluna", colnames(mvetn)[cl], "=", round(mcl, 2)))
  # salva o resultado com a media do item anterior
  resultado <- c(resultado, mcl)
}
# adicona o nome das colunas
names(resultado) <- colnames(mvetn)
# ver o resultado
resultado
# identico ao apply, maior controle de como a média é aplicada
resultado == apply(mvetn, 2, mean)

#' 
#' #### Exemplo 3
#' 
#' Agora usando `for(){}` para fazer algo como o `tapply()`.  
#' 
## ---- opts.label='evalF'------------------------------------------------------
# Fazendo algo == tapply(mvetn[,2],mvetn$classe,sum)
# criamos uma matriz
vetn <- rnorm(100, 30, 1)
mvetn <- matrix(vetn, ncol = 10, dimnames = list(paste("linha", 1:10), paste("coluna", 1:10)))
# transformamos num data.frame adicionando uma coluna categorica
mvetn <- data.frame(classe = sample(paste("categ", 1:3, sep = ""), size = nrow(mvetn), replace = T), mvetn)
head(mvetn[, 1:5])
# cria um objeto para salvar o resultado
resultado <- NULL
# para cada categoria
for (ct in 1:length(levels(mvetn$classe))) {
  # pega a categoria
  cl <- levels(mvetn$classe)[ct]
  # filtra os dados (vetor logico)
  vl <- mvetn$classe == cl
  # calcula a soma dos dados da categoria
  soma <- sum(mvetn[vl, 2], na.rm = T)
  # imprime o passo
  print(paste("A soma da categoria", cl, " é igual a ", soma))
  # junta os resultados
  resultado <- c(resultado, soma)
}
# atribui nomes aos elementos do vetor de somas
names(resultado) <- levels(mvetn$classe)
# confere
resultado == tapply(mvetn[, 2], mvetn$classe, sum)

#' 
#' #### Exemplo 4
#' 
#' Calculando somas e médias de linhas, similar ao que podemos fazer com a função `apply()`:  
#' 
## ---- cache = TRUE------------------------------------------------------------
somas <- NULL # objeto vazio para salvar soma de cada linha
medias <- NULL # objeto vazio para salvar medias de cada linha
for (i in 1:nrow(X)) { # para cada linha
  somai <- sum(X[i, ]) # soma dos valores na linha i
  somas <- c(somas, somai) # junta a somai com o resto (que estará vazio na primeira vez)
  mediai <- mean(X[i, ]) # média  dos valores na linha i
  medias <- c(medias, mediai) # junta as medias
}
# como a matriz tem nomes, acrescenta esses nomes aos vetores com resultados
names(medias) <- rownames(X)
medias
names(somas) <- rownames(X)
somas

#' 
#' ### Iteração com `while(){}`
#' 
#' O comando `while(){}` funciona de forma parecida, mas faz algo `r toupper("enquanto")` (em inglês, *while*) a condição em `while(){}` seja verdadeira.
#' Um exemplo simples:
#' 
#' #### Exemplo 1
#' 
## ---- cache = TRUE------------------------------------------------------------
# cria um vetor de valores aleatorizados
vet <- sample(10:100)
# amostra um valor do vetor até que este valor seja 10
conta <- 1
valor <- 0
while (valor != 10) {
  valor <- sample(vet, 1)
  print(paste("o valor selecionado na iteração", conta, "foi de ", valor))
  conta <- conta + 1
}

#' 
#' 
#' ### Iteração com `for(){}` e a condicional `if(){}`
#' 
#' #### Exemplo 1
#' 
## ---- opts.label='evalF'------------------------------------------------------
# cria um vetor de valores aleatorizados
vet <- sample(10:100, 60, replace = T)
# amostra um valor do vetor até que este valor seja 10
for (v in 1:10000) {
  valor <- sample(vet, 1)
  if (valor == 10) {
    # se o valor selecionado aleatoriamente for 10, ou seja se a expressão valor==10 for TRUE execute:
    # imprima isso
    print(paste("A primeira vez que o valor 10 foi selecionado aleatoriamente foi quando o objeto v assumiu o valor de", v))
    # interrompa (quebre) o loop
    break # note este argumento
  } else {
    # caso contrario, valor!=10, imprime o valor selecionado e continua o loop
    print(paste("O valor selecionado foi ", valor, "no indice", v))
  }
}

#' 
#' É possível que o script acima repita as 10000 vezes do `for(){}` sem encontrar o valor 10, até porque o 10 pode não estar em vet se não for amostrado.  
#' <!-- A expressão `if(){}` não precisa necessariamente estar dentro de um loop, ela é independente.   -->
#' 
#' 
#' ## Criando ou modificando funções
#' 
#' Funções são objetos que contêm um script que usa os argumentos (também objetos) para executar alguma coisa.
#' A expressão `function(){}` é utilizada para criar funções.
#' Criar funções é útil pois podem executar algo várias vezes (podendo ser de forma diferente) sem precisar reescrever o código todas às vezes.
#' Isso nos auxilia em práticas rotineiras como, por exemplo, na manipulação de um conjunto de dados de localização geográfica de espécimes botânicos. 
#' Podemos gerar um mapa personalizado de distribuição geográfica de cada espécie criando uma função para plotar um mapa, e depois utilizamos a aplicamos a função sobre a categoria, neste caso, a variável contendo o nome da espécie.
#' É muito útil também poder modificar uma função criada por outra pessoa, seja uma função de um determinado **pacote** ou uma função que você encontrou em uma página qualquer navegando pela internet.  
#' 
#' É muito simples construir uma função.
#' Há um bloco que deve ser sempre repetido:  
#' 
#' ```
#' function(meu_argumento1, meu_argumento2, ...) {
#'   
#'   # AQUI FICAM AS AÇÕES DE SUA FUNÇÃO, COMO POR EXEMPLO
#'   
#'   return("resultado da função") #
#'   
#' } 
#' ```
#' 
#' É costume sempre utilizar a função `return()` como último elemento da função para que algum objeto seja retornado ao usuário.
#' 
## ---- opts.label='evalF'------------------------------------------------------
?return # veja o help

#' 
#' ### Exemplo I
#' 
#' Vamos fazer a nossa versão da função `mean()`, que tira a média aritmética dos valores de um vetor.  
#' 
## -----------------------------------------------------------------------------
# Vamos fazer essa função na unha:
amedia <- function(x) {
  # x será um vetor de comprimento >=1 e todos os valores devem ser numéricos, senão precisamos avisar.
  # essa funçao ira retornar o valor do 'am' que definimos como nulo inicialmente
  am <- NULL
  # condicao 1
  c1 <- is.vector(x)
  # condicao 2
  xx <- as.numeric(x) # convertemos em numérico
  xx <- xx[!is.na(xx)] # tira o que não é número (o que não foi convertido ou está em branco)
  c2 <- length(xx) == length(x) # os comprimentos são iguais? e tem algum valor?
  if (c1 & length(xx) > 0) { # se for um vetor e houver algum valor numérico, pode calcular a média
    am <- sum(xx) / length(xx)
    if (!c2) { # se c1 for falso
      print(paste(length(x) - length(xx), " valores do vetor não são numéricos e foram excluídos")) # avisa
    }
  } else {
    print("O objeto não é um vetor ou não há valores numéricos") # avisa
  }
  return(am)
}

#' 
#' Vamos agora utilizar a função:
#' 
## -----------------------------------------------------------------------------
v1 <- c(1, 2, 3, 4, 5, 6)
amedia(v1)

v1 <- c(3, 3, 3, 3, 3, 3, 3)
amedia(v1)

v1 <- c(3, 3, 3, 3, 3, 3, "A")
amedia(v1)

v1 <- LETTERS
amedia(v1)

#' 
#' 
#' ### Exemplo II
#' 
#' Os *loops* por meio da expressão `for(){}` e a condicional `if` são muito úteis dentro de funções.
#' Sua função pode, por exemplo, ser construida para que um argumento possa assumir diferentes valores e, a depender do valor, executar uma coisa diferente.
#' Como exemplo, vamos criar uma função que contem o script do exemplo de `if`:
#' 
## ---- eval = TRUE, echo = TRUE------------------------------------------------
# CRIA uma funcao com os seguintes argumentos:
# vet = um vetor de valores
# busca.valor = um valor para busca em vet
# nrun = numero de vezes da iteracao
minhafuncao <- function(vet, busca.valor, nrun) {
  # cria um loop do número de vezes (note o argumento nrun abaixo)
  for (v in 1:nrun) {
    # pega um valor aleatorio
    # amostra o indice aleatoriamente
    idx <- sample(1:length(vet), 1)
    valor <- vet[idx]
    # se o valor amostrado for igual ao valor procurado para
    if (valor == busca.valor) {
      # se o valor selecionado aleatoriamente for 10, ou seja se a expressão valor==10 for TRUE execute:
      # imprima isso
      # print(paste("A primeira vez que o valor 10 foi selecionado aleatoriamente foi quando o objeto v assumiu o valor de",v))
      # interrompa (quebre) o loop
      break # note este argumento
    } else {
      # caso contrario, valor!=10, imprime o valor selecionado e continua o loop
      # print(paste("O valor selecionado foi ",valor,"no indice",v))
    }
  }
  # o valor do objeto v será o último valor assumido na execucao do for(){}, se tiver encontrado será menor que nrun, caso contrario será ==nrun
  # se encontrou retorna o indice do valor (que é o último valor assumido por idx)
  # caso o último valor seja == ao valor buscado, ou que o ultimo v é menor que o especificado em nrun, retorna o indice do valor no vetor vet
  if (v < nrun | valor == busca.valor) {
    print(paste("Encontrei o valor", busca.valor, "no indice, ", idx, "do vetor indicado"))
    return(idx)
  } else {
    # caso contrário returna NA
    print(paste("Não encontrei o valor", busca.valor, "no vetor indicado"))
    return(NA)
  }
}

#' 
#' Vamos utilizar a função recém-criada:
#' 
## ---- eval = TRUE, echo = TRUE------------------------------------------------
umvetor <- sample(10:100, 60, replace = T)
minhafuncao(vet = umvetor, busca.valor = 22, nrun = 1000)
retornou.isso <- minhafuncao(vet = umvetor, busca.valor = 22, nrun = 1000)
# e usar de novo com outros valores
umvetor <- sample(200:300, 50, replace = T)
sort(table(umvetor), decreasing = T)[1:10]
minhafuncao(vet = umvetor, busca.valor = 250, nrun = 10000)
retornou.isso <- minhafuncao(vet = umvetor, busca.valor = 250, nrun = 10000)

#' 
#' ## Para saber mais: {#sabermais-condic}
#' 
#' (1) Acesse vídeoaulas com conteúdo parcial deste capítulo clicando no tópicos abaixo:
#' 
#'   * [Vetores e Operadores Lógicos](http://www.botanicaamazonica.wiki.br/labotam/lib/exe/fetch.php?media=bot89:precurso:6vetores:video01_bot89-2020-04-07_07.52.00.mp4);
#'   
#'   * [Condicionais no R](https://youtu.be/8Z_k02PwQZc)
#' 
#' (2) Auxílio do R - executem a expressão `?Control` no R e vejam a explicação sobre condicionais.  
