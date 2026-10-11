algoritmo "MedControl"
tipo
   // Registro dos pacientes
   tPaciente = registro
      codigo: inteiro
      nome: caractere
      idade: inteiro
      sexo: caractere
      prioridade: inteiro
      sistolica: inteiro
      diastolica: inteiro
      temperatura: real
      status: inteiro
      ordem: inteiro
   fimregistro

var
   // Variaveis Globais
   pacientes: vetor[1..30] de tPaciente
   fila: vetor[1..30] de tPaciente
   aux: tPaciente
   novo: tPaciente
   estat: vetor[1..4, 1..3] de inteiro
   qtd, nFila, opcao, i, j: inteiro

   // Constantes
   MAX_PACIENTES, EMERGENCIA, MUITO_URGENTE, URGENTE, POUCO_URGENTE: inteiro
   AGUARDANDO, ATENDIDO, NAO_ENCONTRADO, IDADE_MAX: inteiro
   COL_CADASTRADOS, COL_AGUARDANDO, COL_ATENDIDOS: inteiro


// FUNCOES


funcao textoStatus(s: inteiro): caractere
inicio
   se s = AGUARDANDO entao
      retorne "Aguardando atendimento"
   senao
      retorne "Atendido"
   fimse
fimfuncao

// Retorna string de prioridade
funcao textoPrioridade(p: inteiro): caractere
inicio
   escolha p
      caso 1
         retorne "Emergencia"
      caso 2
         retorne "Muito urgente"
      caso 3
         retorne "Urgente"
      outrocaso
         retorne "Pouco urgente"
   fimescolha
fimfuncao

// Retorna média ou zero para evitar divisão por zero
funcao calcularMedia(soma: real; quantidade: inteiro): real
inicio
   se quantidade = 0 entao
      retorne 0
   senao
      retorne soma / quantidade
   fimse
fimfuncao

// Retorna a posicao ou NAO_ENCONTRADO
funcao localizarPaciente(n, cod: inteiro): inteiro
var
   k, res: inteiro
inicio
   res <- NAO_ENCONTRADO
   k <- 1
   enquanto (k <= n) e (res = NAO_ENCONTRADO) faca
      se pacientes[k].codigo = cod entao
         res <- k
      fimse
      k <- k + 1
   fimenquanto
   retorne res
fimfuncao

// RECURSIVA 1 - busca de paciente
// Caso-base 1: posic > n            -> nao encontrou
// Caso-base 2: codigo == procurado -> encontrou
// Passo recursivo: chama a si mesma com posic + 1
funcao buscaRecursiva(cod, posic, n: inteiro): inteiro
var
   res: inteiro
inicio
   se posic > n entao
      res <- NAO_ENCONTRADO
   senao
      se pacientes[posic].codigo = cod entao
         res <- posic
      senao
         res <- buscaRecursiva(cod, posic + 1, n)
      fimse
   fimse
   retorne res
fimfuncao

// RECURSIVA 2 - quantidade aguardando
// Caso-base: posic > n -> 0
// Passo: (1 ou 0 da posicao atual) + chamada na proxima posicao
funcao quantidadeAguardando(posic, n: inteiro): inteiro
var
   res: inteiro
inicio
   se posic > n entao
      res <- 0
   senao
      res <- quantidadeAguardando(posic + 1, n)
      se pacientes[posic].status = AGUARDANDO entao
         res <- res + 1
      fimse
   fimse
   retorne res
fimfuncao

// Define ordem na fila de acordo com 3 criterios
// 1) menor prioridade 2) maior idade 3) cadastro mais antigo
funcao vemAntes(a, b: inteiro): logico
var
   res: logico
inicio
   se fila[a].prioridade <> fila[b].prioridade entao
      // 1o criterio: menor numero = mais grave
      res <- fila[a].prioridade < fila[b].prioridade
   senao
      se fila[a].idade <> fila[b].idade entao
         // 2o criterio (empate de prioridade): maior idade primeiro
         res <- fila[a].idade > fila[b].idade
      senao
         // 3o criterio (empate de idade): quem cadastrou antes
         res <- fila[a].ordem < fila[b].ordem
      fimse
   fimse
   retorne res
