#' # Objeto I - Vetores {#vetores}
#' 
#' ## Vetores e operações vetoriais I
#' 
#' Vetor no R é um tipo de objeto que concatena múltiplos valores de uma mesma classe.
#' É fundamental que você entenda vetores para poder entender objetos mais complexos.  
#' 
#' ### Criação de Vetores
#' 
#' A função `c()` é usada na criação de vetores, pois combina ou concatena elementos.
#' Podemos concatenar números:
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
# um vetor de números
v1 <- c(3, 3.14, pi, 37.5, 38)
v1

#' 
#' Podemos concatenar textos:
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
v2 <- c("a", "banana", "maça", "pera", "jabuticaba")
v2

#' Podemos concatenar valores lógicos (veremos adiante como isso é importante):
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
v3 <- c(TRUE, TRUE, FALSE, FALSE)
v3

#' 
#' Podemos abreviar os valores lógicos `TRUE` como `T` e `FALSE` como `F`:
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
# c(TRUE, TRUE, FALSE, FALSE) e o mesmo que
v4 <- c(T, T, F, F)
v4

#' 
#' Vejamos se `v3` é semelhante a `v4`:
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
v3 == v4

#' 
#' Note que `TRUE` e `FALSE` são valores lógicos e essas palavras são entendidas apenas como tal quando em maiúsculas e sem aspas `"` pelo R.
#' Tente executar o comando abaixo para ver o que acontece quando utilizamos esses valores em letras minúsculas:
#' 
## ---- echo = TRUE, eval = FALSE------------------------------------
## v5 <- c(true, true, false, false)

#' 
#' O R retorna a mensagem de erro `Error: object 'true' not found` pois ele procura pelo primeiro objeto de nosso vetor ` c(true, true, false, false)` na área de trabalho e, ao não encontrar, ele retorna esta mensagem de erro, justamente por não compreender `true` como um vetor lógico, e sim como um objeto!
#' Se nós atribuímos valores a esses objetos, então a concatenação funciona, podendo assim atribuirmos este vetor ao objeto `v5` (ou com qualquer nome que desejamos):
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
true <- TRUE
false <- FALSE
v5 <- c(true, true, false, false)
v5

#' 
#' Há no R valores constantes armazenados em objetos que podem ser chamados a qualquer momento por nós.
#' São objetos que concatenam valores de texto, isto é, são vetores de texto.
#' Vejamos abaixo alguns deles:
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
# essas constantes do R são vetores de texto
LETTERS # letras maiusculas

#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
letters # letras minusculuas

#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
month.abb # meses abreviados

#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
month.name # meses por extenso

#' 
#' ### Sequências Numéricas & Repetições
#' 
#' É possível criar vetores numéricos usando a função `seq()` ou o operador `:`.
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
# usando o :
1:10 # cria uma sequencia de números inteiros 1 a 10

#' 
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
20:0 # cria uma sequencia de números inteiros 20 a 0

#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
0:-20 # cria uma sequencia de números inteiros 0 a -20

#' 
#' usando a função `seq()` temos maior controle das sequências:
#' 
## ---- opts.label='evalF'-------------------------------------------
?seq # veja o help da função

#' 
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
seq(from = 1, to = 10, by = 0.5) # de 1 a 0 a cada 0.5

#' 
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
seq(from = 10, to = 0, by = -0.5) # de 10 a 0 a cada 0.5

#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
seq(from = 100, to = 0, length.out = 10) # 10 valores igualmente espaçados de 100 a 0

#' 
#' É possível criar vetores repetindo valores através da função `rep()`:
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
# para números
rep(5, times = 3) # cria um vetor com três elementos de valor 5

#' 
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
rep(1:5, times = 3) # cria um vetor com três repetições da sequência de 1 a 5

#' 
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
rep(1:5, each = 3) # cria um vetor repetindo três vezes cada elemento da sequência de 1 a 5

