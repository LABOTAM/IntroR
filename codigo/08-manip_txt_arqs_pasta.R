#' # Manipulação de textos, arquivos e pastas {#manip-txt-arq-pasta}
#' 
#' ## Funções para manipulação e busca de textos
#' 
#' ### Colar ou concatenar textos
#' 
#' A função `paste()` concatena textos.
#' 
## ---- eval = FALSE, echo = TRUE--------------------------------------------------------------------
## ?paste # veja o help dessa funcao

#' 
#' Vamos criar dois vetores de texto, `txt` e `txt2`, para, em seguida, concatená-los com esta função:
#' 
## ---- eval = TRUE----------------------------------------------------------------------------------
# um vetor de texto
txt <- c("banana", "maça", "pera")
# outro vetor
txt2 <- LETTERS[1:3]

#' 
#' 
#' 
## ---- eval = TRUE----------------------------------------------------------------------------------
# concatenamos os textos par a par
paste(txt, txt2)
# mudamos o separador
paste(txt, txt2, sep = "-")

#' 
#' Podemos também unir os elementos contidos em um vetor em um único elemento, separados por algum símbolo.
#' Basta usar o argumento `collapse` e indicar qual será o elemento que unirá os elementos contidos em um vetor:
#' 
## ---- eval = TRUE----------------------------------------------------------------------------------
# imagine que queremos juntar os elementos de um vetor
# num único texto, separados por ";"
paste(txt, collapse = ";")
paste(txt, collapse = "/")
paste(txt, collapse = " e ")
paste(txt, collapse = " mais ")

#' 
#' ### Quebrar ou desconcatenar textos
#' 
#' A função `strsplit()` quebra um vetor de texto segundo um separador determinado pelo argumento `split`, e retorna uma lista como resultado.
#' 
## ---- eval = FALSE, echo = TRUE--------------------------------------------------------------------
## ?strsplit

#' 
#' 
## --------------------------------------------------------------------------------------------------
txt <- "Este é um texto com várias palavras"
strsplit(txt, split = " ")

#' 
#' Note que o resultado da ação é um objeto de classe lista:
#' 
## --------------------------------------------------------------------------------------------------
class(strsplit(txt, split = " "))

#' 
#' Então, para pegar o resultado da ação da função `strsplit()`, devemos usar o que aprendemos em [indexação de listas](#listas).
#' Para indexar listas, devemos usar duplo colchetes `[[n]]`, em que `n` é o número do elemento que desejamos reter.
#' Vejamos abaixo que retemos o resultado de `strsplit()` no vetor `txt` em um objeto `pl`:
#' 
## --------------------------------------------------------------------------------------------------
pl <- strsplit(txt, split = " ")
pl

#' 
#' Para pegar o tamanho do objeto `pl`, usamos `length(pl)` que nos dá o resultado de **`r length(pl)`**.
#' Por isso, se desejamos reter essa ação como um vetor de texto, nosso `n` é 1, logo, `[[1]]`:
#' 
## --------------------------------------------------------------------------------------------------
pl <- strsplit(txt, split = " ")[[1]]
pl

#' 
#' Agora o objeto `pl` é um vetor de texto e de tamanho corresponde ao número de palavras contidas no vetor:
#' 
## --------------------------------------------------------------------------------------------------
class(pl)
length(pl) # numero de palavras no texto

#' 
#' #### Um exemplo prático
#' 
#' Suponha que você tenha uma tabela em que o nome da espécie esteja em uma única coluna e você queira separar o gênero do epíteto.
#' Podemos usar a função `strsplit()` para resolver essa situação.
#' Vejamos:
#' 
## --------------------------------------------------------------------------------------------------
# um dado qualquer
spp <- c("Ocotea guianensis", "Ocotea longifolia", "Licaria tenuicarpa")
dap <- c(10, 20, 30)
dd <- data.frame(ESPECIE = spp, DAP = dap, stringsAsFactors = F)
dd

