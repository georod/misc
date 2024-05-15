# Malaria plot (lines & points)
# 2024-05-15
# Peter R.

# Aim: Recreated malaria_fig1.png without access to the raw data.

# Notes
# - data were extracted from PNG with https://automeris.io/WebPlotDigitizer/ 
# - In a nutshell, I uploaded an image to the app and traced the data
# - I finished off the fig using Adobe Illustrator


library(ggplot2)

  
wmr <- read.csv("./data/wmr_data.csv", header=F)
gts <- read.csv("./data/gts_data.csv", header=F)

wmr2 <- wmr
wmr2$V1 <- round(wmr$V1)
wmr2$V2 <- round(wmr$V2,1)

gts2 <- gts
gts2$V1 <- round(gts$V1)
gts2$V2 <- round(gts$V2,1)

wmr2_up <- rbind.data.frame(c(2015, 62.5),
                            c(2020, 60.4),
                            c(2021, 58.2),
                            c(2025, 51.7),
                            c(2030, 44.6))

names(wmr2_up) <- c("V1", "V2")


wmr2[6, 1:2] <- wmr2_up[1, 1:2]
wmr2[11, 1:2] <- wmr2_up[2, 1:2]
wmr2[12, 1:2] <- wmr2_up[3, 1:2]
wmr2[16, 1:2] <- wmr2_up[4, 1:2]
wmr2[21, 1:2] <- wmr2_up[5, 1:2]
wmr2

wmr3 <- wmr2[1:12,] 
wmr3$label <- c("wmr")


gts2_up <- rbind.data.frame(c(2020, 37.5),
                            c(2021, 32.2),
                            c(2025, 15.6)
                            )
names(gts2_up) <- c("V1", "V2")
gts2[11, 1:2] <- gts2_up[1, 1:2]
gts2[12, 1:2] <- gts2_up[2, 1:2]
gts2[16, 1:2] <- gts2_up[3, 1:2]
gts2

gts3 <- gts2[6:21,] # plot this
gts3$label <- c("gts")

forecast1 <- wmr2[12:21,] # plot this
forecast1$label <- c("forecast")


cbind.data.frame(wmr2, V3=gts2[,2])

df1 <- rbind(rbind(wmr3, gts3, forecast1))


pdf("./plots/fig1_v1.pdf", width = 6.46, height = 4.88)
plot1 <- ggplot(data=df1, aes(x=V1, y=V2, group=label)) +
  geom_line( aes(color=label), size=0.75)+
  geom_point(aes(color=label), shape=21, fill='white', stroke=1.5, size=2.5) +
  scale_color_manual(values=c("#5D6D7E", "#17A589", "#3498DB" )) +
     #scale_color_manual(values=c("#CC6666", "#9999CC", "#999999" )) +
 expand_limits(y = 100) +  theme_minimal()

#expand_limits(y = 0)
plot1 + scale_y_continuous(breaks=seq(0,100,10)) + scale_x_continuous(breaks=seq(2010,2030,1)) +
  ylab("Malaria deaths per 100000 population at risk") +
theme(panel.grid.minor.x=element_blank(), panel.grid.major.x=element_blank(), panel.grid.minor.y=element_blank(), 
      axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=0.5), axis.title.x=element_blank(), 
      axis.ticks.length.x=unit(0.15, "cm"), axis.ticks.x= element_line(color="gray"),
      axis.line.x = element_line(color="gray", size = 0.5),
      legend.position="top")

dev.off()