#' 
#' Podemos também utilizar a função `rep()` com vetores de texto:
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
# para textos
obj <- c("banana", "maça", "pera")
rep(obj, times = 3)

#' 
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
rep(obj, each = 3)

#' 
#' ## Operações Matemáticas com Vetores
#' 
#' Todas as operações aplicadas a um vetor são aplicadas a cada um de seus elementos:
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
meuvetor <- 1:5 # uma sequencia de 1 a 5
mv2 <- meuvetor * 3 # uma sequencia onde cada valor de meuvetor foi multiplicado por 3
mv2

#' 
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
mv2 <- meuvetor / 3 # uma sequencia onde cada valor de meuvetor foi divido por 3
mv2

#' 
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
# se usar uma função matemática com um vetor ela afetará cada elemento indivualmente
meuvetor <- c(49, 25, 16, 4, 1)
sqrt(meuvetor) # raiz quadrada de cada elemento em meuvetor

#' 
#' Operações com dois ou mais vetores são pareadas.
#' Se os vetores têm o mesmo comprimento (mesmo número de elementos), então a operação é feita par a par, na ordem em que os elementos aparecem no vetor:
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
v1 <- c(1, 5, 10, 15)
v2 <- c(2, 4, 8, 16)
v1 + v2 # soma dos valores individuais e pareados

#' 
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
v1 * v2

#' 
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
v1^v2

#' 
#' ::: {.infobox .idea data-latex="idea"}
#' 
#' **REGRA DA RECICLAGEM** - se os vetores não têm o mesmo comprimento (mesmo número de elementos), então a operação é feita par a par, mas o vetor mais curto é reciclado, i.e. os elementos do vetor mais curto são repetidos sequencialmente até que a operação seja aplicada a todos os elementos do vetor mais longo (o R dará uma aviso quando a operação envolver vetores de tamanhos diferentes, pois às vezes não é isso que queremos).
#' 
#' :::
#' 
#' A mais simples operação para entender a regra da reciclagem é a operação entre um vetor longo e um vetor atômico de um único valor:
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
v1 <- c(1, 5, 10, 15) # vetor com 4 elementos
v2 <- 2 # vetor com 1 elemento
v1 * v2 # cada elemento de v1 é multiplicado pelo único valor do vetor2

#' 
#' 
#' Mas a reciclagem se aplica em todos os casos de operação entre vetores de tamanhos diferentes:
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
v1 <- c(1, 5, 10, 15) # vetor com 4 elementos
v2 <- c(3, 2) # vetor com 2 elemento
v1 * v2 # os valores de v1 são multiplicados par a par pelos valores de v2. Como v2 tem apenas 2 elementos, eles são repetidos 1 vez

#' 
## ---- include = FALSE----------------------------------------------
ob <- rep(c(0, 1), each = 5)
oc <- 1:3

#' 
#' 
#' Quanto temos vetores de tamanhos não múltiplos entre si, como por exemplo o objeto `ob` de tamanho `r length(ob)` e o objeto `oc` de tamanho `r length(oc)`, o R executa a operação, porém retorna uma mensagem de alerta em que diz que o vetor de tamanho maior (`ob`) não é múltiplo do vetor de tamanho menor (`oc`):
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
ob <- rep(c(0, 1), each = 5)
oc <- 1:3
ob * oc

#' 
#' ## Funções com Vetores
#' 
#' Algumas funções operam sobre todo o vetor e não sobre cada elemento individualmente.
#' Essas funções são utilizadas constantemente no R e, portanto, devemos conhecer as principais:
#' 
#' * `length()` e `sort()` - comprimento e ordenação de vetores
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
meuvetor <- 10:1
mv2 <- seq(30, 99, by = 3)
length(meuvetor) # quantos elementos tem meu vetor1

#' 
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
length(mv2) # quantos elementos tem meu vetor2

#' 
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
length(meuvetor) / length(mv2) # operação com os resultados

