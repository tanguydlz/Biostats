/* Import du fichier */
PROC import datafile="/home/u50158257/sasuser.v94/Biostats/Biostat_donnes_projet.txt"
	DBMS=TAB
	OUT=biostat_table
	REPLACE;
	GETNAMES=YES;
	GUESSINGROWS=MAX;
RUN;

/* Caractéristiques de la table de données */
PROC CONTENTS data=biostat_table;
RUN;

/* Statistiques descriptives */
PROC MEANS data=biostat_table;
var Age TotSympt Score;
RUN;

proc sgplot data=biostat_table;
  histogram Age / nbins=10;
run;

proc sgplot data=biostat_table;
  vbar Sexe / response=Hospit_ou_rehospit;
run;

proc sgplot data=biostat_table;
  histogram Score / nbins=10 ;
run;

/* Tables de contingence */
proc freq data=biostat_table;
tables Sexe*Hospit_ou_rehospit / chisq measures;
run;

proc freq data=biostat_table;
tables Gravite*R_TDM_TAP / chisq measures;
run;


