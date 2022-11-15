#' # (PART) Parte II {-}
#' 
#' # Checagem dos dados {#aed-checa-dados}
#' 
#' No tutorial abaixo vamos usar dados de avistamento de aves em fisionomias de cerrado.
#' Baixem o arquivo contendo esses dados (https://github.com/LABOTAM/IntroR/blob/main/dados/aves_cerrado.csv) para a sua pasta de trabalho.  
#' 
#' Vamos praticar neste tutorial o uso de funções que nos mostram a estrutura e resumo dos dados.
#' Já vimos como utilizar essas funções na parte I deste livro.
#' 
## 

## * `str()` - mostra a estrutura do objeto dos dados;

## * `head()` e `tail()`- mostra a cabeça ou a cauda da sua tabela de dados, respectivamente;

## * `summary()` - faz um resumo de todas as variáveis nos seus dados.

## 

#' 
#' 
#' Vamos começar importando os dados ao R:
#' 
## ---- eval = FALSE------------------------------------------------------------
## ## Lendo a planilha com read.table
## avesc <- read.table("aves_cerrado.csv", row.names = 1, header = T, sep = ";", dec = ",", as.is = T, na.strings = c("NA", "", "NULL"))

#' 
## ---- include = FALSE---------------------------------------------------------
load("dados/aves_cerrado.rda")

#' 
#' Repare no argumento `na.strings` da função `read.table()`.
#' Ele é importante na importação de dados pois garante a codificação de valores ausentes usando a constante lógica `NA` do R.
#' Se você não definir isso, o padrão é reconhecer apenas células que tenham o texto **NA** como valor faltante.
#' Veja também o uso do argumento `as.is = TRUE`, que indica que não se deve converter colunas de texto em fatores (ou você pode usar o argumento `stringsAsFactors` para isso; este mesmo argumento é utilizado também na função `data.frame()`).
#' Vamos ver as primeiras 10 linhas do objeto `avesc`:
#' 
## -----------------------------------------------------------------------------
head(avesc, 10)

#' Vamos criar uma cópia para usarmos depois.
#' 
## -----------------------------------------------------------------------------
aves2 <- avesc

#' 
#' É sempre bom verificar se os dados foram importados corretamente.
#' É sempre um bom procedimento checarmos as dimensões do objeto com a função `dim()`, primeiras e últimas linhas e colunas do objeto com funções `head()` e `tail()` respectivamente
#' 
## -----------------------------------------------------------------------------
dim(avesc) # a dimensao do objeto (linhas e colunas)
head(avesc, 3) # a cabeca do objeto (tres primeiras linhas)
tail(avesc, 3) # a cauda do objeto (tres ultimas linhas)

#' 
#' 
## -----------------------------------------------------------------------------
avesc[nrow(avesc), ] # ultima linha

#' Parece que está tudo certo!
#' Vamos checar a estrutura do objeto:
#' 
## -----------------------------------------------------------------------------
# mostra a estrutura do data.frame
str(avesc)

#' 
#' Reparem que há uma variável de texto (`chr`) e três variáveis de números inteiros (`int`).
#' Próximo passo é sempre checar um sumário estatístico das variáveis presentes no objeto usando a função `summary()`:
#' 
## ---- eval=FALSE, echo=TRUE---------------------------------------------------
## # mostra um resumo da variacao nas colunas
## summary(avesc)

#' 
## ----eval=TRUE, echo=FALSE----------------------------------------------------
kable(summary(avesc))

#' 
#' 
#' Há indicação de presença de valores `NA` nas variáveis numéricas, que são valores faltantes.
#' 
#' ## Tem valores ausentes?
#' 
## 

## Há valores ausentes em nossos dados?

## Eles são mesmo faltantes?

## Ou seja, o que significam valores ausentes no seu conjunto de dados?

## 

#' 
#' 
#' Podemos utilizar a função `is.na()` para encontrar a constante lógica `NA`, ou seja, a constante que indica valores ausentes (reveja o uso da função `is.na()` na seção \@ref(filtro-dados-ausentes)).
#' Vejam o `?` da constante lógica `NA` para entender o significado dela no R:
#' 
## ---- eval = FALSE------------------------------------------------------------
## ?NA

#' 
#' Continuemos de onde paramos na seção anterior.
#' Vimos que há a presença de `NA` no `data.frame` `avesc`.
#' Chequemos quais registros (linhas) têm valores `NA`.
#' Vamos checar primeiramanete a variável `avesc$urubu`:
#' 
## ---- eval = FALSE------------------------------------------------------------
## avesc$urubu == NA ## erro: não retorna verdadeiro ou falso
## avesc[avesc$urubu == NA, ] ## também não funciona