#' 
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
mvord <- sort(meuvetor) # ordena os elementos em ordem crescente
mvord

#' 
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
sort(mvord, decreasing = TRUE) # ordena os elementos em ordem decrescentes

#' 
#' * `mean()`, `sd()`, `min()`, `sum()` etc. - funções de estatística descritiva:
#' 
## ---- opts.label='evalF'-------------------------------------------
?mean # veja ajuda de uma dessas funções e navegue por outras

#' 
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
v1 <- c(2, 4, 6, 8, 4, 3, 5, 7)
sum(v1) # soma de todos os valores

#' 
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
mean(v1) # média aritimética dos valores
median(v1) # valor da mediana
sd(v1) # desvio padrão
var(v1) # variância
sqrt(var(v1)) # desvio padrão, pois este é a raíz quadrada da variância
min(v1) # valor mínimo
max(v1) # valor máximo
range(v1) # mínimo e máximo
diff(v1) # intervalos (diferenças entre valores consecutivos) entre os valores do vetor
cumsum(v1) # soma cumulativa dos valores

#' 
#' ## Classes de vetores e fatores {#classes}
#' 
#' Para entender os conceitos, vamos primeiro conhecer algumas funções úteis no entendimento das classes de objetos do R e algumas funções importantes: `class()`, `is.[class]()` e `as.[class]()`.  
#' 
#' Vetores têm classes diferentes e todos os elementos de um vetor pertencem à mesma classe.
#' 
#' As principais classes são:
#' 
#' * `numeric` (=double, i.e. inclui casas decimais);
#' 
#' * `integer` (numérico mas de valor inteiro);
#' 
#' * `character` (texto);
#' 
#' * `logical` (verdadeiro ou falso);
#' 
#' * `date` (para datas).
#' 
#' A função `class()` nos permite saber a classe de um objeto do R.
#' 
## ---- opts.label='evalF'-------------------------------------------
?class # veja o help dessa funcao

#' 
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
v1 <- 1:20 # um vetor de números inteiros
class(v1)

v2 <- seq(1, 10, by = 0.5) # um vetor de números
class(v2)

v3 <- rep(c("A", "B"), each = 10) # um vetor de palavras (character)
class(v3)

v4 <- c(T, T, F, F) # um vetor lógico
class(v4)

v4 <- c(10, "A", 20, "B") # um vetor com misto de números e letras será convertido para texto
class(v4)
v4
# veja que em v4 os elementos 10 e 20 viraram palavras, porque vetor só aceita elementos da mesma classe e enquanto um número pode ser convertido em texto, um texto não pode ser convertido em número. Por isso tudo é convertido para texto para a informação seja perdida (i.e. vire NA)

#' 
#' As funções genéricas `is.[class]()` permitem você perguntar se um vetor é de uma determinada classe (`is?`).
#' Ao utilizar essas funções, o R retornará um vetor lógico, ou seja, verdadeiro ou falso dependendo da classe do objeto:
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
v1 <- 1:20 # um vetor de números inteiros
is.integer(v1) # verdadeiro
is.numeric(v1) # também verdadeiro porque números inteiros também são números

v3 <- rep(c("A", "B"), each = 10) # um vetor de palavras
is.character(v3) # verdadeiro
is.numeric(v3) # falso, porque o vetor contém palavras

v4 <- c(10, "A", 20, "B") # um vetor com misto de números e letras
is.numeric(v4) # falso, porque o vetor contém apenas palavras

v4 <- c(T, T, F, F) # um vetor lógico
is.logical(v4) # verdadeiro
is.numeric(v4) # falso
is.character(v4) # falso

#' 
#' As funções genéricas `as.[class]()` (as = 'como uma?') permitem você converter um vetor de uma classe para outra.
#' Em alguns casos, isso faz sentido; em outros, o retorno será de valores inexistentes (`NA`) ou não numéricos (`NaN`).
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
# conversão total
v1 <- 1:20 # um vetor de números inteiros
as.character(v1) # converte para texto um vetor numérico

