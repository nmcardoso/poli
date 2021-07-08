library(tidyverse)
library(ggplot2)
library(readr)

imdb2 <- read_rds("imdb2.rds")
imdb2 <- imdb2 %>% mutate(`Razão ro`=receita/orcamento)

imdb2 %>% ggplot(aes(x=`Faixa de orçamento`, y=`Razão ro`)) +
  geom_boxplot(aes(fill=`Faixa de orçamento`)) + ylim(0,500)
  
imdb2 %>% ggplot(aes(x=orcamento, y=lucro)) +
  geom_point() #+ scale_y_log10()
