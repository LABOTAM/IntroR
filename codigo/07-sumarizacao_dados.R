#' # Sumarização de dados {#sumar-dados}
#' 
#' ## Tabelas dinâmicas {#tabela-dinamica}
#' 
#' A função `tapply()` calcula alguma funcão sobre um vetor numérico para cada categoria de um fator.
#' Já a função `aggregate()` faz o mesmo, mas permite múltiplos fatores e sempre retorna um `data.frame`.  
#' 
#' Vamos usar dados de parcelas em [caixetais](http://www.botanicaamazonica.wiki.br/labotam/lib/exe/fetch.php?media=disciplinas:bot89_2015:caixeta.csv), formações dominadas por *Tabebuia cassinoides* (Lam.) D.C. (Bignoniaceae), espécie comum da Mata Atlântica nos estados de São Paulo, Minas Gerais, Rio de Janeiro e Espírito Santo.
#' Baixe o arquivo para seu computador e instale-o na sua pasta de trabalho antes de seguir com os comandos abaixo.  
#' 
## ---- opts.label='evalF'------------------------------------------------------
caixeta <- read.table("caixeta.csv", sep = ",", header = T)

#' 
## ---- include = FALSE, message=FALSE------------------------------------------
load("dados/caixeta.rda")

#' 
#' 
## -----------------------------------------------------------------------------
names(caixeta)

#' 
#' 
## ---- opts.label='evalF'------------------------------------------------------
## tapply: resumo de uma variavel numerica, separada por niveis de um ou mais fatores
?tapply # veja o help dessa função

#' 
#' 
## -----------------------------------------------------------------------------
# altura máxima de cada especie
tapply(caixeta$h, INDEX = caixeta$especie, FUN = max)

# circunferencia media por localidade
tapply(caixeta$cap, INDEX = caixeta$local, FUN = mean)

## "Tabelas dinamicas": funcao aggregate
## Criar data.frame com altura media dos fustes por especie e por local

#' 
#' 
## ---- opts.label='evalF'------------------------------------------------------
?aggregate # veja o help dessa função

#' 
#' 
## -----------------------------------------------------------------------------
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
#' 
#' ## Tabelas de contagem
#' 
#' Vamos usar utilizar os mesmos dados de caixetas utilizados na seção \@ref(tabela-dinamica).
#' A função `table()` permite contar valores em fatores e vetores.  
#' 
## ---- opts.label='evalF'------------------------------------------------------
caixeta <- read.table("caixeta.csv", sep = ",", header = T)

#' 
#' 
## -----------------------------------------------------------------------------
names(caixeta)
# tem a coluna especie

# podemos resumir quantos individuos tem de cada espécie (considerando que cada linha é um individuo)
table(caixeta$especie)
# mostra as tres especies mais abundantes
sort(table(caixeta$especie), decreasing = T)[1:3]

# quantos individuos por localidade?
table(caixeta$local)

# especie por localidade
tb <- table(caixeta$especie, caixeta$local)
head(tb, 3) # mostra as tres primeiras linhas

# tabela de presenca e ausencia de especie por localidade
tb <- table(caixeta$especie, caixeta$local)
# quem tem mais de 0 individuos está presente
# portanto, substituo por 1
tb[tb > 0] <- 1
head(tb)

# sendo assim, posso ver o numero de especie por localidade aplicando a suma das linha que tem 1 para cada coluna
apply(tb, 2, sum)

#' 
#' 
#' ## Lógica da junção de tabelas
#' 
#' Unir tabelas é uma prática corriqueira com bases de dados.
#' É comum termos dados relacionados em tabelas diferentes, recurso que minimiza a entrada de redundância e portanto de erros nos nossos dados.  
#' 
#' É frequente também a necessidade de ter esses dados reunidos em uma só tabela.
#' Para unir tabelas, é necessário que duas tabelas diferentes possuam uma coluna em comum, a quem vamos chamar de **identificador**.
#' Vamos criar aqui uma situação artificial com os dados `iris`, mas imagine uma situação mais complexa com muitos dados.
#' 
#' 
## -----------------------------------------------------------------------------
# uma tabela com os nomes das especies
spp <- unique(data.frame(
  GENUS = "Iris",
  SPECIES = iris$Species,
  stringsAsFactors = F
))
spp$fullname <- paste(spp$GENUS, spp$SPECIES)
spp

