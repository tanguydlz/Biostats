%web_drop_table(WORK.projet);

proc import datafile="/home/u50289547/PROJET/Biostat_donnes_projet.txt"
     dbms=TAB
     out=work.projet;      
     getnames=yes;
     GUESSINGROWS=MAX;
     
run;

%web_open_table(WORK.projet);

proc print data=work.projet; 
run;

proc freq data=work.projet;
tables TotSympt / plots=freqplot;
run;
 
proc genmod data = work.projet;
  class Sexe Temp Conscience PAS FC Avec_maladie_respi_hypercapnique SpO2 FR  /param=glm;
  model TotSympt = Sexe Temp Conscience PAS FC Avec_maladie_respi_hypercapnique SpO2 FR Age / type3 dist=poisson;
run;

data pvalue;
  df = 974; chisq = 79.8179;
  pvalue = 1 - probchi(chisq, df);
run;
proc print data = pvalue noobs;
run;
 
proc genmod data = work.projet;
  class Ceph_Courb Gout_Odorat SymptORL SymptDig  /param=glm;
  model TotSympt = Ceph_Courb Gout_Odorat SymptORL SymptDig / type3 dist=poisson;
run;


/*Sans construction symptômes*/
proc glimmix data=work.projet order=data;
class Sexe Temp Conscience PAS FC Avec_maladie_respi_hypercapnique SpO2 FR ;
model TotSympt = Sexe Temp Conscience PAS FC Avec_maladie_respi_hypercapnique SpO2 FR Age/ dist = poisson /*par défault link=log et c'est ce qu'on veut*/
								chisq 
								ddfm=none 
								solution;
run;

proc glimmix data=work.projet order=data;
class SpO2;
model TotSympt = SpO2 Age/ dist = poisson chisq ddfm=none solution;
/*Comptage totsympt avec Sp02=para et age*/
estimate 'z* comptage TotSympt+SpO2_0' Intercept 1 SpO2 1 0 0 0 Age 1 / ilink e cl alpha = 0.1;
estimate 'z* comptage TotSympt+SpO2_1' Intercept 1 SpO2 0 1 0 0 Age 1 / ilink e cl alpha = 0.1;
estimate 'z* comptage TotSympt+SpO2_2' Intercept 1 SpO2 0 0 1 0 Age 1 / ilink e cl alpha = 0.1;
estimate 'z* comptage TotSympt+SpO2_3' Intercept 1 SpO2 0 0 0 1 Age 1 / ilink e cl alpha = 0.1;
estimate 'z* comptage SpO2_0' Intercept 1 SpO2 1 0 0 0 / ilink e cl; 
estimate 'z* comptage SpO2_1' Intercept 1 SpO2 0 1 0 0 / ilink e cl; 
estimate 'z* comptage SpO2_2' Intercept 1 SpO2 0 0 1 0 / ilink e cl; 
estimate 'z* comptage SpO2_3' Intercept 1 SpO2 0 0 0 1 / ilink e cl;
/*Ratio de comptage (CR)*/
estimate 'CR=TotSympt SpO2_0/(SpO2_1,SpO2_2,SpO2_3)' Intercept 0 SpO2 3 -1 -1 -1 / cl e ilink exp; 
estimate 'CR=TotSympt SpO2_1/(SpO2_0,SpO2_2,SpO2_3)' Intercept 0 SpO2 -1 3 -1 -1 / cl e ilink exp; 
estimate 'CR=TotSympt SpO2_2/(SpO2_1,SpO2_0,SpO2_3)' Intercept 0 SpO2 -1 -1 3 -1 / cl e ilink exp; 
estimate 'CR=TotSympt SpO2_3/(SpO2_1,SpO2_2,SpO2_0)' Intercept 0 SpO2 -1 -1 -1 3 / cl e ilink exp; 
run;