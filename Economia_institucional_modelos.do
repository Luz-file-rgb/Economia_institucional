**modelos em painel******************
*************************************
*Primeiro passo, trabalhar nossas variáveis:
gen lncon=ln( conhec_prod_tecnol)
gen lninst=ln(instituicoes) 
gen lnpoli=ln(amb_politico) 
gen lnregul=ln(amb_regulatorio) 
gen lnnego=ln(amb_negocios) 
gen lncaphum=ln(cap_human) 
gen lninfra=ln(infraestr) 
gen lnsoftmer=ln(sofest_merca) 
gen lnsofneg=ln(sofest_neg)

*Vamos informar ao stata que trabalharemos com dados de painel e indicar quem é o indice de individuos e quem é o índice de tempo
xtset idd year


*Usando o modelo Pooled:
 regress lncon lninst lncaphum lninfra lnsoftmer lnsofneg

*Podemos agora separar as instituições em seus subníveis:
*Ambiente político:
 regress lncon lnpoli lncaphum lninfra lnsoftmer lnsofneg
 
 *Ambiente Regulatório:
 regress lncon lnregul lncaphum lninfra lnsoftmer lnsofneg
 
 *Ambiente de negócios:
 regress lncon lnnego lncaphum lninfra lnsoftmer lnsofneg


****Programação em painel:
*No stata, o comando para estimar paineis é o comando XTREG

*PRIMEIRO EFEITOS FIXOS

 xtreg lncon lninst lncaphum lninfra lnsoftmer lnsofneg, fe
*Ambiente político:
 xtreg lncon lnpoli lncaphum lninfra lnsoftmer lnsofneg, fe
 
 *Ambiente Regulatório:
 xtreg lncon lnregul lncaphum lninfra lnsoftmer lnsofneg, fe
 
 *Ambiente de negócios:
 xtreg lncon lnnego lncaphum lninfra lnsoftmer lnsofneg, fe
 
 *PRIMEIRO EFEITOS ALEATÓRIOS

 xtreg lncon lninst lncaphum lninfra lnsoftmr lnsofneg, ree
*Ambiente político:
 xtreg lncon lnpoli lncaphum lninfra lnsoftmer lnsofneg, re
 xttest0
 *Ambiente Regulatório:
 xtreg lncon lnregul lncaphum lninfra lnsoftmer lnsofneg, re
 xttest0
 *Ambiente de negócios:
 xtreg lncon lnnego lncaphum lninfra lnsoftmer lnsofneg, re
 xttest0
 *O critério de decisão entre Pooled * EF é o teste F de contribuição marginal que sai no default do stata
 *O critério de decisão entre Poole*EA é o teste de autocorrelação de Breusch-Pagan LM (simples)
xttest0


*Considerando que os testes anteriores apontaram EF e EA, teremos que usar o teste de hausmann como critério de decisão:

*Repetiremos as regressões de EF e EA, e salvaremos os resultados para comparação:

xtreg lncon lnregul lncaphum lninfra lnsoftmer lnsofneg,fe
estimates store betaFE

xtreg lncon lnregul lncaphum lninfra lnsoftmer lnsofneg,re
estimates store betaRE

hausman betaFE betaRE

****Podemos também investigar a necessidade do uso de instrumentos:
*Para isso podemos incluir os instrumentos no nosso modelo de regressão de painel:

xtivreg lncon (lnregul lncaphum lninfra lnsoftmer lnsofneg = europe africa americalati americadonorte asia distnciaiusa vistos), fe

xtivreg lncon (lnregul lncaphum lninfra lnsoftmer lnsofneg = europe africa americalati americadonorte asia distnciaiusa vistos), re


 *Vamos criar nosso teste de endogeneidade para verificar se realmente precisamos usar instrumentos no modelo de EA
 
 *Primeiro, colocaremos nossas variáveis na sua forma reduzida e salvaremos os valores estimados e os erros:
 
 
xtreg lncon europe africa americalati americadonorte asia distnciaiusa vistos, re
predict Ylncon
*predict Elncon, r

xtreg lninst europe africa americalati americadonorte asia distnciaiusa vistos, re
predict Ylninst
*predict Elninst, r

xtreg lnpoli europe africa americalati americadonorte asia distnciaiusa vistos, re
predict Ylnpoli
*predict Elnpoli, r

xtreg lnregul europe africa americalati americadonorte asia distnciaiusa vistos, re
predict Ylnregul
*predict Elnregul, r

xtreg lnnego europe africa americalati americadonorte asia distnciaiusa vistos, re
predict Ylnnego
*predict Elnnego, r

xtreg lncaphum europe africa americalati americadonorte asia distnciaiusa vistos, re
predict Ylncaphum
*predict Elncaphum, r

xtreg lninfra europe africa americalati americadonorte asia distnciaiusa vistos, re
predict Ylninfra
*predict Elninfra, r

xtreg lnsoftmer europe africa americalati americadonorte asia distnciaiusa vistos, re
predict Ylnsoftmer
*predict Elnsoftmer, r

xtreg lnsofneg europe africa americalati americadonorte asia distnciaiusa vistos, re
predict Ylnsofneg
*predict Elnsofneg, r

*Por fim, vamos realizar o teste de exogeneidade:
xtreg lncon lnregul lncaphum lninfra lnsoftmer lnsofneg Ylnregul Ylncaphum Ylninfra Ylnsoftmer Ylnsofneg, re


*Podemos pensar também no estimador de primeira diferença:
reg d.lncon d.lnregul d.lncaphum d.lninfra d.lnsoftmer d.lnsofneg


*Demonstrando que, em uma situação específica, EF=PD
keep if year>=2015
reg d.lncon d.lnregul d.lncaphum d.lninfra d.lnsoftmer d.lnsofneg
xtreg lncon lnregul lncaphum lninfra lnsoftmer lnsofneg,fe

