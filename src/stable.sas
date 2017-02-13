/*------------------------------------------------------------------*
   | The documentation and code below is supplied by HSR CodeXchange.             
   |              
   *------------------------------------------------------------------*/
                                                                                      
                                                                                      
                                                                                      
  /*------------------------------------------------------------------*
   | MACRO NAME  : stable
   | SHORT DESC  : Survival Analysis Summary-Summarizes univariate
   |               and multivariate Cox models
   *------------------------------------------------------------------*
   | CREATED BY  : Novotny, Paul                 (07/25/2011 14:43)
   *------------------------------------------------------------------*
   | PURPOSE
   |
   | This macro takes time to event data and outputs analysis summaries
   | in an RTF file.  Output can include number of events, median survival
   | times, log-rank p-values, Wilcoxon p-values, survival estimates at
   | specific time points, and univariate and multivariate Cox models.
   |
   | *------------------------------------------------------------------*
   |
   |  REQUIRED PARAMETERS
   |
   | *------------------------------------------------------------------*
   |
   |  Name      : DSN
   |  Default   : _last_
   |  Type      : Dataset Name
   |  Purpose   : Must have only one line per patient
   |
   |  Name      : TIME
   |  Default   : fu_time
   |  Type      : Numeric
   |  Purpose   : Contains the survival times.
   |            : All values must be greater than zero.
   |            : One or two variable may be listed: e.g. fu_time pg_time
   |
   |  Name      : STATUS
   |  Default   : fu_stat
   |  Type      : Numeric
   |  Purpose   : Censoring status for each patient.
   |            : By default, 1=Censored, 2=Event
   |            : but it can be changed with the CENSOR parameter.
   |            : If there are two time variables, there must be
   |            : two status variables.
   |
   |  Name      : VAR
   |  Default   : None
   |  Type      : Numeric or Character
   |  Purpose   : List of all discrete variables to be analyzed
   |            : for differences in survival times. These variables
   |            : will be included in a class statement in phreg.
   |            : These variables will have univariate analyses and
   |            : will be included in the multivariate model.
   |
   |  Name      : CVAR
   |  Default   : None
   |  Type      : Numeric
   |  Purpose   : List of all continuous variables to be analyzed
   |            : for differences in survival times.
   |            : These variables will have univariate analyses and
   |            : will be included in the multivariate model.
   |
   |            : NOTE: the macro call must have a VAR or CVAR parameter
   |            :       or have both
   |
   |  Name      : OUTDOC
   |  Default   : _survsum.doc
   |  Type      : Text
   |  Purpose   : name of RTF file created
   |            : this can contain the directory as well,
   |            : i.e. ~novotny/consult/tables/demogtable, if no
   |            : directory is defined, document will be stored in
   |            : directory from where the program is run.
   |
   | *------------------------------------------------------------------*
   |
   |  OPTIONAL PARAMETERS
   |
   | *------------------------------------------------------------------*
   |     DATA SPECIFICATION OPTIONS
   | *------------------------------------------------------------------*
   |
   |  Name      : REF
   |  Default   : 1
   |  Type      : Numeric
   |  Purpose   : By default, all variables in the VAR parameter are treated as
   |            : categorical variables with the first level being the default
   |            : reference group. If you want to change this default, this
   |            : parameter indicates which level is the new reference group.
   |            :
   |            : There should be one value for each variable in the VAR parameter.
   |
   |            : For example, if VAR=sex site, and REF=1 2, then the first category
   |            : is the reference group for sex and the second category is the
   |            : reference group for site.
   |
   |  Name      : CENSOR
   |  Default   : 1
   |  Type      : Numeric
   |  Purpose   : scoring of censor - events must equal censor+1
   |            : if there are two time endpoints, the censoring
   |            : must be the same for both variables
   |
   |  Name      : TIMEUNITS
   |  Default   : d
   |  Type      : Character
   |  Purpose   : units for the TIME parameter
   |            : d=days, w=weeks, m=months, y=years
   |
   |  Name      : MEDUNITS
   |  Default   : Set to TIMEUNITS parameter
   |  Type      : Character
   |  Purpose   : units for printing the median survival times
   |            : d=days, w=weeks, m=months, y=years
   |
   |  Name      : STRATA
   |  Default   : None
   |  Type      : Character
   |  Purpose   : A variable used to stratify in the adjusted phreg.
   |            : No results will be printed for this variable. It is
   |            : only used as a stratification variable.
   |            : This variable can not be included in the VAR or CVAR parameters.
   |
   | *------------------------------------------------------------------*
   |     COLUMN PRINTING OPTIONS
   | *------------------------------------------------------------------*
   |
   |  Name      : N
   |  Default   : Y
   |  Type      : Character
   |  Purpose   : option for printing the number of observations
   |            : y=print the column, n=do not print
   |
   |  Name      : EVENTS
   |  Default   : Y
   |  Type      : Character
   |  Purpose   : option for printing the number of events
   |            : y=print the column, n=do not print
   |
   |  Name      : MEDIAN
   |  Default   : Y
   |  Type      : Character
   |  Purpose   : option for suppressing the printing of the column
   |            : with the median survival times.
   |            : y=print the column, n=do not print
   |
   |  Name:     : MEDCI
   |  Default   : N
   |  Type      : Character
   |  Purpose   : option for printing the 95% confidence intervals
   |            : for the median survival times
   |            : y=print the 95% CI, n=do not print
   |
   |  Name      : PERCENT
   |  Default   : Y
   |  Type      : Character
   |  Purpose   : option for printing the percent of patients
   |            : surviving a certain number of years.
   |            : (based on the YEAR parameter)
   |            : y=print the column, n=do not print
   |
   |  Name      : YEAR
   |  Default   : 5
   |  Type      : Numeric
   |  Purpose   : Specifies the year at which to output the
   |            : percent of people surviving to that time point.
   |
   |  Name      : PCTCI
   |  Default   : Y
   |  Type      : Character
   |  Purpose   : option for printing 95% confidence intervals for the
   |            : percent of patients that survive a certain number of
   |            : years (based on the YEAR parameter)
   |            : y=print the 95% CI, n=do not print
   |
   |  Name      : LOGRANK
   |  Default   : N
   |  Type      : Character
   |  Purpose   : option for printing the log-rank p-value
   |            : y=print the column, n=do not print
   |
   |  Name      : WILCOXON
   |  Default   : N
   |  Type      : Character
   |  Purpose   : option for printing the Wilcoxon p-value
   |            : y=print the column, n=do not print
   |
   | *------------------------------------------------------------------*
   |     UNIVARIATE COX MODEL OPTIONS
   | *------------------------------------------------------------------*
   |
   |  Name      : HR1
   |  Default   : Y
   |  Type      : Character
   |  Purpose   : option for printing the univariate hazard rates
   |            : and their 95% CI. These are results from phreg with
   |            : only the single variable in the model.
   |            : y=print the column, n=do not print
   |
   |  Name      : WALD1
   |  Default   : N
   |  Type      : Character
   |  Purpose   : option for printing the univariate Wald p-values.
   |            : y=print the column, n=do not print
   |
   |  Name      : SCORE
   |  Default   : Y
   |  Type      : Character
   |  Purpose   : option for printing the univariate Score p-values.
   |            : This is the result from phreg with only the single
   |            : variable in the model.
   |            : y=print the column, n=do not print
   |
   |  Name      : UTOTAL
   |  Default   : N
   |  Type      : Character
   |  Purpose   : option to print the sample size for each univariate
   |            : Cox model. y=print the sample size, n=do not print
   |
   | *-------------------------------------------------------------------*
   |     MULTIVARIATE COX MODEL OPTIONS
   | *-------------------------------------------------------------------*
   |
   |  Name      : HR2
   |  Default   : Y
   |  Type      : Character
   |  Purpose   : option for printing the hazard rates and 95% CIs
   |            : from the multivariate model. The variables included
   |            : in this phreg model are all variables listed in
   |            : the VAR and CVAR parameters.
   |            : y=print the column, n=do not print
   |
   |  Name      : WALD2
   |  Default   : N
   |  Type      : Character
   |  Purpose   : option for printing the Wald p-values from the
   |            : multivariate model. This model includes all variables
   |            : in the VAR and CVAR parameters.
   |            : y=print the column, n=do not print
   |
   |  Name      : LR
   |  Default   : Y
   |  Type      : Character
   |  Purpose   : option for printing the likelihood ratio p-value
   |            : adjusting for all of the other variables in the model.
   |            : The variables included in this phreg model are all           : variables listed in the VAR and CVAR parameters.
   |            : y=print the column, n=do not print
   |
   | *-------------------------------------------------------------------*
   |     LABELING, FORMATTING, AND DEBUGGING OPTIONS
   | *-------------------------------------------------------------------*
   |
   |  Name      : T1LABEL
   |  Default   : Survival
   |  Type      : Character
   |  Purpose   : Label for first time variable
   |
   |  Name      : T2LABEL
   |  Default   : DFS
   |  Type      : Character
   |  Purpose   : Label for second time variable
   |
   |  Name      : TITLE1, TITLE2, TITLE3, TITLE4
   |  Default   : None
   |  Type      : Character
   |  Purpose   : Table titles
   |
   |  Name      : PAGE
   |  Default   : landscape
   |  Type      : Character
   |  Purpose   : Page orientation for output
   |            : portrait or landscape
   |
   |  Name      : DEBUG
   |  Default   : N
   |  Type      : Character
   |  Purpose   : Y to print notes, macro values, and procedure
   |            : output for debugging
   |            : This option can create a huge amount of output!!
   |
   |
   *------------------------------------------------------------------*
   | MODIFIED BY : Novotny, Paul                 (12/07/2011 16:03)
   |
   | Added 95% CI for median survival times
   | and sample sizes for univariate Cox models.
   *------------------------------------------------------------------*
   | MODIFIED BY : Novotny, Paul                 (02/17/2012 12:06)
   |
   | Fix problem with timeunits parameter.
   *------------------------------------------------------------------*
   | OPERATING SYSTEM COMPATIBILITY
   |
   | UNIX SAS v8   :
   | UNIX SAS v9   :   YES
   | MVS SAS v8    :
   | MVS SAS v9    :
   | PC SAS v8     :
   | PC SAS v9     :
   *------------------------------------------------------------------*
   | RETURNED INFORMATION
   |
   | This macro returns an RTF file summarizing time-to-event analyses.
   |
   |
   *------------------------------------------------------------------*
   | EXAMPLES
   |
   | %stable(dsn=master,time=fu_time,status=fu_stat,
   |         var=arm ps site,cvar=age,outdoc=survd.doc);
   |
   | %stable(dsn=master,time=fu_time pg_time,status=fu_stat pg_stat,
   |         var=arm ps site,cvar=age,
   |         t1label=OS, t2label=PROG,
   |         outdoc=survd.doc);
   |
   | %stable(dsn=master,time=fu_time,status=fu_stat,censor=1,year=2,
   |         cvar=age lnagc lnalk lnplt lnast lnbili,
   |         var=carm mdquality_s cps csum chgb csite cbmi,
   |         outdoc=survd.doc,ref=2 1 1 2 1 3 1 2 1 1 1 1 1,pctci=n,
   |         title1=N9741 Survival Summary);
   |
   | %stable(dsn=master,time=fu_time pg_time,status=fu_stat pg_stat,censor=1,year=2,
   |         cvar=lnagc lnalk lnplt lnast lnbili,
   |         var=mdquality_s cps csum chgb csite cbmi,
   |         outdoc=both.doc,
   |         title1=N9741 Survival and Progression Summary);
   |
   |
   |
   *------------------------------------------------------------------*
   | Copyright 2012 Mayo Clinic College of Medicine.
   |
   | This program is free software; you can redistribute it and/or
   | modify it under the terms of the GNU General Public License as
   | published by the Free Software Foundation; either version 2 of
   | the License, or (at your option) any later version.
   |
   | This program is distributed in the hope that it will be useful,
   | but WITHOUT ANY WARRANTY; without even the implied warranty of
   | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
   | General Public License for more details.
   *------------------------------------------------------------------*/
 