# conversão parcial
v4 <- c(10, "A", 20, "B") # um vetor com misto de números e letras
as.numeric(v4) # converte cada elemento separadamente (regra da reciclagem é aplicada), o R vai conseguir mudar os textos que são números, mas as letras serão substituídas por NA e um aviso será dado quando isso acontecer

# um vetor de texto não pode virar número
v3 <- rep(c("A", "B"), each = 10) # um vetor de palavras
as.numeric(v3) # todos viram NA pois a conversão é inválida

# mas um vetor lógico pode virar número
v4 <- c(T, T, F, F) # um vetor lógico
as.numeric(v4) # verdadeiro vira 1 e falso vira 0 - isso é muito útil e é por isso que operações matemáticas funcionam com vetores lógicos:
sum(v4)
mean(v4)
min(v4)

#' 
#' O `factor` (=fator) na linguagem do R é um tipo especial de vetor com elementos de texto (classe `character`), em que os valores de texto são categorias.
#' Isso tem algumas vantagens operacionais e sempre que o R precisa de um vetor de texto no formato de `factor`, ele converte automaticamente (se possível).
#' No entanto, é muito importante que você entenda a diferença entre um vetor de classe `character` e um vetor de classe `factor`.
#' Isso vai aparecer o tempo todo enquanto você usa o R e algumas vezes você precisará converter de um para outro.
#' Funções importantes a serem memorizadas são:
#' 
#' * `levels()` - para ver (ou modificar) os níveis ou categorias de um fator;
#' 
#' * `as.factor()` e  `as.vector()` - para converter entre fator e vetor.
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
# um exemplo de um vetor de palavras
mvv <- c("abacate", "banama", "mamão", "uva")
# repetindo cada fruta 3 vezes
mvv <- rep(mvv, each = 3)
# veja conteúdo
mvv

# qual a classe desse vetor?
class(mvv)

# vamos converter esse vetor de character para um fator
mvv2 <- as.factor(mvv)
class(mvv2) # de fato mudou para factor
mvv2 # compare a estrutura deste objeto com mvv (apareceu a a palavra Levels:, que mostra as categorias existentes no fator)
# por ser um fator você pode
levels(mvv2) # você pode ver os níveis do fator, ou seja as categorias que ele contém)
levels(mvv2) <- c("abacate", "banana", "mamão", "uva") # você pode mudar/corrigir os níveis, aqui corrigindo banama por banana
mvv2 # veja como mudaram as categorias e os valores
as.numeric(mvv2) # você pode converter o fator em numérico, de forma que cada categoria vire um número (muito útil isso)
as.numeric(mvv) # nao pode fazer a mesma coisa com um vetor de palavras

#' 
#' A função `as.Date()` converte um vetor de trecho em um objeto de classe `date`.
#' Datas são uma classe especial, que permite operações artiméticas para calcular distâncias temporais.
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
# muitas vezes queremos calcular tempo entre duas observações, como por exemplo, entre duas medições consecutivas num estudo sobre crescimento de plantas

# Qual a diferença em dias entre duas datas?
data1 <- "31/03/1964"
data2 <- "17/04/2016"

#' 
#' 
## ---- echo = TRUE, eval = FALSE------------------------------------
## # eu nao posso simplesmente subtrair esses valores
## data2 - data1

#' 
#' O R retorna uma mensagem de erro (`Error in data2 - data1 : non-numeric argument to binary operator`) porque esses objetos são de classe texto, e operações matemáticas só são permitidas com números ou datas.
#' Vejam que a classe dos objetos criados acima são do tipo "texto" (`character`):
#' 
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
class(data1)
class(data2)

