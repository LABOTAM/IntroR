#' # Extraindo dados de colunas descritivas {#extr-dados}
#' 
#' Na compilação de dados de especímenes botânicos, informações sobre a planta e o habitat estão em geral anotadas na forma de textos (notas), num formato pouco útil para entender os atributos dos organismos.
#' Os scripts aqui relacionados mostram exemplos de como extrair informações dessas colunas descritivas, categorizando informações de **habito**, **fertilidade**, **textura do solo**, **habitat**, **dap**, **altura**.  
#' 
#' ## Dados categóricos
#' 
#' A lógica básica é simples.
#' Para cada tipo de informação (variável), buscaremos por um conjunto de palavras e suas variantes, e substituiermos todas elas por uma única palavra, criando estados de variação (**categorias**).
#' É importante pensar na ordem em que a busca é feita, pois em algumas notas descritivas duas palavras podem ser encontradas e você quer apenas uma delas.
#' Por exemplo, na busca por hábito você deveria buscar a palavra `epífita` antes da palavra `árvore`, porque se a coleta for de uma planta `epífita`, a palavra `árvore` pode aparecer como hospedeiro.
#' Não precisa se preocupar com acentos nem se a palavra está em caixa alta ou baixa.
#' Criaremos uma função para ignorar isso nas comparações.
#' 
#' ### Passo 01 - Lista de referência
#' 
#' Você cria uma lista de referencia (veja a seção \@ref(listas-ref) para exemplos de listas de referência) para cada variável que quer buscar, composta de vetores com palavras ou parte de palavras a serem buscadas.
#' Cada vetor tem um nome, que é a palavra que define a categoria (estados de variação da variável).
#' A construção dessa lista deve ser baseada nas palavras que existem nos seus dados.
#' As listas de referência abaixo contêm alguns conjuntos de palavras que você pode ajustar para seu uso.
#' Vamos tomar como exemplo a variável hábito.
#' Teremos duas categorias que desejamos separar: arvoreta e árvore.
#' Vamos primeiro criar uma lista de referência usando a construção `obj[[nome.da.categoria]] = c(palavras.a.buscar)`.
#' 
## ----listas-ref-exemplo-------------------------------------------------------
referencias <- list()
referencias[["arvoreta"]] <- c("arvoreta", "treelet", "arvore pequena", "arbolito", "small tree")
referencias[["árvore"]] <- c("arvore", "tree", "rvore", "arvo", "arbol", "avore")
referencias

#' 
#' Vejam que em nossa lista de referência `referencias` incluímos primeiramente arvoreta e depois árvore, porque **árvore** faz parte da palavra **arvoreta**, e nós desejamos diferenciar as duas categorias.
#' Note que erros de grafia e palavras em diferentes idiomas podem ser inseridos nesses vetores como palavras a serem buscadas.  
#' 
#' ### Passo 02 - Funções que fazem a busca
#' 
#' Primeiro criaremos uma função `removeacentos()`, que pega um texto ou vetor de textos e remove acentos.
#' Isso é útil porque é frequente a mesma palavra aparecer com e sem acentos, por isso é melhor ignorar acentos nas comparações.  
#' 
## ----removeacentos------------------------------------------------------------
removeacentos <- function(x) {
  # remove acentos
  xx <- iconv(x, to = "ASCII//TRANSLIT")
  xx <- gsub("[~|^|~|\"|'|`]", "", xx)
  return(xx)
}

#' 
#' E uma segunda função `pegavalor()`que usa a lista de referência para extrair os dados de um texto.
#' Nesta função, o argumento `x` é um vetor  de classe `character` de comprimento igual a **1** contendo o texto original a ser explorado.
#' O segundo argumento da função, `referencias`, é uma lista de comprimento maior ou igual a **1** referente as categorias a serem buscadas no elemento `x`:
#' 
## -----------------------------------------------------------------------------
pegavalor <- function(x, referencias) {
  acategoria <- NA # objeto onde armazena a categoria caso encontre em x
  x <- x[!is.na(x)] # elimina elementos NA em x
  x <- removeacentos(x)
  if (length(x) == 1 & is.character(x)[1]) { # se x ainda for um texto
    for (t in 1:length(referencias)) {
      # se ainda não encontrou procura em outra referencia
      if (is.na(acategoria)) {
        words <- referencias[[t]] # pega as palavras a serem buscadas
        words <- words[!is.na(words)] # limpa caso haja NAs
        hab <- names(referencias)[t] # pega a categoria correspondente
        if (!is.null(hab) & !is.na(hab) & length(words) >= 1) {
          words <- removeacentos(words)
          found <- 0
          # para cada palavra chave busca em x e se encontrar anota
          for (g in 1:length(words)) {
            gp <- grep(words[g], x, ignore.case = T)
            if (length(gp) > 0) {
              found <- found + 1
            }
          }
          # se encontrou, atribui
          if (found > 0) {
            acategoria <- hab
          }
        }
      }
    }
  }
  # retorna o resultado
  return(acategoria)
}