%macro stable(dsn=_last_,time=fu_time,status=fu_stat,censor=1,
              timeunits=d,medunits=,
              var=,ref=1,cvar=,strata=,
              percent=y,year=5,pctci=y,
              n=y,events=y,median=y,medci=n,utotal=n,
              logrank=n,wilcoxon=n,hr1=y,wald1=n,score=y,hr2=y,
              wald2=n,lr=y,
              outdoc=_survsum.doc,
              t1label=Survival, t2label=DFS,
              title1=Survival Summary,title2=,title3=,title4=,
              page=landscape,debug=n);
 
  /*************************************************************/
  /* stores the original options so they can be restored later */
  /*************************************************************/
  %let validvn = %sysfunc(getoption(validvarname));
  %let sdate   = %sysfunc(getoption(nodate));
  %let snotes  = %sysfunc(getoption(nonotes));
  %let snumb   = %sysfunc(getoption(nonumber));
  %let ulinesize = %sysfunc(getoption(linesize));
  %let upagesize = %sysfunc(getoption(pagesize));
 
  /***************************/
  /* sets default parameters */
  /***************************/
  %local time status censor var outdoc title1 title2 title3 title4
         debug num vv vvf vvlbl;
  %let time=%lowcase(&time);
  %let status=%lowcase(&status);
  %let timeunits=%lowcase(&timeunits);
  %let medunits=%lowcase(&medunits);
  %if (&medunits=) %then %let medunits=&timeunits;
  %let var=%lowcase(&var);
  %let cvar=%lowcase(&cvar);
  %let strata=%lowcase(&strata);
  %let n=%lowcase(&n);
  %let percent=%lowcase(&percent);
  %let pctci=%lowcase(&pctci);
  %let events=%lowcase(&events);
  %let median=%lowcase(&median);
  %let medci=%lowcase(&medci);
  %let utotal=%lowcase(&utotal);
  %let logrank=%lowcase(&logrank);
  %if (&var=) %then %let logrank=n;
  %let wilcoxon=%lowcase(&wilcoxon);
  %if (&var=) %then %let wilcoxon=n;
  %let hr1=%lowcase(&hr1);
  %let wald1=%lowcase(&wald1);
  %let score=%lowcase(&score);
  %let hr2=%lowcase(&hr2);
  %let wald2=%lowcase(&wald2);
  %let lr=%lowcase(&lr);
  %let nmult1=;
  %let nmult2=;
  %let debug=%lowcase(&debug);
  %if (&debug=y) %then %do;
                   options mprint mtrace macrogen
                           notes linesize=132 ps=58;
                 %end;
                 %else %do;
                   options nonotes nomprint nomacrogen
                           nomtrace nosymbolgen nomlogic
                           linesize=132 ps=58;
                 %end;
 
   /************************************************************/
   /* creates adjustment factors based on the input data scale */
   /************************************************************/
   %if (&timeunits=d) %then %let scale=1;
   %if (&timeunits=w) %then %let scale=7;
   %if (&timeunits=m) %then %let scale=30.4;
   %if (&timeunits=y) %then %let scale=365.24;
 
   %if (&medunits=d) %then %let mscale=1;
   %if (&medunits=w) %then %let mscale=7;
   %if (&medunits=m) %then %let mscale=30.4;
   %if (&medunits=y) %then %let mscale=365.24;
 
   /********************************************************/
   /* LTIME is the time in days where survival percentages */
   /* percentages are needed                               */
   /********************************************************/
   %let ltime=%sysevalf(&year*365.24/&scale);
 
  /**********************************************/
  /* creates a new dataset of the analysis file */
  /**********************************************/
  data _dsn;
    set &dsn;
    run;
 
  /**********************************************/
  /* creates a file of variable characteristics */
  /**********************************************/
  proc sql;
    create table _c_ as
      select *
       from sashelp.vcolumn
       where libname="WORK"
        and memname="_DSN";
    quit;
 
 
  /*******************************************************************/
  /* determines if there are one or two censored variables to analyze*/
  /* the macro variable NTIME contains the number of time variables  */
  /* to analyze                                                      */
  /*******************************************************************/
  %macro words(string,new);
    %local count word;
    %global &&new;
    %let count=1;
    %let word=%qscan(&string,&count,%str( ));
    %do %while(&word^=);
      %let count=%eval(&count+1);
      %let word=%qscan(&string,&count,%str(  ));
    %end;
    %let &&new=%eval(&count-1);
  %mend;
 
  %words(&time,ntime);
 
  %let t1labelb=&t1label;
  %if (&ntime=1) %then %let t1labelb=;
 
  /**********************************************/
  /**********************************************/
  /** runs the analyses for each time endpoint **/
  /**********************************************/
  /**********************************************/
  %do tt=1 %to &ntime;
      %let newtime=%scan(&time,&tt);
      %let newstat=%scan(&status,&tt);
 
  /*****************************************************/
  /*****************************************************/
  /** runs the analyses for each independent variable **/
  /*****************************************************/
  /*****************************************************/
  %let num=1;
     /* num = the number of the variable being processed */
  %let vv=%scan(&var &cvar,&num);
     /* vv = the variable name of variable being processed */
  %let vref=;
 
  %do %while (&vv^=);
 
    /***********************************************/
    /* determines whether the independent variable */
    /* being processed is continuous or discrete   */
    /***********************************************/
    %if (%scan(&var,&num)=) %then %let cont=y;
                            %else %let cont=n;
 
    /*********************************************/
    /* gets the variable type, format, and label */
    /*********************************************/
    %let vvf=;
    %let vvlbl=;
 
    data _null_;
      set _c_;
      name=lowcase(name);
      if (type='num') & (format=' ') then format='8.';
      if (type='char') & (format=' ') then
         format='$char' || trim(left(length)) || '.';
      if (label=' ') then label=name;
      if (name="&vv") then do;
         call symput('vvf',trim(left(format)));
              /* vvf    = current variable format */
         call symput('vvlbl',trim(left(%str(label))));
              /* vvlbl  = current variable label  */
         call symput('vvtype',trim(left(%str(type))));
              /* vvtype = current variable type   */
      end;
 
      /******************************************/
      /* gets the label for the strata variable */
      /******************************************/
      %if (strata^=) %then %do;
        if (name="&strata") then
           call symput('strlbl',trim(left(%str(label))));
           /* strlbl = strata label */
      %end;
      run;
 
    /*************************************************************/
    /* creates a new numeric variable from the original variable */
    /* This is used for selecting the reference group            */
    /*************************************************************/
    data _master;
      set _dsn;
      if (missing(&vv)) then delete;
 
    /**********************************/
    /* defines the reference group    */
    /* and renumbers the new variable */
    /**********************************/
    %let ovref=&vref;           /* keeps the prior reference */
       /* OVREF is the previous reference group */
    %let vref=%scan(&ref,&num);
       /* VREF is the reference group for the current variable       */
       /* The reference groups is set to the first group if          */
       /* none is specified or to the last specified reference group */
    %if (&vref=) & (&ovref=) %then %let vref=1;
    %if (&vref=) %then %let vref=&ovref;
 
 
    /*******************************************************/
    /* macro variable NLVL counts the number of levels of  */
    /* the current variable                                */
    /* ONEWV has values 1, 2, 3, ... that identify the     */
    /* number of the level of the current variable         */
    /*******************************************************/
    proc sort data=_master;
      by &vv;
 
    data _master;
      set _master;
      by &vv;
      if (_n_=1) then onewv=0;
      if (first.&vv) then onewv=onewv+1;
      retain onewv;
      call symput('nlvl',trim(left(onewv)));
           /* nlvl = number of levels of the current variable */
 
    /********************************************/
    /* sets the reference level to '0' so it is */
    /* the first level for phreg                */
    /********************************************/
    data _master;
      set _master;
      if (onewv=&vref) then onewv=0;
      if ("&cont"='y') then onewv=&vv;
 
    proc sort data=_master;
      by onewv;
 
    /*******************************************************/
    /* renumbers the levels to start at '1' instead of '0' */
    /*******************************************************/
    data _master;
      set _master;
      by onewv;
      if (_n_=1) then newv=0;
      if (first.onewv) then newv=newv+1;
      if ("&cont"='y') then newv=&vv;
      retain newv;
 
    proc sort data=_master;
      by &vv;
 
    /**************************************************/
    /* creates a concordance between the new variable */
    /* and the original variable                      */
    /**************************************************/
    data _conc (keep=newv &vv);
      set _master;
      by &vv;
      if (first.&vv);
 
    %if (&debug=y) %then %do;
       %if (&cont=n) %then %do;
         proc print data=_conc;
           var &vv newv;
           title "list of analysis levels for &vv";
           run;
       %end;
    %end;
 
    proc sort data=_conc;
      by newv;
 
 
   /**************************************************/
   /**************************************************/
   /* obtains the logrank p-value, median survival   */
   /* times, and percent of patients surviving a     */
   /* certain number of years                        */
   /**************************************************/
   /**************************************************/
 
   /*******************************/
   /* uses only nonmissing values */
   /*******************************/
   data _ttmp;
     set _master;
     if ^missing(&vv);
 
   /***************************************/
   /* counts the overall number of events */
   /***************************************/
   proc freq data=_ttmp noprint;
     table &newstat / out=_ons sparse nowarn;
 
   data _tns (keep=_nn total cum_ev);
     set _ons end=last;
     _nn=1;
     if (_n_=1) then do;
        total=0;
        cum_ev=.;
     end;
     total=total+count;
     if (&newstat^=&censor) then cum_ev=count;
     retain total cum_ev;
     if (last) then output;
     run;
 
   /***************************************************/
   /* calculates overall median and survival estimate */
   /***************************************************/
   ods listing close;
   proc lifetest data=_ttmp timelist=0 &ltime 50000;
     time &newtime * &newstat (&censor);
     ods output Quartiles=_medall;
     ods output ProductLimitEstimates=_estall;
     run;
   ods listing;
 
   data _ttimes (keep=yearn yearl yearu _nn);
     set _estall;
     _nn=1;
     if (_n_=1) then do;
        yearn=.; yearl=.; yearu=.;
     end;
     if (_n_=2) then do;
        yearn=Survival;
        se=StdErr;
     end;
     if (_n_=3) then do;
        yearl=yearn-1.96*se;
        if (yearl<0) & (yearn^=.) then yearl=0;
        yearu=yearn+1.96*se;
        if (yearu>1) & (yearn^=.) then yearu=1;
        output;
     end;
     retain yearn yearl yearu se;
 
   data _tmed (keep=med medl medu _nn);
     set _medall;
     if (percent=50);
     med=Estimate*&scale/&mscale;
     medl=LowerLimit*&scale/&mscale;
     medu=UpperLimit*&scale/&mscale;
     _nn=1;
 
 
  /***********************************/
  /* lifetest for discrete variables */
  /***********************************/
  %if (&cont=n) %then %do;
   /*********************************************/
   /* counts the number of events in each group */
   /*********************************************/
   proc freq data=_ttmp noprint;
     table newv * &newstat / out=_ons sparse nowarn;
 
   data _ns (keep=newv total cum_ev);
     set _ons;
     by newv;
     if (first.newv) then do;
        total=0;
        cum_ev=.;
     end;
     total=total+count;
     if (&newstat^=&censor) then cum_ev=count;
     retain total cum_ev;
     if (last.newv) then output;
 
 
   /******************************************************/
   /* calculates medians and survival estimates by group */
   /******************************************************/
   ods listing close;
   proc lifetest data=_ttmp timelist=0 &ltime 50000;
     time &newtime * &newstat (&censor);
     strata newv;
     ods output HomTests=_lrank;
     ods output Quartiles=_medall;
     ods output ProductLimitEstimates=_estall;
     run;
   ods listing;
 
      data _logr (keep=logrank wilcoxon _nn);
        set _lrank end=last;
        if (_n_=1) then do;
           logrank=.;
           wilcoxon=.;
        end;
        if (Test='Log-Rank') then logrank=ProbChiSq;
        if (Test='Wilcoxon') then wilcoxon=ProbChiSq;
        retain logrank wilcoxon;
        _nn=1;
        if (last) then output;
 
      data _med (keep=newv med medl medu);
        set _medall;
        if (Percent=50);
        med=Estimate*&scale/&mscale;
        medl=LowerLimit*&scale/&mscale;
        medu=UpperLimit*&scale/&mscale;
 
      data _year (keep=newv yearn yearl yearu);
        set _estall;
        by newv;
        if (^first.newv & ^last.newv) then do;
           yearn=Survival;
           yearl=Survival-1.96*StdErr;
           if (.<yearl<0) then yearl=0;
           yearu=Survival+1.96*StdErr;
           if (yearu>1) then yearu=1;
           output;
        end;
  %end;
  run;
 
  /**************************/
  /* Univariate PHREG model */
  /**************************/
  %if (&debug^=y) %then %do; ods listing close; %end;
  ods output GlobalTests=_score;
  ods output NObs=_nobs;
  ods output ParameterEstimates=_est;
  proc phreg data=_master covout outest=_coxest1 nosummary;
    %if (&cont=n) %then %do; class newv / descending; %end;
    model &newtime * &newstat (&censor) = newv / rl;
    %if (&strata^=) %then %do; strata &strata; %end;
 
    title "Univariate Cox model for &vv";
    run;
  ods output close;
  %if (&debug^=y) %then %do; ods listing; %end;
 
  data _nuniv (keep=_nn nuniv);
    set _nobs;
    nuniv=NObsUsed;
    _nn=1;
 
 
  /***********************************************/
  /* obtains the Wald p-values and Hazard Ratios */
  /***********************************************/
  data _est (keep=hr lower upper pvalue _nn
             %if (&cont^=y) %then %do; newv %end; );
    set _est;
    newv=.;
    %if (&cont=n) %then %do; newv=ClassVal0; %end;
    hr=HazardRatio;
    lower=HRLowerCL;
    upper=HRUpperCL;
    pvalue=ProbChiSq;
    _nn=1;
 
 
  /*****************************/
  /* obtains the Score p-value */
  /*****************************/
  data _score (keep=pscore _nn);
    set _score;
    if (test='Score');
    pscore=ProbChiSq;
    _nn=1;
 
 
  /****************************************************/
  /****************************************************/
  /** Multivariate Cox Model including all variables **/
  /** in the VAR and CVAR parameters                 **/
  /****************************************************/
  /****************************************************/
 
  /***********************************************/
  /* counts the number of variables in each list */
  /***********************************************/
  %words(&var,ndisc);  /* ndisc is the number of discrete variables */
  %words(&cvar,ncont); /* ncont is the number of continuous variables*/
 
  /***************************************************/
  /* removes the current variable name from the list */
  /* so that the new variable can be used instead    */
  /***************************************************/
  %let blank=%str( );
  %let allvar=&blank;
  %if (&ndisc^=0) %then %do;
      %do i = 1 %to &ndisc;
          %let word=%scan(&var,&i);
          %if (&word^=&vv) %then %let allvar=&allvar &word;
      %end;
  %end;
 
  %let allvarc=;
  %if (&ncont^=0) %then %do;
      %do i = 1 %to &ncont;
          %let word=%scan(&cvar,&i);
          %if (&word^=&vv) %then %let allvarc=&allvarc &word;
      %end;
  %end;
 
  %if (&cont=y) %then %let allvarc=&allvarc newv;
                %else %let allvar=&allvar newv;
 
 
  /****************************/
  /* Multivariate PHREG model */
  /****************************/
  %if (&debug^=y) %then %do; ods listing close; %end;
  ods output Type3=_type3;
  ods output ParameterEstimates=_est2;
  ods output NObs=_nobs;
  proc phreg data=_master nosummary;
    %if (&var^=) %then %do; class &allvar / descending; %end;
    model &newtime * &newstat (&censor) = &allvar &allvarc
          / rl type3(LR);
    %if (&strata^=) %then %do; strata &strata; %end;
    title "Multivariate Cox model for &vv";
    run;
  ods output close;
  %if (&debug^=y) %then %do; ods listing; %end;
 
  data _null_;
    set _nobs;
    call symput('nmult' || trim(left(&tt)),trim(left(NObsUsed)));
    run;
 
  /****************************************/
  /* Obtains the Likelihood Ratio p-value */
  /****************************************/
  data _llr (keep=pllr _nn);
    set _type3;
    pllr=ProbLRChiSq;
    if (Effect='newv');
    _nn=1;
 
 
  /***********************************************/
  /* obtains the Wald p-values and Hazard Ratios */
  /***********************************************/
  data _est2 (keep=hra lowera uppera pvaluea _nn
                   %if (&cont^=y) %then %do; newv %end; );
    set _est2;
    if (Parameter='newv');
    newv=.;
    %if (&cont=n) %then %do; newv=ClassVal0; %end;
    hra=HazardRatio;
    lowera=HRLowerCL;
    uppera=HRUpperCL;
    pvaluea=ProbChiSq;
    _nn=1;
 
 
  /**************************************************/
  /* combines the analysis results into one dataset */
  /**************************************************/
  %if (&cont=n) %then %do;
      data _est (drop=_nn);
        set _est;
 
      data _est2 (drop=_nn);
        set _est2;
 
      proc sort data=_est;
        by newv;
 
      proc sort data=_est2;
        by newv;
 
      data _tmp;
        merge _conc _ns _med _year _est _est2;
        by newv;
 
      data _ll;
        merge _logr _score _llr;
        by _nn;
 
      data _tmp;
        set _tmp _ll _nuniv (in=a);
        if a then order=2;
             else order=1;
 
      proc sort data=_tmp;
        by order &vv;
  %end;
  %else %do;
      data _tmp;
        merge _tns _tmed _ttimes _est _est2 _score _llr;
        by _nn;
        order=1;
        nuniv=.;
  %end;
 
 
  /*****************************************************/
 
