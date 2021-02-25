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
model Hospit_ou_rehospit(event='Oui') = Gravite R_TDM_TAP FC Temp/ dist = binary
 			link=logit
 			chisq
 			ddfm=none
 			solution;
/* Combinaison linéaire des coefficients */ 
*estimate 'Logit et proba scan=Envahissement >25% et <50%+Gravité=Moderee-Evaluer' Intercept 1 R_TDM_TAP 0 1 0 0 Gravite 0 0 1 0 0 / ilink e cl;
*estimate 'Logit et proba scan=Envahissement >25% et <50%+Gravité=Elevee' Intercept 1 R_TDM_TAP 0 1 0 0 Gravite 0 0 0 0 1 / ilink e cl;
*estimate 'Logit et proba scan Envahissement >25% et <50%+FC = 2 ' Intercept 1 R_TDM_TAP 0 1 0 0 FC 0 0 1 / ilink e cl;  
*estimate 'Logit et proba scan Envahissement >25% et <50%+FC = 1 ' Intercept 1 R_TDM_TAP 0 1 0 0 FC 0 1 0 / ilink e cl; 
*estimate 'Logit et proba scan Envahissement >25% et <50%+Temp = 2 ' Intercept 1 R_TDM_TAP 0 0 0 1 Temp 0 1 0 / ilink e cl; 
*estimate 'Logit et proba scan Envahissement >25% et <50%+Temp = 0 ' Intercept 1 R_TDM_TAP 1 0 0 0 Temp 0 0 1 / ilink e cl; 
*lsmeans Gravite R_TDM_TAP FC Temp/ cl ilink;
/*Odds Ratios --> proba de l'évenement / proba de l'évenement contraire*/
estimate 'OR(scan Envahissement >25% et <50%/proba évènement contraire)' Intercept 0 R_TDM_TAP -1 3 -1 -1 / cl e ilink exp;
estimate 'OR(scan Envahissement <25%/proba évènement contraire)' Intercept 0 R_TDM_TAP 3 -1 -1 -1 / cl e ilink exp;
estimate 'OR(scan Envahissement >50%/proba évènement contraire)' Intercept 0 R_TDM_TAP -1 -1 3 -1 / cl e ilink exp;
estimate 'OR(scan Pas Envahissement/proba évènement contraire)' Intercept 0 R_TDM_TAP -1 -1 -1 3 / cl e ilink exp;
estimate 'OR(FC 2/proba évènement contraire)' Intercept 0 FC -1 -1 2 / cl e ilink exp;
estimate 'OR(FC 1/proba évènement contraire)' Intercept 0 FC -1 2 -1 / cl e ilink exp;
estimate 'OR(gravité 5/proba évènement contraire)' Intercept 0 Gravite -1 -1 -1 -1 4 / cl e ilink exp;
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