#' Porém, se convertermos esses objetos para a classe `Date`, então poderemos fazer operações matemáticas com eles:
#' 
## ---- echo = TRUE, eval = FALSE------------------------------------
## # mas o R tem um classe para datas
## # entao fazemos a conversao
## ?as.Date # veja o help dessa função

#' 
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
data1 <- as.Date(data1, format = "%d/%m/%Y")
data2 <- as.Date(data2, format = "%d/%m/%Y")
# agora a classe mudou
class(data1)
class(data2)
# posso fazer matemática com data
data2 - data1

# note o argumento format, ele importa para o R possa entender o formato de sua data
data3 <- "2016-04-21" # formato americano
as.Date(data3, format = "%d/%m/%Y") # se eu usasse isso com o mesmo formato acima, o resultado é NA, porque está mal especificado

# mas mudando a simbologia do argumento format
as.Date(data3, format = "%Y-%m-%d")

# ele reconhece

#' 
#' 
#' ## Indexação {#indexacao}
#' 
#' Já vimos que vetores são conjuntos de valores da mesma classe (seção \@ref(vetores)).
#' Esses valores tem uma posição dentro do vetor, ou seja, possuem um **índice**.  
#' Já vimos também que podemos alterar a ordem dos valores, utilizando a função `sort()`, ou seja, alterar a posição dos elementos no vetor.  
#' 
#' O índice identifica os elementos do vetor individualmente:
#' 
#' * pode ser um número equivalente à posição do elemento no vetor,
#' 
#' * ou pode ser um nome, quando os elementos do vetor tiverem um nome.
#' 
#' Entender indexação é fundamental para escrever bons códigos no R, pois isso se aplica também às matrizes e às outras classes de objetos do R. 
#' 
#' Aqui vamos ver indexação de vetores, que é dada pelo operador `[]`.  
#' 
#' ### Usando índices numéricos
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
# um vetor simples
v1 <- 1:10
v1[1] # valor na posição/índice 1
v1[8] # valor na posição/índice 8

# em outra ordem
v1 <- 1:10
v1 <- sort(v1, decreasing = TRUE) # ordena decrescente
v1[1] # valor na posição/índice 1
v1[8] # valor na posição/índice 8

#' 
#' ### Usando índices de nomes
#' 
#' Índices de nomes são elementos essenciais na manipulação de dados reais, pois nomes de linhas (seus registros) e nomes de colunas (suas variáveis) são nomes dos elementos que compõem a sua matriz.
#' Índice de nomes preservam o identificador dos seus objetos (registros).
#' Podemos atribuir nomes aos elementos do vetor usando a função `names()`.
#' Uma outra função útil se chama `paste()`, muito utilizada na manipulação de textos.  
#' 
## ---- opts.label='evalF'-------------------------------------------
?paste # veja o help da função paste
?names # veja o help da função names

#' 
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
# um vetor simples
v1 <- 1:10
# criando um vetor para usar como nomes
v2 <- paste("nome", v1, sep = "") # significa = use a regra da reciclagem e cole (paste) a palavra 'nome' com cada valor do vetor v1, sem separador
v2 # é portanto um conjunto de textos
# note que é muito mais rápido fazer isso do que escrever nome1, nome2 ... nome10, certo?

# agora vamos atribuir v2 como nome dos elementos de v1
# para isso é importante que v1 e v2 tenham o mesmo comprimento
length(v1)
length(v2)

names(v1) # deve ser nulo, pois os elementos não tem nome
names(v1) <- v2 # atribuimos os nomes
v2 # pronto agora os elementos tem nome

# posso usar o nome como índice para pegar elementos
v1["nome8"] # valor do elemento que tem nome = nome8
v1[8] # isso deve ser equivalente, pois criamos os nomes assim

# mas note a diferença quando reordenamos o vetor e mudamos os valores de posição
v3 <- sort(v1, decreasing = T)
v3[8] # o índice numérico pega outro valor
v3["nome8"] # o indice de nome pega o mesmo valor (PRESERVA)

