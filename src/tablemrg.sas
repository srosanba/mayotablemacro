/*------------------------------------------------------------------*
   | The documentation and code below is supplied by HSR CodeXchange.             
   |              
   *------------------------------------------------------------------*/
                                                                                      
                                                                                      
                                                                                      
  /*------------------------------------------------------------------*
   | MACRO NAME  : tablemrg
   | SHORT DESC  : Output multiple %table tables to a single
   |               file
   *------------------------------------------------------------------*
   | CREATED BY  : Parkinson, Julia              (04/28/2004 11:09)
   *------------------------------------------------------------------*
   | PURPOSE
   |
   | This macro takes the datasets created in the %table macro and
   | re-creates the tables in one rtf file. It retains the table
   | titles and footnotes defined in the %table macro.  However,
   | table attributes such as font size and cell-width must be
   | redefined.
   |
   | Formatted variables will be printed using their formats.
   |
   |
   |
   |
   *------------------------------------------------------------------*
   | MODIFIED BY : Tan, Angelina                 (02/05/2007 19:58)
   |
   | There was a SAS version issue with the cellwidth that define in
   | PROC TEMPLATE for creating a style for the table. This forced each
   | of the column in the table printed on a new page when running
   | %tablemrg in SAS v9. cellwidth=10 was removed from the table style
   | statement in TEMPLATE procedure.
   |
   *------------------------------------------------------------------*
   | MODIFIED BY : Tan, Angelina                 (10/20/2008 18:32)
   |
   | Change the upper range of the do-loop from 100 to 300, so that,
   | we can append more than 36 tables in a single document.
   *------------------------------------------------------------------*
   | MODIFIED BY : Novotny, Paul                 (07/25/2011 14:03)
   |
   | Modified the BY levels so they can contain symbols like <, >, +, -, etc.
   *------------------------------------------------------------------*
   | OPERATING SYSTEM COMPATIBILITY
   |
   | UNIX SAS v8   :   YES
   | UNIX SAS v9   :   YES
   | MVS SAS v8    :
   | MVS SAS v9    :
   | PC SAS v8     :
   | PC SAS v9     :
   *------------------------------------------------------------------*
   | MACRO CALL
   |
   | %tablemrg(
   |            dsn= ,
   |            outdoc= ,
   |            page=portrait,
   |            number=N,
   |            titlesz=10,
   |            bodysz=10,
   |            footsz=10,
   |            titlefnt=Times New Roman,
   |            headfnt=Times New Roman,
   |            bodyfnt=Times New Roman,
   |            ciwd= ,
   |            pvalwd= ,
   |            levelwd= ,
   |            datawd= ,
   |            space= ,
   |            debug=N
   |          );
   *------------------------------------------------------------------*
   | REQUIRED PARAMETERS
   |
   | Name      : dsn
   | Default   :
   | Type      : Dataset Name
   | Purpose   : dataset names (list) from %table
   |
   | Name      : outdoc
   | Default   :
   | Type      : Text
   | Purpose   : name of WORD file created (it is created in
   |             directory where the program is run)
   |             this can contain the directory as well,
   |             i.e. ~parkj2/consult/tables/demogtable, .doc will
   |             be appended to all documents if no other appendage
   |             is specified
   |
   *------------------------------------------------------------------*
   | OPTIONAL PARAMETERS
   |
   | Name      : page
   | Default   : portrait
   | Type      : Text
   | Purpose   : Page orientation for ODS RTF output: portraite or
   |             landscape (optional; default=portrait)
   |
   | Name      : number
   | Default   : N
   | Type      : Text
   | Purpose   : Print the page number in the upper right corner,
   |             Y or N (optional; default=N)
   |
   | Name      : titlesz
   | Default   : 10
   | Type      : Number (Single)
   | Purpose   : font size for title (optional; default=10)
   |
   | Name      : bodysz
   | Default   : 10
   | Type      : Number (Single)
   | Purpose   : font size for body text (optional; default=10)
   |
   | Name      : footsz
   | Default   : 10
   | Type      : Number (Single)
   | Purpose   : font size for footer (optional; default=10)
   |
   | Name      : titlefnt
   | Default   : Times New Roman
   | Type      : Text
   | Purpose   : font-face for table titles
   |             (fonts available: Times New Roman, Helvetica,
   |             Arial, SwissB)
   |
   | Name      : headfnt
   | Default   : Times New Roman
   | Type      : Text
   | Purpose   : font-face for column headings, levels, footnotes
   |
   | Name      : bodyfnt
   | Default   : Times New Roman
   | Type      : Text
   | Purpose   : font-face for all data.
   |
   | Name      : ciwd
   | Default   :
   | Type      : Number (Single)
   | Purpose   : cellwidth for confidence interval column
   |
   | Name      : pvalwd
   | Default   :
   | Type      : Number (Single)
   | Purpose   : cellwidth for pvalue column
   |
   | Name      : levelwd
   | Default   :
   | Type      : Number (Single)
   | Purpose   : cellwidth for level/heading column
   |
   | Name      : datawd
   | Default   :
   | Type      : Number (Single)
   | Purpose   : cellwidth for data columns
   |
   | Name      : space
   | Default   :
   | Type      : Number (Single)
   | Purpose   : cell spacing
   |             (optional; default sets cellpadding=2)
   |             1=pack; sets cellpadding=1
   |             2=expand; sets cellpadding=4
   |
   | Name      : debug
   | Default   : N
   | Type      : Text
   | Purpose   : 'Y' to print notes and macro values for debugging
   |
   *------------------------------------------------------------------*
   | RETURNED INFORMATION
   |
   | Creates a single rich text file (.rtf) with summary tables
   |
   |
   |
   |
   *------------------------------------------------------------------*
   | ADDITIONAL NOTES
   |
   | Written by: Julia Parkinson (novotny@mayo.edu)  2/2002
   |  - based on %table written by Paul Novotny (novotny@mayo.edu)
   |  - thanks to Ryan Lennon for the idea
   |
   |
   |
   |
   *------------------------------------------------------------------*
   | EXAMPLES
   |
   | First create the datasets with the %table macro:
   |    %table(dsn=master, by=arm, var=var1 var2 var3, type=1,
   |           outdat=dat1);
   |    %table(dsn=master, by=arm, var=var4 var5 var6, type=2,
   |           outdat=dat2);
   |    %table(dsn=master, by=arm, var=var7 var8 var9, type=2 1 2,
   |           outdat=dat3);
   |
   |  Put these datasets into %tablemerge to create a document with
   |  all the tables (number=Y will print page #'s)
   |    %tablemerge(dsn=dat1 dat2 dat3,
   |                outdoc=~parkj2/consult/tob/alldat.rtf, number=Y);
   |
   |
   |
   |
   *------------------------------------------------------------------*
   | Copyright 2011 Mayo Clinic College of Medicine.
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
 
%MACRO TABLEMRG(DSN=_last_, OUTDOC=, PAGE=portrait, TITLESZ=10,
        BODYSZ=10, FOOTSZ=10, NUMBER=N, TITLEFNT=Times New Roman,
        HEADFNT=Times New Roman, BODYFNT=Times New Roman, TITLEBLD=Y,
        CIWD=, PVALWD=100, LEVELWD=, DATAWD=, SPACE=, DEBUG=N
                  );
 
 
%let validvn=%sysfunc(getoption(validvarname));
%let sdate=%sysfunc(getoption(nodate));
%let snotes=%sysfunc(getoption(nonotes));
%let snumb=%sysfunc(getoption(nonumber));
 
 
/************************************/
/* creates defaults and conversions */
/************************************/
 