/* creates the report parameter column               */
  /* with the label and levels of the current variable */
  /*****************************************************/
  data _tmp;
    set _tmp;
    length vbl level vvv $ 60;
    vbl="&vvlbl";
    %if (&cont=n) %then %do;
        level='   ' || trim(left(put(&vv,&vvf)));
    %end;
    if (level=' ') & (vbl^=' ') & (order < 2) then
       level = trim(left(vbl));
    if (level=' ') & (order>1)                then
       level='Univariate Model (n='
       || trim(left(nuniv)) || ')';
    vvv=trim(left("&num"));
    line=_n_;
    ctype="&cont";
    if (order<2) then output;
    if (order>1) & ("&utotal"="y") then output;
 
 
  /********************************************************/
  /* concatenates the results from the current variable   */
  /* to the end of the combined results for all variables */
  /********************************************************/
  %if (&num=1) %then %do;
     data _mst;
       set _tmp;
  %end;
  %else %do;
     data _mst;
       set _mst _tmp;
  %end;
 
 
  /*****************************************/
  /* reads in the next variable to analyze */
  /*****************************************/
  %let num=%eval(&num+1);
  %let vv=%scan(&var &cvar,&num);
 
%end;
 
%let num=%eval(&num-1);
 
 
/******************************/
/* creates the table template */
/******************************/
proc template;
  define style newtable;
  style cellcontents / nobreakspace=on font_face="Times New Roman"
                       font_weight=medium font_style=roman
                       font_size=8 pt just=center vjust=center asis=on
                       font_size=1;
  style lhead / nobreakspace=on font_face="Times New Roman"
                font_weight=bold font_size=8 pt font_style=roman
                just=center vjust=center asis=on font_size=1;
  style table / frame=hsides asis=on cellpadding=4 cellspacing=4
                just=center rules=groups borderwidth=2;
  style Body                       / font_face="Times New Roman"
        asis=on font_size=8 pt;
  style BodyDate                   / font_face="Times New Roman"
        asis=on font_size=8 pt;
  style SysTitleAndFooterContainer / font_face="Times New Roman"
        asis=on font_size=8 pt;
  style SystemFooter               / font_face="Times New Roman"
        asis=on font_size=8 pt;
  style data                       / font_face="Times New Roman"
                                     font_size=8 pt;
  style SystemTitle                / font_face="Times New Roman"
                                     font_size=8 pt;
  style ByLine                     / font_face="Times New Roman"
        asis=on font_size=8 pt;
  style Header                     / font_face="Times New Roman"
        asis=on font_size=8 pt fontweight=bold;
  end;
  run;
 