#' 
#' 
#' ## Vetores e operadores lógicos {#vetor-operador-logico}
#' 
#' Para manipular dados no R, entender vetores lógicos e operadores lógicos é fundamental.
#' Vetores lógicos são vetores de verdadeiros (`TRUE` ou apenas `T`, sempre em letras maiúsculas) ou falsos (`FALSE` ou `F`).
#' Eles podem ser convertidos em vetores numéricos e, portanto, operados matematicamente (`T` = 1, e `F` = 0).  
#' 
#' ### Fazendo perguntas à vetores {#perg-vetores}
#' 
#' Vetores lógicos podem ser respostas às perguntas feitas por **operadores lógicos**:
#' 
#' * `>` - é maior que?
#' 
#' * `<` - é menor que?
#' 
#' * `>=` - é maior igual a?
#' 
#' * `<=` - é menor igual a?
#' 
#' * `==` - é igual a?
#' 
#' * `!=` - é diferente de?
#' 
#' * `%in%` - compara conteúdo de vetores
#' 
#' Há ainda a função `duplicated()` que busca valores repetidos em um vetor.
#' O resultado desta função é um vetor contendo `TRUE` ou `FALSE`. 
#' Valores que possuam o valor `TRUE` são duplicados.
#' Para checar os duplicados, devemos filtrar o resultado desta ação (veja na seção \@ref(vetor-filtro-logico)).
#' 
#' <!-- Há funções úteis que auxiliam na filtragem de dados utilizando valores lógicos. -->
#' <!-- A primeira se chama `grep()`, que busca parte de palavras em um vetor, e a segunda chama-se `duplicated()`, que busca valores repetidos.   -->
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
# um vetor numerico
v1 <- 1:20
# quais valores de v1 são maiores ou iguais a 10
p1 <- v1 >= 10 # vai retornar um vetor lógico
p1
# soma dos verdadeiros responde "quantos valores de v1 são maiores ou iguais a 10, pois apenas esses valores são verdadeiros ou seja são 1)
sum(p1)
# experimente os demais operadores

# a regra da reciclagem também se aplica neste conceito
v1 <- 1:20
v2 <- 1:20
p2 <- v1 == v2 # compara cada par dos vetores que são idênticos
p2 # é o vetor lógico resultando, todos os valores são verdadeiros
# portanto, as seguintes expressões também são verdadeiras
sum(v1 == v2) == length(v1)
# ou então
sum(v1 == v2) == length(v2)

# valores duplicados
vv <- c(2, 2, 2, 3, 4, 5)
vv # apenas o dois é duplicado
duplicated(vv) # note que esta função retorna TRUE apenas para dois dos três valores 2 (o primeiro não é duplicado)

# comparando vetores
v1 <- c(1, 2, 3, 4)
v2 <- c(4, 4, 5, 6)
v1 %in% v2 # quantos elementos de v1 existem em v2
sum(v1 %in% v2) # apenas 1
v2 %in% v1 # quais elementos de v2 estão em v1
sum(v2 %in% v1) # os dois quatro

notas.dos.alunos <- c(6.0, 5.1, 6.8, 2.8, 6.1, 9.0, 4.3, 10.4, 6.0, 7.9, 8.9, 6.8, 9.8, 4.6, 11.3, 8.0, 6.7, 4.5)
## Quantos aprovados?
sum(notas.dos.alunos >= 5)
# Qual a proporção de aprovados?
prop <- sum(notas.dos.alunos >= 5) / length(notas.dos.alunos)
prop
# ou em texto
paste(round(prop * 100), "%", sep = "")

#'   
#' Podemos usar também vetores de texto e fatores em conjunto com operadores lógicos.  
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
# E VETORES DE TEXTO?
v1 <- rep(c("banana", "pera", "laranja", "limão"), 10)
v1 # um vetor de palavras
# quantos elementos são iguais a banana
v1 == "banana"
sum(v1 == "banana")
# também poderia perguntar: quantos elementos de v1 contém banana
sum(v1 %in% "banana")
v1 %in% "banana"