#' 
#' Reparem que os comandos acima, apesar de funcionarem, não respondem à nossa pergunta que é saber quais linhas possuem `NA`.
#' Para isso, devemos nos valer da função `is.na()`:
#' 
## -----------------------------------------------------------------------------
is.na(avesc) # pergunta em todo o data frame: quem é NA?
!is.na(avesc) # inverte: quem não é NA?
avesc[!is.na(avesc)]

#' 
#' Proceder com o último comando gera um resultado confuso, pois o `data.frame` é convertido em um vetor de dimensão de 236 valores.
#' Podemos investigar da maneira abaixo.
#' Checamos qual é o tamanho total de valores presentes no objeto `avesc`, multiplicando o número de linhas pelo número de colunas através da expressão `(nrow(avesc) * ncol(avesc))`.
#' Temos então um número total de `r (nrow(avesc) * ncol(avesc))` valores possíveis em `avesc`.
#' E comparamos essa valor com o número de valores não faltantes em `avesc` através da expressão `length(avesc[!is.na(avesc)])`, que retorna `r length(avesc[!is.na(avesc)])`. 
#' Portanto, se não houver valores faltantes, a primeira expressão abaixo deve retornar verdadeiro (`TRUE`), e falso (`FALSE`) se houver valores faltantes:
#' 
## -----------------------------------------------------------------------------
(nrow(avesc) * ncol(avesc)) == length(avesc[!is.na(avesc)])

#' 
#' Então quantos valores faltantes existem em nossos dados?
#' 
## -----------------------------------------------------------------------------
# ou então, o número de valores NA no data.frame é de:
(nrow(avesc) * ncol(avesc)) - length(avesc[!is.na(avesc)])

#' O procedimento adotado acima pode ser difícil de entender.
#' Fazer essa pergunta por colunas torna o entendimento mais fácil:
#' 
## -----------------------------------------------------------------------------
is.na(avesc$urubu) # quais são NA, vetor lógico
# mesmo que
is.na(avesc$urubu) == T
# e o contrário é (quem não é NA)
is.na(avesc$urubu) == F
# ou simplesmente
!is.na(avesc$urubu)

#' 
#' Vetores lógicos `TRUE` e `FALSE` podem ser somados. `TRUE` corresponde a 1, e `FALSE` a 0.
#' Usando o resultado de `is.na(avesc$urubu)` (ou qualquer outra variável de `avesc`) junto à função `sum()`, teremos então o número de valores faltantes na variável escolhida:
#' 
## -----------------------------------------------------------------------------
sum(is.na(avesc$urubu)) # quantos sao?
sum(!is.na(avesc$urubu)) # quantos não são?
# e, isso é verdadeiro, né?
(sum(is.na(avesc$urubu)) + sum(!is.na(avesc$urubu))) == nrow(avesc)

#' 
#' Podemos perguntar quais posições do vetor lógico oriundo de `is.na(avesc$urubu)` são correspondentes a `NA` por meio da função `which()`.
#' Teremos como resposta um vetor de números inteiros indicando o número das linhas com valores `NA` na `urubu`:
#' 
## -----------------------------------------------------------------------------
which(is.na(avesc$urubu)) # vetor com indices das posições que são NA

#' 
#' Vamos utilizar agora este resultado para filtrar o `data.frame` `avesc` e checar que linha é essa:
#' 
## -----------------------------------------------------------------------------
avesc[which(is.na(avesc$urubu)), ] # mesma coisa, mas precisa de uma segunda função, então menos parcimonioso

#' 
#' Podemos filtrar também sem a função `which()`, usando apenas os vetores lógicos `TRUE` e `FALSE` oriundos da função `is.na()`:
#' 
## -----------------------------------------------------------------------------
avesc[is.na(avesc$urubu), ] # mostra as linhas completas para os registros com NA na coluna urubu

#' 
#' 
## -----------------------------------------------------------------------------

## para ver se tem NA em uma das tres colunas com nomes de aves: usamos o operador | (quer dizer 'ou')
meufiltro <- is.na(avesc$urubu) | is.na(avesc$carcara) | is.na(avesc$seriema)
sum(is.na(avesc)) # soma dos valores NA nas tres colunas
avesc[meufiltro, ] # mostra todas as linhas que tem algum valor NA

# Esses valores NA, na verdade são AUSENCIA da ave (não avistamento) numa determinada localidade (linha no dado). Portanto, NA neste caso deveria ser de fato 0.

## Então, vamos corrigir estes valores
vl <- is.na(avesc$urubu)
## Podemos ver os valores de vários jeitos
avesc$urubu[vl] # assim
avesc[vl, "urubu"] # ou assim
avesc[, "urubu"][vl] # ou assim...
# se podemos ver, podemos atribuir 0 para esse valor ausentes
avesc$urubu[vl] <- 0

## Continuando, para as outras aves, mostrando variacoes de códigos
avesc$carcara[is.na(avesc$carcara)] <- 0
avesc$seriema[is.na(avesc$seriema) == T] <- 0

