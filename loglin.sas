proc import datafile='/folders/myfolders/Biostat_donnes_projet.txt'
	dbms=TAB
	out=work.data_projet;
	getnames=yes;
	GUESSINGROWS=MAX;

PROC CONTENTS DATA=work.data_projet; 
RUN; 

proc catmod data=work.data_projet;
     model Hospit_rehospit*FR*SpO2*avec_maladie_respi_hypercapnique*Air_ou_O2*PAS*FC*Conscience*Temp = _response_
           /*/ ML=nr pred=freq profile covb clparm zero=sampling miss=sampling */;
     loglin  Hospit_rehospit FR SpO2 avec_maladie_respi_hypercapnique Air_ou_O2 PAS FC Conscience Temp;
quit;
run;

proc catmod data=work.data_projet;
     model Hospit_rehospit*SpO2*avec_maladie_respi_hypercapnique*FC*Conscience*Temp = _response_
           /*/ ML=nr pred=freq profile covb clparm zero=sampling miss=sampling */;
     loglin  Hospit_rehospit SpO2 avec_maladie_respi_hypercapnique FC Conscience Temp;
quit;
run;

proc catmod data=work.data_projet;
     model Hospit_rehospit*SpO2*FC*Temp = _response_;
     loglin  Hospit_rehospit SpO2 FC Temp
     			Hospit_rehospit | SpO2
     			Hospit_rehospit | FC
     			SpO2 | Temp;
quit;
run;

proc catmod data=work.data_projet;
     model Hospit_rehospit*SpO2*FC*Temp = _response_;
     loglin  Hospit_rehospit SpO2 FC Temp
     			Hospit_rehospit | SpO2
     			SpO2 | FC
     			Hospit_rehospit | Temp;
quit;
run;
proc catmod data=work.data_projet;
     model Hospit_rehospit*SpO2*avec_maladie_respi_hypercapnique*FC*Conscience*Temp = _response_;
     loglin  Hospit_rehospit SpO2 avec_maladie_respi_hypercapnique FC Conscience Temp
     			Hospit_rehospit*Temp
     			SpO2*avec_maladie_respi_hypercapnique
     			SpO2*FC
     			SpO2*Conscience
     			SpO2*Temp;
quit;
run;




/* Modèle qui semble correcte, p-values significatives et maximum ed vraisemblance qui restitue bien */
proc catmod data=work.data_projet;
     model Hospit_rehospit*SpO2*FC*Temp = _response_;
     loglin  Hospit_rehospit SpO2 FC Temp
     			Hospit_rehospit*Temp
     			SpO2*Temp;
quit;
run;