/***************************/
/* creates the table title */
/***************************/
title ' ';
 
%let titles=&title1;
%if "&title2"^="" %then %do; %let titles=&titles.#&title2.; %end;
%if "&title3"^="" %then %do; %let titles=&titles.#&title3.; %end;
%if "&title4"^="" %then %do; %let titles=&titles.#&title4.; %end;
 
data _mst;
  set _mst;
  varnum=.;
  varnum=vvv;
 
proc sort data=_mst;
  by varnum line;
 
 
/***************************************/
/* creates the formatted column values */
/***************************************/
data _final&tt;
  set _mst end=last;
  by varnum;
  length ns evts medians $ 20;
  length years hrc1 pc1 hrc2 pc2 hrc3 pc3 pc4 $ 50;
 
  /********************************/
  /* creates the number of events */
  /********************************/
  ns=trim(left(put(round(total,1.),10.)));
  if (total>0) & (cum_ev^=.) then
     evts= '     ' || trim(left(put(round(cum_ev,1.),10.))) || ' (' ||
           trim(left(put(round(cum_ev/total*100,1.),10.))) || '%)';
 
  /*************************************/
  /* creates the median survival times */
  /*************************************/
  median=med;
  medianl=medl;
  medianu=medu;
 
  if (median^=.) then do;
    %if (&medunits=d) %then %do;
       medians=trim(left(put(round(median,1.0),10.0)));
    %end;
    %else %do;
       medians=trim(left(put(round(median,0.1),10.1)));
    %end;
 
    %if (&medci=y) & (&medunits^=d) %then %do;
        medians=trim(left(medians)) || ' ('
                        || trim(left(put(round(medianl,0.1),10.1)))
                        || '-'
                        || trim(left(put(round(medianu,0.1),10.1)))
                        || ')';
    %end;
    %if (&medci=y) & (&medunits=d) %then %do;
        medians=trim(left(medians)) || ' ('
                        || trim(left(put(round(medianl,1.0),10.0)))
                        || '-'
                        || trim(left(put(round(medianu,1.0),10.0)))
                        || ')';
  %end;
  end;
 
  /*************************************/
  /* creates the yearly survival rates */
  /*************************************/
  if (yearn=.) & (order<2) then yearn=0;
  if (yearl=.) & (order<2) then yearl=0;
  if (yearu=.) & (order<2) then yearu=0;
  if (yearn^=.) then
    years=trim(left(put(round(yearn*100,0.1),6.1))) || '%'
    %if (&pctci=y) %then %do;
        || ' (' ||
        trim(left(put(round(yearl*100,0.1),6.1))) || '%,' ||
        trim(left(put(round(yearu*100,0.1),6.1))) || '%)'
    %end; ;
 
  /****************************/
  /* creates the hazard rates */
  /****************************/
  %macro hr(hn,hl);
    hrc&hn=trim(left(put(round(hr&hl,0.01),6.2))) || " (" ||
           trim(left(put(round(lower&hl,0.01),6.2))) || "," ||
           trim(left(put(round(upper&hl,0.01),6.2))) || ")";
    if (0.98<round(lower&hl,0.01)<1.02) |
       (0.98<round(upper&hl,0.01)<1.02) then
       hrc&hn=trim(left(put(round(hr&hl,0.001),6.3))) || " (" ||
              trim(left(put(round(lower&hl,0.001),6.3))) || "," ||
              trim(left(put(round(upper&hl,0.001),6.3))) || ")";
    if (0.998<round(lower&hl,0.001)<1.002) |
       (0.998<round(upper&hl,0.001)<1.002) then
       hrc&hn=trim(left(put(round(hr&hl,0.0001),6.4))) || " (" ||
              trim(left(put(round(lower&hl,0.0001),6.4))) || "," ||
              trim(left(put(round(upper&hl,0.0001),6.4))) || ")";
    if (hr&hl=.) & (logrank=.) then hrc&hn='--';
    if (hr&hl=.) & (order>1) then hrc&hn='  ';
  %mend;
 
  %hr(1,);
  %hr(2,a);
 
  /**********************************************/
  /* creates the log-rank and Wilcoxon p-values */
  /**********************************************/
  length logrankp wilcoxonp $ 10;
  logrankp=trim(left(put(round(logrank,0.0001),7.4)));
  if (.<logrank<0.0001) then logrankp='<0.0001';
  wilcoxonp=trim(left(put(round(wilcoxon,0.0001),7.4)));
  if (.<wilcoxon<0.0001) then wilcoxonp='<0.0001';
  pc1=trim(left(put(round(pscore,0.0001),7.4)));
  if (.<pscore<0.0001) then pc1='<0.0001';
  pc2=trim(left(put(round(pvaluea,0.0001),7.4)));
  if (.<pvaluea<0.0001) then pc2='<0.0001';
  pc3=trim(left(put(round(pllr,0.0001),7.4)));
  if (.<pllr<0.0001) then pc3='<0.0001';
  pc4=trim(left(put(round(pvalue,0.0001),7.4)));
  if (.<pvalue<0.0001) then pc4='<0.0001';
 
  if (first.varnum) & (ctype='n') then do;
     evts=' ';
     medians=' ';
     years=' ';
     hrc1=' ';
     hrc2=' ';
  end;
 
  label vbl='Parameter'
        level='Parameter'
        ns='N'
        evts='Events'
        %if (&medci=y) %then %do;
           medians="Median &t1label Time (95% CI)"
        %end;
        %else %do;
           medians="Median &t1label Time"
        %end;
        %if (&pctci=y) %then %do;
          years="&year-Year &t1label % (95% CI)"
        %end;
        %else %do;
          years="&year-Year &t1label %"
        %end;
        logrankp="&t1label log-rank p-value"
        wilcoxonp="&t1label Wilcoxon p-value"
        hrc1="&t1label Cox Univariate HR (95% CI)"
        pc1="&t1label Cox Univariate Score p-value"
        hrc2="&t1label Cox Multivariate HR (95% CI)"
        pc2="&t1label Cox Multivariate Wald p-value"
        pc3="&t1label Cox Likelihood Ratio p-value"
        pc4="&t1label Cox Univariate Wald p-value";
  output;
 
  /***************************************/
  /* adds a blank line between variables */
  /***************************************/
  if (last.varnum) & ^(last) then do;
     line=999999; vbl=' '; level=' '; ns=' '; evts=' '; medians=' ';
                           years=' '; logrankp=' '; wilcoxonp=' ';
                           hrc1=' '; pc1=' '; hrc2=' '; pc2=' ';
                           hrc3=' '; pc3=' '; pc4=' ';
     output;
  end;
 
  %end;
 
  %if (&ntime=2) %then %do;
 
    /*********************************************************/
    /* combines the datasets if there are two time variables */
    /*********************************************************/
    data _final2 (keep=vvv line ns2 evts2 medians2 years2 logrankp2
                       wilcoxonp2 hrc12 pc42 pc12 hrc22 pc22 pc32);
      set _final2;
      length logrankp2 wilcoxonp2 $ 10;
      length ns2 evts2 medians2 $ 15;
      length years2 hrc12 pc12 hrc22 pc22 pc32 pc42 $ 50;
      logrankp2=logrankp;
      wilcoxonp2=wilcoxonp;
      ns2=ns;
      evts2=evts;
      medians2=medians;
      years2=years;
      hrc12=hrc1;
      pc12=pc1;
      hrc22=hrc2;
      pc22=pc2;
      pc32=pc3;
      pc42=pc4;
 
      label ns2="&t2label N"
            evts2="&t2label Events"
            %if (&medci=y) %then %do;
              medians2="Median &t2label Time (95% CI)"
            %end;
            %else %do;
              medians2="Median &t2label Time"
            %end;
            %if (&pctci=y) %then %do;
              years2="&year-Year &t2label Time (95% CI)"
            %end;
            %else %do;
              years2="&year-Year &t2label %"
            %end;
            logrankp2="&t2label log-rank p-value"
            wilcoxonp2="&t2label Wilcoxon p-value"
            hrc12="&t2label Cox Univariate HR (95% CI)"
            pc12="&t2label Cox Univariate Score p-value"
            hrc22="&t2label Cox Multivariate HR (95% CI)"
            pc22="&t2label Cox Multivariate Wald p-value"
            pc32="&t2label Cox Likelihood Ratio p-value"
            pc42="&t2label Cox Univariate Wald p-value";
 
    proc sort data=_final1;
      by vvv line;
 
    proc sort data=_final2;
      by vvv line;
 
    data _final1 (keep=level ns  evts  medians  years  logrankp
                       wilcoxonp  hrc1  pc4  pc1  hrc2  pc2  pc3
                       ns2 evts2 medians2 years2 logrankp2
                       wilcoxonp2 hrc12 pc42 pc12 hrc22 pc22 pc32);
      merge _final1 _final2;
      by vvv line;
  %end;
 
 