## Verificando se substituimos corretamente
avesc[meufiltro, ]

# poderiamos ter feito a mudanca de uma vez
aves2[meufiltro, ] # a cópia que fiz no início
aves2[meufiltro, ][is.na(aves2[meufiltro, ])] # visualizo só os NAs
aves2[meufiltro, ][is.na(aves2[meufiltro, ])] <- 0 # atribuo 0

## Agora esses valores são zero, certo?
avesc[avesc$urubu == 0 | avesc$carcara == 0 | avesc$seriema == 0, ]

#' 
#' ## Colunas com fatores
#' 
## 

## As colunas com fatores estão codificadas corretamente?

## 

#' 
#' 
#' Temos algumas funções úteis para se trabalhar com fatores.
#' A primeira delas se chama `table()` e é responsável por fazer contagens de valores em fatores ou vetores de texto.
#' Já as funções `factor()`  e `as.factor()` permitem criar ou definir fatores.  
#' 
## -----------------------------------------------------------------------------
# agora vamos ver a nossa coluna fisionomia, que não importamos como fator
str(avesc)
avesc$fisionomia
class(avesc$fisionomia)

#' 
#' As categorias da variável `avesc$fisionomia` significam:
#' 
#' * "CL" = campo limpo;
#' * "CC" = campo cerrado;
#' * "Ce" = cerrado.
#' 
#' Vamos tabular essa coluna e verificar quantos valores temos para cada categoria:
#' 
## -----------------------------------------------------------------------------
table(avesc$fisionomia)

#' 
#' Reparem que a categoria `ce` e `Ce` são tratadas como diferentes pois o R^[Isso ocorre na maioria das linguagens de programação. Vejam esta postagem: <https://softwareengineering.stackexchange.com/questions/9965/why-is-there-still-case-sensitivity-in-some-programming-languages>.] interpreta letras minúsculas e maiúsculas diferentemente.
#' A falta de padronização em dados biológicos tabulados é muito frequente, e trabalhar com scripts permite ao usuário documentar todas as mudanças em etapas que precedem o momento da análise.
#' Por isso, fique sempre atento à padronização e a checagem de dados durante a AED.  
#' <!-- Busquem qualquer conjunto de dados próprios e procurem a coluna de nome científico, por exemplo. -->
#' 
#' Antes de proceder com a correção, vamos fazer uma cópia da variável `avesc$fisionomia` para fins deste exercício:
#' 
## -----------------------------------------------------------------------------
fisionomia.copia <- avesc$fisionomia

#' 
#' Digamos que o padrão deve ser `Ce`, então vamos filtrar os valores presentes em `avesc` que não correspondem a `Ce`, isto é, o valor `ce`:
#' 
## -----------------------------------------------------------------------------
vl <- avesc$fisionomia == "ce" # quem tem esse valor
avesc$fisionomia[vl] <- "Ce" # corrigindo
table(avesc$fisionomia)

#' 
#' Tendo em vista que a diferença é apenas de capitalização entre `ce` e `Ce`, poderíamos ter feito simplesmente o exposto abaixo para efeito de correção:
#' 
## -----------------------------------------------------------------------------
avesc$fisionomia <- fisionomia.copia # volto ao valor original

#' 
#' Primeiro, usamos a cópia dos valores originais e o atribuímos aos valores modificados.
#' Em seguida, mudamos a capitalização das palavras para caixa alta com a função `toupper()`.
#' Em seguida, tabulamos as categorias:  
#' 
## -----------------------------------------------------------------------------
# corrijo, simplesmente mudando tudo para maiúsculo:
avesc$fisionomia <- toupper(avesc$fisionomia)
table(avesc$fisionomia)

#' 
#' Porém, se nós tivéssemos importado os dados transformando vetores de texto como fatores, por meio dos argumentos `as.is = FALSE` OU `stringsAsFactors = FALSE`, poderíamos proceder da seguinte maneira:
#' 
## -----------------------------------------------------------------------------
# digamos no entanto, que eu tivesse importado a coluna como fator
avesc$fisionomia <- as.factor(fisionomia.copia)
class(avesc$fisionomia)
levels(avesc$fisionomia) # os níveis ou categorias do fator

#' 
#' 
#' 
## -----------------------------------------------------------------------------
# isso é verdadeiro, certo?:
sort(unique(avesc$fisionomia)) == levels(as.factor(avesc$fisionomia))

# sendo um fator, para corrigir, eu precisaria apenas:
levels(avesc$fisionomia)[2] <- "Ce"
levels(avesc$fisionomia) # pronto, corrigido
table(avesc$fisionomia)

## Verificando novamente
str(avesc)

#' 
## ---- eval=FALSE, echo=TRUE---------------------------------------------------
## summary(avesc)

#' 
## ----eval=TRUE, echo=FALSE----------------------------------------------------
kable(summary(avesc))