options nodate nonumber validvarname=v7 ;
 
%let debug=%upcase(&debug);
%if (&debug=Y) %then %do;
    options mprint mtrace macrogen linesize=132 ps=58; %end;
               %else %do;
    options nonotes nomprint nomacrogen nomtrace nosymbolgen
            nomlogic linesize=132 ps=58; %end;
 
%if (&space=) %then %let space=2;
%else %if (&space=1)  %then %let space=0;
%else %if (&space=2)  %then %let space=4;
 
 
 
/******************************/
/* creates the table template */
/******************************/
proc template;
  define style newtable;
  style cellcontents /
     nobreakspace=on
     font_face="&bodyfnt."
     font_weight=medium
     font_style=roman
     font_size=&bodysz. pt
     just=center
     vjust=center
     asis=on
     font_size=1;
  style lhead /
     nobreakspace=on
     font_face="&headfnt."
     font_weight=bold
     font_size=&bodysz. pt
     font_style=roman
     just=center
     vjust=center
     asis=on
     font_size=1;
  style table /
     frame=hsides
     asis=on
     cellpadding=&space.
     cellspacing=&space.
     just=center
     rules=groups
     borderwidth=2;
  style Body /
     font_face="&headfnt."
     asis=on
     font_size=&bodysz. pt;
  style BodyDate /
     font_face="&headfnt."
     asis=on
     font_size=&bodysz. pt;
  style SysTitleAndFooterContainer /
     font_face="&headfnt."
     asis=on
     font_size=&bodysz. pt;
  style SystemFooter /
     font_face="&headfnt."
     asis=on
     font_size=&bodysz. pt;
  style data /
     font_face="&headfnt."
     font_size=&bodysz. pt;
  style SystemTitle /
     font_face="&headfnt."
     font_size=&bodysz. pt;
  style ByLine /
     font_face="&headfnt."
     asis=on
     font_size=&bodysz. pt;
  style Header /
     font_face="&headfnt."
     asis=on
     font_size=&bodysz. pt;
  end;
  run;
 
 