#' 
#' ### Passo 03 - Usando a função
#' 
#' Vamos utilizar dados de exemplo para testar a função. Baixe o arquivo presente neste endereço (https://github.com/LABOTAM/IntroR/blob/main/dados/pegados_dados_exemplo.csv).
#' Ele apresenta uma coluna com notas de exsicatas para ilustrar nosso exemplo.  
#' 
## ----opts.label='evalF'-------------------------------------------------------
# voce já deve ter os seguinte objetos: pegavalor(), removeacentos(), referencias
# le o arquivo de exemplo
dados <- read.table(file = "pegados_dados_exemplo.csv", sep = "\t", as.is = TRUE, na.strings = c("NA", "NULL", ""), header = TRUE)

#' 
## ----include = FALSE, eval = TRUE---------------------------------------------
load("dados/pegados_dados_exemplo.rda")

#' 
#' 
## -----------------------------------------------------------------------------
txt.org <- dados$NOTAS_ORIGINAL # coluna com dados de notas (cada linha é um registro)
head(txt.org)

#' 
## -----------------------------------------------------------------------------
habito <- sapply(txt.org, pegavalor, referencias = referencias)
table(habito) # o que estiver NA significa que ele não encontrou as palavras em referencias.
# adiciona com uma nova coluna em dados
dados$HABITO <- habito

#' 
#' ## Listas de referência {#listas-ref}
#' 
#' As listas de referência abaixo podem ser úteis e você pode acrescentar termos de busca a cada categoria.
#' A ordem das categorias na lista deve ser pensada de forma que minimize erros.
#' Por exemplo, é importante primeiro encontrar `liana herbacea` e apenas depois definir `liana lenhosa` porque muitas vezes aparece apenas a palavra 'liana' que se refere a plantas lenhosas quando não diferenciada.  
#' 
#' O formato básico é:
#' 
#' >lista[["categoria a definir"]] = c(vetor com as palavras a serem encontradas que indiquem a categoria)
#' 
#' ### Hábito da planta
#' 
## ----opts.label='evalF'-------------------------------------------------------
habito.refs <- list()
habito.refs[["liana herbácea"]] <- c("erva trepadeira", "trepadeira", "liana herbácea", "liana herbacea", "erva liana", "rastejante", "vine", "scandent vine", "erva liana")
habito.refs[["liana lenhosa"]] <- c("cipó", "liana", "liana sublenhosa", "liana lenhosa")
habito.refs[["hemiepífita"]] <- c("hemiepifita", "hemi-epifita", "hemiepiphyte", "hemi-epiphyte")
habito.refs[["epífita"]] <- c("epífita", "epiphyte")
habito.refs[["arvoreta"]] <- c("arvoreta", "treelet", "Trellet", "arvore pequena", "arbolito", "small tree")
habito.refs[["árvore"]] <- c("m de altura", "DAP:", "arvore", "tree", "rvore", "arvo", "arbol", "arbre", "Arbor", "Arv.", " DAP", "DBH ", " DBH", "DAP ", "D.A.P. ", "Árovore", "Arborea", "Ávore", "ÁRVIRE", "Arbóreo", "Tronco ", " PAP ", "Rrv.")
habito.refs[["arbusto"]] <- c("arbust", "shrub", "scrub", "subarbust", "arbust", "Shruv")
habito.refs[["hemiparasita"]] <- c("hemiparasit", "hemi-parasit")
habito.refs[["saprófita"]] <- c("saprofit", "saprophy")
habito.refs[["parasita"]] <- c("parasit")
habito.refs[["erva aquática"]] <- c("erva aquática", "erva aquatica", "Macrófita aquática", "macrofit", "macrophy", "aquatic herb")
habito.refs[["erva"]] <- c("erva", "herbace", "terrestre", "herbacia", "herb")

