# Bibliotecas

library(tidyverse)
library(readr)
library(ggpubr)
library(scales)
library(MASS)



# Importação dos dados

imdb2 <- read_rds("imdb2.rds")
df_g2 <- imdb2 %>% filter(estreia=="2000-2010")
imdb2 <- imdb2 %>% mutate(Lucro=receita-orcamento)
df_g2 <- df_g2 %>% mutate(Lucro=receita-orcamento)



# Pergunta 01

IC_media_Z <- function(dados, confianca, dp) {
  xbarra = mean(dados, na.rm=TRUE)
  z = qnorm((1 + confianca) / 2)
  n = length(dados)
  e = z * (dp / sqrt(n))
  LS = xbarra + e
  LI = xbarra - e
  return(c(LI, LS))
}
IC_media_Z(imdb2$Lucro, 0.95, 55e6)



# Pergunda 02

IC_media_t <- function(dados, confianca) {
  xbarra = mean(dados, na.rm=TRUE)
  n = length(dados)
  t = qt((1 + confianca) / 2, (n - 1))
  e = t * (sd(dados, na.rm=TRUE) / sqrt(n))
  LS = xbarra + e
  LI = xbarra - e
  return(c(LI, LS))
}
IC_media_t(imdb2$Lucro, 0.95)



# Pergunta 03

imdb2 <- imdb2 %>% mutate(
  Aprovado=ifelse(nota_imdb >= 6.5, TRUE, FALSE)
)
df_g2 <- imdb2 %>% mutate(
  Aprovado=ifelse(nota_imdb >= 6.5, TRUE, FALSE)
)



# Pergunta 04

IC_prop <- function(dados, confianca) {
  n = length(dados)
  z = qnorm((1 + confianca) / 2)
  p_linha = table(dados) / n
  e = z * sqrt((p_linha * (1 - p_linha)) / n)
  LS = p_linha + e
  LI = p_linha - e
  return(c(LI, LS))
}
IC_prop(imdb2$Aprovado, 0.80)
IC_prop(imdb2$Aprovado, 0.95)
IC_prop(imdb2$Aprovado, 0.99)



# Pergunta 05

IC_var <- function(dados, confianca) {
  gl = length(dados) - 1
  S = var(dados, na.rm=TRUE)
  chi_lower = qchisq((1 + confianca) / 2, gl)
  chi_upper = qchisq((1 - confianca) / 2, gl)
  LI = sqrt(gl * S / chi_lower) 
  LS = sqrt(gl * S / chi_upper)
  return(c(LI, LS))
}
IC_var(imdb2$Lucro, 0.95)



# Pergunta 06

p1 <- df_g2 %>% ggplot(aes(x=Aprovado, y=Lucro)) +
  geom_boxplot(aes(fill=Aprovado)) +
  theme(legend.position="none") +
  scale_y_continuous(labels=unit_format(unit="M", scale=1e-6)) +
  labs(
    x="Aprovado",
    y="Lucro",
    title="Gráfico de Boxplot",
    subtitle="Lucro em função de aprovação"
  )

p2 <- df_g2 %>% ggplot(aes(x=Aprovado, y=Lucro)) +
  theme(legend.position="none") +
  geom_jitter(aes(colour=Aprovado)) +
  scale_y_continuous(labels=unit_format(unit="M", scale=1e-6)) +
  labs(
    x="Aprovado",
    y="Lucro",
    title="Stripchart",
    subtitle="Lucro em função de aprovação"
  )

ggarrange(p1, p2, ncol=2)



# Pergunta 07

var.test(
  x=df_g2[df_g2$Aprovado==TRUE,]$Lucro,
  y=df_g2[df_g2$Aprovado==FALSE,]$Lucro
)

F_crit <- qf(
  p=0.05, 
  df1=length(df_g2[df_g2$Aprovado==TRUE,]$Lucro) - 1, 
  df2=length(df_g2[df_g2$Aprovado==FALSE,]$Lucro) - 1, 
  lower.tail=FALSE
)
F_crit



# Pergunta 08

t.test(
  x=df_g2[df_g2$Aprovado==TRUE,]$Lucro,
  y=df_g2[df_g2$Aprovado==FALSE,]$Lucro,
  var.equal=FALSE
)

mean(df_g2[df_g2$Aprovado==TRUE,]$Lucro) - mean(df_g2[df_g2$Aprovado==FALSE,]$Lucro)



# Pergunta 09

fit <- fitdistr(df_g2$nota_imdb, "normal")
MI <- fit$estimate[1]
SIGMA <- fit$estimate[2]

plot3 <- df_g2 %>% ggplot(aes(x=nota_imdb)) +
  geom_histogram(
    aes(y=..density..), 
    bins=10, 
    colour="black", 
    fill="tan1"
  ) +
  labs(
    x="Nota imdb",
    y="Densidade de frequência",
    title="Histograma de densidade\nde frequência",
    subtitle="Nota IMDB"
  ) +
  stat_function(
    fun=dnorm,
    args=list(mean=MI, sd=SIGMA),
    size=1,
    col="black",
    linetype=1
  )

plot4 <- df_g2 %>% ggplot(aes(sample=nota_imdb)) +
  geom_qq_line(colour="darkorange4") +
  geom_qq(shape=21, colour="tan4", fill="tan1", size=3) +
  labs(
    x="Quantis teóricos",
    y="Quantis amostrais",
    title="Papel de probabilidade normal",
    subtitle="Nota IMDB"
  )

ggarrange(plot3, plot4, ncol=2)



# Pergunta 10

x = df_g2$nota_imdb
KS_teste <- ks.test(x, "pnorm", mean=mean(x), sd=sd(x))
KS_teste

D_crit <- 1.63 / sqrt(length(x))
D_crit