fimfuncao


// PROCEDIMENTOS


// Mostra os dados de pacientes[posic]
procedimento exibirPaciente(posic: inteiro)
inicio
   escreval("Codigo: ", pacientes[posic].codigo)
   escreval("Nome: ", pacientes[posic].nome)
   escreval("Idade: ", pacientes[posic].idade, "  Sexo: ", pacientes[posic].sexo)
   escreval("Prioridade: ", pacientes[posic].prioridade, " - ", textoPrioridade(pacientes[posic].prioridade))
   escreval("Pressao: ", pacientes[posic].sistolica, "/", pacientes[posic].diastolica, "  Temperatura: ", pacientes[posic].temperatura)
   escreval("Status: ", textoStatus(pacientes[posic].status))
fimprocedimento

// Cadastro com validacao
procedimento cadastrarPaciente(var n: inteiro)
inicio
   se n >= MAX_PACIENTES entao
      escreval("Capacidade maxima atingida (", MAX_PACIENTES, " pacientes).")
   senao
      repita
         escreva("Codigo: ")
         leia(novo.codigo)
         se novo.codigo <= 0 entao
            escreval("Codigo invalido. Informe um numero positivo.")
         senao
            se localizarPaciente(n, novo.codigo) <> NAO_ENCONTRADO entao
               escreval("Codigo ja cadastrado. Informe outro.")
               novo.codigo <- 0   // forca nova leitura
            fimse
         fimse
      ate novo.codigo > 0

      escreva("Nome: ")
      leia(novo.nome)

      repita
         escreva("Idade: ")
         leia(novo.idade)
         se (novo.idade < 0) ou (novo.idade > IDADE_MAX) entao
            escreval("Idade invalida (0 a ", IDADE_MAX, ").")
         fimse
      ate (novo.idade >= 0) e (novo.idade <= IDADE_MAX)

      repita
         escreva("Sexo (M/F): ")
         leia(novo.sexo)
         se (novo.sexo <> "M") e (novo.sexo <> "F") entao
            escreval("Sexo invalido. Use M ou F (maiusculo).")
         fimse
      ate (novo.sexo = "M") ou (novo.sexo = "F")

      repita
         escreva("Prioridade (1-Emergencia 2-Muito urgente 3-Urgente 4-Pouco urgente): ")
         leia(novo.prioridade)
         se (novo.prioridade < EMERGENCIA) ou (novo.prioridade > POUCO_URGENTE) entao
            escreval("Prioridade inexistente. Use de 1 a 4.")
         fimse
      ate (novo.prioridade >= EMERGENCIA) e (novo.prioridade <= POUCO_URGENTE)

      repita
         escreva("Pressao sistolica: ")
         leia(novo.sistolica)
         escreva("Pressao diastolica: ")
         leia(novo.diastolica)
         se (novo.sistolica <= 0) ou (novo.diastolica <= 0) ou (novo.sistolica <= novo.diastolica) entao
            escreval("Pressao invalida (positivas e sistolica > diastolica).")
         fimse
      ate (novo.sistolica > 0) e (novo.diastolica > 0) e (novo.sistolica > novo.diastolica)

      repita
         escreva("Temperatura (C): ")
         leia(novo.temperatura)
         se (novo.temperatura < 30) ou (novo.temperatura > 45) entao
            escreval("Temperatura invalida (30 a 45).")
         fimse
      ate (novo.temperatura >= 30) e (novo.temperatura <= 45)

      // Grava no vetor. Todo paciente novo comeca AGUARDANDO
      n <- n + 1
      pacientes[n].codigo <- novo.codigo
      pacientes[n].nome <- novo.nome
      pacientes[n].idade <- novo.idade
      pacientes[n].sexo <- novo.sexo
      pacientes[n].prioridade <- novo.prioridade
      pacientes[n].sistolica <- novo.sistolica
      pacientes[n].diastolica <- novo.diastolica
      pacientes[n].temperatura <- novo.temperatura
      pacientes[n].status <- AGUARDANDO
      pacientes[n].ordem <- n

      // Atualiza a matriz
      estat[novo.prioridade, COL_CADASTRADOS] <- estat[novo.prioridade, COL_CADASTRADOS] + 1
      estat[novo.prioridade, COL_AGUARDANDO] <- estat[novo.prioridade, COL_AGUARDANDO] + 1
      escreval("Paciente cadastrado com sucesso!")
   fimse