#' 
#' ### Estado de fertilidade da amostra
#' 
## ----opts.label='evalF'-------------------------------------------------------
fertilidade.refs <- list()
fertilidade.refs[["flores"]] <- c(" flor", " petal", " flôr", " pétala", " estigma", " sépal", " sepal", " bract", " flower", " bráctea", "sicônio", "siconio", " estgimas", " espadice", " espádice", " ovário", "ovario", " tépala", " antera", " estame", "tepala", "Pétal", "Tépal", "Sépal", "espata", "corolla", "anthers")
fertilidade.refs[["botões"]] <- c(" botão", " botões", " botao", " botao", " bud")
fertilidade.refs[["frutos"]] <- c(" fruto", " fruit", "futo", "f ruto", "frutescencia", "frutescenc", "frutescênc", " legume", " semente", " cupula", " cúpula")
fertilidade.refs[["estéril"]] <- c("Estéril", "Sterile")

#' 
#' ### Classes de hábitat
#' 
## ----opts.label='evalF'-------------------------------------------------------
habitat.refs <- list()
habitat.refs[["Floresta ciliar"]] <- c("Riverbank", "beria de rio", "beira de rio", "berra de rio", " ciliar", "galeria", "Gallery forest", "margem alta do igarap")
habitat.refs[["Floresta de igapó"]] <- c("igapo", "margin of black water igarapé")
habitat.refs[["Floresta Inundável"]] <- c("varzea", "flooded forest", "floresta indundavel", "periodicamente inundavel")
habitat.refs[["Campinarana"]] <- c("campinarana", "varillal", "chamisal", "wallaba", "curuni", "sandy soil", "Solo arenoso, dossel")
habitat.refs[["Campina"]] <- c("campina", "campinarana gramíneo lenhosa", "savannis areno")
habitat.refs[["Aquático"]] <- c("aquatic")
habitat.refs[["Vegetação secundária"]] <- c("Mata secundária", "Secondary forest", "capoeira", "Disturbed margin of road", "mata perturbada", "mata pertubada", "rea alterada", "beira de mata", "beira de estrada", "beira da estrada", "antropizada", "floresta secundária", "vegetação secundária")
habitat.refs[["Floresta de Baixio"]] <- c("Nomflooded moist forest", "baixio", "area encharcada", "encharcado", "Non-flooded moist forest", "Solo argiloso sujeito a inundação tempor")
habitat.refs[["Floresta de Vertente"]] <- c("vertente", "encosta", "slope", "Solo areno-argiloso")
habitat.refs[["Floresta de Platô"]] <- c("plato", "plateau")
habitat.refs[["Floresta de Terra Firme"]] <- c("Solo argiloso. Dossel", "Solo argiloso, dossel", "Mata de solo argiloso", "Upland hillside forest", "Upland forest", "Primary forest", "terra firme", "terra alta", "Terreno firme", "Floresta", "Mata primaria", "Mata de terra", "Terreno argiloso", "Mature forest")
habitat.refs[["Cerradão"]] <- c("cerradao")
habitat.refs[["Cerrado"]] <- c("cerrado", "savanna", "savana")
habitat.refs[["Campo rupestre"]] <- c("Campo rupestre")

#' 
#' ### Textura do solo
#' 
## ----opts.label='evalF'-------------------------------------------------------
solo.refs <- list()
solo.refs[["pedregoso"]] <- c("pedregos", "pedral", "rock")
solo.refs[["areno-argiloso"]] <- c("areno-argilos", "areno argilos", "arenoso-argiloso", "arenoso argiloso", "argilo-arenoso", "argilo arenoso", "areno-arcill")
solo.refs[["argiloso"]] <- c("argilos", "agilos", "clay", "clayish", " loam", " arcill")
solo.refs[["arenoso"]] <- c("arenoso", "aenoso", "areia branca", "sand", "arrenoso")
solo.refs[["siltoso"]] <- c(" silte", " silt")

