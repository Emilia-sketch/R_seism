#


rm(list=ls())

library(ggplot2)

inp <- read.table('~/R_seism/rede_armazenamento.txt')
dt <- data.frame(yr=as.numeric(substr(inp$V2,1,4)),
                 rede=substr(inp$V2,6,7),
                 store=as.numeric(inp$V1)/1024)
 
p1 <- ggplot(dt[ dt$yr >= 2000,], aes(x=yr, y=store, fill=rede)) 

p1 + geom_bar(stat = 'identity', position=position_dodge()) +
  facet_wrap(.~rede)+
  #geom_point() + geom_line() +
  ylab('Total de dados armazenados (Gb)') +
  geom_text(aes(label = round(store,0)), vjust =1.5,
            size=3, position = "dodge") +

  #geom_label(aes(label = round(store,0)), label.size = 0.15) + 
  theme(legend.position = "none")

