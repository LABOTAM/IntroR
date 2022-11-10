#' # Baixar e descomprimir um arquivo {#unzip}
#' 
#' Caso você queira baixar e descomprimir um arquivo `.zip` no próprio R, ao invés de baixá-lo manualmente, siga os comandos abaixo.
#' Utilizaremos um arquivo utilizado na seção \@ref(obj-complexos).  
#' 
## ---- opts.label='evalF'--------------------------------------
# grava o endereco do arquivo em um objeto
arq_zip_url <- "https://github.com/LABOTAM/IntroR/blob/main/dados/municipiosshape.zip"
# cria um diretorio temporario
dirtemp <- tempdir()
# cria um arquivo temporario para arquivar esse zip
arq_temp <- tempfile(tmpdir = dirtemp, fileext = ".zip")
# baixa o arquivo para dentro do arquivo temporario
download.file(arq_zip_url, arq_temp)

# Apos executar o comando acima, o arquivo `.zip` e baixado para o objeto `arq_temp`
# agora utilizaremos a funcao `unzip()` para descomprimir o arquivo

# pega o nome do primeiro arquivo dentro do zip == corresponde ao nome da pasta
fname <- unzip(arq_temp, list = TRUE)$Name[1]
nomes_arqs <- unzip(arq_temp, list = TRUE)
class(nomes_arqs) # e um dataframe; a primeira coluna mostra o caminho de cada arquivo presente no zip; segunda coluna, o tamanho do arquivo
str(nomes_arqs)
nomes_arqs
# Descomprime o arquivo zip para a pasta temporaria
unzip(arq_temp, files = nome_pasta, exdir = dirtemp, overwrite = TRUE)
# caminho completo do arquivo extraido
caminho_completo <- file.path(dirtemp, nome_pasta)
caminho_completo

# lista arquivos dentro do caminho contido em caminho_completo
list.files(paste0(caminho_completo, "/."), all.files = TRUE)