#' 
#' Vamos adicionar uns dados ao objeto `spp`.
#' Para isso, utilizaremos o pacote `taxize` [@R-taxize] para buscar nomes de espécies na rede.
#' Para fazer uso da função `tp_search()`, é necessário ter uma [chave API](https://en.wikipedia.org/wiki/Application_programming_interface_key), que nada mais é que uma senha para que você possa acessar serviços na rede sem a necessidade de um navegador.
#' Nós utilizamos uma chave obtida junto ao [Tropicos.org](https://www.tropicos.org/), base de dados do Jardim Botânico do Missouri (Missouri Botanical Garden).
#' O pacote `taxize` oferece uma função chamada `use_tropicos()` que abre o navegador na página de solicitação da chave API.
#' Você pode executar o comando, preencher o formulário e aguardar por sua chave:
#' 
## ---- eval = FALSE------------------------------------------------------------
## use_tropicos()

#' 
#' Para este exemplo, guardamos nossa chave API em um objeto chamado `tropicos_key` que, por motivos óbvios, não mostraremos aqui o que ele guarda:
#' 
## ---- opts.label='evalF'------------------------------------------------------
# install.packages("taxize")
library("taxize") # instale se nao tiver
sppinfo <- sapply(spp$fullname, tp_search, key = tropicos_key, type = "exact")

#' 
#' O resultado de nossa pesquisa foi estocado no objeto `sppinfo`.
#' Vamos pegar as colunas obtidas para todos os nomes:
#' 
## ---- include = FALSE---------------------------------------------------------
load("dados/sppinfo.rda")

#' 
## -----------------------------------------------------------------------------
keys <- table(unlist(lapply(sppinfo, names)))
keys <- names(keys[keys == length(sppinfo)])
keys

#' 
#' Juntemos agora tudo em um único `data.frame`:
#' 
## -----------------------------------------------------------------------------
sppinfo <- as.data.frame(do.call(mapply, c(FUN = c, lapply(sppinfo, `[`, keys))), stringsAsFactors = F)
sppinfo

#' 
#' Vamos excluir os nomes ilegítimos:
#' 
## -----------------------------------------------------------------------------
sppinfo <- sppinfo[-grep("illeg", sppinfo$nomenclaturestatusname, ignore.case = T), ]
sppinfo

#' 
#' Vamos agora criar um identificador compartilhado entre as tabelas:
#' 
## -----------------------------------------------------------------------------
sppinfo$Species <- gsub("Iris ", "", sppinfo$scientificname)

#' 
#' Vamos bagunçar a ordem dos dados em `sppinfo` para mostrar como se procede a junção de tabelas:
#' 
## -----------------------------------------------------------------------------
set.seed(4857)
sppinfo <- sppinfo[sample(1:3), ]
rownames(sppinfo) <- sppinfo$Species

#' 
#' Agora temos dois conjuntos de dados que em comum possuem a coluna `Species`, mas apresentam linhas diferentes:
#' 
## -----------------------------------------------------------------------------
sppinfo

#' 
#' 
## -----------------------------------------------------------------------------
head(iris)

#' 
#' Suponhamos que você queira adicionar à tabela `iris` uma coluna com informação que está na tabela sppinfo.
#' Podemos pensar em duas maneiras de executar esta ação.
#' 
#' ### Maneira 1 - função `match()` {#juncao-tbl-maneira1}
#' 
#' Pegaremos as linhas da tabela `sppinfo` com correspondência a cada linha da tabela `iris`.
#' Para isso, devemos ter o **índice** da tabela `sppinfo` segundo o valor da coluna `Species`, que é o identificador em comum entre as duas tabelas:
#' 
## -----------------------------------------------------------------------------
idxinfo <- match(iris$Species, sppinfo$Species)

#' 
#' Guardamos esta correspondência no vetor `idxinfo`, que possui o mesmo comprimento que o número de linhas que `iris` e contem o número das linhas (os **índices**!) da tabela `sppinfo`:
#' 
## -----------------------------------------------------------------------------
# assim, seguindo indexacao numerica eu posso pegar informacoes da tabela sppinfo e colocar na tabela iris
iris$speciesComAutor <- sppinfo$scientificnamewithauthors[idxinfo]
head(iris)