#' 
#' ### Exsudato
#' 
## ----opts.label='evalF'-------------------------------------------------------
exsudato.refs <- list()
exsudato.refs[["látex"]] <- c("latex", "látex")
exsudato.refs[["resina"]] <- c("resina")
exsudato.refs[["seiva"]] <- c("seiva", " sap ")
exsudato.refs[["exsudato"]] <- c("exsudato", "exsudação", "exsudate")

#' 
#' ## Extraindo altura e dap
#' 
#' Funções para extrair altura e diâmetro à altura do peito (DAP) de colunas descritivas.  
#' 
#' ### Altura
#' 
## -----------------------------------------------------------------------------
pegaaltura <- function(x) {
  x <- gsub("\\+/-", "", x)
  x <- gsub("  ", " ", x)
  x <- gsub("  ", " ", x)
  # print(x)
  pt1 <- "[-+]?[0-9]*[,.]?[0-9] m x"
  pt2 <- "[-+]?[0-9]*[,.]?[0-9]m x"
  pt3 <- "[-+]?[0-9]*[,.]?[0-9] m\\. x"
  pt4 <- "[-+]?[0-9]*[,.]?[0-9] m de altura"
  pt5 <- "[-+]?[0-9]*[,.]?[0-9] m\\. de altura"
  pt6 <- "[-+]?[0-9]*[,.]?[0-9]m d ealtura"
  pt7 <- "[-+]?[0-9]*[,.]?[0-9]m de alto"
  pt8 <- "[-+]?[0-9]*[,.]?[0-9] m de alto"
  pt9 <- "[-+]?[0-9]*[,.]?[0-9]m alto"
  pt10 <- "[-+]?[0-9]*[,.]?[0-9]m de altura"
  pt11 <- "[-+]?[0-9]*[,.]?[0-9] m tall"
  pt12 <- "[-+]?[0-9]*[,.]?[0-9]m tall"
  pt13 <- "[-+]?[0-9]*[,.]?[0-9] m\\. tall"
  pt14 <- "[-+]?[0-9]*[,.]?[0-9] m\\. Tall"
  pt15 <- "[-+]?[0-9]*[,.]?[0-9]m\\. tall"
  pt16 <- "Tree, [-+]?[0-9]*[,.]?[0-9]m"
  pt17 <- "Tree, [-+]?[0-9]*[,.]?[0-9] m"
  pt18 <- "Tree [-+]?[0-9]*[,.]?[0-9] m"
  pt19 <- "Tree [-+]?[0-9]*[,.]?[0-9]m"
  pt20 <- "to [-+]?[0-9]*v?[0-9] m"
  pt21 <- "Tree [0-9]*-[0-9]*m"
  pt22 <- "de [-+]?[0-9]*[,.]?[0-9] m"
  pt23 <- "de [-+]?[0-9]*v?[0-9]m"
  pt24 <- "de [0-9]*-[0-9]* m"
  pt25 <- "Tree [0-9]*-[0-9]* m"
  pt26 <- "de [0-9]*-[0-9]*m"
  pt27 <- "alt. [-+]?[0-9]*[,.]?[0-9] m"
  pt28 <- "[-+]?[0-9]*[,.]?[0-9] feet high"
  pt29 <- "[-+]?[0-9]*[,.]?[0-9] ft. high"

  pt30 <- "rvore [-+]?[0-9]*[,.]?[0-9]m"
  pt31 <- "rvore [-+]?[0-9]*[,.]?[0-9] m"
  pt32 <- "rvore, [-+]?[0-9]*[,.]?[0-9] m"
  pt33 <- "rvore, [-+]?[0-9]*[,.]?[0-9]m"

  pt34 <- "rbusto [-+]?[0-9]*[,.]?[0-9]m"
  pt35 <- "rbusto [-+]?[0-9]*[,.]?[0-9] m"
  pt36 <- "rbusto, [-+]?[0-9]*[,.]?[0-9] m"
  pt37 <- "rbusto, [-+]?[0-9]*[,.].?[0-9]m"
  pt38 <- "rvore +/- [-+]?[0-9]*[,.].?[0-9]m"
  pt39 <- "rvore ca. [-+]?[0-9]*[,.].?[0-9]m"
  pt40 <- "de [-+]?[0-9]*[,.].?[0-9] de altura"
  pt41 <- "altura [-+]?[0-9]*[,.].?[0-9]m"
  pt42 <- "altura [-+]?[0-9]*[,.].?[0-9] m"
  pt43 <- "of [-+]?[0-9]*[,.].?[0-9]m"
  pt44 <- "to [-+]?[0-9]*[,.].?[0-9]m"
  pt45 <- "Treelet [-+]?[0-9]*[,.].?[0-9]m"
  pt46 <- "rvore [-+]?[0-9]*[,.].?[0-9] m"
  pt47 <- "rvore, [-+]?[0-9]*[,.].?[0-9] m"
  pt48 <- "rvoreta, [-+]?[0-9]*[,.].?[0-9] m"
  pt49 <- "Fuste= [-+]?[0-9]*[,.].?[0-9] m"
  pt50 <- "Fuste= [-+]?[0-9]*[,.].?[0-9]m"
  pt51 <- "com [-+]?[0-9]*[,.].?[0-9] m. alt."
  pt52 <- "Height: [-+]?[0-9]*[,.].?[0-9] m"
  pt53 <- "Arbol [-+]?[0-9]*[,.].?[0-9]m"
  pt54 <- "Treelet, [-+]?[0-9]*[,.].?[0-9]m"
  pt55 <- "altura = [-+]?[0-9]*[,.].?[0-9]m"
  pt56 <- "Fuste = [-+]?[0-9]*[,.].?[0-9]m"
  pt57 <- "Fuste = [-+]?[0-9]*[,.].?[0-9] m"

  altura <- NA
  for (p in 1:57) {
    pt <- get(paste("pt", p, sep = ""))
    gp <- grep(pt, x, ignore.case = F)
    if (length(gp) > 0 & is.na(altura)) {
      # print(p)
      rmm <- strsplit(x, pt)[[1]]
      rmm <- rmm[rmm != "" & rmm != "." & !is.na(rmm)]
      xx <- x
      if (length(rmm) > 0) {
        for (r in length(rmm):1) {
          xx <- gsub(rmm[r], "", xx, fixed = T, useBytes = T)
        }
      }
      xx <- trimws(gsub("[A-Z]|\\(|\\)|:|=", "", xx, ignore.case = T), which = "both")
      xx <- gsub(",", ".", xx)
      tt <- grep("-", xx)
      if (length(tt) > 0) {
        xxx <- strsplit(xx, "-")[[1]]
        xxx <- xxx[xxx != ""]
        xxx <- gsub(" \\.", "", xxx)
        xx <- mean(as.numeric(trimws(xxx, which = "both")), na.rm = T)
      } else {
        xx <- strsplit(xx, " ")[[1]]
        xx <- trimws(xx, which = "both")
        xx <- xx[xx != "."]
        xx <- xx[1]
      }
      xx <- as.numeric(xx)
      if (!is.na(xx) && xx > 0) {
        altura <- xx
      } else {
        altura <- NA
      }
    }
  }
  return(altura)
}