#' 
#' Vamos criar uma função para receber um vetor de texto e quebrá-lo segundo o separador `sep = " "`, isto é, vai quebrar a palavra onde houver um espaço `" "`.
#' 
## --------------------------------------------------------------------------------------------------
# criamos um funcao
peganome <- function(x, qual = 1, sep = " ") {
  # pega o texto e quebra segundo o separador informado
  xx <- strsplit(x, split = sep)[[1]]
  # retorna o valor
  return(xx[qual])
}

#' 
#' Com a função criada acima, `peganome()`, vamos utilizar a função `lapply()` para aplicar esta função sobre cada elemento do vetor `dd$ESPECIE`:
#' 
## --------------------------------------------------------------------------------------------------
# usamos essa funcao com o lapply para pegar o genero
lapply(dd$ESPECIE, peganome, qual = 1)

#' 
#' Repare que o resultado da ação é uma lista, pois `lapply()` sempre retorna uma lista!
#' Podemos converter esta lista em um vetor usando o procedimento abaixo:
#' 
## --------------------------------------------------------------------------------------------------
# como é uma lista transformamos num vetor
gg <- as.vector(lapply(X = dd$ESPECIE, FUN = peganome, qual = 1), mode = "character")
gg

#' 
#' Podemos também gerar um vetor de texto simplesmente utilizando a função `vapply()` para aplicar a função `peganome()` em cada elemento de `dd$ESPECIE`, informando à função `vapply()` que esperamos como retorno um vetor de texto de tamanho 1 (`FUN.VALUE = as.character(1)`).
#' O resultado é o mesmo obtido no objeto `gg`:
#' 
## --------------------------------------------------------------------------------------------------
vapply(X = dd$ESPECIE, FUN = peganome, FUN.VALUE = as.character(1), qual = 1)

#' 
#' Agora que temos o nome do gênero separado do epíteto, vamos guardar o nome do gênero estocado em `gg` no `data.frame` `dd`:
#' 
## --------------------------------------------------------------------------------------------------
# ADICIONAMOS NO OBJETO ORIGINAL
dd$GENERO <- gg
dd

#' 
#' Agora vamos pegar o epíteto da espécie, mudando o argumento `qual` da função `peganome()`:
#' 
## --------------------------------------------------------------------------------------------------
# usamos essa funcao com o lapply para pegar o epiteto
spp <- as.vector(lapply(dd$ESPECIE, peganome, qual = 2), mode = "character")
spp

#' 
#' Repetimos então o procedimento de guardar o epíteto `spp` em nosso `data.frame` `dd`:
#' 
## --------------------------------------------------------------------------------------------------
# adiciona
dd$SPP <- spp
# mostra
dd
str(dd)

#' 
#' ### Altera caixa do texto
#' 
#' As funções `toupper()` e `tolower()` mudam a caixa do texto, isto é, convertem o texto para totalmente maiúsculas ou minúsculas, respectivamente.  
#' 
## --------------------------------------------------------------------------------------------------
txt <- "Um texto QUALQUER"
# transforma para caixa baixa
tolower(txt)

# caixa alta
toupper(txt)

# apenas a primeira letra em maiusculo
# temos que construir nossa funcao para isso
mudatexto <- function(x) {
  xx <- strsplit(x, split = "")[[1]]
  xx <- tolower(xx)
  xx[1] <- toupper(xx[1])
  xx <- paste(xx, collapse = "")
  return(xx)
}
txt
mudatexto(txt)

#' 
#' ### Remove espaços em branco
#' 
#' A função `trimws()` remove espaços em branco no início e final do texto.  
#' Repare que isso ocorre no objeto `txt2` criado abaixo:
#' 
## --------------------------------------------------------------------------------------------------
txt2 <- "   Outro texto com espacos em branco no inicio e fim     "

#' 
#' Podemos removê-los usando a função `trimws()` e informando para o argumento `which` em qual(is) posição(ões) queremos remover os espaços em branco.
#' Vejamos:
#' 
## --------------------------------------------------------------------------------------------------
# Remove dos dois lados
trimws(txt2, which = "both")
# remove do lado direito
trimws(txt2, which = "right")
# Remove do lado esquerdo
trimws(txt2, which = "left")

