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

PROC UNIVARIATE data=biostat_table;
var Age TotSympt Score;
RUN;

proc freq data=biostat_table;
tables Gravite*Hospit_ou_rehospit;
run;


/* Tables de contingence */
proc freq data=biostat_table;
tables Sexe*Hospit_ou_rehospit / chisq measures;
run;

proc freq data=biostat_table;
tables Gravite*R_TDM_TAP / chisq measures;
run;

