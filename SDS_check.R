#...........................................................#
# Inverstigar aumento de volume de dados na SDS             #
#
#

rm(list = ls())

library(stringr)
library(dplyr)
library(ggplot2)
library(reshape2)
library(forcats)

#---- dir_list
# listar diretórios até um nível determinado

dir_list <- function(path, level=1){
  dd <- unique(
        str_split_fixed(
          list.dirs(path), pattern = '/', n = level+1)[,level])
  dd <- dd[nchar(dd) != 0]
  return(dd)  
}

a2024 <- list()
sta <- dir_list('/SDS/2024/BL', level = 5)
for(i in 1:length(sta)){
  a2024[[i]] <- str_split_fixed(
                  system(paste0('du -sm  /SDS/2024/BL/',sta[i]), intern = T),
                  pattern = '\t', 2)
  a2024[[i]][2] <- sta[i]
}
sds_2024 <- data.frame(do.call(rbind, a2024))
sds_2024$X1 <- as.numeric(sds_2024$X1)
names(sds_2024) <- c("2024", "Station")

# criando data.frame 2023
a2023 <- list()
sta <- dir_list('/SDS/2023/BL', level = 5)
for(i in 1:length(sta)){
  a2023[[i]] <- str_split_fixed(
    system(paste0('du -sm  /SDS/2023/BL/',sta[i]), intern = T),
    pattern = '\t', 2)
  a2023[[i]][2] <- sta[i]
}
sds_2023 <- data.frame(do.call(rbind, a2023))
sds_2023$X1 <- as.numeric(sds_2023$X1)
names(sds_2023) <- c("2023", "Station")

sds_space <- merge(sds_2023, sds_2024, by = 'Station', all = T)
names(sds_space)[1] <- c("Estação")
# entrou PRMB saiu PARB
# qual estação tem mais dado em 2024 que em 2023?

sds$Station[which(sds[,'2024'] > sds[,'2023'])]

#"AMBA" --> trocou de rede
#"AQDB" -->
#"ARCA" -->
#"C2SB" 
#"CANS" 
#"CNLB" 
#"ESAR" --> completude?
#"FRTB" 
#"MURT" --> trocou de rede
#"PCMB" 
#"PRB1" --> reinstalada em Set/23
#"RCLB"
#"RVDE" --> trocou de rede
#"SJMB"--> completude?

#Fazer barplot
sds_space$dif <- sds_space[,3] - sds_space[,2]
ordem <- arrange(sds_space, desc(dif))
ord <- as.factor((ordem$Estação))
dt1 <- melt(ordem[,1:4], id='Estação')

dt1$Estação <- factor(dt1$Estação, levels=ord)

pl1 <- 
  ggplot(dt1, aes(x=Estação, y=value, fill=variable))+
  geom_bar(stat="identity", position = position_dodge()) + 
  theme_minimal()+
  ggtitle("Comparação de espaço alocado na SDS por estação para 2023, 2024(até 23Nov), e a diferença entre eles")+
  scale_fill_brewer(palette="Blues", direction = 1) + 
  ylab("Tamanho (MB)") + 
  theme(axis.title.x = element_blank(),
        axis.text.x = element_text(angle=90),
        panel.border = element_rect(fill=NA, colour = 'black'),
        legend.title = element_blank()) 

#---- Total de dados em porcentagem
aux <- readLines('R_seism/sds_2023.txt')
aux <- aux[which(!(is.na(str_match(aux, pattern = 'BL,'))))]
aux <- str_split_fixed(aux, pattern = c("[[:punct:]]"), n=14)[,c(2,3,5,12,13)]
a <- as.matrix(aux)
aa <- data.frame(aux)
aa$valor <- as.numeric(paste0(aa$X4, '.', aa$X5))
names(aa)[2] <- 'Sta'

sds_2023 <-
  aa %>% 
    group_by(Sta) %>%
    summarise(sds2023 = mean(valor))

aux <- readLines('R_seism/sds_2024.txt')
aux <- aux[which(!(is.na(str_match(aux, pattern = 'BL,'))))]
aux <- str_split_fixed(aux, pattern = c("[[:punct:]]"), n=14)[,c(2,3,5,12,13)]
a <- as.matrix(aux)
aa <- data.frame(aux)
aa$valor <- as.numeric(paste0(aa$X4, '.', aa$X5))
names(aa)[2] <- 'Sta'

sds_2024 <-
  aa %>% 
  group_by(Sta) %>%
  summarise(sds2023 = mean(valor))


sds_comp <- merge(sds_2023, sds_2024, by='Sta')
names(sds_comp) <- c("Estação", 'sds_2023', 'sds_2024')

#Fazer barplot
sds_comp$dif <- sds_comp[,3] - sds_comp[,2]
names(sds_comp)[2:3] <- c('2023','2024')
ordem <- arrange(sds_comp, desc(dif))
ord <- as.factor((ordem$Estação))
dt2 <- melt(ordem[,1:4], id='Estação')
dt2$Estação <- factor(dt2$Estação, levels=ord)

pl2 <- 
  ggplot(dt2, aes(x=Estação, y=value, fill=variable))+
  geom_bar(stat="identity", position = position_dodge()) + 
  theme_minimal()+
  ggtitle("Comparação de completude na SDS por estação para 2023, 2024(até 23Nov), e a diferença entre eles")+
  scale_fill_brewer(palette="Greens", direction = 1) + 
  ylab("Completude (%)") + 
  theme(axis.title.x = element_blank(),
        axis.text.x = element_text(angle=90),
        panel.border = element_rect(fill=NA, colour = 'black'),
        legend.title = element_blank()) 


jpeg('~/R_seism/sds_2023-2024-total.jpeg',width = 960)
  pl1
dev.off()

jpeg('~/R_seism/sds_2023-2024-percentual.jpeg',width = 960)
pl2
dev.off()