#' 
#' ### Substitui ou pega parte de texto
#' 
#' A função `gsub()` busca padrões de um texto para substituí-los por outro em um vetor de caracteres.  
#' 
#' Já a função `substr()` extrai ou substitui pedaços de um texto em um vetor de caracteres.  
#' 
#' Por fim, a função `nchar()` conta o número de caracteres contidos em um vetor de caracteres.  
#' 
## --------------------------------------------------------------------------------------------------
# substitui palavras ou parte de palavras
txt <- "Um texto que contém muita COISA"
gsub("m", "M", txt)
gsub("que", "o qual", txt)

# pega uma parte do texto
substr(txt, 1, 10)
substr(txt, 11, 20)

# qual o numero de caracteres num texto
nchar(txt)
substr(txt, nchar(txt) - 10, nchar(txt)) # dez ultimos caracteres

#' 
#' 
#' ### Expressões Regulares
#' 
#' [Expressões regulares](https://pt.wikipedia.org/wiki/Express%C3%A3o_regular) são modelos lógicos para buscar caracteres em textos.
#' É uma ferramenta muito poderosa usada em computação. Não é fácil entender e usar expressões regulares, mas é muito poderoso e importante conhecer os recursos.
#' Aqui apresentamos apenas um exemplo muito simples do uso de expressões regulares.  
#' 
## --------------------------------------------------------------------------------------------------
txt <- "Um texto com varios numeros 1 2 9 no meio e 5 7 8 20 3456"
txt
# imagine que eu queira apagar todos os números desse texto
gsub("[0-9]", "", txt) # paga números de 0 a 9

# todas as letras minusculas
gsub("[a-z]", "", txt)

# todas as letras
gsub("[a-z|A-Z]", "", txt)

# todas as minúculas e numeros
gsub("[a-z|0-9]", "", txt)

#' 
#' Entender expressões regulares (*regular expressions*) é muito importante porque é fonte frequente de erros quando escrevemos códigos.
#' Algumas funções que buscam por padrões interpretam expressões regulares para buscar por padrões em objetos de texto.
#' Por exemplo, `gsub()` e `grep()` são duas funções parecidas, que buscam por um padrão (argumento `pattern`) em textos.
#' Enquanto `gsub()` busca e permite substituir o padrão por outro texto, `grep()` retorna o índice do elemento que contém o padrão de interesse.
#' O argumento `pattern`, citado anteriormente, pode ser um texto simples ou uma expressão regular, então é importante que você entenda um pouco sobre isso.
#' Expressões regulares podem ser bem complexas e até existem sites que lhe permitem entender e gerar uma expressão regular para uma busca especifica (veja abaixo na seção [**Para saber mais**](#sabermais-manip-txt-arqs-fld)).  
#' 
#' ### Remove Acentos
#' 
#' Remover acentos e padronizar textos podem ser importantes quando estamos comparando dados.
#' Por exemplo, quando queremos verificar se os nomes que aparecem em uma coluna estão padronizados, devemos checar se há duplicidade de palavras devido à presença de um acento em uma palavra e ausência em outra (e.g., odores "cítrico" e "citrico" são computados como duas palavras diferentes).
#' Não há uma função específica, mas como tudo pode ser feito no R, uma solução é mostrada aqui.  
#' 
## --------------------------------------------------------------------------------------------------
txt <- "Palavrão ou bobalhão têm acentos"
# convertemos quebrando acentos
xx <- iconv(txt, to = "ASCII//TRANSLIT")
xx
# apagamos os acentos sozinhos
xx <- gsub("[~|^|~|\"|'|`]", "", xx)
xx

# podemos colocar isso numa funcao
removeacentos <- function(x) {
  xx <- iconv(x, to = "ASCII//TRANSLIT")
  xx <- gsub("[~|^|~|\"|'|`]", "", xx)
  return(xx)
}

# usando a funcao criada
removeacentos(txt)

txt2 <- "macarrão também tem acentos, né?"
removeacentos(txt2)