ods listing close;
 
options orientation=&page.;
 
 
%if %length(%scan(&outdoc,-1,%str(.)))=3 %then
 %let doctype=%scan(&outdoc,-1,%str(.)); %else %let doctype=0;
 
ods escapechar='~';
 
%if "&doctype"="0" %then %do;
 ods rtf file="&outdoc..doc" style=newtable; %end;
%else %do; ods rtf file="&outdoc." style=newtable; %end;
 
title ' ';
 
%let nvar=0;
%do jj = 1 %to 300;
    %if (%scan(&dsn, &jj)^=) %then %do;
      %let data=%scan(&dsn,&jj);
 
%if %sysfunc(exist(&data)) %then %do;
 
data _null_;
  set &data; where _line=0;
  call symput('ttitle1',trim(left(tit1)));
  call symput('ttitle2',trim(left(tit2)));
  call symput('ttitle3',trim(left(tit3)));
  call symput('ttitle4',trim(left(tit4)));
  call symput('foot',trim(left(ft1)));
  call symput('foot2',trim(left(ft2)));
  call symput('foot3',trim(left(ft3)));
  call symput('foot4',trim(left(ft4)));
  call symput('foot5',trim(left(ft5)));
  call symput('date',trim(left(fdate)));
  call symput('nby',trim(left(nby)));
  call symput('nobs',trim(left(nobs)));
  call symput('ci',trim(left(put(haveci,1.))));
  call symput('tot',trim(left(put(havetot,1.))));
  call symput('p',trim(left(put(havep,1.))));
  call symput('pfoot',trim(left(upcase(pfoot))));
  call symput('pft',trim(left(pft)));
run;
 
data _null_;
  set &data; where _line=0;
  %do i=1 %to &nby;
    call symput("byn&i",trim(left(byn&i)));
    call symput("by&i",trim(left(by&i)));
    call symput("fby&i",trim(left(fby&i)));
  %end;
run;
 
data _pdat;
  set &data;
  where _line^=0;
  run;
 
%let titles=&ttitle1;
%if "&ttitle2"^=" " %then %do; %let titles=&titles.#&ttitle2.; %end;
%if "&ttitle3"^=" " %then %do; %let titles=&titles.#&ttitle3.; %end;
%if "&ttitle4"^=" " %then %do; %let titles=&titles.#&ttitle4.; %end;
%if &date=Y %then %do; %let fdate=(report generated on " sysdate9 ");
 %end; %else %do; %let fdate=; %end;