#' 
#' ### DAP
#' 
## -----------------------------------------------------------------------------
pegadap <- function(x) {
  x <- gsub("\\+/-", "", x)
  x <- gsub("  ", " ", x)
  x <- gsub("  ", " ", x)
  # print(x)
  pt1 <- "x [-+]?[0-9]*[,.]?[0-9] cm de circ"
  pt2 <- "x [-+]?[0-9]*[,.]?[0-9] cm de di"
  pt3 <- "x [-+]?[0-9]*[,.]?[0-9]cm de di"
  pt4 <- "x [-+]?[0-9]*[,.]?[0-9]cm di"
  pt5 <- "m x [-+]?[0-9]*[,.]?[0-9] cm DAP"
  pt6 <- "m x [-+]?[0-9]*[,.]?[0-9] cm"
  pt7 <- "de [-+]?[0-9]*[,.]?[0-9] m de DAP"
  pt8 <- "[-+]?[0-9]*[,.]?[0-9] cm de DAP"
  pt9 <- "[-+]?[0-9]*[,.]?[0-9] cm (DAP)"
  pt10 <- "[-+]?[0-9]*[,.]?[0-9] cm dbh"
  pt11 <- "DAP [-+]?[0-9]*[,.]?[0-9] cm"
  pt12 <- "[-+]?[0-9]*[,.]?[0-9] cm D.A.P."
  pt13 <- "D.A.P. = [-+]?[0-9]*[,.]?[0-9] cm"
  pt14 <- "[-+]?[0-9]*[,.]?[0-9]cm de di"
  pt15 <- "[-+]?[0-9]*[,.]?[0-9]cm dap"
  pt16 <- "[-+]?[0-9]*[,.]?[0-9]cm. dia"
  pt17 <- "dbh. [-+]?[0-9]*[,.]?[0-9]cm"
  pt18 <- "[-+]?[0-9]*[,.]?[0-9]cm. in dia"
  pt19 <- "[-+]?[0-9]*[,.]?[0-9] cm de di"
  pt20 <- "[-+]?[0-9]*[,.]?[0-9] cm (DAP)"
  pt21 <- "DBH [-+]?[0-9]*[,.]?[0-9] cm"

  # x="Árvore de 13m de altura x 11cm de diâmetro do fuste."
  altura <- NA
  for (p in 1:21) {
    pt <- get(paste("pt", p, sep = ""))
    gp <- grep(pt, x, ignore.case = F)
    if (length(gp) == 1 & is.na(altura)) {
      # print(p)
      rmm <- strsplit(x, pt)[[1]]
      rmm <- rmm[rmm != "" & rmm != "." & !is.na(rmm)]
      xx <- x
      if (length(rmm) == 1) {
        for (r in length(rmm):1) {
          xx <- gsub(rmm[r], "", xx, fixed = T, useBytes = T)
        }
      } else {
        if (length(rmm) == 2) {
          n1 <- nchar(rmm[1])
          n2 <- nchar(rmm[2])
          n0 <- nchar(x)
          ns <- n1 + 1
          nt <- n0 - n2
          xx <- substr(x, ns, nt)
        } else {
          if (length(rmm) > 2) {
            xx <- NA
          }
        }
      }
      if (!is.na(xx)) {
        xx <- trimws(gsub("[A-Z]|\\(|\\)|:|=", "", xx, ignore.case = T), which = "both")
        xx <- gsub(",", ".", xx)
        tt <- grep("-", xx)
        if (length(tt) > 0) {
          xxx <- strsplit(xx, "-")[[1]]
          xxx <- xxx[xxx != ""]
          xxx <- gsub(" \\.", "", xxx)
          xx <- mean(as.numeric(trimws(xxx, which = "both")), na.rm = T)
        } else {
          xx <- strsplit(xx, " ")[[1]]
          xx <- trimws(xx, which = "both")
          xx <- xx[xx != "." & xx != "" & xx != "..."]
          xx <- xx[1]
          if (substr(xx, nchar(xx), nchar(xx)) == ".") {
            xx <- substr(xx, 1, nchar(xx) - 1)
          }
        }
        xx <- as.numeric(xx)
        if (xx > 0) {
          altura <- xx
        }
      }
    }
  }
  return(altura)
}