# no caso acima == e %in% funcionam igual, mas o operador %in% é util quando quisermos comparar dois vetores de character
v2 <- c("banana", "pera", "abacate")
v1 %in% v2 # quais elementos de v1 correspondem a elementos de v2
sum(v1 %in% v2) # quantos são? 10 laranjas e 10 peras
v2 %in% v1 # quais elementos de v2 estão em v1
sum(v2 %in% v1) # quantos são (apenas laranja e pera, abacate não está)

#' 
#' 
#' Operadores auxiliares permitem combinar perguntas:
#' 
#' * `&` equivale a `E` - essa condição E essa outra;
#' 
#' * `|` equivale a `OU` - essa condição OU essa outra;
#' 
#' * `!` - inverte os valores da pergunta
#' 
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
# um vetor
v1 <- 1:20
v1
p1 <- v1 > 5 & v1 <= 15 # quais elementos de v1 são maiores que 5 E menores ou iguais a 15
sum(p1) # quantos são?
p1 <- v1 > 5 | v1 <= 15 # quais elementos de v1 são maiores que 5 OU menores ou iguais a 15
sum(p1) # quantos são

# !exclamação NEGA ou INVERTE verdadeiros e falsos
v1 <- 1:20
sum(v1 == 5) # quantos v1 são iguais a 5?
sum(!v1 == 5) # quantos v1 são diferentes de 5?

sum(v1 > 5) # quantos v1 são maiores que 5?
sum(!v1 > 5) # quantos v1 são menores que 5?

# texto
v1 <- rep(c("banana", "pera", "laranja", "limão"), 10)
v1 # um vetor de palavras
vl <- v1 == "banana" & v1 == "pera" # quantos elementos de v1 sao banana E sao pera
vl
sum(vl) # nenhum valor satisfaz as duas condicoes

vl <- v1 == "banana" | v1 == "pera" # quantos elementos de v1 sao banana ou sao pera
vl
sum(vl) # tem 20 valores que satisfazem 1 das condições
# isso é o mesmo que pergunta desse outro jeito:
sum(v1 %in% c("banana", "pera"))

#' 
#' ### Filtrando dados com vetores lógicos {#vetor-filtro-logico}
#' 
#' Vetores lógicos podem ser usados como índices (Seção \@ref(indexacao)) para filtrar elementos de um vetor.
#' É através deste conceito que podemos filtrar dados de matrizes e criar subconjunto de dados.  
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
# um vetor com sequencia de 1 a 100
v1 <- 1:100

p1 <- v1 > 15 # Pergunta 1 quantos são maiores que 15
v1[p1] # valores que satisfazem a pergunta 1

p2 <- v1 <= 20 # Pergunta 2 quantos são menores ou iguais a 20
v1[p2] # valores que satisfazem a pergunta 2

# quantos satisfazem as duas perguntas
p3 <- p1 & p2
v1[p2] # valores que satisfazem as duas perguntas

#' 
#' A função `grep()` permite a busca de uma palavra (ou pedaço dela) em um vetor de palavras.
#' Mais de uma palavra pode ser buscada ao mesmo tempo.  
#' 
## ---- opts.label='evalF'-------------------------------------------
?grep # veja o help dessa função e seus argumentos

#' 
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
# um vetor de palavras
v1 <- rep(c("banana", "pera", "laranja", "limão"), 5)
grep("an", v1) # quais elementos tem a palavra 'an' no nome?
# note que é case.sensitive (depende se é maiusculo ou minúsculo)
grep("An", v1) # não encontra nada
grep("An", v1, ignore.case = T) # mas eu posso dizer para ele ignorar se é minusculo ou maiúsculo e ele encontra novamente
# quem sao esses elementos
vl <- grep("An", v1, ignore.case = T) # pega os índices desses elementos
v1[vl]
unique(v1[vl]) # valores únicos desse vetor

