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
estimate 'Logit et proba gravite BASSE' Intercept 1 Gravite 1 0 0 0 / ilink e cl; 
estimate 'Logit et proba gravite BASSE-EVALUER' Intercept 1 Gravite 0 1 0 0 / ilink e cl; 
estimate 'Logit et proba gravite MODEREE-EVALUER' Intercept 1 Gravite 0 0 1 0 / ilink e cl; 
lsmeans Gravite R_TDM_TAP FC Temp/ cl ilink;
/*Odds Ratios --> proba de l'évenement / proba de l'évenement contraire*/
estimate 'OR(Retine_saine/Retine_depigm T1/T2)' Intercept 0 Temp 0 1 -1 / cl e ilink exp; /* OR = Odd Ratio*/
run;


proc glimmix data=work.data_projet;
class SpO2 FC Temp;
model Hospit_ou_rehospit(event='Oui') = SpO2 FC Temp/ dist = binary
 			link=logit
 			chisq
 			ddfm=none
 			solution;
/* Combinaison linéaire des coefficients */
lsmeans SpO2 FC Temp/ cl ilink;
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


proc glimmix data=work.data_projet;
class Ceph_Courb SymptORL FR SpO2 FC;
model Hospit_ou_rehospit = Ceph_Courb SymptORL FR SpO2 FC/ dist = binary
 			link=logit
 			chisq
 			ddfm=none
 			solution;
lsmeans Ceph_Courb SymptORL FR SpO2 FC/ cl ilink;
run;

proc glimmix data=work.data_projet;
class Sexe Ceph_Courb Gout_Odorat SymptORL SymptDig TotSympt FR SpO2 Avec_maladie_respi_hypercapnique Air_ou_O2 PAS FC Conscience Temp;
model Hospit_ou_rehospit = Sexe Ceph_Courb Gout_Odorat SymptORL SymptDig TotSympt FR SpO2 Avec_maladie_respi_hypercapnique Air_ou_O2 PAS FC Conscience Temp/ dist = binary
 			link=logit
 			chisq
 			ddfm=none
 			solution;
lsmeans Ceph_Courb SymptORL FR SpO2 FC/ cl ilink;
run;