#' 
#' ## Usando essas funções 
#' 
#' Vamos utilizar o conjunto `dados` carregado acima para utilizar as funções que criamos anteriormente:
#' 
## -----------------------------------------------------------------------------
txt.org <- as.vector(dados$NOTAS) # sua coluna com dados descritivos

#' 
#' ### Obtendo valores de altura
#' 
## -----------------------------------------------------------------------------
# aplica a funcao
alts <- sapply(txt.org, pegaaltura)
head(alts)

#' 
## -----------------------------------------------------------------------------
names(alts) <- NULL
# quais valores viraram NA (ou seja, não encontrou um valor de altura)
txt.org[is.na(alts)]
# histograma
hist(alts)
# adiciona ao conjunto de dados
dados$ALTURAm <- alts

#' 
#' 
#' ### Obtendo valores de DAP
#' 
## -----------------------------------------------------------------------------
# aplica a funcao
daps <- sapply(txt.org, pegadap)
head(daps)

#' 
#' 
## -----------------------------------------------------------------------------
names(daps) <- NULL
# quais valores viraram NA (ou seja, não encontrou um valor de dap)
txt.org[is.na(daps)]
# histograma
hist(daps)
# adiciona ao conjunto de dados
dados$DAPcm <- daps

#' 
#' Reparem que ambas as funções ainda precisam de alguns ajustes.
#' Retirar variáveis de vetores de texto é algo complexo, especialmente quando não se há um padrão, fato observado comumente nas etiquetas de espécimes coletados e depositados em herbários.
#' Ainda assim, conseguimos extrair bastante informação da coluna de notas de texto estocada em `txt.org`.  