%let foots=;
%if "&foot"=" " %then %do; %let foot=; %end;
%if ("&foot2"^=" ") %then %do; %let foots=&foot2; %end;
%if ("&foot3"^=" ") %then %do; %let foots=&foots.#&foot3; %end;
%if ("&foot4"^=" ") %then %do; %let foots=&foots.#&foot4; %end;
%if ("&foot5"^=" ") %then %do; %let foots=&foots.#&foot5; %end;
 
 
proc template;
  define table summ;
  mvar sysdate9;
  column level c1 c2-c&nby. ci ctotal pvalue;
  header table_header_1;
  footer table_footer_1 table_footer_2;
  define table_header_1;
     text "&titles.# ";
     style=header{font_size=&titlesz. pt font_face="&titlefnt."
     %if &titlebld=Y %then %do; font_weight=bold %end; };
     split='#';
  end;
  define table_footer_1;
     %if (&date=Y) | ("&foot"^="") | &pfoot=Y %then %do;
       %if &pfoot=Y %then %do; text " &fdate#&pft#&foot"; %end;
       %else %do; text " &fdate#&foot"; %end;
     %end; %else %do; text ""; %end;
     split='#';
     just=left;
     style=header{font_size=&footsz. pt font_face="&headfnt."};
  end;
  define table_footer_2;
     %if ("&foots"^="") %then %do; text " &foots"; %end;
       %else %do; text ""; %end;
     split='#';
     just=left;
     style=header{font_size=&footsz. pt font_face="&headfnt."};
  end;
  define header header;
     split='#';
  end;
  define column level;
         generic=on;
         vjust=top;
         just=left;
         header=" ";
         cellstyle substr(_val_,1,1)^=' ' as
           cellcontents{font_weight=bold font_size=&bodysz. pt
                        font_face="&headfnt."
            %if (&levelwd^=) %then %do; cellwidth=&levelwd. %end; },
         substr(_val_,1,1)=' ' as
           cellcontents{font_weight=medium font_size=&bodysz. pt
                        font_face="&headfnt."
           %if (&levelwd^=) %then %do; cellwidth=&levelwd. %end; };
  end;
 
  %do i = 1 %to &nby.;
    define column c&i.;
         generic=on;
         style=cellcontents{font_size=&bodysz. pt font_face="&bodyfnt."
                            %if (&datawd^=) %then %do;
                              cellwidth=&datawd. %end; };
         vjust=top;
         just=center;
         %if ("&&by&i."="") | ("&&by&i."=" ") %then %do;
  header="Missing                                     (N=&&byn&i.)";
         %end;
         %else %do;
  header="&&fby&i.                                        (N=&&byn&i.)";
         %end;
         end;
  %end;
 
  define column ci;
         generic=on;
         style=cellcontents{font_size=&bodysz. pt font_face="&bodyfnt."
                      %if (&ciwd^=) %then %do; cellwidth=&ciwd. %end; };
         vjust=top;
         just=center;
         header=" ";
         end;
 
  define column ctotal;
         generic=on;
         style=cellcontents{font_size=&bodysz. pt font_face="&bodyfnt."
                  %if (&datawd^=) %then %do; cellwidth=&datawd. %end; };
         vjust=top;
         just=center;
        header="Total                                       (N=&nobs.)";
         end;
  define column pvalue;
         generic=on;
         style=cellcontents{font_size=&bodysz. pt font_face="&bodyfnt."
                  %if (&pvalwd^=) %then %do; cellwidth=&pvalwd. %end; };
         vjust=top;
         just=center;
         header="p value";
         end;
  end;
  run;
 
 
/****************************/
/* Creates Each Table       */
/****************************/
 
  data _null_;
    set _pdat;
    file print ods=(template='summ'
       columns=(level=level(generic=on)
       %do i = 1 %to &nby.;
         c&i.=c&i.(generic=on)
       %end;
       %if (&ci=1) %then %do;  ci=ci(generic=on) %end;
       %if (&tot=1)   %then %do;  ctotal=ctotal(generic=on)  %end;
       %if (&p=1) %then %do;  pvalue=pvalue(generic=on)  %end;
       ));
    put _ods_;
  run;
  %end;
 /*end of error creating dataset - basically skips this dataset and
   moves onto the next one */
  %else %do;
  %put ERROR: Dataset &data does not exist, no table will be created
for this data; %end;
 
  %end;  /*of the do loop to run through each table*/
  %else %do; %let jj=300; %end;
%end;
 
 
ods rtf close;
ods listing;
 
  %if "&doctype"="0" %then %do; %put Created File: &outdoc..doc; %end;
  %else %do; %put Created File: &outdoc.; %end;
 
 
options validvarname=&validvn &sdate &snotes &snumb;
 
%mend tablemrg;
 
 
 
