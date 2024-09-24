#install.packages("readxl")
library(readxl)
df = read_excel("three_d.xlsx") 

png(file="plot.png", width=6, height=8, units="in", res=600)
par(mfrow=c(3,2),oma = c(4, 1, 1, 1),xpd = FALSE)

plot(df$time[1:3],df$apb[1:3] , type = "b", frame = FALSE, pch = 17, 
     col = "black", ylim = c(min(df$apb),max(df$apb)), xlim = c(min(df$time),max(df$time)),
     xlab = "Estimation Time (seconds)", ylab = "Absolute Percentage Bias",main= "Diagonal Covariance (Dimension = 3)")

lines(df$time[4:6], df$apb[4:6], pch = 18, col = "red", type = "b", lty = 3)
lines(df$time[7:9], df$apb[7:9], pch = 22, col = "blue", type = "b", lty = 6)

df = read_excel("three_full.xlsx") 

plot(df$time[1:3],df$apb[1:3] , type = "b", frame = FALSE, pch = 17, 
     col = "black", ylim = c(min(df$apb),max(df$apb)), xlim = c(min(df$time),max(df$time)),
     xlab = "Estimation Time (seconds)", ylab = "Absolute Percentage Bias",main= "Full Covariance (Dimension = 3)")

lines(df$time[4:6], df$apb[4:6], pch = 18, col = "red", type = "b", lty = 3)
lines(df$time[7:9], df$apb[7:9], pch = 22, col = "blue", type = "b", lty = 6)

df = read_excel("five_d.xlsx") 

plot(df$time[1:3],df$apb[1:3] , type = "b", frame = FALSE, pch = 17, 
     col = "black", ylim = c(min(df$apb),max(df$apb)), xlim = c(min(df$time),max(df$time)),
     xlab = "Estimation Time (seconds)", ylab = "Absolute Percentage Bias",main= "Diagonal Covariance (Dimension = 5)")

lines(df$time[4:6], df$apb[4:6], pch = 18, col = "red", type = "b", lty = 3)
lines(df$time[7:9], df$apb[7:9], pch = 22, col = "blue", type = "b", lty = 6)

df = read_excel("five_full.xlsx") 

plot(df$time[1:4],df$apb[1:4] , type = "b", frame = FALSE, pch = 17, 
     col = "black", ylim = c(min(df$apb),max(df$apb)), xlim = c(min(df$time),max(df$time)),
     xlab = "Estimation Time (seconds)", ylab = "Absolute Percentage Bias",main= "Full Covariance (Dimension = 5)")

lines(df$time[5:8], df$apb[5:8], pch = 18, col = "red", type = "b", lty = 3)
lines(df$time[9:12], df$apb[9:12], pch = 22, col = "blue", type = "b", lty = 6)

df = read_excel("ten_d.xlsx") 

plot(df$time[1:3],df$apb[1:3] , type = "b", frame = FALSE, pch = 17, 
     col = "black", ylim = c(min(df$apb),max(df$apb)), xlim = c(min(df$time),max(df$time)),
     xlab = "Estimation Time (seconds)", ylab = "Absolute Percentage Bias",main= "Diagonal Covariance (Dimension = 10)")

lines(df$time[4:6], df$apb[4:6], pch = 18, col = "red", type = "b", lty = 3)
lines(df$time[7:9], df$apb[7:9], pch = 22, col = "blue", type = "b", lty = 6)

df = read_excel("ten_full.xlsx") 

plot(df$time[1:3],df$apb[1:3] , type = "b", frame = FALSE, pch = 17, 
     col = "black", ylim = c(min(df$apb),max(df$apb)), xlim = c(min(df$time),max(df$time)),
     xlab = "Estimation Time (seconds)", ylab = "Absolute Percentage Bias",main= "Full Covariance (Dimension = 10)")

lines(df$time[4:6], df$apb[4:6], pch = 18, col = "red", type = "b", lty = 3)
lines(df$time[7:9], df$apb[7:9], pch = 22, col = "blue", type = "b", lty = 6)
par(xpd=NA)
legend("bottom",legend=c( "Halton", "MLHS", "DQ"), horiz = TRUE,inset = c(0,-1),
       col=c("black", "red","blue"), pch = c(17,18,22), lty = c(1,3,6), cex=1)

dev.off()