#' 
#' Agora, vamos unir as duas tabelas:
#' 
## -----------------------------------------------------------------------------
novoiris <- cbind(iris, sppinfo[idxinfo, ])
head(novoiris)

#' 
#' ### Maneira 2 - índices nominais
#' 
#' A tabela `sppinfo` contem nomes de linhas que correspondem aos valores que estão na coluna `iris$Species`.
#' Portanto, para fazer a mesma coisa que fizemos na [maneira 1](#juncao-tbl-maneira1), nós poderíamos simplesmente filtrar através dos nomes das linhas da tabela `sppinfo`:
#' 
## -----------------------------------------------------------------------------
iris$speciesComAutor <- sppinfo[iris$Species, ]$scientificnamewithauthors
# juntando as duas tabelas  completas
novoiris <- cbind(iris, sppinfo[iris$Species, ])
novoiris

#' 
#' ## Junção de tabelas utilizando funções^[Texto publicado originalmente no blog de R.O.Perdiz (https://ricardoperdiz.com/post/2020_04_23_r-juncao-tabelas/juncao-tbl/)]
#' 
## ----setup-juncao-tabelas, eval = TRUE, include = FALSE-----------------------
colorize <- function(x, color) {
  if (knitr::is_latex_output()) {
    sprintf("\\textcolor{%s}{%s}", color, x)
  } else if (knitr::is_html_output()) {
    sprintf(
      "<span style='background: %s;'>%s</span>", color,
      x
    )
  } else {
    x
  }
}
# carrega pacotes
library("knitr")
library("kableExtra")
library("magrittr")

#' 
#' O pacote `base` do R fornece uma função que executa essa ação, chamada `merge()`.
#' Porém, há alguns tipos de junções não podem ser executados com esta função, o que nos levará ao uso de vetores lógicos em conjunto com a função `interaction()`.
#' <!-- Podemos executar também as mesmas operações usando vetores lógicos e a função `match()`. -->
#' Daremos exemplos com essas duas novas maneiras.
#' 
#' ### Dados para nossa prática
#' 
#' Utilizaremos três tabelas para esta prática:
#' 
#' (@) O `data.frame` `tab1` possui nomes de famílias, gêneros e epítetos específicos de algumas angiospermas:
#' 
## ---- opts.label='executa_mostra'---------------------------------------------
familia <- c("Burseraceae", "Solanaceae", "Sapindaceae", "Rubiaceae", "Lauraceae")
generos <- c("Protium", "Trattinnickia", "Dacryodes", "Duckeodendron", "Markea", "Solanum", "Allophylastrum", "Cupania", "Thinouia", "Psychotria", "Duroia", "Cinchona", "Ocotea", "Licaria", "Rhodostemonodaphne", "Anisophyllea", "Freziera")
epitetos <- c("aracouchini", "burserifolia", "edilsonii", "cestroides", "ulei", "cyathophorum", "frutescens", "rubiginosa", "myriantha", "viridis", "eriopila", "amazonica", "delicata", "aureosericea", "recurva", "manausensis", "carinata")
tab1 <- data.frame(familia = c(rep(familia, each = 3), "Anisophylleaceae", "Pentaphylacaceae"), genero = generos, epiteto = epitetos, stringsAsFactors = FALSE)

#' 
## ---- opts.label='executa'----------------------------------------------------
kable(tab1, caption = "Tabela 1")

#' 
#' (@) O `data.frame` `tab2` contem um conjunto pequeno com alguns nomes de famílias, gêneros, e o nome de seus respectivos clados acima dos nomes de ordens segundo o @APG:
#' 
## ---- opts.label='executa_mostra'---------------------------------------------
familia2 <- c("Burseraceae", "Solanaceae", "Sapindaceae", "Rubiaceae", "Annonaceae")
generos2 <- c("Protium", "Duckeodendron", "Thinouia", "Psychotria", "Guatteria")
clado <- c("Malvids", "Lamiids", "Malvids", "Lamiids", "Magnoliids")
tab2 <- data.frame(familia = familia2, genero = generos2, clado = clado, stringsAsFactors = FALSE)