#' 
#' ### Metacaracteres
#' 
#' Metacaracteres são caracteres que em uma expressão regular apresentam um significado especial e por isso não são interpretados como tal.
#' Alguns metacaracteres são:
#' 
#' * `.` encontra qualquer coisa que exista;
#' 
#' * `+` encontra o item que precede esse metacaractere uma ou mais vezes;
#' 
#' * `*` encontra o item que precede esse metacaractere zero ou mais vezes;
#' 
#' * `^` encontra qualquer espaço vazio no início da linha. Quando usado numa expressão de classe de caractere (veja abaixo), encontra qualquer caractere exceto aqueles que seguem esse metacaractere;
#' 
#' * `\$` encontra qualquer espaço vazio no final da linha;
#' 
#' * `|` operador que significa `OU` e é utilizado em buscas do tipo  `busque isso OU aquilo`;
#' 
#' * `(` e `)` para agrupamentos;
#' 
#' * `[` e `]` definem classes de caracteres em expressões regulares (veja abaixo na seção [Classes de caracteres](#classes-caracteres)).
#' 
#' Suponha que você importe ao R um conjunto de dados de uma planilha usando, por exemplo, a função `read.table()`, e que os nomes das colunas no original tinham muitos espaços em branco.
#' Como o R não aceita espaços em branco, ele substitui espaços por pontos ao utilizar esta função, então os nomes das colunas do `data.frame` dos dados terão muitos pontos, algumas vezes em sequência.
#' Suponha também que isso acontece toda vez que você importa dados ao R e já está cansado desse comportamento e você quer colocar no seu script um comando que elimina esses pontos, de forma a não se preocupar com isso no editor de planilhas onde estão os seus dados.  
#' 
## --------------------------------------------------------------------------------------------------
# vamos criar um data.frame que simule esta situação
Número.....da.......árvore <- c(1, 10, 15)
Diâmetro..cm. <- c(10, 15, 20)
Altura.....m.... <- c(15, 20, 39)
dados <- data.frame(Número.....da.......árvore, Diâmetro..cm., Altura.....m....)
class(dados)
dim(dados)
colnames(dados)
# nome de colunas, que também neste caso pode ser obtido com
names(dados)

nn <- names(dados)
# então digamos que eu queira substituir pontos multiplos por apenas 1 ponto. como eu quero manter 1 ponto eu poderia repetir várias vezes um substituicao de dois pontos por um ponto:
gsub(pattern = "..", replacement = ".", nn)
# estranho né? tudo virou ponto

# isso é porque . é um metacaractere e o R não interpreta isso como ponto. Ponto significa pega 'pega qualquer caractere' numa expressão regular

# pelo fato de ponto ser um metacaractere, precisamos indicar que queremos o caractere ponto e não o metacaractere. Você faz isso usando uma ou duas barras invertidas (backslash)
gsub(pattern = "\\.\\.", replacement = ".", nn)

# diminuiu o número de pontos, mas preciso fazer isso várias vezes para ficar com um único ponto
nn2 <- gsub(pattern = "\\.\\.", replacement = ".", nn)
nn2 <- gsub(pattern = "\\.\\.", replacement = ".", nn2)
nn2
nn2 <- gsub(pattern = "\\.\\.", replacement = ".", nn2)
nn2
# pronto consegui

# note que isso fica restrito a quantos pontos tem nos meus dados, e portanto, não é um método genérico ou eficiente em termos de programação, por o número que vezes que isso deve ser feito irá variar dependendo do conjunto de dados.

# seria mais fácil adicionar um metacaractere (+) e fazer isso uma única vez, sem necessidade de repetição:
nn
nn2 <- gsub(pattern = "\\.+", replacement = ".", nn)
nn2
# procurar por qualquer letra+
txt <- "qualqueeeeeer palavra"
gsub("e+", "E", txt)

# da mesma forma se eu quiser buscar pelo caractere + ao invés de usar o metacaractere, preciso usar a barra invertida:
txt <- c("um texto com simbolo +", "sem o simbolo")
gsub("+", "MAIS", txt) # nao funciona
gsub("\\+", "MAIS", txt) # funciona