fimprocedimento

procedimento listarPacientes(n: inteiro)
var
   k: inteiro
inicio
   se n = 0 entao
      escreval("Nenhum paciente cadastrado.")
   senao
      para k de 1 ate n faca
         escreval("--------------------------------")
         exibirPaciente(k)
      fimpara
   fimse
fimprocedimento

procedimento consultarPaciente(n: inteiro)
var
   cod, posic: inteiro
inicio
   se n = 0 entao
      escreval("Nenhum paciente cadastrado.")
   senao
      escreva("Codigo do paciente: ")
      leia(cod)
      posic <- localizarPaciente(n, cod)
      se posic = NAO_ENCONTRADO entao
         escreval("Paciente nao encontrado.")
      senao
         escreval("Paciente encontrado.")
         exibirPaciente(posic)
      fimse
   fimse
fimprocedimento

// Copia pacientes[orig] para fila[dest]
procedimento copiarParaFila(orig, dest: inteiro)
inicio
   fila[dest].codigo <- pacientes[orig].codigo
   fila[dest].nome <- pacientes[orig].nome
   fila[dest].idade <- pacientes[orig].idade
   fila[dest].sexo <- pacientes[orig].sexo
   fila[dest].prioridade <- pacientes[orig].prioridade
   fila[dest].sistolica <- pacientes[orig].sistolica
   fila[dest].diastolica <- pacientes[orig].diastolica
   fila[dest].temperatura <- pacientes[orig].temperatura
   fila[dest].status <- pacientes[orig].status
   fila[dest].ordem <- pacientes[orig].ordem
fimprocedimento

// Troca fila[a] com fila[b]
procedimento trocarFila(a, b: inteiro)
inicio
   aux.codigo <- fila[a].codigo
   aux.nome <- fila[a].nome
   aux.idade <- fila[a].idade
   aux.sexo <- fila[a].sexo
   aux.prioridade <- fila[a].prioridade
   aux.sistolica <- fila[a].sistolica
   aux.diastolica <- fila[a].diastolica
   aux.temperatura <- fila[a].temperatura
   aux.status <- fila[a].status
   aux.ordem <- fila[a].ordem

   fila[a].codigo <- fila[b].codigo
   fila[a].nome <- fila[b].nome
   fila[a].idade <- fila[b].idade
   fila[a].sexo <- fila[b].sexo
   fila[a].prioridade <- fila[b].prioridade
   fila[a].sistolica <- fila[b].sistolica
   fila[a].diastolica <- fila[b].diastolica
   fila[a].temperatura <- fila[b].temperatura
   fila[a].status <- fila[b].status
   fila[a].ordem <- fila[b].ordem

   fila[b].codigo <- aux.codigo
   fila[b].nome <- aux.nome
   fila[b].idade <- aux.idade
   fila[b].sexo <- aux.sexo
   fila[b].prioridade <- aux.prioridade
   fila[b].sistolica <- aux.sistolica
   fila[b].diastolica <- aux.diastolica
   fila[b].temperatura <- aux.temperatura
   fila[b].status <- aux.status
   fila[b].ordem <- aux.ordem
fimprocedimento

// Bubble Sort na fila
procedimento ordenarFila(n: inteiro)
var
   x, y: inteiro
inicio
   para x de 1 ate n - 1 faca
      para y de 1 ate n - x faca
         se nao vemAntes(y, y + 1) entao
            trocarFila(y, y + 1)
         fimse
      fimpara
   fimpara