#' 
#' ### Perguntando por valores ausentes - NA {#filtro-dados-ausentes}
#' 
#' Vimos anteriormente como o R codifica valores ausentes (seção \@ref(valor-na)): converte em uma classe lógica definida pela palavra `NA` em maiúsculo.
#' E nossos dados frequentemente têm valores ausentes.
#' Isso vai gerar avisos indesejáveis e impedir certas análises.
#' Então, muitas vezes precisamos tirar registros com valores ausentes ou colunas com muitos valores ausentes.  
#' 
#' Perguntar por valores ausentes no R é feito por uma função especial chamada `is.na()`.
#' A resposta da função é um vetor lógico indicando quem é e quem não é `NA`.
#' Há uma outra função chamada `na.omit()` que elimina valores `NA` de um vetor.  
#' 
## ---- opts.label='evalF'-------------------------------------------
?is.na # veja o help

#' 
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
# um vetor com NAs
v1 <- c(NA, NA, 1, 2, 3, 4, 5, 6)
is.na(v1) # quem é NA?
v2 <- v1[!is.na(v1)] # criar um vetor novo com quem não é NA (note o !)
v2

#' 
#' 
## ---- echo = TRUE, eval = FALSE------------------------------------
## # isso também pode ser feito com na.omit()
## ?na.omit # veja o help dessa função

#' 
#' 
## ---- echo = TRUE, eval = TRUE-------------------------------------
v3 <- na.omit(v1)
v3 # a diferença é que criou um objeto de classe na.omit
v3 <- as.vector(v3) # isso elimina a diferença, convertendo em vetor
v3 # agora é idêntico a v2

# agora suponha o seguinte vetor
v4 <- c("NA", "NA", "pera", "banana", "mamão")
is.na(v4) # ops todos são falsos
# isso porque "NA" é texto e não um objeto de classe lógica
class(NA)
class("NA")
# mas eu poderia corrigir isso
v4[v4 == "NA"] # vejo
v4[v4 == "NA"] <- NA # corrijo
v4
is.na(v4) # agora dois são NAs
# note que agora todos são diferentes de "NA" como texto
v4[!v4 == "NA"]
# mas isso de mostra quem não é corretamente
v5 <- v4[!is.na(v4)]
v5

#' 
#' ## Para saber mais: {#sabermais-vetores}
#' 
#' Veja nossas vídeoaulas com parte do conteúdo deste capítulo:
#' 
#' * [Criação de vetores](https://youtu.be/qXSZkGoDk1Y).
#' * [Sequências numéricas e repetições](https://youtu.be/PJ02yj0gnWc).
#' * [Indexação](http://www.botanicaamazonica.wiki.br/labotam/lib/exe/fetch.php?media=bot89:precurso:5vetores:video01_bot89-2020-04-07_07.38.30.mp4).
#' * [Vetores e Operadores Lógicos](http://www.botanicaamazonica.wiki.br/labotam/lib/exe/fetch.php?media=bot89:precurso:6vetores:video01_bot89-2020-04-07_07.52.00.mp4).
#' 
#' ## Exercícios
#' 
#' * Resolva o exercício [102.04 Biomassa de Árvores](http://notar.ib.usp.br/exercicio/19).
#' * Resolva o exercício [102.02 Sequências](http://notar.ib.usp.br/exercicio/12).
#' * Resolva o exercício [102.03 Conta de Luz](http://notar.ib.usp.br/exercicio/4).
#' * Resolva o exercício [102.01 Área Basal](http://notar.ib.usp.br/exercicio/17).
#' * Resolva o exercício [102.05 Variância na Unha](http://notar.ib.usp.br/exercicio/5).
#' * Resolva o exercício [101.03 Objetos de Data](http://notar.ib.usp.br/exercicio/18).
#' 