#' 
#' ### Classes de caracteres {#classes-caracteres}
#' 
#' Algumas classes de caracteres podem ser utilizadas em buscas com expressões regulares:
#' 
#' * [0-9] - busca números no vetor de caracteres;
#' 
#' * [a-z] - busca apenas caracteres minúsculos no vetor de caracteres;
#' 
#' * [A-Z] - busca apenas caracteres maiúsculos no vetor de caracteres;
#' 
#' * [a-zA-Z] - busca caracteres do alfabeto no vetor de caracteres;
#' 
#' * [^a-zA-Z] - busca não alfabéticos no vetor de caracteres;
#' 
#' * [a-zA-Z0-9] - busca elementos alfa-numéricos no vetor de caracteres;
#' 
#' * [ \t\n\r\f\v] - busca espaçamentos no vetor de caracteres. Espaçamentos podem ser quebras de linha, tabulações etc;
#' 
#' * []$*+.?[^{|(#%&~_/⇔✬!,:;❵\")}@-] - busca caracteres de pontuação no vetor de caracteres.
#' 
#' Perceb-se que estas classes permitem fazer buscas complexas.
#' Suponha que você precisa substituir todos os valores que não contenham letras ou números por `NA`:
#' 
## --------------------------------------------------------------------------------------------------
# suponha um vetor de palavras (nomes de cores neste exemplo)
vt <- colors()
# vejamos os 30 primeiros valores
head(vt, 30)

#' 
#' 
## --------------------------------------------------------------------------------------------------
# podemos mostrar os valores que contém branco:
grep("white", vt, value = TRUE)

#' 
#' 
## --------------------------------------------------------------------------------------------------
# se eu coloco white numa expressao regular
# vejamos os 30 primeiros valores
grep("[white]", vt, value = TRUE)[1:30]
# neste caso significa pegue qualquer elemento que contenha uma das letras indicadas: w, h, i, t ou e. Por isso a lista aumentou

#' 
#' 
## --------------------------------------------------------------------------------------------------
# pega só cores que tenham número
# vejamos os 30 primeiros valores
grep("[0-9]", vt, value = TRUE)[1:30]

#' 
#' 
## --------------------------------------------------------------------------------------------------
# neste caso é o mesmo que nao-alfabeticos
# vejamos os 30 primeiros valores
grep("[^a-zA-Z]", vt, value = TRUE)[1:30]

#' 
#' 
## --------------------------------------------------------------------------------------------------
# que tenham caracteres maiusculos
grep("[A-Z]", vt, value = TRUE) # nao tem nenhum neste vetor

#' 
#' 
## --------------------------------------------------------------------------------------------------
# minusculos
# vejamos os 30 primeiros valores
grep("[a-z]", vt, value = TRUE)[1:30]

#' 
#' ### Barra invertida `\`
#' 
#' O uso da barra invertida `\` (em inglês, *backslash*) indica ao R que a expressão regular espera lidar com tabulações, quebra de linhas e outros símbolos especiais.
#' Isso é fundamental se você quer incluir/buscar num texto por aspas, parênteses, colchetes, barras, metacaracteres, etc.
#' 
## ---- eval = FALSE, echo = TRUE--------------------------------------------------------------------
## ?Quotes # leia atentamente esse help
## # criar um texto com aspas

#' 
#' Se você tentar executar o comando abaixo, perceberá que ele não funciona, porque as aspas são utilizadas para abrir e fechar textos.  
#' 
#' ```
#' txt = "Um texto que tem "aspas" no meio" 
#' ```
#' 
#' Porém, podemos combinar aspas simples e duplas para fazer isso:
#' 
## --------------------------------------------------------------------------------------------------
txt <- 'Um texto que tem "aspas" no meio'
txt
# veja que o R adicionou uma \ antes das aspas do texto, criando um escape character, que indica ao R que não interprete aquilo como abertura ou fechamento de textos
# entao eu posso fazer isso
txt <- "Um texto que tem \"aspas\" "
txt
# também funciona

# isso é importante quando buscamos valores
txt <- c("com \"aspas\"", "outro objeto")
grep("\"", txt) # qual elemento tem aspas
txt[grep("\"", txt)]