fimprocedimento

// Copia so os que aguardam para a fila e ordena a copia
procedimento montarFila(n: inteiro)
var
   k: inteiro
inicio
   nFila <- 0
   para k de 1 ate n faca
      se pacientes[k].status = AGUARDANDO entao
         nFila <- nFila + 1
         copiarParaFila(k, nFila)
      fimse
   fimpara
   ordenarFila(nFila)
fimprocedimento

procedimento exibirFila(n: inteiro)
var
   k: inteiro
inicio
   montarFila(n)
   se nFila = 0 entao
      escreval("Fila vazia: nenhum paciente aguardando.")
   senao
      escreval("FILA DE ATENDIMENTO (", nFila, " aguardando):")
      para k de 1 ate nFila faca
         escreval(k, ". [", textoPrioridade(fila[k].prioridade), "] ", fila[k].nome, " - ", fila[k].idade, " anos (cod ", fila[k].codigo, ")")
      fimpara
   fimse
fimprocedimento

// Atende o proximo da fila e valida se paciente existe,
// ja foi atendido ou esta fora da vez
procedimento realizarAtendimento(n: inteiro)
var
   cod, posic, p: inteiro
inicio
   se n = 0 entao
      escreval("Nenhum paciente cadastrado.")
   senao
      montarFila(n)
      se nFila = 0 entao
         escreval("Nao ha pacientes aguardando atendimento.")
      senao
         escreval("Proximo da fila: ", fila[1].nome, " (cod ", fila[1].codigo, ")")
         escreva("Confirme o codigo do paciente a atender: ")
         leia(cod)
         posic <- localizarPaciente(n, cod)
         se posic = NAO_ENCONTRADO entao
            escreval("Paciente inexistente.")
         senao
            se pacientes[posic].status = ATENDIDO entao
               escreval("Este paciente ja foi atendido.")
            senao
               se cod <> fila[1].codigo entao
                  escreval("Este paciente nao e o proximo da fila.")
               senao
                  pacientes[posic].status <- ATENDIDO
                  p <- pacientes[posic].prioridade
                  estat[p, COL_AGUARDANDO] <- estat[p, COL_AGUARDANDO] - 1
                  estat[p, COL_ATENDIDOS] <- estat[p, COL_ATENDIDOS] + 1
                  escreval("Atendimento registrado para ", pacientes[posic].nome, ".")
               fimse
            fimse
         fimse
      fimse
   fimse
fimprocedimento

procedimento exibirAtendidos(n: inteiro)
var
   k, cont: inteiro
inicio
   cont <- 0
   para k de 1 ate n faca
      se pacientes[k].status = ATENDIDO entao
         cont <- cont + 1
         escreval(cont, ". ", pacientes[k].nome, " (cod ", pacientes[k].codigo, ", prioridade ", pacientes[k].prioridade, ")")
      fimse
   fimpara
   se cont = 0 entao
      escreval("Nenhum paciente atendido ainda.")
   fimse
fimprocedimento

procedimento exibirEstatisticas(n: inteiro)
var
   k, p, c: inteiro
   contAguard, contAtend, contPrio12, maiorIdade, menorIdade: inteiro
   somaIdade, somaTemp: real