/*****************************/
/*****************************/
/** outputs the final table **/
/*****************************/
/*****************************/
ods listing close;
 
options orientation=&page;
 
ods rtf file="&outdoc" style=newtable;
ods escapechar='~';
 
/******************************/
/* creates the table footnote */
/******************************/
%let blank1=%str( );
%let blank0=%str();
%let foot1=;
%let foot2=;
%let foot3=;
%let foot4=;
%let fdate=(report generated on " sysdate9 ")  ;
%if (&strata^=) %then
    %let foot1=&blank1.Cox Models Stratified by &strlbl..  ;
 
%let foot=%str(&fdate.&blank1.&blank1.&blank1.&foot1.&blank1.);
%let foot=%str(&foot.&blank1.&foot2.&foot3.&foot4);
 
 
/************************************/
/* creates the main output template */
/************************************/
proc template;
  define table summ;
  mvar sysdate9;
  column vbl level ns  evts  medians  years  logrankp  wilcoxonp
                   hrc1  pc4  pc1  hrc2  pc2  pc3
                   ns2 evts2 medians2 years2 logrankp2 wilcoxonp2
                   hrc12 pc42 pc12 hrc22 pc22 pc32;
  header table_header_1;
  footer table_footer_1;
  define table_header_1;
     text "&titles.# ";
     style=header{font_size=8 pt font_face="Times New Roman"
                  font_weight=bold};
     split='#';
  end;
  define table_footer_1;
     text "&foot.";
     split='#';
     just=left;
     style=header{font_size=8 pt font_face="Times New Roman"};
  end;
  define header header;
     split='#';
  end;
 
  define column level;
    generic=on;
    cellstyle substr(_val_,1,1)^=' ' as
                  cellcontents{font_weight=bold   font_size=8 pt
                               font_face="Times New Roman"},
              substr(_val_,1,1)=' ' as
                  cellcontents{font_weight=medium font_size=8 pt
                               font_face="Times New Roman"};
    style=cellcontents{font_size=8 pt  font_face="Times New Roman"};
    vjust=top;
    just=left;
    header="Variable";
    end;
 
  %macro dcol(cc,hh1,hh2,hh3,hh4,hh5);
    %let lblank=%str(                                               );
    %let lline
     =&hh1.&lblank.&hh2.&lblank.&hh3.&lblank.&hh4.&lblank.&hh5.;
    define column &cc;
      generic=on;
        style=cellcontents{font_size=8 pt
               font_face="Times New Roman"};
         vjust=top;
         just=center;
         header="&lline";
         end;
  %mend;
 
  %dcol(ns,N);
  %dcol(evts,&t1labelb Events);
 
  %if (&medci=y) %then %let yci=(95% CI);
                 %else %let yci=;
  %if (&medunits=d) %then %do;
     %dcol(medians,Median &t1labelb,Days,%str(&yci));
  %end;
  %if (&medunits=w) %then %do;
     %dcol(medians,Median &t1labelb,Weeks,%str(&yci));
  %end;
  %if (&medunits=m) %then %do;
     %dcol(medians,Median &t1labelb,Months,%str(&yci));
  %end;
  %if (&medunits=y) %then %do;
     %dcol(medians,Median &t1labelb,Years,%str(&yci));
  %end;
 
  %if (&pctci=y) %then %do;
    %dcol(years,%str(&year-Year &t1label %%),%str((95%% CI)));
  %end;
  %else %do;
    %dcol(years,%str(&year-Year &t1label %%));
  %end;
  %dcol(logrankp,%str(&t1labelb log-rank),p-value);
  %dcol(wilcoxonp,%str(&t1labelb Wilcoxon),p-value);
  %dcol(hrc1,%str(&t1labelb Cox Univariate),Hazard Ratio,
        %str((95%% CI)));
  %dcol(pc1,%str(&t1labelb Cox Univariate),Score p-value);
  %dcol(pc4,%str(&t1labelb Cox Univariate),Wald p-value);
  %dcol(hrc2,%str(&t1labelb Cox Multivariate),Hazard Ratio,
        %str((95%% CI)));
  %dcol(pc2,%str(&t1labelb Cox Multivariate),Wald p-value,
        %str((n=&nmult1)));
  %dcol(pc3,%str(&t1labelb Cox Multivariate),Likelihood Ratio,p-value,
       %str((n=&nmult1)));
 
  %dcol(ns2,&t2label N);
  %dcol(evts2,&t2label Events);
  %if (&medunits=d) %then %do;
      %dcol(medians2,Median &t2label,Days,%str(&yci));
  %end;
  %if (&medunits=w) %then %do;
      %dcol(medians2,Median &t2label,Weeks,%str(&yci));
  %end;
  %if (&medunits=m) %then %do;
      %dcol(medians2,Median &t2label,Months,%str(&yci));
  %end;
  %if (&medunits=y) %then %do;
      %dcol(medians2,Median &t2label,Years,%str(&yci));
  %end;
  %if (&pctci=y) %then %do;
      %dcol(years2,%str(&year-Year &t2label %%),%str((95%% CI)));
  %end;
  %else %do;
    %dcol(years2,%str(&year-Year &t2label %%));
  %end;
 
  %dcol(logrankp2,%str(&t2label log-rank),p-value);
  %dcol(wilcoxonp2,%str(&t2label Wilcoxon),p-value);
  %dcol(hrc12,%str(&t2label Cox Univariate),Hazard Ratio,
        %str((95%% CI)));
  %dcol(pc12,%str(&t2label Cox Univariate),Score p-value);
  %dcol(pc42,%str(&t2label Cox Univariate),Wald p-value);
  %dcol(hrc22,%str(&t2label Cox Multivariate),Hazard Ratio,
        %str((95%% CI)));
  %dcol(pc22,%str(&t2label Cox Multivariate),Wald p-value,
        %str((n=&nmult2)));
  %dcol(pc32,%str(&t2label Cox Multivariate),Likelihood Ratio,p-value,
        %str((n=&nmult2)));
  end;
  run;
 
  /***************************/
  /* outputs the final table */
  /***************************/
  title ' ';
  footnote ' ';
  data _null_;
    set _final1;
    file print ods=(template='summ'
         columns=(level=level(generic=on)
                  %if (&n=y)        %then %do;
                      ns=ns(generic=on)               %end;
                  %if (&events=y)   %then %do;
                      evts=evts(generic=on)           %end;
                  %if (&median=y)   %then %do;
                      medians=medians(generic=on)     %end;
                  %if (&percent=y)  %then %do;
                      years=years(generic=on)         %end;
                  %if (&logrank=y)  %then %do;
                      logrankp=logrankp(generic=on)   %end;
                  %if (&wilcoxon=y) %then %do;
                      wilcoxonp=wilcoxonp(generic=on) %end;
                  %if (&hr1=y)      %then %do;
                      hrc1=hrc1(generic=on)           %end;
                  %if (&score=y)    %then %do;
                      pc1=pc1(generic=on)             %end;
                  %if (&wald1=y)    %then %do;
                      pc4=pc4(generic=on)             %end;
                  %if (&hr2=y)      %then %do;
                      hrc2=hrc2(generic=on)           %end;
                  %if (&wald2=y)    %then %do;
                      pc2=pc2(generic=on)             %end;
                  %if (&lr=y)       %then %do;
                      pc3=pc3(generic=on)             %end;
 
                  %if (&ntime=2) %then %do;
                    /* ns2=ns2(generic=on) */
                    %if (&events=y)   %then %do;
                        evts2=evts2(generic=on)           %end;
                    %if (&median=y)   %then %do;
                        medians2=medians2(generic=on)     %end;
                    %if (&percent=y)  %then %do;
                        years2=years2(generic=on)         %end;
                    %if (&logrank=y)  %then %do;
                        logrankp2=logrankp2(generic=on)   %end;
                    %if (&wilcoxon=y) %then %do;
                        wilcoxonp2=wilcoxonp2(generic=on) %end;
                    %if (&hr1=y)      %then %do;
                        hrc12=hrc12(generic=on)           %end;
                    %if (&score=y)    %then %do;
                        pc12=pc12(generic=on)             %end;
                    %if (&wald1=y)    %then %do;
                        pc42=pc42(generic=on)             %end;
                    %if (&hr2=y)      %then %do;
                        hrc22=hrc22(generic=on)           %end;
                    %if (&wald2=y)    %then %do;
                        pc22=pc22(generic=on)             %end;
                    %if (&lr=y)       %then %do;
                        pc32=pc32(generic=on)             %end;
                  %end;
                 ));
    put _ods_;
    run;
 
  ods rtf close;
  ods listing;
 
  /*********************************************************/
  /* prints a copy of the table results to the SAS listing */
  /*********************************************************/
  %if (&debug=y) %then %do;
     options linesize=128 pagesize=56;
 
     proc print data=_final1 label noobs split='*';
       var level ns  evts  medians  years  logrankp  wilcoxonp  hrc1
           pc1  pc4 hrc2  pc2  pc3 pc4
           %if (&ntime=2) %then %do;
                 ns2 evts2 medians2 years2 logrankp2 wilcoxonp2 hrc12
                 pc12 pc42 hrc22 pc22 pc32 pc42
           %end; ;
       title  "&title1";
       title2 "&title2";
       title3 "&title3";
       title4 "&title4";
 
run;
  %end;
 
  /******************************/
  /* removes temporary datasets */
  /******************************/
  proc datasets nolist;
    delete _dsn _c_ _final1 _master _conc _ttmp _lrank _ltime _logr
           _ttimes _tlrank
           _times _est _est2 _tmp _mst _ll1 _ll2 _ll _score _wil _tmp_
           _tmp1_ _counts_ _lr1 _lr2 _lrmstr _print_ _x1 _llr _type3
           _coxest1 _estall _med _medall _nobs _ns _nuniv _ons _tmed
           _tns _year
           %if (&ntime=2) %then %do; _final2 %end; ;
  run;
  quit;
 
  options validvarname=&validvn &sdate &snotes &snumb
          linesize=&ulinesize pagesize=&upagesize;;
  run;
 
%mend;
 
