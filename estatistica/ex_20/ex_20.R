input = ("
Processo Temperatura  Nivel
I         1           79
I         1           96
I         1           110
I         2           122
I         2           128
I         2           128
I         3           72
I         3           109
I         3           111
I         4           131
I         4           72
I         4           111
II        1           122
II        1           44
II        1           82
II        2           100
II        2           117
II        2           103
II        3           115
II        3           59
II        3           79
II        4           72
II        4           69
II        4           130
III       1           80
III       1           74
III       1           72
III       2           34
III       2           50
III       2           85
III       3           126
III       3           146
III       3           114
III       4           115
III       4           99
III       4           133
")

data = read.table(textConnection(input), header=TRUE)
anova2 <- aov(Nivel ~ as.factor(Processo) * as.factor(Temperatura), data=data)
summary(anova2)