# barras
txt <- c("com \\ barras", "sem barras")
txt
grep("\\\\", txt) # isso é mais complicado, veja o número de barras que preciso para buscar por 1 barra num texto, porque barra desse jeito é o código que ele usa para buscar por códigos, então complica né?

# parentesis
txt <- c("sem parenteses", "com ()")

#' 
#' 
#' ```r
#' grep("(", txt) # isso não funciona por parentesis é usado para abrir e fechar funcoes, o R se atrapalha
#' grep("\\(", txt) # assim funciona
#' grep("\\)", txt)
#' ```
#' 
#' 
#' 
#' 
#' ## Manipulação de pastas e arquivos
#' 
#' <!-- Suponha que você tem 2000 arquivos numa pasta e quer pegar os arquivos que contenham a palavra "folha" no nome e com cada arquivo você quer mudar o nome e salvar em outro local. -->
#' 
#' As funções abaixo auxiliam a checagem de arquivos dentro de pastas, possibilitam a criação de pastas, e a cópia de arquivos dentro do sistema.
#' Dominar essas funções e algumas outras correlatas são importantíssimas, por exemplo, no ramo da bioinformática.
#' No dia a dia, dominá-las também possibilitará que muito tempo seja poupado em atividades maçantes, como copiar ou mover muitos arquivos de uma pasta a outra.  
#' 
#' Vamos analisar o uso das funções `dir()`, `dir.create()` e `file.copy()` (vejam a seção [Para saber mais](#sabermais-manip-txt-arqs-fld) para mais informações).
#' Não esqueçam de checar o `?` de cada função (e.g., `?dir`) para auxiliar no entendimento do funcionamento de cada uma das funções.  
#' 
## ---- eval = FALSE, echo = TRUE--------------------------------------------------------------------
## # meu caminho
## caminho <- "~/Documents/DOC/PROJETO_DOC/R/pkgs/BOT89-introR/tutorial/"
## # lista todos os arquivos no caminho que sejam pdfs
## arqs <- dir(caminho, pattern = ".pdf")
## 
## # renomeia os arquivos adicionando a data no final do nome
## # cria funcao para gerar novos nomes
## novonome <- function(x) {
##   # separa as palavras
##   xx <- strsplit(x, ".pdf")[[1]]
##   # cola a data
##   xx1 <- paste(xx, Sys.Date(), sep = "_")
##   # junta novamente tudo
##   xx <- paste(xx1, ".pdf", sep = "")
##   # retorna o novo nome
##   return(xx)
## }
## 
## # agora copia cada arquivo para uma subpasta em caminho
## novapasta <- paste(caminho, "/pdfs", sep = "")
## dir.create(novapasta)
## 
## # salva os arquivos com mesmo nome na nova pasta
## # cria uma funcao para isso
## salvaarq <- function(arq, origem, destino) {
##   from <- paste(origem, "/", arq, sep = "")
##   to <- paste(destino, "/", novonome(arq), sep = "")
##   file.copy(from, to)
## }
## 
## # aplica a funcao a todos os arquivos
## sapply(arqs, salvaarq, origem = caminho, destino = novapasta)
## 
## # pronto os arquivos devem ter sido copiados
## dir(novapasta)

#' 
#' 
#' ## Para saber mais: {#sabermais-manip-txt-arqs-fld}
#' 
#' (1) [RegExr is an online tool to learn, build, & test Regular Expressions (RegEx / RegExp)](http://regexr.com) - Página que ajuda o usuário a construir uma expressão regular.  
#' 
#' (2) Vídeoaulas - temos vídeosaulas disponíveis, gravadas com o material desta aula. Acesse-as nos *links* abaixo:
#' 
#'   * [parte I](https://youtu.be/at5XpBAT1sI);
#'   
#'   * [parte II](https://youtu.be/j6O6e96qmEc);
#'   
#'   * [Manipulação de pastas e arquivos](https://youtu.be/TbY5nEQTwLw).  
#' 
#' (3) Pacote [fs](https://github.com/r-lib/fs) - Um pacote que agrupa funções para manipulações de arquivos e pastas, e que apresenta algumas melhoras sobre o conjunto de funções do pacote base do R. Além disso, há alguns tutoriais disponíveis.