#' 
## ---- opts.label='executa'----------------------------------------------------
kable(tab2, caption = "Tabela 2")

#' 
#' 
#' (@) O `data.frame` `tab3` corresponde à tabela 2, `tab2`, sem as famílias Solanaceae e Rubiaceae:
#' 
## ---- opts.label='executa_mostra'---------------------------------------------
tab3 <- subset(tab1, familia %in% c("Burseraceae", "Sapindaceae"))

#' 
## ---- opts.label='executa'----------------------------------------------------
kable(tab3, caption = "Tabela 3", row.names = FALSE)

#' 
#' ### Maneira 3 - função `merge()`
#' 
#' O básico para entender a função `merge()` é saber que existem dois argumentos, `x` e `y`, que correspondem aos `data.frames` de entrada.
#' Quando unimos tabelas, existem junções que adicionam variáveis, e junções que filtram variáveis.
#' Vamos ver abaixo 4 tipos da primeira ( [junção interna](#interna), [junção à esquerda](#esquerda), [junção à direita](#direita), [junção total](#total)), e dois tipos desta última ( [semijunção](#semi) e [antijunção](#anti)).
#' 
#' #### Junção interna {#interna}
#' 
#' ::: {.infobox .idea data-latex="idea"}
#' 
#' 
#' Ao juntarmos tabelas `x` e `y`, temos todas as linhas de `x` em que há valores em comum com `y`, e todas as colunas de `x` e `y`. Se houver múltiplas *correspondências* entre `x` e `y`, todas as combinações retornam.
#' 
#' :::
#' 
#' 
#' ![](https://www.sqlfromhell.com/wp-content/uploads/2018/06/inner-join.png)
#' 
#' Em nosso exemplo, vamos unir as tabelas 1 e 2.
#' Ambas possuem em comum os identificadores `familia` e `genero`.
#' Para facilitar o entendimento, vamos verificar primeiro cada tabela com cores para checar as correspondências entre `x` e `y` nas variáveis em comum:
#' 
## ----junc-interna, opts.label='executa'---------------------------------------
tab1 %>%
  dplyr::mutate(
    familia = cell_spec(familia, "html", background = ifelse(familia %in% tab2$familia, "yellow", "red")),
    genero = cell_spec(genero, "html", background = ifelse(genero %in% tab2$genero, "yellow", "red"))
  ) %>%
  kable(., caption = "Tabela 1", format = "html", escape = FALSE) %>%
  kable_styling(full_width = F, position = "left") # %>% as_image(., width = 3, height= 3, file = "./juncao-interna_tab1.png")

tab2 %>%
  dplyr::mutate(
    familia = cell_spec(familia, "html", background = ifelse(familia %in% tab1$familia, "yellow", "red")),
    genero = cell_spec(genero, "html", background = ifelse(genero %in% tab1$genero, "yellow", "red"))
  ) %>%
  kable(., caption = "Tabela 2", format = "html", escape = FALSE) %>%
  kable_styling(full_width = F, position = "left") # %>% as_image(., width = 3, height= 3, file = "./juncao-interna_tab2.png")

#' 
#' Reparem que os valores em que há correspondência entre `x` e `y` estão coloridos de `r colorize("amarelo", "yellow")`; para os em que não há correspondência, estão coloridos de `r colorize("vermelho", "red")`.
#' Agora, executemos a junção das duas tabelas:  
#' 
## ---- opts.label='executa_mostra'---------------------------------------------
merge(x = tab1, y = tab2)

