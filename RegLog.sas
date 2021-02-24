proc import datafile='/folders/myfolders/sasuser.v94/BioStat/Biostat_donnes_projet.txt'
	dbms=TAB
	out=work.data_projet;
	getnames=yes;
	GUESSINGROWS=MAX;

PROC CONTENTS DATA=work.data_projet; 
RUN; 


/*modele 1 avec scan AIC = 401 */
proc glimmix data=work.data_projet;
class Gravite R_TDM_TAP FC Temp;
model Hospit_ou_rehospit = Gravite R_TDM_TAP FC Temp/ dist = binary
 			link=logit
 			chisq
 			ddfm=none
 			solution;
/* Combinaison linéaire des coefficients */
estimate 'Logit et proba gravite' Intercept 1 Gravite 0 0 0 1 / ilink e cl; 
lsmeans Gravite R_TDM_TAP FC Temp/ cl ilink;
run;


/*modele 2 sans scan à 3 var AIC = 596.91*/
proc glimmix data=work.data_projet;
class Gravite Temp Gout_Odorat;
model Hospit_ou_rehospit = Gravite Temp Gout_Odorat/ dist = binary
 			link=logit
 			chisq
 			ddfm=none
 			solution;
*estimate 'Logit et proba gravite' Intercept 1 Gravite 0 0 0 1 / ilink e cl; 
lsmeans Gravite Temp Gout_Odorat/ cl ilink;
run;


/*modele 2 sans scan à 2 var AIC = 597.69*/
proc glimmix data=work.data_projet;
class Gravite Temp Gout_Odorat FC;
model Hospit_ou_rehospit = Gravite Temp Gout_Odorat FC/ dist = binary
 			link=logit
 			chisq
 			ddfm=none
 			solution;
run;


