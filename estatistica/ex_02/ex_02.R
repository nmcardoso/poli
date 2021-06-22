library(qcc)

contagem <- c(126, 210, 67, 54, 131)
names(contagem) <- c('Componentes com falha', 'Componentes incorretos', 'Soldas insuficientes', 'Soldas em excesso', 'Falta de componentes')

pdf('plot.pdf')
par(mar=c(6, 1, 1, 1))
pareto.chart(contagem, cumperc=seq(0, 100, by=10), main='Diagrama de Pareto', ylab='Contagem', ylab2='Porcentagem acumulada', las=2)
dev.off()