#' 
#' Vejam que houve a incorporação dos valores da coluna `epiteto`, presente apenas na tabela 2, em que há correspondência entre as tabelas 1 e 2.
#' É importante notar que as famílias `r colorize("Lauraceae, Anisophylleaceae, e Pentaphylacaceae", "red")` ficaram de fora, pois não são encontradas na tabela `y`, isto é, a tabela 2, assim como seus respectivos gêneros e epítetos associados a estes.
#' Gêneros presentes na tabela 1 de famílias em comum entre ambas as tabelas também não foram incorporados nessa junção, pois nãp encontram correspondência na tabela 2: `r colorize("Dacryodes, Trattinnickia, Markea, Solanum, Allophylastrum, Cupania, Duroia, Cinchona", "red")`.
#' Revejam o conceito de [junção interna](#interna) para entender o porquê desse acontecimento.  
#' 
#' #### Junção à esquerda {#esquerda}
#' 
#' 
#' ::: {.infobox .idea data-latex="idea"}
#' 
#' Ao juntarmos tabelas `x` e `y`, temos todas as linhas de `x`, e todas as colunas de `x` e `y`. Linhas em `x` sem correspência em `y` terão valores `NA` adicionados nas novas colunas. Se houver múltiplas *correspondências* entre `x` e `y`, todas as combinações retornam.
#' 
#' :::
#' 
#' 
#' ![](https://www.sqlfromhell.com/wp-content/uploads/2018/06/left-join.png)
#' 
#' Continuaremos utilizando as tabelas 1 e 2.
#' Como mostrado anteriormente, ambas possuem em comum os identificadores `familia` e `genero`.
#' Chequemos novamente as cores das correspondências dentro de cada identificador, coloridas em `r colorize("amarelo", "yellow")`:
#' 
## ----junc-esq, opts.label='executa'-------------------------------------------
kable(tab1, caption = "Tabela 1") %>%
  kable_styling(full_width = F, position = "left") %>%
  column_spec(1:3, background = "yellow") # %>% as_image(., width = 3, height= 3, file = "./juncao-esquerda_tab1.png")

tab2 %>%
  dplyr::mutate(
    familia = cell_spec(familia, "html", background = ifelse(familia %in% tab1$familia, "yellow", "red")),
    genero = cell_spec(genero, "html", background = ifelse(genero %in% tab1$genero, "yellow", "red")),
    clado = cell_spec(clado, "html", background = ifelse(tab2$genero %in% tab1$genero, "yellow", "red"))
  ) %>%
  kable(., caption = "Tabela 2", format = "html", escape = FALSE) %>%
  kable_styling(full_width = F, position = "left") # %>% as_image(., width = 3, height= 3, file = "./juncao-esquerda_tab2.png")

#' 
#' Em uma junção à esquerda, todas as linhas de `x` retornam após a junção.
#' Para executar este tipo de junção, acrescentaremos um novo argumento, `all.x = TRUE`, indicando que manteremos todas as linhas de `x`, isto é, o `data.frame` à esquerda, que é a tabela 1.
#' 
## ---- opts.label='executa_mostra'---------------------------------------------
merge(x = tab1, y = tab2, all.x = TRUE)

#' 
#' Agora, temos uma nova situação. Para os valores de `x` sem correspondência em y, valores `NA` são acrescentados.
#' Reparem na coluna `clado` e vejam que isso ocorreu apenas nesta variável.
#' Por exemplo, vejam a família Anisophylleaceae. Ela ocorre apenas na tabela 1 e, portanto, não possui nenhum valor de `clado`a ssociado a ela, pois esta variável ocorre apenas na tabela 2. Com a junção das tabelas, essa variável é retida, porém sem a existência de um valor para a família, é inserido então o valor `NA`.
#' Temos também o caso de Annonaceae, presente na tabela 2. A família não é recuperada na junção interna, pois ela não existe na tabela 1 dentro da variável `familia` e, portanto, não apresenta correspondência com nenhum dado da tabela 1.
#' Revejam o conceito de [junção à esquerda](#esquerda) para entender o porquê desse acontecimento.  
#' 
#' #### Junção à direita {#direita}
#' 
#' ::: {.infobox .idea data-latex="idea"}
#' 
#' Ao juntarmos tabelas `x` e `y`, temos todas as linhas de `y`, e todas as colunas de `x` e `y`.Linhas em `y` sem correspência em `x` terão valores NA adicionados nas novas colunas. Se houver múltiplas *correspondências* entre `x` e `y`, todas as combinações retornam.
#' 
#' :::
#' 
#' 
#' ![](https://www.sqlfromhell.com/wp-content/uploads/2018/06/right-join.png)
#' 
#' De maneira oposta à junção à esquerda, na junção à direita são mantidas todas as linhas de `y`.
#' Desta vez, o argumento a ser utilizado é `all.y = TRUE`.
#' Antes de executar a junção, vamos checar novamente as variáveis em comum e correspondências entre as tabelas `x` e `y`:
#' 
## ----junc-dir, opts.label='executa'-------------------------------------------
tab1 %>%
  dplyr::mutate(
    familia = cell_spec(familia, "html", background = ifelse(familia %in% tab2$familia, "yellow", "red")),
    genero = cell_spec(genero, "html", background = ifelse(genero %in% tab2$genero, "yellow", "red")),
    epiteto = cell_spec(epiteto, "html", background = ifelse(tab1$genero %in% tab2$genero, "yellow", "red"))
  ) %>%
  kable(., caption = "Tabela 1", format = "html", escape = FALSE) %>%
  kable_styling(full_width = F, position = "left") # %>% as_image(., width = 3, height= 3, file = "./juncao-direita_tab1.png")

