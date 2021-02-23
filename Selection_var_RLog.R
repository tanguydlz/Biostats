data <- read.csv2("C:/SASUniversityEdition/myfolders/sasuser.v94/BioStat/Biostat_donnes_projet.csv", sep=";", header = TRUE)
attach(data)
data2 = data[,2:17]
ytrain= data[,24]
data[,25] = recode(data[,24], "Non" = 0, "Oui" = 1)

glmnet(model.matrix(~., data2),ytrain,family="binomial", lambda=0)

install.packages("VGAM")
library(VGAM)
modele <- vglm(model.matrix(~., data2),ytrain,family=multinomial())
print(modele)

library(MASS)
str_constant <- "~ 1"
str_full <- model.matrix(~., data[,2:17])
str_full <- "~ Sexe+Ceph_Courb+Gout_Odorat+SymptORL+SymptDig+TotSympt+FR+SpO2+Avec_maladie_respi_hypercapnique+Air_ou_O2+PAS+FC+Conscience+Temp+Score"
modele <- glm(V25 ~ 1, data=data, family = binomial)
modele.forward <- stepAIC(modele, scope=list(lower=str_constant, upper=str_full), trace=TRUE, data=data, direction="forward")
modele2 <- glm(paste("V25", str_full), data=data, family = binomial)
modele.backward <- stepAIC(modele2, scope=list(lower=str_constant, upper=str_full), trace=TRUE, data=data, direction="backward")