inicio
   se n = 0 entao
      escreval("Nenhum paciente cadastrado.")
   senao
      contAguard <- 0
      contAtend <- 0
      contPrio12 <- 0
      somaIdade <- 0
      somaTemp <- 0
      maiorIdade <- pacientes[1].idade
      menorIdade <- pacientes[1].idade

      para k de 1 ate n faca
         somaIdade <- somaIdade + pacientes[k].idade
         somaTemp <- somaTemp + pacientes[k].temperatura
         se pacientes[k].idade > maiorIdade entao
            maiorIdade <- pacientes[k].idade
         fimse
         se pacientes[k].idade < menorIdade entao
            menorIdade <- pacientes[k].idade
         fimse
         se pacientes[k].status = AGUARDANDO entao
            contAguard <- contAguard + 1
         senao
            contAtend <- contAtend + 1
         fimse
         se (pacientes[k].prioridade = EMERGENCIA) ou (pacientes[k].prioridade = MUITO_URGENTE) entao
            contPrio12 <- contPrio12 + 1
         fimse
      fimpara

      escreval("===== ESTATISTICAS =====")
      escreval("Total de pacientes: ", n)
      escreval("Aguardando: ", contAguard, " (conferencia recursiva: ", quantidadeAguardando(1, n), ")")
      escreval("Atendidos: ", contAtend)
      escreval("Media de idade: ", calcularMedia(somaIdade, n):5:1)
      escreval("Media de temperatura: ", calcularMedia(somaTemp, n):5:1)
      escreval("Maior idade: ", maiorIdade, "  Menor idade: ", menorIdade)
      escreval("Percentual atendidos: ", contAtend * 100 / n:6:1, "%")
      escreval("Percentual aguardando: ", contAguard * 100 / n:6:1, "%")
      escreval("Pacientes com prioridade 1 ou 2: ", contPrio12)
      escreval("")
      escreval("Prioridade (cadastrados / aguardando / atendidos):")
      para p de EMERGENCIA ate POUCO_URGENTE faca
         escreva(textoPrioridade(p), ": ")
         para c de COL_CADASTRADOS ate COL_ATENDIDOS faca
            escreva(estat[p, c], "  ")
         fimpara
         escreval("")
      fimpara
   fimse
fimprocedimento

procedimento consultaRecursiva(n: inteiro)
var
   cod, posic: inteiro
inicio
   se n = 0 entao
      escreval("Nenhum paciente cadastrado.")
   senao
      escreva("Codigo a buscar (recursivo): ")
      leia(cod)
      posic <- buscaRecursiva(cod, 1, n)
      se posic = NAO_ENCONTRADO entao
         escreval("Paciente nao encontrado.")
      senao
         escreval("Encontrado na posicao ", posic, ":")
         exibirPaciente(posic)
      fimse
   fimse
fimprocedimento

// ------------------------------------------------------------
// PROGRAMA PRINCIPAL
// ------------------------------------------------------------
inicio
   MAX_PACIENTES <- 30
   EMERGENCIA <- 1
   MUITO_URGENTE <- 2
   URGENTE <- 3
   POUCO_URGENTE <- 4
   AGUARDANDO <- 0
   ATENDIDO <- 1
   NAO_ENCONTRADO <- 0
   IDADE_MAX <- 120
   COL_CADASTRADOS <- 1
   COL_AGUARDANDO <- 2
   COL_ATENDIDOS <- 3

   // Zera a matriz
   para i de 1 ate 4 faca
      para j de 1 ate 3 faca
         estat[i, j] <- 0
      fimpara
   fimpara
   qtd <- 0

   repita
      escreval("")
      escreval("MEDCONTROL - GERENCIAMENTO DE ATENDIMENTOS")
      escreval("1. Cadastrar paciente")
      escreval("2. Listar pacientes")
      escreval("3. Consultar paciente")
      escreval("4. Exibir fila de atendimento")
      escreval("5. Realizar atendimento")
      escreval("6. Exibir pacientes atendidos")
      escreval("7. Exibir estatisticas")
      escreval("8. Executar consulta recursiva")
      escreval("9. Encerrar sistema")
      escreva("Opcao: ")
      leia(opcao)
      escolha opcao
         caso 1
            cadastrarPaciente(qtd)
         caso 2
            listarPacientes(qtd)
         caso 3
            consultarPaciente(qtd)
         caso 4
            exibirFila(qtd)
         caso 5
            realizarAtendimento(qtd)
         caso 6
            exibirAtendidos(qtd)
         caso 7
            exibirEstatisticas(qtd)
         caso 8
            consultaRecursiva(qtd)
         caso 9
            escreval("Sistema encerrado.")
         outrocaso
            escreval("Opcao inexistente. Escolha de 1 a 9.")
      fimescolha
   ate opcao = 9
fimalgoritmo