kable(tab2, caption = "Tabela 2") %>%
  kable_styling(full_width = F, position = "left") %>%
  column_spec(1:3, background = "yellow") # %>% as_image(., width = 3, height= 3, file = "./juncao-direita_tab2.png")

#' 
#' Agora executaremos a junção com o comando abaixo.
#' Não deixem de reparar no uso do argumento `all.y = TRUE`, pois ele é o responsável por agora manter todas as linhas da tabela 2 (== `y`):
#' 
## ---- opts.label='executa_mostra'---------------------------------------------
merge(x = tab1, y = tab2, all.y = TRUE)

#' 
#' Notem que agora todos os dados da tabela 2 foram mantidos.
#' Houve a inserção de um valor `NA` para a família Annonaceae na variável `epiteto`, pois esta variável não está presente na tabela 2.
#' Revejam o conceito de [junção à direita](#direita) para entender o porquê desse acontecimento.  
#' 
#' #### Junção total {#total}
#' 
#' ::: {.infobox .idea data-latex="idea"}
#' 
#' Ao juntarmos tabelas `x` e `y`, temos todas as linhas e colunas de `x` e `y`. Onde não houver valores correspondentes, valores `NA` serão colocados nesses lugares.
#' 
#' :::
#' 
#' 
#' ![](https://www.sqlfromhell.com/wp-content/uploads/2018/06/outer-join.png)
#' 
#' Em uma junção total, uniremos todas as linha de `x` e `y` utilizando o argumento `all = TRUE`.
#' 
## ---- opts.label='executa_mostra'---------------------------------------------
merge(x = tab1, y = tab2, all = TRUE)

#' 
#' Reparem que valores `NA` são colocados nos valores da tabela 2 referentes à coluna `epiteto`, ausente na tabela 1.
#' O mesmo se passa com valores da coluna `clado`, presente na tabela 2 e ausente na tabela 1.
#' Revejam o conceito de [junção total](#total) para entender o porquê desse acontecimento.  
#' 
#' #### Semijunção {#semi}
#' 
#' ::: {.infobox .idea data-latex="idea"}
#' 
#' Ao juntarmos tabelas `x` e `y`, temos todas as linhas de `x` onde houver valores correspondentes em `y`, mantendo apenas colunas de `x`. É parecida com a junção interna, porém difere desta por nunca duplicar valores de `x`, retornando sempre apenas valores de `x` que houver uma correspondência em `y`.
#' 
#' :::
#' 
#' 
#' ![](https://www.sqlfromhell.com/wp-content/uploads/2018/06/left-anti-semi-join.png)
#' 
#' A semijunção é muito similar à junção interna, diferindo desta por não incorporar as colunas de `y`, pois apenas utiliza esta tabela para filtrar os dados de `x`, constituindo-se então em um tipo de junção que filtra variáveis.
#' Neste exemplo, utilizaremos as tabelas 1 e 3.
#' Ambas compartilham as colunas `familia` e `genero`.
#' Vamos checar primeiramente cada tabela e ver o que é compartilhado entre cada uma:
#' 
## ----semi-junc, opts.label='executa'------------------------------------------
tab1 %>%
  dplyr::mutate(
    familia = cell_spec(familia, "html", background = ifelse(familia %in% tab3$familia, "yellow", "red")),
    genero = cell_spec(genero, "html", background = ifelse(genero %in% tab3$genero, "yellow", "red")),
    epiteto = cell_spec(epiteto, "html", background = ifelse(tab1$genero %in% tab3$genero, "yellow", "red"))
  ) %>%
  kable(., caption = "Tabela 1", format = "html", escape = FALSE) %>%
  kable_styling(full_width = F, position = "left") # %>% as_image(., width = 3, height= 3, file = "./juncao-semi_tab1.png")

