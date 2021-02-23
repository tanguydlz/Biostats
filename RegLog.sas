proc import datafile='/folders/myfolders/sasuser.v94/BioStat/Biostat_donnes_projet.txt'
	dbms=TAB
	out=work.data_projet;
	getnames=yes;
	GUESSINGROWS=MAX;

PROC CONTENTS DATA=work.data_projet; 
RUN; 


proc glimmix data=work.data_projet;
class SpO2 Ceph_Courb FC FR;
model Hospit_ou_rehospit = SpO2 Ceph_Courb FC FR/ dist = binary
 			link=cumlogit
 			chisq
 			ddfm=none
 			solution;
/* Combinaison linéaire des coefficients */
estimate 'Logit et proba cata+trait2' Intercept 1 SpO2 1 0 0 0 Ceph_Courb 0 1 FC 1 0 0 FR 1 0/ ilink e cl /*alpha = 0.1*/;
lsmeans SpO2 Ceph_Courb FC FR/ cl ilink;
run;


/* Résultats R */
/*AIC forward */
/*V25 ~ SpO2 + Ceph_Courb + FC + FR AIC = 523.78 */
proc glimmix data=work.data_projet;
class SpO2 Ceph_Courb FC FR;
model Hospit_ou_rehospit = SpO2 Ceph_Courb FC FR/ dist = binary
 			link=cumlogit
 			chisq
 			ddfm=none
 			solution;
run;

/*V25 ~ SpO2 + Ceph_Courb + FC AIC = 524.82 */
proc glimmix data=work.data_projet;
class SpO2 Ceph_Courb FC;
model Hospit_ou_rehospit = SpO2 Ceph_Courb FC/ dist = binary
 			link=cumlogit
 			chisq
 			ddfm=none
 			solution;
run;

/*AIC backward */
/* V25 ~ Ceph_Courb + SymptORL + FR + SpO2 + FC AIC 525.29 */
proc glimmix data=work.data_projet;
class Ceph_Courb SymptORL FR SpO2 FC;
model Hospit_ou_rehospit = Ceph_Courb SymptORL FR SpO2 FC/ dist = binary
 			link=cumlogit
 			chisq
 			ddfm=none
 			solution;
run;

V25 ~ Ceph_Courb + Gout_Odorat + SymptORL + FR + SpO2 + FC /* 526.79 */
V25 ~ Ceph_Courb + Gout_Odorat + SymptORL + FR + SpO2 + Avec_maladie_respi_hypercapnique + 
    FC /* 528.35 */
V25 ~ Ceph_Courb + Gout_Odorat + SymptORL + SymptDig + FR + SpO2 + 
    Avec_maladie_respi_hypercapnique + FC /*AIC 529.89 */
V25 ~ Sexe + Ceph_Courb + Gout_Odorat + SymptORL + SymptDig + 
    TotSympt + FR + SpO2 + Avec_maladie_respi_hypercapnique + 
    Air_ou_O2 + PAS + FC + Conscience + Temp + Score /*AIC = 540.58 */
V25 ~ Sexe + Ceph_Courb + Gout_Odorat + SymptORL + SymptDig + 
    FR + SpO2 + Avec_maladie_respi_hypercapnique + PAS + FC + 
    Conscience + Temp /* Idem */
	