kable(tab3, caption = "Tabela 3", row.names = FALSE) %>%
  kable_styling(full_width = F, position = "left") %>%
  column_spec(1:3, background = "yellow") # %>% as_image(., width = 3, height= 3, file = "./juncao-semi_tab3.png")

#' 
#' ##### Maneira 4 - vetores lógicos e a função `interaction()`
#' 
#' Para executar uma semijunção com o pacote `base` do R, devemos fazer uso de vetores lógicos e da função `interaction()`, pois a função `merge()` não fornece uma maneira de se obter o que desejamos.  
#' 
#' Vamos então à prática^[Esta solução de semijunção é baseada no tutorial do pacote [poorman](https://nathaneastwood.github.io/2020/03/08/poorman-replicating-dplyrs-join-and-filter-join-functions-with-base-r/), recém-criado para emular as funções do pacote [dplyr](https://github.com/tidyverse/dplyr).].
#' As colunas compartilhadas por ambas as tabelas serão nossas `chaves`:
#' 
## ---- opts.label='executa_mostra'---------------------------------------------
chaves <- c("familia", "genero")

#' 
#' Partimos então para filtrar na tabela 1 a combinação de linhas para esse conjunto de colunas utilizando a função `interaction()` do pacote `base` do R:
#' 
## ---- opts.label='executa_mostra'---------------------------------------------
interaction(tab1[, chaves])

#' 
#' Essa função computa um vetor de fatores que representa a interação das colunas fornecidas na tabela 1.
#' Se fizermos isso com a tabela 3, poderemos saber quais combinações ocorrem em ambas as tabelas.
#' 
## ---- opts.label='executa_mostra'---------------------------------------------
interaction(tab3[, chaves])

#' 
#' Agora utilizamos a mesma função `interaction` e o operador `%in%` para retornar um vetor lógico que utilizaremos para filtrar os valores da tabela 1 com correspondência na tabela 3.
#' 
## ---- opts.label='executa_mostra'---------------------------------------------
linhas <- interaction(tab1[, chaves]) %in% interaction(tab3[, chaves])
linhas

#' 
## ---- opts.label='executa_mostra'---------------------------------------------
tab1[linhas, ]

#' 
#' 
#' #### Antijunção {#anti}
#' 
#' ::: {.infobox .idea data-latex="idea"}
#' 
#' Retorna todas as linhas de `x` em que não há correspondência em `y`, mantendo apenas colunas de `x`.
#' 
#' :::
#' 
#' 
#' ![](https://www.sqlfromhell.com/wp-content/uploads/2018/06/right-anti-semi-join.png)
#' 
#' Uma antijunção é ligeiramente diferente de uma semijunção pois ela retorna todas as linhas de `x` que não aparecem em y.
#' Portanto, podemos utilizar o inverso de nosso vetor lógico `linhas` e utilizar este inverso para filtrar as linhas da tabela 1 e ter nossa tabela antijunção entre `x` e `y`:
#' 
## ---- opts.label='executa_mostra'---------------------------------------------
antilinhas <- !linhas
tab1[antilinhas, ]

#' 
#' 
#' ## Para saber mais
#' 
#' * [Join in R](http://www.datasciencemadesimple.com/join-in-r-merge-in-r/);
#' * [Tudo sobre Joins (merge) em R](https://www.fulljoin.com.br/posts/2016-05-12-tudo-sobre-joins/);
#' * [Join com dplyr](https://rpubs.com/CristianaFreitas/311735);
#' * [Entendendo o JOIN do SQL (ou Junções)](https://www.sqlfromhell.com/entendendo-join-sql/) - Obtive as imagens aqui apresentadas desta página. Há uma boa explicação com SQL como pano de fundo para operações de junções de tabela.
