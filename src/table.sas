/*------------------------------------------------------------------*
   | The documentation and code below is supplied by HSR CodeXchange.             
   |              
   *------------------------------------------------------------------*/
                                                                                      
                                                                                      
                                                                                      
  /*------------------------------------------------------------------*
   | MACRO NAME  : table
   | SHORT DESC  : Customized variable summaries with results
   |               written to .doc file
   *------------------------------------------------------------------*
   | CREATED BY  : Parkinson, Julia              (04/28/2004 10:52)
   |             : Novotny, Paul
   *------------------------------------------------------------------*
   | PURPOSE
   |
   | This macro prints summary measures for discrete, continuous, and
   | censored variables by subgroups and overall along with p-values
   | for differences in subgroups. The results are output to an
   | rtf document that can be imported into WORD.
   |
   | Formatted variables will be printed using their formats.
   |
   | The parameters in this macro are all keyword parameters.
   | They must be specified by entering each parameter name with an
   | equal sign and the value of the parameter. Parameters are NOT
   | case sensitive (e.g. N and n are both valid parameter values)
   |
   | Note: For survival analyses, a separate Mayo survival macro
   | (%survlrk) is called.
   |
   | ~REQUIRED PARAMETERS~
   | **** PLEASE REFER TO THE REFERENCE SECTION DOWN THE PAGE ****
   |
   | ~OPTIONAL PARAMETERS~
   |
   | SUMMARY MEASURE OPTIONS:
   | BY = subgroup variable. Summary measures will be produced for each
   |      level of this variable. If no BY variable is entered, only a total
   |      column will be created.
   |      (can be formatted, character or numeric; Only ONE variable is allowed
   |       but it can have as many levels as desired)  (default=no BY variable)
   | TOTAL = y:print a total column, n: do not print a total column
   |         (default=y)
   | CSTATS = list of statistics desired for continuous data
   |          (only used if TYPE=1)
   |          Options are: n, nmiss, mean, sd, median, quartiles, range, cv
   |          (default=n mean sd median quartiles range)
   | DSTATS = list of statistics desired for discrete data.
   |          Options are: n , percent (default=n percent)
   |          (this will only affect variables with TYPE=2, p1, p2, or p3)
   | PCTTYPE = Indicate the type of percentage to display for discrete data
   |           row= row percentages, col= column percentages
   |          (default=col)
   | SURV = follow up status variables for survival analysis
   |        (required if there's a survival variable in VAR) SURV can be
   |        a list if you have multiple survival variables, but if SURV
   |        will be the same for all of the survival variables in the
   |        VAR parameter, you only need to list it once
   | SCENSOR = scoring for censored values. events must equal censor+1
   |           SCENSOR can be a list of censored values for each of the
   |           survival variables in VAR, but if the the censor value
   |           will be the same for each of the survival variables,
   |           only one needs to be listed.
   |          (required if there is a survival variable)
   |          (default=1)
   | SYEAR = year at which to print survival estimates (default=5 years)
   | TIMEUNITS = Units of input time variables (d=days, w=weeks,
   |             m=months, y=years) (default=D)
   | MEDUNITS  = Units for printing the median times (d=days, w=weeks,
   |             m=months, y=years) (default=D)
   |
   |
   | ROUNDING OPTIONS:
   | DECPCT  = number of decimals to print on percentages - 0 up to 5
   |           (default=1)
   | PCTDEC  = same parameter as DECPCT (you can specify either one of them)
   |           (both parameters are in the macro so that older code will
   |           still work)
   | PDEC    = number of decimals to print for p-values -1 to 5
   |           (default=4)
   | MEANDEC = Number of decimals to print for the mean on
   |           continuous data-0 to 5 (default=1)
   | MEDDEC  = Number of decimals to print for the median on
   |           continuous data-0 to 5 (default=1)
   | SDDEC   = Number of decimals to print for the standard deviation on
   |           continuous data-0 to 5 (default=1)
   | RNGDEC  = Number of decimals to print for the range on
   |           continuous data-0 to 5 (default=1)
   | QDEC    = Number of decimals to print for the quartiles on
   |           continuous data-0 to 5 (default=1)
   | CVDEC   = Number of decimals to print for the coefficient of
   |           variation for continuous data (default=1)
   | STATDEC = Number of decimals to print for all of the summary
   |           statistics for continuous data-0 to 5
   |          (default=use MEANDEC, MEDDEC, SDDEC, RNGDEC, CVDEC, and QDEC)
   |          (if STATDEC is specified it overrules MEANDEC, MEDDEC, SDDEC,
   |           RNGDEC, CVDEC, and QDEC) (and sets them all to this value)
   |
   | TESTING AND CONFIDENCE INTERVAL OPTIONS:
   | PVALUES = y=print p-values, n=do not print p-values (default=y)
   |           Default p-values:
   |           continuous-type=1 then default=kruskal-wallis
   |           discrete-type=2 then default=chi-square
   |           ordinal-type=3 then default=wilcoxon
   |           survival-type=4 then default=log-rank
   |           if PVALUES=y then all pvalues will be run for each variable
   |           and can be seen in the SAS listing output.
   |           Only one p-value (either the default or the
   |           p-value specified in PTYPE) will print in the ODS table
   |           created.
   |
   | PTYPE = list of tests desired for each variable in the VAR list.
   |         If specified, it must be specified for all variables
   |         0 or n = no p-value for this variable
   |         1 or c or ch = Chi-Square p-value
   |            this option can be used with a discrete variable
   |            if there is no BY variable (the chi-square test is
   |            then a test for whether or not each level of the
   |            variable has an equal proportion of the patients)
   |         2 or fe = Fisher's Exact p-value
   |         3 or kw = Kruskal-Wallis p-value
   |         4 or ekw = Exact Kruskal-Wallis p-value
   |         5 or w = Wilcoxon Rank Sum p-value (use only if there
   |            are two BY groups otherwise use a Kruskal-Wallis
   |         6 or ew = Exact Wilcoxon p-value (use only if there
   |            are two BY groups otherwise use a Kruskal-Wallis
   |         7 or f = ANOVA F-test p-value
   |         8 or lr = log-rank p-value (for survival data)
   |         9 or t = Student T-Test (Testing the mean different
   |            than a constant if there is no BY variable)
   |         10 or sr = Sign Rank (Testing the median different than
   |            a constant if there is no BY variable)
   |         11 or tr = Cochran-Armitage trend test for increasing or
   |            decreasing proportions in categorical/ordinal variables
   |            (Either the BY or VAR variable must have exactly two levels
   |             to use this test. WARNING: The p-value is calculated based on
   |            the order of the formatted values if the variable is
   |            formatted or on the order of unformatted values if the variable is not
   |            formatted.) (No p-value is possible if INCMISS=Y).
   |         12 or te = Equal variance two sample t-test
   |         13 or tu = Unequal variance two sample t-test
   |         14 or t2 = Two sample two stage testing - This option first tests
   |           to see if the data are normal. If the data are not normal then
   |           a Wilcoxon test is run. If the data are normal it then tests
   |           to see if the variances are equal in both groups. If the variances
   |           are equal it runs a two sample t-test assuming equal variances.
   |           If the variances are not equal it runs a two sample t-test
   |           assuming unequal variances.
   |
   | PNORM = p-value for testing for normality if ptype=14 (default=0.05)
   | PVAR = p-value for testing for equal variances if ptype=14 (default=0.05)
   |
   | TLOC  = value of the mean or location parameter in the null hypothesis
   |         for tests of location, used in conjunction with T-test and
   |         Sign-Test for continuous data when a BY group is NOT included
   |         (default=0)
   | PFOOT = Adds a footnote showing the tests used for each p-value
   |         in the table (a superscript number will be placed after each
   |         p-value in the table)
   |         Note: this only works if running SAS 8.2 or higher
   |        (default=n)
   |
   | CI = print 95% confidence intervals (default=none)
   |      (confidence intervals are only created for the difference
   |      between the first two BY categories) enter the number of the
   |      variable in the VAR parameter for which you want confidence
   |      intervals (e.g. ci=2 5   prints confidence intervals for the
   |      2nd and 5th variables in the VAR list
   |      (confidence intervals are only calculated for the first BY group
   |      minus the 2nd BY group)
   |      (for discrete variables it calculates the differences between
   |      proportions in the last category)
   |
   |
   | MISSING VALUE AND SUBSET OPTIONS:
   | BYMISS  = Include a column for missing BY variables as a separate
   |           category Y=print the column, N=remove missing BY values
   |           from the analyses and the table (default=Y)
   |
   | INCMISS = including missing values as a separate category during
   |           analysis for all categorical variables this option treats
   |           missing values as a distinct category and includes them in
   |           percentages and p-values (this applies to variables in both
   |           the VAR and BY parameters)
   |           Y=yes N=no (you can include missings as a category in
   |           only selected variables using the incmiss1 parameter)
   |          (default=N)
   |
   | INCMISS1 = list of variable numbers which can include missing values
   |            in analysis (a maximum of 100 variable numbers can be
   |            included in this list) (e.g. incmiss=4 25 will include
   |            missing values in only the 4th and 25th variables in the
   |            VAR parameter. All other variables will not include
   |            missing value) (default=none)
   |
   | POP = Type in the expression to determine population
   |       (default=all records are used in the analyses) this will be
   |       put into an if statement.
   |       i.e. if in the macro call you put POP=excluded<7 then in
   |       the dataset where it sets your data it will say: if excluded<7;
   |
   | RTF TABLE FORMATTING AND LABELING OPTIONS:
   | TTITLE1 = 1st table title
   |           (default=none)
   | TTITLE2 = 2nd table title
   |           (default=none)
   | TTITLE3 = 3rd table title
   |           (default=none)
   | TTITLE4 = 4th table title
   |           (default=none)
   | FOOT = footnote
   |        (default=none)
   | FOOT2, FOOT3, FOOT4, FOOT5 = More footnotes
   |        (default=none)
   | DATE = Prints the date in the footnote of each table, Y or N
   |        (default=Y).
   | NUMBER = prints the page numbers, Y or N
   |          (default=N);
   | PAGE = Page orientation for ODS RTF output: portrait or landscape
   |        (default=portrait)
   | DVAR = list of variable numbers for which you want a line deleted
   |        (default=none)
   | DLINE = list of lines to delete for corresponding variable number
   |         in DVAR (default=none)
   |         i.e. dvar=2 5, dline=2 3 : for variable #2 delete line 2
   |         and for variable #5 delete line 3
   | COMMENTS = SAS dataset name of comments to add into the printout
   |           (default=none)
   |            e.g. create this dataset in your SAS code:
   |            data comm;
   |              length level $ 150;
   |              length pvalue $ 17;
   |              length ci c1 c2 c3 ctotal $ 40;
   |              nvar=1; _line=0.5; level="O'Brien Global Test";
   |              pvalue='0.0157';
   |              output;
   |              nvar=1; _line=0.6; level=' ';
   |              pvalue=' ';
   |              output;
   |              nvar=2; _line=0.5;
   |              level='Baseline ECOG';
   |              output;
   |              nvar=3; _line=1;
   |              level=' ';
   |              output;
   |              nvar=3; _line=2;
   |              level='Missing Values Excluded';
   |              output;
   |            run;
   |
   |           then add comments=comm, and these comments will be print
   |           in your table Note: Comments in LEVEL will be printed in
   |           bold text if there is not a blank as the first character and
   |           will not be bold if there is a blank as the first character.
   |
   | TABLE BORDERS AND SPACING OPTIONS:
   | LABELWD = maximum characters to print in the column for variable labels
   |           and levels. values greater than this will be truncated or wrapped
   |           depending on the value of the LABELWRAP parameter
   |           (default=print up to 50 characters on each line)
   | LABELWRAP = determines if long variable labels are truncated or wrapped
   |             (N=truncated, Y=wrapped) (default=N)
   | TITLESZ = font size for title
   |           (default=10)
   | BODYSZ  = font size for body text
   |           (default=10)
   | FOOTSZ  = font size for footer
   |           (default=10)
   | TITLEBLD= font-weight for table title: Y=bold, N=normal.
   |           (default=Y)
   | TITLEFNT= font-face for table titles
   |           (default=Times New Roman)
   |           (fonts available: Times New Roman, Helvetica,
   |            Arial, SwissB)
   | HEADFNT = font-face for column headings, levels, footnotes
   |          (default=Times New Roman)
   | BODYFNT = font-face for all data.  (default=Times New Roman)
   | FRAME = specifies the lines framing the table, standard options are
   |         listed below (default=hsides)
   |         above = at top
   |         below = at bottom
   |         box = top bottom and both sides
   |         hsides = borders at top and bottom
   |         lhs = border on left side
   |         rhs = border on right side
   |         void = no borders
   |         vsides = borders at left and right sides
   | RULES = specifies the lines rules within the table around the
   |         individual cells (default=groups)
   |         all = between all rows and columns
   |         cols = between all columns
   |         groups = between header and table, and between table and footer
   |         none = no rules anywhere
   |         rows = between all rows
   | CIWD  = cellwidth for confidence interval column
   |         (default=computer default)
   | PVALWD  = cellwidth for pvalue column
   |           (default=computer default)
   | LEVELWD  = cellwidth for level/variable heading column
   |            (default=computer default)
   | DATAWD  = cellwidth for data columns
   |           (default=computer default)
   | SPACE = cell spacing (default sets cellpadding=2)
   |         1=pack; sets cellpadding=1
   |         2=expand; sets cellpadding=4
   |
   | ~ MORE OPTIONAL PARAMETERS~
   | **** PLEASE REFER TO THE REFERENCE SECTION DOWN THE PAGE ****
   |
   |
   |
   *------------------------------------------------------------------*
   | MODIFIED BY : Tan, Angelina                 (02/05/2007 19:56)
   |
   | There was a SAS version issue with the cellwidth that define in
   | PROC TEMPLATE for creating a style for the table. This forced each
   | of the column in the table printed on a new page when running %table
   | in SAS v9. cellwidth=10 was removed from the table style statement
   | in two PROC TEMPLATE codes.
   |
   *------------------------------------------------------------------*
   | MODIFIED BY : Tan, Angelina                 (02/12/2007 11:15)
   |
   | Documentation error found in Macro call.
   *------------------------------------------------------------------*
   | MODIFIED BY : Tan, Angelina                 (08/29/2007 11:31)
   |
   | Fixing the problems when the ptype=0 been used and pdec=2 been used.
   *------------------------------------------------------------------*
   | MODIFIED BY : OByrne, Megan                 (06/09/2011 11:04)
   |
   | Added a length statement to avoid a variable length warning for a merge.
   *------------------------------------------------------------------*
   | MODIFIED BY : Tan, Angelina                 (07/28/2011 13:31)
   |             : Novotny, Paul
   |
   | Additions:
   | - row or column percentages
   | - can specify number of decimals to print in mean, median, sd,
   |   range, quartiles, cv, percentages and p-values
   | - one sample tests if no BY variable (t-test, sign rank test and
   |   chi-square test for equal proportions
   | - print coefficient of variation
   | - Armitage trend test for categorical variables
   |
   | Modifications:
   | - Reverts to original user options on templates, linesize,
   |   pagesize and notes
   | - Exact test no attempted unless requested
   | - Works for formatted values of a continuous BY variable
   | - Option to remove missing BY values
   | - Prints longer variable labels (up to 150 characters)
   |
   | Problems Corrected:
   | - Percentile decimal places not printing properly
   | - Missing variable counts are off if there are missing BY values
   | - P-value not printing if ptype=0 for the first variable
   | - Missing value total counts were sometimes off
   | - Wilcoxon p-value footnotes not printing correctly
   |
   | Corrected and expanded the documentation:
   | - Confidence Intervals
   | - Data Listing
   | - Comments
   *------------------------------------------------------------------*
   | MODIFIED BY : Tan, Angelina                 (08/18/2011 15:05)
   |             : Novotny, Paul
   |
   | Updated by Paul Novotny 8/17/2011:
   | Added two sample t-tests and aliases for TYPE and PTYPE
   *------------------------------------------------------------------*
   | MODIFIED BY : Tan, Angelina                 (08/31/2011 13:42)
   |
   | Paul Novotny (8/30/2011): Fixed the error when type=p3 is used.
   *------------------------------------------------------------------*
   | MODIFIED BY : Novotny, Paul                 (09/12/2011 13:59)
   |             : Tan, Angelina
   |
   | Paul Novotny 9/10/2011:
   | Added word wrapping for long labels and enhanced survival output
   *------------------------------------------------------------------*
   | MODIFIED BY : Tan, Angelina                 (09/14/2011 11:35)
   |             : Novotny, Paul
   |
   | Paul Novotny 9/13/2011: Fixed the problem with outdoc parameter.
   *------------------------------------------------------------------*
   | MODIFIED BY : Tan, Angelina                 (11/01/2011 14:50)
   |             : Paul, Novotny
   |
   | Paul Novotny 11/1/2011: Fixed the problem that caused
   | by by= value when a permanent dataset is used in dsn=.
   |
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
   | MACRO CALL
   |
   | %table   (
   |            DSN=_last_,
   |            VAR= ,
   |            TYPE=
   |          );
   *------------------------------------------------------------------*
   | REQUIRED PARAMETERS
   |
   | Name      : DSN
   | Default   : _last_
   | Type      : Dataset Name
   | Purpose   : REFER TO REFERENCE SECTION
   |
   | Name      : VAR
   | Default   :
   | Type      : Variable Name (List)
   | Purpose   : REFER TO REFERENCE SECTION
   |
   | Name      : TYPE
   | Default   :
   | Type      : Number (Range/List)
   | Purpose   : REFER TO REFERENCE SECTION
   |
   *------------------------------------------------------------------*
   | ADDITIONAL NOTES
   |
   | UPDATES:
   |  04/2003-Added TYPE=7,8 which are different print options for
   |          continuous data - TYPE=7 prints median and quartiles while
   |          TYPE=8 prints means and range (see above for full
   |          documentation)
   |  04/2003-Added DSTATS and CSTATS which allow the user to choose which
   |          default stats they want printed for discrete and continuous
   |          data.  Quartiles and Number Missing added to continuous stat
   |          options (see above for full documentation)
   |  04/2003-Removed the automatic addition of .doc so users must type in
   |          their own appendage (.doc or .rtf)
   |  04/2003-Added PFOOT which will print the pvalue types in a footnote
   |          of the table, default=n
   |  04/2003-Added PDEC which allows the user to choose the number of
   |          decimals to print for p-values, default=4
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *------------------------------------------------------------------*
   | EXAMPLES
   |
   | %table(dsn=master, by=arm, var=factor_a factor_b gender race,
   |         type=1 2, outdoc=facttable);
   |  %table(dsn=master, by=arm, var=ps, type=3, pvalues=n,
   |         outdoc=~parkj2/consult/pstable);
   |  %table(dsn=master, by=curr_arm, var=sex race age weeks,
   |         type=2 2 1 1, outdat=demog);
   |  %table(dsn=master, id=id, list=y, var=sex race age ps,
   |         type=2 2 1 3, outdoc=demographics, outdat=demdat);
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *------------------------------------------------------------------*
   | REFERENCES
   |
   | %MACRO TABLE(DSN=_last_, BY=, VAR=, TYPE=, OUTDOC=, OUTDAT=,
   |              PCTTYPE=COL, CSTATS=n mean sd median quartiles range,
   |              DSTATS=n percent, pfoot=n,
   |              PTYPE=, TLOC=0, PNORM=0.05, PVAR=0.05, PVALUES=Y,
   |              TTITLE1=, TTITLE2=, TTITLE3=, TTITLE4=,
   |              FOOT=, FOOT2=, FOOT3=, FOOT4=, FOOT5=,
   |              TOTAL=Y, NUMBER=N, DATE=Y, PAGE=portrait,
   |              PDEC=4, STATDEC=, MEANDEC=1, SDDEC=1, MEDDEC=1,
   |              RNGDEC=1, QDEC=1, CVDEC=1, PCTDEC=1, DECPCT=,
   |              SURV=, SCENSOR=1, SYEAR=5, TIMEUNITS=D, MEDUNITS=D,
   |              BYMISS=Y, INCMISS=N, INCMISS1=,
   |              COMMENTS=, CI=, DVAR=, DLINE=,
   |              TITLESZ=10, BODYSZ=10, FOOTSZ=10, TITLEBLD=Y,
   |              TITLEFNT=Times New Roman, RULES=groups, FRAME=hsides,
   |              HEADFNT=Times New Roman, BODYFNT=Times New Roman,
   |              LABELWD=50, LABELWRAP=N, CIWD=, PVALWD=100,
   |              LEVELWD=, DATAWD=, SPACE=,
   |              POP=, LIST=N, PRINT=N, ID=, DEBUG=N);
   |
   | ~Required PARAMETERS~
   |
   | DSN = dataset name, dataset must have only one line per patient
   |      (REQUIRED: default=_last_)
   | VAR = list of discrete, continuous and censored variables in the order in which
   |       they will be printed (discrete variables can be character or numeric,
   |       but continuous variables must be numeric) (for survival variable, enter fu_time
   |       in this list and the follow up status variable under SURV= and the censoring value
   |       under SCENSOR=) (variables can be formatted)
   |       (there is a maximum of 100 variables allowed in this parameter) (REQUIRED)
   | TYPE = list of indicators for type of analysis for each variable in the
   |        var parameter (REQUIRED)
   |        i.e. var=score1 score2 scorepct, type=1 1 2.
   |        If a list of variables are of the same type, you only have to enter
   |        the type once
   |        i.e. var=gender race stage, type=2.
   |             var=gender age race stage ps, type= 2 1 2.
   |        1=continuous data: prints n, mean, median, std, quartiles, range
   |          - these default stats can be changed in the CSTATS variable
   |        2=discrete data: prints freqs (n, %) - these default stats can be
   |          changed in the DSTATS variable
   |        3=ordinal data: print freqs (n, %)
   |        4=survival data: print number of patients, number of events, median
   |          time to survival (the survival information is only available if you
   |          have access to the Mayo SAS survival macros)
   |        5=discrete data: prints freqs (n only)
   |        6=discrete data: prints freqs (% only)
   |        7=continuous data: prints n, median, quartiles
   |        8=continuous data: prints n, mean, sd, range
   |        p1=discrete data: only prints the first category
   |          (e.g. if categories are No and Yes and you only want the No displayed,
   |           use this option)
   |        p2=discrete data: does not print the first category
   |           (e.g. if the first category is 'missing' and you do not want this
   |            displayed, use this option to deletes this first category)
   |        p3=discrete data: does not print the first two categoris
   |           (e.g. if the first category is 'missing' and the second is 'No'
   |            and you want to only print 'Yes' use this option)
   |
   |        You can also enter 'c' for continuous data, 'd' for discrete data,
   |        'o' for ordinal data, or 's' for survival data. 'c' is the same as '1',
   |        'd' is the same as '2', 'o' is the same as '3', and 's' is the same as '4'.
   |        These options were added to make the options easier to remember.
   |
   | ~OPTIONAL PARAMETERS~
   | **** PLEASE REFER TO THE PURPOSE SECTION for more details ****
   |
   | OUTPUT FILE AND DATASET OPTIONS:
   | OUTDOC = name of WORD file created
   |          (.doc will be appended to all documents if no appendage
   |          is typed in) this can contain the directory as well,
   |          i.e. ~parkj2/consult/tables/demogtable,
   |          if no directory is defined, document will be stored in
   |          directory from where the program is run If left blank,
   |          no document will be created.
   |         (default=none)
   |
   | OUTDAT = name of SAS dataset created which can then be used with
   |          tablemerge.macro. If left blank, no dataset will be created.
   |          (default=none)
   |
   |
   | LISTING AND DEBUGGING OPTIONS:
   | LIST = Make an RTF listing of all variables used in the analyses
   |        (the output listing is named with the OUTDOC parameter
   |        with _lst appended), (default=N)
   | ID = ID variable to sort on for listing (required if LIST=Y,
   |      default=none)
   | PRINT = Print out the dataset used to make table in SAS listing output,
   |         (default=N)
   | DEBUG = Y to print notes and macro values for debugging
   |         (default=N)
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
 
%MACRO TABLE(DSN=_last_, BY=, VAR=, TYPE=, OUTDOC=, OUTDAT=,
             PCTTYPE=COL, CSTATS=n mean sd median quartiles range,
             DSTATS=n percent, pfoot=n,
             PTYPE=, TLOC=0, PNORM=0.05, PVAR=0.05, PVALUES=Y,
             TTITLE1=, TTITLE2=, TTITLE3=, TTITLE4=,
             FOOT=, FOOT2=, FOOT3=, FOOT4=, FOOT5=,
             TOTAL=Y, NUMBER=N, DATE=Y, PAGE=portrait,
             PDEC=4, STATDEC=, MEANDEC=1, SDDEC=1, MEDDEC=1,
             RNGDEC=1, QDEC=1, CVDEC=1, PCTDEC=1, DECPCT=,
             SURV=, SCENSOR=1, SYEAR=5, TIMEUNITS=D, MEDUNITS=D,
             BYMISS=Y, INCMISS=N, INCMISS1=,
             COMMENTS=, CI=, DVAR=, DLINE=,
             TITLESZ=10, BODYSZ=10, FOOTSZ=10, TITLEBLD=Y,
             TITLEFNT=Times New Roman, RULES=groups, FRAME=hsides,
             HEADFNT=Times New Roman, BODYFNT=Times New Roman,
             LABELWD=50, LABELWRAP=N, CIWD=, PVALWD=100,
             LEVELWD=, DATAWD=, SPACE=,
             POP=, LIST=N, PRINT=N, ID=, DEBUG=N);
 
 
 /**************************************************/
 /* stores the user's original options so they can */
 /* be restored at the end of the program          */
 /**************************************************/
 %let validvn   = %sysfunc(getoption(validvarname));
 %let sdate     = %sysfunc(getoption(nodate));
 %let snotes    = %sysfunc(getoption(nonotes));
 %let snumb     = %sysfunc(getoption(nonumber));
 %let ulinesize = %sysfunc(getoption(linesize));
 %let upagesize = %sysfunc(getoption(pagesize));
 run;
 
 %let debug = %upcase(&debug);
 %if (&debug=Y) %then %do;
    options mprint symbolgen mlogic mlogicnest merror notes linesize=132 ps=58;
 %end;
 %else %do;
    options nonotes nomprint nosymbolgen nosymbolgen nomlogic nomlogicnest
            nomerror linesize=132 ps=58;
 %end;
 
 
 
 %let number  = %upcase(&number);
 options nodate validvarname=v7
         %if &number=Y %then %do;  number    %end;
                       %else %do;  nonumber  %end;  ;
 
 /************************************/
 /* creates defaults and conversions */
 /************************************/
 %if (&space=) %then %let space=2;
 %else %if (&space=1)  %then %let space=0;
 %else %if (&space=2)  %then %let space=4;
 
 %let dsn       = %upcase(&dsn);
 %let by        = %upcase(&by);
 %let pvalues   = %upcase(&pvalues);
 %let total     = %upcase(&total);
 %let incmiss   = %upcase(&incmiss);
 %let list      = %upcase(&list);
 %let print     = %upcase(&print);
 %let titlebld  = %upcase(&titlebld);
 %let date      = %upcase(&date);
 %let pfoot     = %upcase(&pfoot);
 %let pcttype   = %upcase(&pcttype);
 %let bymiss    = %upcase(&bymiss);
 %let labelwrap = %upcase(&labelwrap);
 %let timeunits = %upcase(&timeunits);
 %let medunits  = %upcase(&medunits);
 
 /******************************************************************/
 /* these next two statements look backwards, but they are correct */
 /******************************************************************/
 %if &pcttype=ROW %then %let pct_type=PCT_COL;
 %if &pcttype=COL %then %let pct_type=PCT_ROW;
 
 /****************************************/
 /* keeps track of footnote superscripts */
 /****************************************/
 %if &pvalues=N %then %let pfoot=N;
 
 %if &pfoot=Y %then %do;
    %let pfnum = 0;
    %let pt1   = 0;
    %let pt2   = 0;
    %let pt3   = 0;
    %let pt4   = 0;
    %let pt5   = 0;
    %let pt6   = 0;
    %let pt7   = 0;
    %let pt8   = 0;
    %let pt9   = 0;
    %let pt10  = 0;
    %let pt11  = 0;
    %let pt12  = 0;
    %let pt13  = 0;
    %let pt14  = 0;
    %let pnm1  = Chi-Square;
    %let pnm2  = Fisher Exact;
    %let pnm3  = Kruskal Wallis;
    %let pnm4  = Exact Kruskal Wallis;
    %let pnm5  = Wilcoxon;
    %let pnm6  = Exact Wilcoxon;
    %let pnm7  = ANOVA F-Test;
    %let pnm8  = Log-Rank;
    %let pnm9  = T-Test (Mu0=%superq(tloc));
    %let pnm10 = Sign Rank (Mu0=%superq(tloc));
    %let pnm11 = Armitage Trend Test;
    %let pnm12 = Equal Variance T-Test;
    %let pnm13 = Unequal Variance T-Test;
    %let pnm14 = Two Stage Two Sample Test;
 
    %let pft   = ;
 %end;
 
 /*****************************************/
 /* checks whether there is a BY variable */
 /*****************************************/
 %if (&by=) %then %do;
    %let total = N;
    %let noby  = 1;
    %let nby=1;
    %let ci    = ;
 %end;
 %else %do;
    %let noby = 0;
 %end;
 
 /* this is to keep the original parameter working */
 %if (&decpct^=) %then %let pctdec=&decpct;
 /*************************************************/
 /* sets the rounding values for summary measures */
 /*************************************************/
 %global decmean decmed decsd decrng decq decrd ppct decstat deccv;
 %macro dec(d1,d2,def);
    %let &d2 = &def;
    %if (&&&d1=5) %then %let &&d2 =0.00001;
    %if (&&&d1=4) %then %let &&d2 =0.0001;
    %if (&&&d1=3) %then %let &&d2 =0.001;
    %if (&&&d1=2) %then %let &&d2 =0.01;
    %if (&&&d1=1) %then %let &&d2 =0.1;
    %if (&&&d1=0) %then %let &&d2 =1.;
 %mend;
 
 %dec(meandec,decmean,0.1);
 %dec(meddec,decmed,1.);
 %dec(sddec,decsd,0.1);
 %dec(rngdec,decrng,1.);
 %dec(qdec,decq,1.);
 %dec(pctdec,decrd,0.1);
 %dec(pdec,ppct,0.0001);
 %dec(statdec,decstat,0.1);
 %dec(cvdec,deccv,0.1);
 
 /****************************************************/
 /* if STATDEC is specified, all continuous  summary */
 /* stats are set to the same number of digits       */
 /****************************************************/
 %if (&statdec^=) %then %do;
     %let decmean=&decstat;
     %let decmed =&decstat;
     %let decsd  =&decstat;
     %let decrng =&decstat;
     %let decq   =&decstat;
     %let deccv  =&decstat;
     %let meandec=&statdec;
     %let meddec =&statdec;
     %let sddec  =&statdec;
     %let rngdec =&statdec;
     %let qdec   =&statdec;
     %let cvdec  =&statdec;
 %end;
 
 %let errors = 0;
 
 %if %scan(&surv,2)^= %then %let snum = 1;
 %else %let snum = 0;
 
 %if %scan(&scensor,2)^= %then %let scen = 1;
 %else %let scen = 0;
 
 /***********************************************/
 /* determines which summary measures to output */
 /* for continuous variables                    */
 /***********************************************/
 %let cn     = 0;
 %let cmn    = 0;
 %let csd    = 0;
 %let cmd    = 0;
 %let cq     = 0;
 %let cr     = 0;
 %let cnmiss = 0;
 %let cv     = 0;
 
 %do i=1 %to 8;
    %let myscan = %upcase(%scan(&cstats,&i));
    %if (&myscan^=) %then %do;
        %if &myscan=N               %then %let cn    = 1;
        %else %if &myscan=MEAN      %then %let cmn   = 1;
        %else %if &myscan=SD        %then %let csd   = 1;
        %else %if &myscan=MEDIAN    %then %let cmd   = 1;
        %else %if &myscan=QUARTILES %then %let cq    = 1;
        %else %if &myscan=RANGE     %then %let cr    = 1;
        %else %if &myscan=NMISS     %then %let cnmiss= 1;
        %else %if &myscan=CV        %then %let cv    = 1;
    %end;
 %end;
 
 /**************************************************/
 /* determines whether to print the mean and/or SD */
 /**************************************************/
 %if &cmn=1 & &csd=1 %then %let cms = 1;
 %else %if &cmn=1    %then %let cms = 2;
 %else %if &csd=1    %then %let cms = 3;
 %else %let cms = 0;
 
 /**************************************/
 /* determines which summary values to */
 /* output for discrete variables      */
 /**************************************/
 %let dn = 0;
 %let dp = 0;
 
 %do i=1 %to 2;
    %if (%scan(&dstats,&i)^=) %then %do;
       %if %upcase(%scan(&dstats,&i))=N             %then %let dn = 1;
       %else %if %upcase(%scan(&dstats,&i))=PERCENT %then %let dp = 1;
    %end;
 %end;
 
 %if &dn=1 & &dp=1 %then %let dnp = 1;
 %else %if &dn=1   %then %let dnp = 2;
 %else %if &dp=1   %then %let dnp = 3;
 %else %do;
    %put ERROR: incorrect statistics chosen in DSTATS, defaults will be used;
    %let dnp = 1;
 %end;
 
 proc format;
   picture fpvalue low-high='9.9999';
   run;
 
 
 /******************************************************/
 /* creates macro variables for BY variable properties */
 /******************************************************/
 /* ln       = dataset library name      */
 /* mn       = dataset member name       */
 /* byf    = format of the BY variable   */
 /* bylbl  = label of the BY variable    */
 /* bylength = length of the BY variable */
 /****************************************/
 
 /***********************************************/
 /* looks for a '.' to determine if the dataset */
 /* is a permanent dataset or not               */
 /***********************************************/
 data _null_;
   length a ln mn $ 200;
   a="&dsn";
   i=indexc(a,'.');
   if (i=0) then do;
      ln='WORK';
      mn="&dsn";
   end;
   else do;
     ln=substr(a,1,i-1);
     mn=substr(a,i+1,length(a)-i);
   end;
   call symput("ln",trim(left(ln)));
   call symput("mn",trim(left(mn)));
   run;
 
 proc sql;
    create table _c_ as
    select *
    from sashelp.vcolumn
    where libname="&ln" and memname="&mn";
    quit;
 
 data _null_;
    set _c_;
    if ("&by"='') then do;
       format='$char15.';
       label='Total';
       length=8;
    end;
    if (trim(left(upcase(name)))=trim(left("&by"))) | ("&by"='') then do;
       if (format=' ') & (type='char') then format='$char'
          || trim(left(length)) || '.';
       if (format=' ') & (type='num') then format='8.';
       call symput('byf',trim(left(format)));
       call symput('bylbl',trim(left(label)));
       call symput('bylength',trim(left(put(length,3.))));
    end;
 run;
 
 /***********************************************************************/
 /* creates a temporary analysis master file                            */
 /* with a character _BY_ variable in place of the original BY variable */
 /***********************************************************************/
 %if ^(%sysfunc(exist(&dsn))) %then %do;
    %let errors   = 1;
    %let errorwhy = Dataset &dsn does not exist;
 %end;
 %else %do;
    data _master (keep=&id &var &surv &by _by_ );
       set &dsn;
 
       /********************************************************************/
       /* creates a character variable to replace the original BY variable */
       /********************************************************************/
       length _by_ $ 200;
 
       %if (&noby=1) %then %do;
           _by_='Total';
       %end;
       %else %do;
          _by_ = put(&by,&byf);
       %end;
 
       /* removes missing BY variables if requested */
       %if (&bymiss^=Y) %then %do;
           if (missing(&by)) then delete;
       %end;
 
       /* selects the correct analysis population */
       /* if a subset of data is requested        */
       %if ("&pop"^="")   %then %do;
          if &pop;
       %end;
 
    %if (&type=) %then %do;
       %let errors   = 1;
       %let errorwhy = Variable TYPE was not defined;
    %end;
 
    %let opn=%sysfunc(open(_master));
 
    %if &opn %then %do;
       %if (%sysfunc(attrn(&opn,NOBS))=0) %then %do;
          %let errors   = 1;
          %let errorwhy = Error creating master dataset from dataset &dsn;
       %end;
       %let rc=%sysfunc(close(&opn));
    %end;
 %end;
 
 /******************************************/
 /* creates a listing of the analysis file */
 /* if requested                           */
 /******************************************/
 %if &errors^=1 %then %do;
    /*****************************************/
    /* creates the template for the listings */
    /*****************************************/
    proc template;
       define style lsttable;
          style table /
             frame=&frame
             cellpadding=4
             cellspacing=2
             rules=&rules
             asis=on
             borderwidth=2;
          style data /
             font_face="&bodyfnt" asis=on font_size=&bodysz.pt;
          style Body /
             font_face="&bodyfnt" asis=on font_size=&bodysz.pt;
          style SystemTitle /
             font_face="&bodyfnt" asis=on font_size=&bodysz.pt font_weight=bold;
          style Header /
             font_face="&bodyfnt" asis=on font_size=&bodysz.pt;
          style BodyDate /
             font_face="&bodyfnt" asis=on font_size=&bodysz.pt;
          style Byline /
             font_face="&bodyfnt" asis=on font_size=&bodysz.pt;
          style SystemFooter /
             font_face="&bodyfnt" asis=on font_size=&bodysz.pt;
          style SysTitleAndFooterContainer /
             font_face="&bodyfnt" asis=on font_size=&bodysz.pt;
          style Obs /
             font_face="&bodyfnt" asis=on font_size=&bodysz.pt;
          style IndexItem /
             font_face="&bodyfnt" asis=on font_size=&bodysz.pt;
          style Rowheader /
             font_face="&bodyfnt" asis=on font_size=&bodysz.pt;
       end;
    run;
 
    options linesize=120 pagesize=54;
 
    %if %length(%scan(&outdoc,-1,%str(.)))=3 %then
       %let doctype=%scan(&outdoc,-1,%str(.));
    %else %let doctype=0;
 
    %if &list=Y %then %do;
       %if "&doctype"="0" %then %do;
          %let docnm=&outdoc._lst.doc;
       %end;
       %else %do;
          %let docnm=%scan(&outdoc,1,.)_lst.&doctype;
       %end;
 
       ods listing close;
       ods rtf file="&docnm"  style=lsttable;
 
       data _tmp_;
          set _master;
       run;
 
       proc sort data=_tmp_;
          by &by &id;
       run;
 
       %let docname=%scan(&outdoc,-1,/);
 
       proc print data=_tmp_ label uniform split='#';
          %if &noby=0 %then %do;
             by &by;
          %end;
          var &id &var;
          title "Listing of Data for &docname created on &sysdate9";
       run;
 
       ods trace off;
       ods rtf close;
       ods listing;
       %put Created File: &docnm;
    %end;
 
    options linesize=72 pagesize=60;
 
    /**********************************************/
    /* creates tables of variable characteristics */
    /* as macro variables                         */
    /**********************************************/
    proc sql;
       create table _c_ as
       select *
       from sashelp.vcolumn
       where libname="WORK" and memname="_MASTER";
 
       create table _c2_ as
       select *
       from sashelp.vtable
       where libname="WORK" and memname="_MASTER";
    quit;
 
    /**************************************************************/
    /* determines the number of observations in the analysis file */
    /**************************************************************/
    /* nobs = number of observations in the analysis file */
    data _null_;
       set _c2_;
       call symput('nobs',trim(left(put(nobs,5.))));
    run;
 
    /********************************************************/
    /* creates the overall distribution of the BY variable  */
    /* (including missing values) and creates macro         */
    /*  variables of the different levels                   */
    /********************************************************/
    proc freq data=_master noprint;
       table _by_ / out=_d01 missing sparse nowarn;
    run;
 
    /**************************************************/
    /* BY1, BY2, etc are identifiers of the BY levels */
    /* BYN1, BYN2,... are the totals in each BY group */
    /* NBY is the number of levels of the BY variable */
    /**************************************************/
    proc sort data=_d01;
       by _by_;
 
    data _null_;
       set _d01;
       call symput("fby" || trim(left(_n_)),trim(_by_));
       call symput("by" || trim(left(_n_)),trim(_by_));
       call symput("byn" || trim(left(_n_)),trim(left(count)));
       call symput("nby", trim(left(_n_)));
    run;
 
    /*******************************************************/
    /* NBY_MISS is the number of levels of the BY variable */
    /* without counting MISSING as a separate level        */
    /*******************************************************/
    %let nby_miss=0;
    data _null_;
       set _d01;
       where _by_^=" ";
       call symput("nby_miss",trim(left(_n_)));
    run;
 
 
    /****************************************************/
    /****************************************************/
    /** Main Loop: does the analyses for each variable **/
    /****************************************************/
    /****************************************************/
 
    /* num = the number of the variable currently being processed in this loop */
    %let num=1;
 
    /* v1 = the variable name for the variable currently being processed in this loop */
    %let v1=%upcase(%scan(&var,&num));
 
    /* ind = type of variable being analyzed (from TYPE parameter) */
    %let ind=%upcase(%scan(&type,&num));
 
    /* pval=type of pvalue desired for current variable */
    %if ("&ptype"^="") %then %let pval=%upcase(%scan(&ptype,&num));
 
    /*************************************************************/
    /* sets default p-values if not specified by PTYPE parameter */
    /*************************************************************/
    %else %do;
 
       /* ind=1, 7 or 8 are continuous data */
       %if &ind=1 | &ind=7 | &ind=8 | &ind=C %then %do;
 
          /* pval=3 kruskal wallis test */
          %if (&noby. =0) %then %let pval=3;
 
          /* t-test */
          %if (&noby. =1) %then %let pval=9;
       %end;
 
       /* Wilcoxon test */
       %else %if &ind=3 | &ind=O %then %let pval=5;
 
       /* log-rank test */
       %else %if &ind=4 | &ind=S %then %let pval=8;
 
       /* chi-square test */
       %else %let pval=1;
    %end;
 
    /**********************************************/
    /* converts TYPE and PTYPE aliases to numbers */
    /**********************************************/
    %if (&ind=C) %then %let ind=1;
    %if (&ind=D) %then %let ind=2;
    %if (&ind=O) %then %let ind=3;
    %if (&ind=S) %then %let ind=4;
 
    %if (&pval=N)   %then %let pval=0;
    %if (&pval=C) | (&pval=CH) %then %let pval=1;
    %if (&pval=FE)  %then %let pval=2;
    %if (&pval=KW)  %then %let pval=3;
    %if (&pval=EKW) %then %let pval=4;
    %if (&pval=W)   %then %let pval=5;
    %if (&pval=EW)  %then %let pval=6;
    %if (&pval=F)   %then %let pval=7;
    %if (&pval=LR)  %then %let pval=8;
    %if (&pval=T)   %then %let pval=9;
    %if (&pval=SR)  %then %let pval=10;
    %if (&pval=TR)  %then %let pval=11;
    %if (&pval=TE)  %then %let pval=12;
    %if (&pval=TU)  %then %let pval=13;
    %if (&pval=T2)  %then %let pval=14;
 
    /****
     TANA added on 7/29/2009
     If test statistic was specified as T-test or Sign rank
     when a BY variable is specified then
     the test will get changed to Kruskal wallis test
     ****/
    %if (&noby. =0) and (&pval=9 | &pval=10) and (&ind=1 | &ind=7 | &ind=8) %then
       %let pval=3;
 
    data _mst;
    run;
 
    /**********************/
    /* MAIN ANALYSIS LOOP */
    /**********************/
    %do %while (&v1^=);
       /*********************************************/
       /* gets the variable type, format, and label */
       /*********************************************/
       %let v1type=;
 
%let v1f=;
       %let v1lbl=;
       %let hasit=0;
 
       data _null_;
          set _c_;
          if (label=' ') then label=name;
          if (upcase(name)="&v1") then do;
 
             /* v1type = current variable type   */
             call symput('v1type',trim(left(type)));
 
             /* v1f    = current variable format */
             call symput('v1f',trim(left(format)));
 
             /* v1lbl  = current variable label  */
             call symput('v1lbl',trim(left(%str(label))));
             call symput('hasit',1);
          end;
       run;
 
       %if &hasit=0 %then %do;
          %let errorvar=1;
          %put WARNING: Variable &v1 not found in dataset &dsn;
       %end;
       %else %let errorvar=0;
 
       /*******************************************************/
       /* determines whether or not to include missing values */
       /* in the summary for this variable                    */
       /*******************************************************/
       %do i=1 %to 100;
             %let mis=N;
             %if (%scan(&incmiss1,&i)=&num) | (&incmiss=Y) %then %do;
                %let mis=Y;
             %end;
       %end;
 
       /****************************************************************/
       /* determines whether or not to include confidence              */
       /* intervals for the differences between variables              */
       /* there must be at least 2 levels of the BY variable           */
       /* cip=0 no CI                                                  */
       /* cip=1 CI for the difference in means for continuous data     */
       /* cip=2 CI for the difference in proportions for discrete data */
       /****************************************************************/
       %let cip=0;
       %if &nby>=2 %then %do;
          %do i=1 %to 100;
              %if %scan(&ci,&i)=&num %then %do;
                 %let cip = 2;
                 %if &ind=1 or &ind=7 or &ind=8 %then %do;
                    %let cip = 1;
                 %end;
              %end;
          %end;
       %end;
 
       %if &errorvar=0 %then %do;
          /************************************/
          /************************************/
          /** ANALYSIS FOR DISCRETE VARIABLES */
          /************************************/
          /************************************/
          %if &ind=2  or &ind=3  or &ind=5 or &ind=6 or
              &ind=P1 or &ind=P2 or &ind=P3  %then %do;
 
             /*********************************************/
             /* overall distribution of analysis variable */
             /*********************************************/
             data _master;
                set _master;
                run;
 
             proc freq data=_master noprint;
                table &v1 / out=_d02 sparse nowarn
                %if (&mis=Y) %then %do;
                   missing missprint
                %end;
                ;
                run;
 
             /*******************************************************/
             /* creates a matrix of all possible combinations of the*/
             /* analysis variable and the BY variable               */
             /* including missing values all on one data line       */
             /*******************************************************/
             /* l1-l8 are the levels of the by variable     */
             /* n1-n8 are the total counts at each by level */
             /* nall is the total number of observations    */
             /***********************************************/
 
             data _level (keep=l1-l&nby. n1-n&nby. nall _merge);
                set _d01 end=eof;
                length l1-l&nby. $ 200;
                retain l1-l&nby. n1-n&nby. ;
                _merge=1;
                %do i=1 %to &nby;
                   if _n_=&i then do;
                      l&i. = _by_;
                      n&i. = count;
                   end;
                %end;
 
                if eof then do;
                   nall=sum(of n1-n&nby.);
                   output;
                end;
             run;
 
 
             /*******************************************************/
             /* creates a new file with every possible combination  */
             /* of the summary variable and the BY variable         */
             /* including missing levels                            */
             /* NY is the number of level of the variable           */
             /* currently being summarized                          */
             /* NX is the number of levels of the BY variable       */
             /*******************************************************/
 
             data _dall;
                set _d02;
                if (_n_=1) then set _level;
             run;
 
             data _dall (keep=_by_ &v1);
                set _dall end=eof;
                length _by_ $ 200.;
                %do i=1 %to &nby.;
                   if l&i.^=' ' then do;
                      _by_=l&i.;
                      output;
                   end;
                %end;
                if eof then call symput ('ny',trim(left(_n_)));
             run;
 
             %let nx=&nby;
 
             /**************************************/
             /* sets p-values initially to missing */
             /**************************************/
             data _d2;
               p_pchi=.;
               p_exact2=.;
               p2_trend=.;
               xp2_fish=.;
               output;
               run;
 
             /********************************************/
             /* subgroup distributions excluding missing */
             /********************************************/
             proc freq data=_master noprint;
                table _by_ * &v1 / out=_d1 outpct trend sparse chisq nowarn
                   %if (&mis=Y) %then %do;   missing   %end;
                   %if ((&nby_miss>1) | ((&nby>1) & (&incmiss=Y)))
                      & "&pvalues"="Y"  & &pval=2 %then %do;  exact   %end; ;
 
                   %if ((&nby_miss>1) | ((&nby>1) & (&incmiss=Y)))
                      & "&pvalues"="Y"  %then %do;
                      output out=_d2 n nmiss pchi trend chisq
                      /*** TANA added 2/3/2011 - only performs exact
                           test when requested by user ***/
                      %if &pval. =2 %then %do;  exact   %end; ;
                   %end;
             run;
 
             /************************************************************/
             /**** Tana added this: runs one sample tests on categorical */
             /**** variables if there is no BY variable                  */
             /**** or only one BY category                               */
             /************************************************************/
             %if (&noby.=1) | (&nby_miss=1 & &incmiss=N) | (&nby=1 & &incmiss=Y) %then %do;
                proc freq data=_master noprint;
                   table &v1 / sparse chisq nowarn
                       %if (&mis=Y) %then %do;  missing   %end;  ;
                   output out=_d2 n nmiss pchi chisq;
                run;
             %end;
 
             /* creates a dummy variable to merge on later */
             data _d2;
               set _d2;
               _merge=1;
               run;
 
             /**************************/
             /* Kruskal-Wallis p-value */
             /**************************/
             %if (&v1type=num) & ((&nby_miss>1) | (&nby_miss=1 & &mis=Y & &nby>1))
                  & (&pvalues=Y) %then %do;
                proc npar1way data=_master wilcoxon noprint
                   %if (&mis=Y) %then %do; missing %end; ;
                   var &v1;
                   class _by_;
 
                   /*** TANA added on 2/3/2011: criteria for running
                        an exact test-done only if requested by user ***/
                   %if &pval.=4 | &pval.=6 %then %do;
                      exact wilcoxon;
                   %end;
                   output out=_f1 wilcoxon anova;
                run;
             %end;
             %else %do;
                data _f1;
                   p_kw=.;
                   xp_kw=.;
                   p_f=.;
                   p2_wil=.;
                   xp2_wil=.;
                   p_s=.;
                   p_t=.;
                   output;
                run;
             %end;
 
             data _f1;
                set _f1;
                _merge=1;
             run;
 
             proc sort data=_dall;
                by &v1 _by_;
             run;
 
             proc sort data=_d1;
                by &v1 _by_;
             run;
 
             data _final;
                merge _dall (in=a) _d1 (in=b);
                by &v1 _by_;
             run;
 
             /***************************************************/
             /* creates the summary counts for the TOTAL column */
             /* and appends it to the end of the _final dataset */
             /***************************************************/
             data _tmp;
                set _master;
 
                /*** 8/4/2009 modified to include/exclude the missing values ***/
                %if (&mis^=Y) %then %do;
                   if (_by_^=' ');
                %end;
             run;
 
             proc freq data=_tmp noprint;
                table &v1 / out=_d02  sparse nowarn
                %if (&mis=Y) %then %do;
                   missing missprint
                %end;
                ;
             run;
 
             data _d02;
                set _d02;
                _by_="zzzzzzz";
                total='y';
             run;
 
             data _final;
               set _final _d02;
               run;
 
             /* rounds, formats, and labels all of the p-values */
             proc sort data=_final;
               by &v1 _by_;
               run;
 
             data _d2;
                length pvalue $ 17;
                merge _d2 _level  _f1;
                by _merge;
                format p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 p12 p13 fpvalue.;
                keep l1-l&nby. n1-n&nby. nall pvalue p1-p13;
 
                /************************************************/
                /* prevents notes about uninitialized variables */
                /************************************************/
                if (p1=.) then p1=.;
                if (p2=.) then p2=.;
                if (p3=.) then p3=.;
                if (p4=.) then p4=.;
                if (p5=.) then p5=.;
                if (p6=.) then p6=.;
                if (p7=.) then p7=.;
                if (p8=.) then p8=.;
                if (p9=.) then p9=.;
                if (p10=.) then p10=.;
                if (p11=.) then p11=.;
                if (p12=.) then p12=.;
                if (p13=.) then p13=.;
                if (p_pchi=.) then p_pchi=.;
                if (xp2_fish=.) then xp2_fish=.;
                if (p_kw=.) then p_kw=.;
                if (xp_kw=.) then xp_kw=.;
                if (p2_wil=.) then p2_wil=.;
                if (xp2_wil=.) then xp2_wil=.;
                if (p_f=.) then p_f=.;
                if (p_t=.) then p_t=.;
                if (p_s=.) then p_s=.;
                if (p2_trend=.) then p2_trend=.;
                if (p_te=.) then p_te=.;
                if (p_tu=.) then p_tu=.;
                if (pvalue=' ') then pvalue=' ';
 
                /***********************/
                /* rounds the p-values */
                /***********************/
                p1  = round(p_pchi,&ppct.);
                p2  = round(xp2_fish,&ppct.);
                p3  = round(p_kw,&ppct.);
                p4  = round(xp_kw,&ppct.);
                p5  = round(p2_wil,&ppct.);
                p6  = round(xp2_wil,&ppct.);
                p7  = round(p_f,&ppct.);
                p9  = round(p_t,&ppct.);
                p8  = .;
                p10 = round(p_s,&ppct.);
                p11 = round(p2_trend,&ppct.);
                run;
 
             /************************************************/
             /* fills in '0' for missing combinations of the */
             /* summary variable and the BY variable         */
             /************************************************/
             data _final;
                set _d2 _final;
                if (count=.) then count=0;
                %if (&v1type=num) %then %do;
                   if (percent=.) & (&v1^=.) & (_by_^=' ') then percent=0;
                   if (pct_col=.) & (&v1^=.) & (_by_^=' ') then pct_col=0;
                   if (pct_row=.) & (&v1^=.) & (_by_^=' ') then pct_row=0;
                %end;
                %if (&v1type=char) %then %do;
                   if (percent=.) & (&v1^=' ') & (_by_^=' ') then percent=0;
                   if (pct_col=.) & (&v1^=' ') & (_by_^=' ') then pct_col=0;
                   if (pct_row=.) & (&v1^=' ') & (_by_^=' ') then pct_row=0;
                %end;
 
                length value vlbl vtype var $ 200;
                nvar=.;
                ny=.;
                nvar=&num;
 
                %if (&v1f=)  & (("&v1type"="num") | ("&v1type"="char")) %then %do;
                   value=trim(&v1);
                %end;
 
                %if (&v1f^=) & (("&v1type"="num") | ("&v1type"="char")) %then %do;
                   value=trim(put(&v1,&v1f));
                %end;
 
                vlbl  = "&v1lbl";
                vtype = "&v1type";
                ny    = &ny;
                var   = "&v1";
             run;
 
             /*************************************************************/
             /* creates a file that can be easily printed with proc print */
             /*************************************************************/
             data _tmp (keep=nvar _line level ci c1-c&nby. p1-p13 ctotal pvalue);
                length level $ 200;
                length pvalue $ 17;
                length ci c1-c&nby. ctotal $ 40;
                set _final end=last;
                %if ("&by1"="") | ("&by1"=" ") %then %do;
                   label c1='Missing';
                %end;
                %else %do;
                   label c1="&fby1";
                %end;
 
                label level = '#'
                         ci = '     '
                     ctotal = "Total";
 
                %if (&nby_miss>1) | ((&nby>1) & (&incmiss=Y)) %then %do;
                   %do i = 2 %to &nby;
                      label c&i.="&&fby&i.";
                   %end;
                %end;
 
                /***************************************************/
                /* creates the first line as the label and p-value */
                /***************************************************/
                if (_n_=1) then do;
                   level   = vlbl;
                   ci      = '      ';
                   cctotal = ' ';
 
                   %if (&nby_miss>1) | ((&nby>1) & (&incmiss=Y)) %then %do;
                      %do i = 2 %to &nby.;
                         c&i.=' ';
                      %end;
                   %end;
                  _line = 1;
                  pci1  = .;
                  pci2  = .;
                  nci1  = 0;
                  nci2  = 0;
                  output;
               end;
               else do;
                  pvalue = ' ';
                  p1     = .;
                  p2     = .;
                  p3     = .;
                  p4     = .;
                  p5     = .;
                  p6     = .;
                  p7     = .;
                  p8     = .;
                  p9     = .;
                  p10    = .;
                  p11    = .;
                  p12    = .;
                  p13    = .;
 
                  /******************************/
                  /* outputs the variable level */
                  /******************************/
                  if (&v1=' ') then level='    Missing';
                  else level="    " || trim(left(value));
 
                  %if ((_by_=' ') | (&v1=' ')) & ("&mis"^="Y")
                  %then %do i = 1 %to &nby.;
                     if (trim(left(_by_))=trim(left("&&by&i"))) then
                        c&i.=trim(left(count));
                  %end;
                  %else %do i = 1 %to &nby;
                     %if &ind=5 | &dnp=2 %then %do;
                        if (trim(left(_by_))=trim(left("&&by&i"))) then
                           c&i.=trim(left(count));
                     %end;
                     %else %if &ind=6 | &dnp=3 %then %do;
                        if (trim(left(_by_))=trim(left("&&by&i"))) then
                           c&i.=trim(left(put(round(&pct_type,&decrd),10.&pctdec))) || "%";
                     %end;
                     %else %do;
                        if (trim(left(_by_))=trim(left("&&by&i"))) then
                           c&i.=trim(left(count)) || " ("
                                || trim(left(put(round(&pct_type,&decrd),10.&pctdec))) || "%)";
                     %end;
 
                     %if (&nby_miss>1) | ((&nby>1) & (&incmiss=Y)) %then %do;
                        if (trim(left(_by_))=trim(left("&by1"))) then do;
                           pci1 = &pct_type;
                           nci1 = nci1+count;
                        end;
 
                        if (trim(left(_by_))=trim(left("&by2"))) then do;
                           pci2 = &pct_type;
                           nci2 = nci2+count;
                        end;
                     %end;
                  %end;
                end;
 
                if (total='y') then do;
                   %do i = 1 %to &nby;
                      if (c&i.=' ') then c&i.='0 (0%)';
 
                      /* different formats if the values are missing */
                      if (&v1=' ') & ("&mis"^='Y') then ctotal=trim(left(count));
                      else do;
                         %if &ind=5 | &dnp=2 %then %do;
                            ctotal=trim(left(count));
                         %end;
                         %else %if &ind=6 | &dnp=3 %then %do;
                            ctotal=trim(left(put(round(percent,&decrd),10.&pctdec))) || "%";
                         %end;
 
                         %else %do;
                            ctotal=trim(left(count)) || " ("
                                  || trim(left(put(round(percent,&decrd),10.&pctdec))) || "%)";
                         %end;
                      end;
                   %end;
                   _line=_line+1;
                   output;
                end;
 
                /**************************************************/
                /* inserts a 95% confidence interval if requested */
                /**************************************************/
                if (last) & ("&cip"="2") then do;
                   mdiff   = pci1-pci2;
                   sd      = sqrt(pci1*(100-pci1)/nci1 + pci2*(100-pci2)/nci2);
                   lowerci = round(mdiff-1.96*sd,0.1);
                   upperci = round(mdiff+1.96*sd,0.1);
                   mdiff   = round(mdiff,0.1);
                   _line   = _line+1;
                   level   = ' ';
 
                   %do i = 1 %to &nby;
                      c&i. = ' ';
                   %end;
 
 
                   ctotal = ' ';
                   _line  = _line+1;
                   output;
                   level = 'Difference (95% CI)';
                   ci    = trim(left(mdiff)) || ' (' || trim(left(lowerci)) || ', '
                           || trim(left(upperci)) || ')';
                   output;
                end;
 
                /********************************************/
                /* inserts a blank line after each variable */
                /********************************************/
                if (last) then do;
                   level = ' ';
 
                   %do i = 1 %to &nby.;
                      c&i. = ' ';
                   %end;
 
                   ctotal = ' ';
                   pvalue = ' ';
                   ci     = ' ';
                   _line  = _line+1;
                   output;
                end;
 
                retain ci c1-c&nby. ctotal _line pci1 pci2 nci1 nci2 p1-p4;
             run;
 
 
             /***********************************************************/
             /* removes lines if requested by parameters DVAR and DLINE */
             /***********************************************************/
             data _tmp;
                set _tmp end=last;
                if ("&ind"="P1") | ("&ind"="N1") then do;
                   if (_line>2) & not last then delete;
                end;
                if ("&ind"="P2") | ("&ind"="N2") then do;
                   if (_line=2) then delete;
                end;
                if ("&ind"="P3") then do;
                   if (_line=2) | (_line=3) then delete;
                end;
 
                *** Added by TANA on 5/16/2005;
                /* removes '%' if there are missing values */
                %do i=1 %to &nby.;
                   if trim(left(scan(c&i.,2,'('))) ='%)' then c&i. = scan(c&i.,1,'(');
                %end;
             run;
 
          %end;  ** end of discrete/ordinal analysis **;
 
          /***************************************/
          /***************************************/
          /** ANALYSIS FOR CONTINUOUS VARIABLES **/
          /***************************************/
          /***************************************/
          %if (&ind=1) | (&ind=7) | (&ind=8) %then %do;
 
             /*************************/
             /* overall distributions */
             /*************************/
             proc univariate data=_master noprint;
                var &v1;
                %if (&mis^=Y) %then %do; where (_by_ ^= ' '); %end;
                output out=_e0 mean=mean median=median std=std min=min
                       max=max n=n nmiss=nmiss q1=q1 q3=q3 cv=cv;
             run;
 
             data _e0;
                set _e0;
                total = 'y';
 
             /*********************************************************/
             /* distributions by group (including missing as a group) */
             /*********************************************************/
             proc sort data=_master;
                by _by_;
 
             proc univariate data=_master noprint;
                var &v1;
                by _by_;
                output out=_e mean=mean median=median std=std min=min max=max
                       n=n nmiss=nmiss var=var q1=q1 q3=q3 cv=cv;
 
             data _all;
                set _e _e0;
                std    = round(std, &decsd.);
                mean   = round(mean, &decmean.);
                median = round(median, &decmed.);
             run;
 
             /***********************************/
             /* p-values without missing values */
             /***********************************/
             data _f;
                length pvalue $ 17;
                _merge = 1;
                _by_   = ' ';
                pvalue = '             ';
                p1     = .;
                p2     = .;
                p3     = .;
                p4     = .;
                p5     = .;
                p6     = .;
                p7     = .;
                p8     = .;
                p9     = .;
                p10    = .;
                p11    = .;
                p12    = .;
                p13    = .;
             run;
 
 
             /***** TANA modified this on 7/26/2006 ****/
             %if "&pvalues"="Y" %then %do;
                /********************************************/
                /* Kruskal-Wallis, Wilcoxon and ANOVA tests */
                /********************************************/
                %if ((&nby_miss>1) | ((&nby>1) & (&incmiss=Y))) %then %do;
                   proc npar1way data=_master wilcoxon anova noprint
                      %if (&mis=Y) %then %do; missing %end; ;
                      var &v1;
                      class _by_;
                      %if &pval.=4 | &pval.=6 %then %do;
                         exact wilcoxon;
                      %end;
                      output out=_f wilcoxon anova;
                   run;
                %end;
                /***** TANA modified this on 7/26/2006 ****/
                /****************************************/
                /* One sample t-test and sign rank test */
                /****************************************/
                %else %if &nby_miss=1 %then %do;
                   proc univariate data=_master mu0=&tloc. noprint;
                      var &v1;
                      output out=_f probt=p_t probs=p_s;
                   run;
                %end;
 
                data _f;
                  set _f;
                  _merge=1;
 
                /**********************/
                /* Two sample t-tests */
                /**********************/
                %if (&nby_miss=2 & &incmiss^=Y) |
                    (&nby_miss=1 & &nby=2 & &incmiss=Y) %then %do;
                    /******************/
                    /* Normality Test */
                    /******************/
                    data _master;
                      set _master;
                      length _newby_ $ 150;
                      _newby_=_by_;
                      %if (&incmiss=Y) %then %do;
                          if (_newby_=' ') then _newby_='Missing';
                      %end;
 
                    proc sort data=_master;
                      by _newby_;
 
                    proc univariate data=_master normal noprint;
                      var &v1;
                      by _newby_;
                      output out=_n2 probn=p_n;
 
                    data _n (keep=pn1 pn2);
                      set _n2 end=last;
                      if (_n_=1) then pn1=p_n;
                      if (_n_=2) then do;
                         pn2=p_n;
                         output;
                      end;
                      retain pn1 pn2;
 
                    data _n;
                      set _n;
                      _merge=1;
 
                    /***********/
                    /* T-Tests */
                    /***********/
                    ods listing close;
                    ods output TTests=_ttest;
                    ods output Equality=_equality;
                    proc ttest data=_master h0=&tloc.;
                      class _newby_;
                      var &v1;
                      run;
                    ods output close;
                    ods listing;
                    run;
 
                   data _t (keep=p_te p_tu p_v _merge);
                     set _ttest _equality end=last;
                     _merge=1;
                     if (_n_=1) then do;
                        p_te=.;
                        p_tu=.;
                        p_v=.;
                     end;
                     if (Variances='Equal')   then p_te=Probt;
                     if (Variances='Unequal') then p_tu=Probt;
                     if (Method='Folded F')   then p_v=ProbF;
                     retain p_te p_tu p_v;
                     if (last) then output;
 
                   data _f;
                     merge _n _f _t;
                     by _merge;
 
                %end;
 
                %let tt14=n;
 
                data _f;
                   set _f;
                   /* statements to avoid an uninitialized warning */
                   if (p_kw=.)     then p_kw=.;
                   if (xp_kw=.)    then xp_kw=.;
                   if (p2_wil=.)   then p2_wil=.;
                   if (xp2_wil=.)  then xp2_wil=.;
                   if (p_f=.)      then p_f=.;
                   if (p_t=.)      then p_t=.;
                   if (p_s=.)      then p_s=.;
                   if (p2_trend=.) then p2_trend=.;
                   if (p_te=.)     then p_te=.;
                   if (p_tu=.)     then p_tu=.;
 
                   p1     = .;
                   p2     = .;
                   p3     = round(p_kw,&ppct.);
                   p4     = round(xp_kw,&ppct.);
                   p5     = round(p2_wil,&ppct.);
                   p6     = round(xp2_wil,&ppct.);
                   p7     = round(p_f,&ppct.);
                   p8     = .;
                   p9     = round(p_t,&ppct.);
                   p10    = round(p_s,&ppct.);
                   p11    = round(p2_trend,&ppct.);
                   p12    = round(p_te,&ppct.);
                   p13    = round(p_tu,&ppct.);
 
                   /*****************************************/
                   /* 2 step t-test or Wilcoxon if ptype=14 */
                   /*****************************************/
                   if (pn1=.) then pn1=.;
                   if (pn2=.) then pn2=.;
                   if ("&pval"="14") then do;
 
                      /* Wilcoxon */
                      if (.<pn1<&pnorm.) | (.<pn2<&pnorm.) then _t14=1;
 
                      /* Unequal Variance t-test */
                      else if (.<p_v<&pvar.) then _t14=2;
 
                      /* Equal Variance t-test */
                      else _t14=3;
                      call symput('tt14',trim(left(_t14)));
                   end;
                   run;
 
                   %if (&tt14=1) %then %let pval=5;
                   %if (&tt14=2) %then %let pval=13;
                   %if (&tt14=3) %then %let pval=12;
                   run;
            %end;
 
             /*************************************************************/
             /* creates a file that can be easily printed with proc print */
             /*************************************************************/
             data _t;
                length level $ 200;
                length ci c1-c&nby. ctotal $ 40;
                _merge = 1;
                level  = "&v1lbl";
                _line  = 1;
                ci     = '      ';
                ctotal = ' ';
                %do i = 1 %to &nby.;
                    c&i.=' ';
                %end;
                output;
             run;
 
             data _p (keep=_line level ci c1-c&nby. ctotal pvalue p1-p13);
                merge _t _f;
                by _merge;
                length pvalue $ 17;
                if (pvalue=' ') then pvalue=' ';
             run;
 
             %let ln=2;
 
             /**********/
             /* counts */
             /**********/
             data _n (keep=_line level c1-c&nby. ctotal);
                set _all end=last;
                length level $ 200;
                length c1-c&nby. ctotal $ 40;
                retain c1-c&nby. ctotal;
                level = '    N';
                _line = &ln;
 
                %if (&cn=1 & &ind=1) | &ind=7 | &ind=8 %then %do;
                   %let ln=%eval(&ln+1);
                %end;
 
                %if &cip=1 %then %do;
                   if (trim(left(_by_))=trim(left("&by1"))) then do;
                      call symput("cin1",trim(left(N)));
                   end;
                   if (trim(left(_by_))=trim(left("&by2"))) then do;
                      call symput("cin2",trim(left(N)));
                   end;
                %end;
 
                %do i = 1 %to &nby.;
                   if (trim(left(_by_))=trim(left("&&by&i"))) &
                      total^='y' then c&i.=trim(left(N));
                %end;
 
                if (last) then ctotal=trim(left(N));
                if (last) then output;
             run;
 
             /******************/
             /* number missing */
             /******************/
             data _nmiss (keep=_line level c1-c&nby. ctotal);
                set _all end=last;
                length level $ 200;
                length c1-c&nby. ctotal $ 40;
                retain c1-c&nby. ctotal;
 
                level = '    Missing';
                _line = &ln;
 
                %if (&cnmiss=1 & &ind=1) %then %do;
                   %let ln=%eval(&ln+1);
                %end;
 
                %do i = 1 %to &nby.;
                   if (trim(left(_by_))=trim(left("&&by&i.")))  &
                      total^='y' then c&i.=trim(left(Nmiss));
                %end;
 
                if (last) then ctotal=trim(left(Nmiss));
                if (last) then output;
             run;
 
             /*********************************/
             /* means and standard deviations */
             /*********************************/
             data _mean (keep=_line level c1-c&nby. ctotal);
                set _all end=last;
                length level $ 200;
                length c1-c&nby. ctotal $ 40;
                retain c1-c&nby. ctotal;
 
                if      (&cms=2 & &ind=1) then level = '    Mean';
                else if (&cms=3 & &ind=1) then level = '    SD';
                else level = '    Mean (SD)';
 
                _line = &ln;
 
                %if (&cms>0 & &ind=1) | &ind=8 %then %do;
                   %let ln=%eval(&ln+1);
                %end;
 
                %if &cip=1 %then %do;
                   if (trim(left(_by_))=trim(left("&by1"))) then do;
                      call symput("cimean1",trim(left(MEAN)));
                      call symput("cisd1",trim(left(STD)));
                   end;
 
                   if (trim(left(_by_))=trim(left("&by2"))) then do;
                      call symput("cimean2",trim(left(MEAN)));
                      call symput("cisd2",trim(left(STD)));
                   end;
                %end;
 
                %do i = 1 %to &nby.;
                   if (trim(left(_by_))=trim(left("&&by&i.")))  & total^='y' then do;
                      %if &cms=2 & &ind=1  %then %do;
                         if (mean^=.) then c&i.=trim(left(put(MEAN,10.&meandec.)));
                      %end;
                      %else %if &cms=3 & &ind=1 %then %do;
                         if (std^=.) then c&i.=trim(left(put(STD,10.&sddec.)));
                      %end;
                      %else %do;
                         if (mean^=.) | (std^=.) then c&i.=trim(left(put(MEAN,10.&meandec.)))
                            || ' (' || trim(left(put(STD,10.&sddec.))) || ')';
                      %end;
                   end;
                %end;
 
                if (last) then do;
                   %if &cms=2 & &ind=1 %then %do;
                      if (mean^=.) then ctotal = trim(left(put(MEAN,10.&meandec.)));
                   %end;
                   %else %if &cms=3 & &ind=1 %then %do;
                      if (std^=.) then ctotal = trim(left(put(STD,10.&sddec.)));
                   %end;
                   %else %do;
                      if (mean^=.) | (std^=.) then ctotal=trim(left(put(MEAN,10.&meandec.)))
                         || ' (' || trim(left(put(STD,10.&sddec.))) || ')';
                   %end;
                end;
 
                if (last) then output;
             run;
 
             /***********/
             /* medians */
             /***********/
             data _med (keep=_line level c1-c&nby. ctotal);
                set _all end=last;
                length level $ 200;
                length c1-c&nby. ctotal $ 40;
                retain c1-c&nby. ctotal;
                level = '    Median';
                _line = &ln;
 
                %if (&cmd=1 & &ind=1) | &ind=7 %then %do;
                   %let ln=%eval(&ln+1);
                %end;
 
                %do i = 1 %to &nby.;
                   if (trim(left(_by_))=trim(left("&&by&i."))) & total^='y' then
                      c&i.=trim(left(put(MEDIAN,10.&meddec.)));
                %end;
 
                if (last) then ctotal=trim(left(put(MEDIAN,10.&meddec.)));
                if (last) then output;
             run;
 
             /*************/
             /* quartiles */
             /*************/
             data _quart (keep=_line level c1-c&nby. ctotal);
                set _all end=last;
                length level $ 200;
                length c1-c&nby. ctotal $ 40;
                retain c1-c&nby. ctotal;
                level = '    Q1, Q3';
                _line = &ln;
 
                %if (&cq=1 & &ind=1) | &ind=7 %then %do;
                   %let ln=%eval(&ln+1);
                %end;
 
                %do i = 1 %to &nby.;
                   if (trim(left(_by_))=trim(left("&&by&i.")))  & total^='y' & ((q1^=.) | (q3^=.))
                      then c&i.=trim(left(put(Q1,10.&qdec.))) || ', '
                         || trim(left(put(Q3,10.&qdec.)));
                %end;
 
                if (last & ((q1^=.) | (q3^=.))) then ctotal=trim(left(put(Q1,10.&qdec.)))
                   || ', ' || trim(left(put(Q3,10.&qdec.)));
                if (last) then output;
             run;
 
             /*********/
             /* range */
             /*********/
             data _range (keep=_line level c1-c&nby. ctotal);
                set _all end=last;
                length level $ 200;
                length c1-c&nby. ctotal $ 40;
                retain c1-c&nby. ctotal;
                level = '    Range';
                _line = &ln;
 
                %if (&cr=1 & &ind=1) | &ind=8 %then %do;
                   %let ln=%eval(&ln+1);
                %end;
 
                %do i = 1 %to &nby.;
                   if (trim(left(_by_))=trim(left("&&by&i.")))  and
                      total^='y' & ((min^=.) | (max^=.)) then
                      c&i.='(' || trim(left(put(MIN,10.&rngdec.))) || '-'
                         || trim(left(put(MAX,10.&rngdec.))) || ')';
                %end;
 
                if (last & ((min^=.) | (max^=.))) then ctotal='('
                   || trim(left(put(MIN,10.&rngdec.))) || '-'
                   || trim(left(put(MAX,10.&rngdec.))) || ')';
                if (last) then output;
             run;
 
             /****************************/
             /* coefficient of variation */
             /****************************/
             data _cv (keep=_line level c1-c&nby. ctotal);
                set _all end=last;
                length level $ 200;
                length c1-c&nby. ctotal $ 40;
                retain c1-c&nby. ctotal;
                level = '    CV';
                _line = &ln;
 
                %if (&cv=1 & &ind=1) %then %do;
                   %let ln=%eval(&ln+1);
                %end;
 
 
                %do i = 1 %to &nby.;
                   if (trim(left(_by_))=trim(left("&&by&i."))) & total^='y'  then
                      c&i.=trim(left(put(CV,10.&cvdec.)));
                %end;
 
                if (last) then ctotal=trim(left(put(CV,10.&cvdec.)));
                if (last) then output;
             run;
 
             /**************/
             /* blank line */
             /**************/
             data _blank (keep=_line level ci c1-c&nby. ctotal pvalue p1-p13);
                length level $ 200;
                length pvalue $ 17;
                length ci c1-c&nby. ctotal $ 40;
 
                %do i = 1 %to &nby.;
                   c&i.=' ';
                %end;
 
                level  = ' ';
                ci     = '      ';
                ctotal = ' ';
                pvalue = '            ';
                p1     = .;
                p2     = .;
                p3     = .;
                p4     = .;
                p5     = .;
                p6     = .;
                p7     = .;
                p8     = .;
                p9     = .;
                p10    = .;
                p11    = .;
                p12    = .;
                p13    = .;
                _line  = &ln;
             run;
 
             data _tmp;
                set _p
                %if (&cn=1 & &ind=1) | &ind=7 | &ind=8 %then %do;
                   _n
                %end;
                %if (&cnmiss=1) %then %do;
                   _nmiss
                %end;
                %if (&cmn=1 & &ind=1) | &ind=8 %then %do;
                   _mean
                %end;
                %if (&cmd=1 & &ind=1) | &ind=7 %then %do;
                   _med
                %end;
                %if (&cq=1 & &ind=1) | &ind=7 %then %do;
                   _quart
                %end;
                %if (&cr=1 & &ind=1) | &ind=8 %then %do;
                   _range
                %end;
                %if (&cv=1 & &ind=1) %then %do;
                   _cv
                %end;
                _blank;
                nvar = &num;
             run;
 
             /******************************************/
             /* adds confidence intervals if requested */
             /******************************************/
             %if &cip=1 %then %do;
                data _ci (keep=_line nvar level c1-c&nby. ci ctotal p1-p13);
                   length c1 ci c2 c3 c4 c5 c6 c7 c8 ctotal $ 40 level $ 200;
                   length pvalue $ 17;
                   nvar    = &num;
                   _line   = 7;
                   mdiff   = &cimean1-&cimean2;
                   se      = sqrt(&cisd1*&cisd1/&cin1 + &cisd2*&cisd2/&cin2);
                   lowerci = mdiff-1.96*se;
                   upperci = mdiff+1.96*se;
                   mdiff   = round(mdiff, &decmean.);
                   lowerci = round(lowerci, &decmean.);
                   upperci = round(upperci, &decmean.);
                   level   = "Difference (95% CI)";
                   ci      = trim(left(mdiff)) || ' (' || trim(left(lowerci))
                             || ', ' || trim(left(upperci)) || ')';
                   output;
 
                   %do i = 1 %to 8;
                      c&i. = ' ';
                   %end;
 
                   level  = ' ';
                   ci     = '      ';
                   ctotal = ' ';
                   pvalue = '            ';
                   p1     = .;
                   p2     = .;
                   p3     = .;
                   p4     = .;
                   p5     = .;
                   p6     = .;
                   p7     = .;
                   p8     = .;
                   p9     = .;
                   p10    = .;
                   p11    = .;
                   p12    = .;
                   p13    = .;
                   _line = 8;
                   output;
                run;
 
                data _tmp;
                   set _tmp _ci;
                run;
             %end;
 
          %end;  ** end of continuous analysis **;
 
          /***************************************/
          /***************************************/
          /** ANALYSIS FOR SURVIVAL VARIABLES   **/
          /***************************************/
          /***************************************/
          %if (&ind=4) %then %do;
             /***************************************/
             /* defines the event (status) variable */
             /***************************************/
             %if &snum=0 %then %let event=&surv;
             %else %do;
                %if (%scan(&surv,&snum)^=) %then %do;
                   %let event = %scan(&surv,&snum);
                   %let snum  = %eval(&snum+1);
                %end;
             %end;
 
             /**********************************************/
             /* defines which value is considered censored */
             /**********************************************/
             %if &scen=0 %then %let cen_vl = &scensor;
             %else %do;
                %if (%scan(&scensor, %scen)^=) %then %do;
                   %let cen_vl = %scan(&scensor,&scen);
                   %let scen = %eval(&scen+1);
                %end;
             %end;
 
             %let time = &v1;
             %let errorflg = 0;
 
             %if &time=  %then %do;
                %put  ERROR - Variable <time> not defined;
                %let  errorflg = 1;
             %end;
 
             %if &event=  %then %do;
                %put  ERROR - Variable <event> not defined;
                %let  errorflg = 1;
             %end;
 
             /*****************************************************/
             /* gets medians survival and survival rates by group */
             /* and calculates the log-rank test                  */
             /*****************************************************/
             %let ltime=%sysevalf(365.24*&syear);
 
             /********************************************/
             /* rescales the time variable to be in days */
             /********************************************/
             data _master;
               set _master;
               _time=&time;
               if ("&timeunits"='W') then _time=_time*7;
               if ("&timeunits"='M') then _time=_time*30.44;
               if ("&timeunits"='Y') then _time=_time*365.24;
 
             ods listing close;
             /*************************************/
             /* lifetest to get the log-rank test */
             /* with or without missing values    */
             /*************************************/
             proc lifetest data=_master method=km timelist=0 &ltime 50000
               %if (&incmiss=Y) %then %do; missing %end; ;
               time _time * &event (&cen_vl);
               strata _by_;
               %if (&nby_miss>1) | ((&nby>1) & (&incmiss=Y)) %then %do;
                   ods output HomTests=_lr;
               %end;
               run;
 
             /******************************************************/
             /* lifetest with missing to get medians and estimates */
             /******************************************************/
             proc lifetest data=_master method=km timelist=0 &ltime 50000 missing;
               time _time * &event (&cen_vl);
               strata _by_;
               ods output Quartiles=_med;
               ods output ProductLimitEstimates=_est;
               run;
               ods listing;
               run;
 
             /*****************/
             /* log-rank data */
             /*****************/
             data _lr (keep=plr _merge);
               %if (&nby_miss>1) | ((&nby>1) & (&incmiss=Y)) %then %do;
                  set _lr;
                  plr=.;
                  plr=ProbChisq;
                  if (Test='Log-Rank');
               %end;
               %else %do;
                  plr=.;
               %end;
               _merge=1;
 
             /***************/
             /* median data */
             /***************/
             data _med (keep=_by_ med medl medu);
               set _med;
               if (Percent=50);
               med=Estimate;
               medl=LowerLimit;
               medu=UpperLimit;
               if ("&medunits"='W') then do;
                  med=med/7;
                  medl=medl/7;
                  medu=medu/7;
               end;
               if ("&medunits"='M') then do;
                  med=med/30.44;
                  medl=medl/30.44;
                  medu=medu/30.44;
               end;
               if ("&medunits"='Y') then do;
                 med=med/365.24;
                 medl=medl/365.24;
                 medu=medu/365.24;
               end;
 
             /*********************************/
             /* survival estimates and counts */
             /*********************************/
             data _est (keep=_by_ surv survl survu se n events risk);
               set _est;
               by _by_;
               if (first._by_) then do;
                  surv=.; survl=.; survu=.; se=.; n=Left; events=.; risk=.;
               end;
               if (^first._by_ & ^last._by_) then do;
                  surv=Survival;
                  se=StdErr;
                  risk=Left;
               end;
               if (last._by_) then do;
                  events=Failed;
                  survl=surv-1.96*se;
                  if (survl<0) & (surv^=.) then survl=0;
                  survu=surv+1.96*se;
                  if (survu>1) & (surv^=.) then survu=1;
                  output;
               end;
               retain surv survl survu se n events risk;
 
             /***************************************************/
             /* calculates overall median and survival estimate */
             /***************************************************/
             ods listing close;
             proc lifetest data=_master timelist=0 &ltime 50000
               %if (&incmiss=Y) %then %do; missing %end; ;
               time &time * &event (&cen_vl);
               ods output Quartiles=_medall;
               ods output ProductLimitEstimates=_estall;
               run;
             ods listing;
 
             /******************/
             /* overall median */
             /******************/
             data _medall (keep=meda medla medua _merge);
               set _medall;
               if (percent=50);
               meda=Estimate;
               medla=LowerLimit;
               medua=UpperLimit;
               if ("&medunits"='W') then do;
                  meda=meda/7;
                  medla=medla/7;
                  medua=medua/7;
               end;
               if ("&medunits"='M') then do;
                  meda=meda/30.44;
                  medla=medla/30.44;
                  medua=medua/30.44;
               end;
               if ("&medunits"='Y') then do;
                 meda=meda/365.24;
                 medla=medla/365.24;
                 medua=medua/365.24;
               end;
               _merge=1;
 
            /****************************************/
            /* overall survival estimate and counts */
            /****************************************/
            data _estall (keep=surva survla survua sea na eventsa riska _merge);
              set _estall;
              _merge=1;
              if (_n_=1) then do;
                 surva=.; survla=.; survua=.; sea=.; na=Left; eventsa=.; riska=.;
              end;
              if (_n_=2) then do;
                 surva=Survival;
                 sea=StdErr;
                 riska=Left;
              end;
              if (_n_=3) then do;
                 eventsa=Failed;
                 survla=surva-1.96*sea;
                 if (survla<0) & (surva^=.) then survla=0;
                 survua=surva+1.96*sea;
                 if (survua>1) & (surva^=.) then survua=1;
                 output;
              end;
              retain surva survla survua sea na eventsa riska;
 
            /*****************************/
            /* combines the overall data */
            /*****************************/
            data _tmp1;
              merge _lr _estall _medall;
              by _merge;
 
            data _tmp1 (keep=_line level ci ctotal pvalue p1-p13);
              set _tmp1;
              length level $ 200;
              length pvalue $ 17;
              length ctotal $ 40;
 
              level  = "&v1lbl";
              ci     = '      ';
              ctotal = ' ';
              pvalue = ' ';
              p1     = .;
              p2     = .;
              p3     = .;
              p4     = .;
              p5     = .;
              p6     = .;
              p7     = .;
              p8     = plr;
              p9     = .;
              p10    = .;
              p11    = .;
              p12    = .;
              p13    = .;
 
              _line  = 1;
              output;
 
               _line=2;
              level='    N';
              ctotal=trim(left(na));
              output;
 
              _line=3;
              level='    Events';
              ctotal=trim(left(eventsa));
              output;
 
              _line=4;
              %if (&medunits=D) %then %do; level='    Median Survival Days'; %end;
              %if (&medunits=W) %then %do; level='    Median Survival Weeks'; %end;
              %if (&medunits=M) %then %do; level='    Median Survival Months'; %end;
              %if (&medunits=Y) %then %do; level='    Median Survival Years'; %end;
              ctotal=trim(left(put(round(meda,0.1),10.1)))  || ' (' ||
                     trim(left(put(round(medla,0.1),10.1))) || '-' ||
                     trim(left(put(round(medua,0.1),10.1))) || ')';
              output;
 
              _line=5;
              level="    &syear Yr Survival Rate";
              pct=round(surva*100,0.1);
              pctl=round(survla*100,0.1);
              pctu=round(survua*100,0.1);
              ctotal=trim(left(put(round(pct,0.1),10.1)))  || '% (' ||
                     trim(left(put(round(pctl,0.1),10.1))) || '%-' ||
                     trim(left(put(round(pctu,0.1),10.1))) || '%)';
              output;
 
              _line=6;
              level="    Year &syear N at Risk";
              ctotal=trim(left(riska));
              output;
 
              _line=7;
              level=' ';
              ctotal=' ';
              output;
              run;
 
            /*******************************/
            /* combines the data by groups */
            /*******************************/
            data _tmp2;
              merge _med _est;
              by _by_;
 
            %do i = 1 %to &nby;
              data _c&i (keep=_line c&i);
                set _tmp2;
                if (_n_=&i);
                length c&i $ 40;
                _line=2;
                c&i=trim(left(n));
                output;
 
                _line=3;
                c&i=trim(left(events));
                output;
 
                _line=4;
                c&i=trim(left(put(round(med,0.1),10.1)))  || ' (' ||
                    trim(left(put(round(medl,0.1),10.1))) || '-' ||
                    trim(left(put(round(medu,0.1),10.1))) || ')';
                output;
 
                _line=5;
                pct=round(surv*100,0.1);
                pctl=round(survl*100,0.1);
                pctu=round(survu*100,0.1);
                c&i=trim(left(put(round(pct,0.1),10.1))) || '% (' ||
                trim(left(put(round(pctl,0.1),10.1))) || '%-' ||
                trim(left(put(round(pctu,0.1),10.1))) || '%)';
                output;
 
                _line=6;
                c&i=trim(left(risk));
                output;
 
                _line=7;
                c&i=' ';
                output;
 
              proc sort data=_c&i;
                by _line;
                run;
            %end;
 
            /***********************************************/
            /* creates the final dataset for this variable */
            /***********************************************/
            data _tmp;
              merge _tmp1
                %do i = 1 %to &nby; _c&i %end; ;
              by _line;
              nvar=&num;
              %if (&nby=1) %then %do;
                  length c1 $ 40;
                  c1=ctotal;
              %end;
              run;
         %end; ** end of survival analysis **;
 
 
       /***********************************************/
       /* updates the test footnotes and superscripts */
       /***********************************************/
       %if (&pval>0 & &pfoot=Y) %then %do;
 
           /* test not used before */
           %if &&pt&pval=0 %then %do;
 
               /* flags the test as used already */
               %let pt&pval=1;
 
               /* increase the superscript number */
               %let pfnum=%eval(&pfnum+1);
 
               /* sets p-value superscript to current number */
               %let pnum&pval = &pfnum;
 
               /* adds this label to the test footnote */
               %let pft = &pft    ~{super &pfnum}&&pnm&pval;
           %end;
       %end;
 
       /*************************************************/
       /* sets the pvalue column to the correct p-value */
       /* with rounding and/or footnote labels          */
       /*************************************************/
       data _tmp;
         set _tmp;
         if (_line=1) then do;
 
            /****************************************/
            /* selects the correct p-value to print */
            /* with rounding and/or footnote labels */
            /****************************************/
            %if &pval>0 %then %do;
               if (p&pval.<&ppct. & p&pval.^=.) then do;
                  %if &pfoot=Y %then %do;
                     pvalue="<&ppct.~{super &&pnum&pval}";
                  %end;
                  %else %do;
                     pvalue="<&ppct.";
                  %end;
               end;
               else do;
                  %if &pfoot=Y %then %do;
                     pvalue=trim(left(put(round(p&pval.,&ppct.),6.&pdec.)))
                            || "~{super &&pnum&pval}";
                  %end;
                  %else %do;
                     pvalue=trim(left(put(round(p&pval.,&ppct.),6.&pdec.)));
                  %end;
               end;
            %end;
            %else %do; pvalue=' '; %end;
 
            label p1  = 'Chi-Square p-value'
                  p2  = "Fisher's Exact p-value"
                  p3  = 'Kruskal-Wallis p-value'
                  p4  = "Exact Kruskal-Wallis p-value"
                  p5  = 'Wilcoxon p-value'
                  p6  = 'Exact Wilcoxon p-value'
                  p7  = 'ANOVA F-test p-value'
                  p8  = 'Log Rank p-value'
                  p9  = 'T-test p-value'
                  p10 = 'Sign Rank p-value'
                  p11 = 'Armitage Trend-test p-value'
                  p12 = 'Equal Variance T-Test'
                  p13 = 'Unequal Variance T-Test';
         end;
 
 
/********************************************/
         /* adds the analyses for this variable      */
         /* to the analyses for all of the variables */
         /********************************************/
         data _mst;
            set %if (&num^=1) %then %do; _mst %end; _tmp;
            run;
 
         %if (&debug=Y) %then %do;
             %put _all_;
 
             proc print data=_tmp;
               title 'DEBUG: _tmp';
               run;
 
             proc print data=_mst;
               title 'DEBUG: _mst';
               run;
         %end;
 
      %end; *end of errorvar - skips analysis if the variable does not exist;
 
 
      /******************************/
      /* reads in the next variable */
      /******************************/
      %let num    = %eval(&num+1);
      %let v1     = %upcase(%scan(&var,&num));
      %let indold = &ind;
      %let ind    = %upcase(%scan(&type,&num));
 
      /* uses the previous type if none was selected */
      %if (&ind=) %then %do;
         %let ind=&indold;
      %end;
 
      /* ptype=type of pvalue desired */
      %if "&ptype"^="" %then %let pval=%upcase(%scan(&ptype,&num));
 
      %if "&ptype"="" %then %do;
         %if &ind=1 | &ind=7 | &ind=8 | &ind=C %then %do;
            %if &noby.=0 %then %let pval=3;
            %if &noby.=1 %then %let pval=9;
         %end;
         %else %if &ind=3 | (&ind=O) %then %let pval=5;
         %else %let pval=1;
      %end;
 
      /**********************************************/
      /* converts TYPE and PTYPE aliases to numbers */
      /**********************************************/
      %if (&ind=C) %then %let ind=1;
      %if (&ind=D) %then %let ind=2;
      %if (&ind=O) %then %let ind=3;
      %if (&ind=S) %then %let ind=4;
 
      %if (&pval=N)   %then %let pval=0;
      %if (&pval=C) | (&pval=CH) %then %let pval=1;
      %if (&pval=FE)  %then %let pval=2;
      %if (&pval=KW)  %then %let pval=3;
      %if (&pval=EKW) %then %let pval=4;
      %if (&pval=W)   %then %let pval=5;
      %if (&pval=EW)  %then %let pval=6;
      %if (&pval=F)   %then %let pval=7;
      %if (&pval=LR)  %then %let pval=8;
      %if (&pval=T)   %then %let pval=9;
      %if (&pval=SR)  %then %let pval=10;
      %if (&pval=TR)  %then %let pval=11;
      %if (&pval=TE)  %then %let pval=12;
      %if (&pval=TU)  %then %let pval=13;
      %if (&pval=T2)  %then %let pval=14;
 
   %end;
 
   %let num=%eval(&num-1);
 
   /********************************/
   /* removes the final blank line */
   /********************************/
   data _mst;
     set _mst end=last;
     if (last) then delete;
     run;
 
   /**************************************/
   /* adds in any comments for the table */
   /* and deletes specified lines        */
   /**************************************/
   data _mst;
     set _mst %if (&comments^=) %then %do;
                  &comments %end; ;
     %do i = 1 %to 50;
        %let vr = %scan(&dvar,&i);
        %let dl = %scan(&dline,&i);
        %if (&vr^=) %then %do;
           if (&vr=nvar) & (&dl=_line) then delete;
        %end;
     %end;
   run;
 
   proc sort data=_mst;
     by nvar _line;
     run;
 
   /*****************************************************/
   /* wraps or truncates long lines in the LEVEL column */
   /* based on the LABELWD and LABELWRAP parameters     */
   /*****************************************************/
   data _mst (drop=newline tmpline bindex llength newstart newend i bflag tlength line1);
     set _mst;
     length tmpline $ 200;
     by nvar;
     if (first.nvar) then newline=0;
     newline=newline+1;
 
     /****************************/
     /* label wrapping algorithm */
     /****************************/
     if ("&labelwrap"^="N") then do;
        line1=1;
 
        /* original LEVEL labels */
        tmpline=level;
 
        /* character number to start checking for breaking characters */
        newstart=1;
 
        /* character number to stop checking for breaking characters */
        newend=&labelwd;
 
        /* total length of the string left to check */
        llength=length(tmpline);
 
        if (llength<&labelwd) then newend=llength;
 
        /* flags if there is a blank in the first column */
        if (substr(level,1,1)=' ') then bflag=1;
                                   else bflag=0;
 
         /* sets the target length of characters to search */
        if (bflag=1) then do;
           tlength=&labelwd-4;
 
           /* reduces the overall length and target length */
           /* if there is a blank in the first column */
           llength=llength-4;
        end;
        else tlength=&labelwd;
 
        /* skips the first 4 characters if there is a blank in the first column */
        if (bflag=1) & (line1=1) then newstart=newstart+4;
 
        /* reduces the target window again if this is a continuation line */
        if (bflag=1) & (line1^=1) then tlength=tlength-4;
 
        /* Loops until the remaining characters are less than the window size */
        do while (llength>tlength);
           /**************************************************/
           /* finds the last breaking character in the level */
           /**************************************************/
           bindex=newstart;
           do i = newstart to newend;
              if (substr(tmpline,i,1) in
                 (" ","&","*",")","_","+","=","-",",","/","\","|","]","}"))
                  then bindex=i;
           end;
           if (bindex=newstart) then bindex=newend;
           /****************************************/
           /* outputs the current part of the line */
           /****************************************/
           level=substr(tmpline,newstart,bindex-newstart+1);
           level=trim(left(level));
           if (bflag=1) then level='    ' || level;
           if (bflag=1) & (line1^=1) then level='    ' || level;
           _line=newline;
           output;
           /**************************************************************/
           /* sets the parameters to look at the next part of the string */
           /**************************************************************/
           line1=0;
           newline=newline+1;
           newstart=bindex+1;
           llength=length(tmpline)-bindex;
           if (llength>tlength) then newend=newstart+tlength-1;
                                else newend=length(tmpline);
           %do i = 1 %to &nby.;
               c&i=' ';
           %end;
           ctotal=' ';
           ci=' ';
           pvalue=' ';
        end;
        /*************************************/
        /* outputs the last part of the line */
        /*************************************/
        if (llength>0) then level=substr(tmpline,newstart,llength);
        level=trim(left(level));
        if (bflag=1) then level='    ' || level;
        if (bflag=1) & (line1^=1) then level='    ' || level;
        _line=newline;
        output;
     end;
     /**************************************************/
     /* reports truncated records if no label wrapping */
     /**************************************************/
     else do;
        llength=length(level);
        if (llength>&labelwd) then llength=&labelwd;
        level=substr(level,1,llength);
        output;
     end;
     retain newline;
 
   /******************************/
   /* creates the table template */
   /******************************/
   proc template;
     define style newtable;
 
     style cellcontents /
        nobreakspace=on   font_face="&bodyfnt."  font_weight=medium
        font_style=roman  font_size=&bodysz. pt
        just=center  vjust=center  asis=on  font_size=1;
 
     style lhead /
        nobreakspace=on  font_face="&headfnt."  font_weight=bold
        font_size=&bodysz. pt  font_style=roman
        just=center  vjust=center  asis=on  font_size=1;
 
     style table /
        frame=&frame  asis=on  cellpadding=&space.  cellspacing=&space.
        /*cellwidth=10 */ just=center  rules=&rules  borderwidth=2;
 
     style Body /
        font_face="&headfnt."  asis=on  font_size=&bodysz. pt;
 
     style BodyDate /
        font_face="&headfnt."  asis=on  font_size=&bodysz. pt;
 
     style SysTitleAndFooterContainer /
        font_face="&headfnt."  asis=on  font_size=&bodysz. pt;
 
     style SystemFooter /
        font_face="&headfnt."  asis=on  font_size=&bodysz. pt;
 
     style data /
        font_face="&headfnt." font_size=&bodysz. pt;
 
     style SystemTitle /
        font_face="&headfnt."  font_size=&bodysz. pt;
 
     style ByLine /
        font_face="&headfnt."  asis=on  font_size=&bodysz. pt;
 
     style Header /
        font_face="&headfnt."  asis=on  font_size=&bodysz. pt;
     end;
     run;
 
    %if ("&outdoc"^="") %then %do;
       ods listing close;
       options orientation=&page.;
 
          %if "&doctype"="0" %then %do;
             ods rtf file="&outdoc..doc" style=newtable;
          %end;
          %else %do;
              ods rtf file="&outdoc." style=newtable;
          %end;
 
          %if &pfoot=Y %then %do;
             ods escapechar='~';
          %end;
          title ' ';
 
          %let titles=&ttitle1;
          %if "&ttitle2"^="" %then %do;
             %let titles=&titles.#&ttitle2.;
          %end;
 
          %if "&ttitle3"^="" %then %do;
             %let titles=&titles.#&ttitle3.;
          %end;
 
          %if "&ttitle4"^="" %then %do;
             %let titles=&titles.#&ttitle4.;
          %end;
 
          %if &date=Y %then %do;
             %let fdate=(report generated on " sysdate9 ");
          %end;
 
          %else %do;
             %let fdate=;
          %end;
 
          proc template;
             define table summ;
                mvar sysdate9;
                column level c1 c2-c&nby. ci ctotal pvalue;
                header table_header_1;
                footer table_footer_1 table_footer_2;
             define table_header_1;
                text "&titles.# ";
                style=header{font_size=&titlesz. pt font_face="&titlefnt."
                %if &titlebld=Y %then %do;
                   font_weight=bold
                %end;
                };
                split='#';
             end;
 
             define table_footer_1;
                %if (&date=Y) | ("&foot"^="") | &pfoot=Y %then %do;
                   %if &pfoot=Y %then %do;
                       text " &fdate#&pft#&foot";
                   %end;
                   %else %do;
                       text " &fdate#&foot";
                   %end;
                %end;
                %else %do;
                   text "";
                %end;
 
                split='#';
                just=left;
                style=header{font_size=&footsz. pt font_face="&headfnt."};
             end;
 
             define table_footer_2;
                %if ("&foot2"^="") | ("&foot3"^="") | ("&foot4"^="")
                    | ("&foot5"^="") %then %do;
                   text " &foot2#&foot3#&foot4#&foot5";
                %end;
 
                %else %do;
                   text "";
                %end;
 
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
                cellcontents{font_weight=bold   font_size=&bodysz. pt
                font_face="&headfnt."
                %if (&levelwd^=) %then %do;
                   cellwidth=&levelwd.
                %end;
                },
                substr(_val_,1,1)=' ' as
                cellcontents{font_weight=medium font_size=&bodysz. pt
                font_face="&headfnt."
                %if (&levelwd^=) %then %do;
                   cellwidth=&levelwd.
                %end;
                };
             end;
 
             %do i = 1 %to &nby.;
                define column c&i.;
                   generic=on;
                   style=cellcontents{font_size=&bodysz. pt
                   font_face="&bodyfnt."
                   %if (&datawd^=) %then %do;
                      cellwidth=&datawd.
                   %end;
                   };
                   vjust=top;
                   just=center;
                   %if ("&&by&i"="") or ("&&by&i"=" ") %then %do;
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
                %if (&ciwd^=) %then %do;
                   cellwidth=&ciwd.
                %end;
                };
                vjust=top;
                just=center;
                header=" ";
             end;
 
             define column ctotal;
                generic=on;
                style=cellcontents{font_size=&bodysz. pt font_face="&bodyfnt."
                %if (&datawd^=) %then %do;
                   cellwidth=&datawd.
                %end;
                };
                vjust=top;
                just=center;
                header="Total                                       (N=&nobs.)";
             end;
 
             define column pvalue;
                generic=on;
                style=cellcontents{font_size=&bodysz. pt font_face="&bodyfnt."
                %if (&pvalwd^=) %then %do;
                   cellwidth=&pvalwd.
                %end;
                };
                vjust=top;
                just=center;
                header="p value";
             end;
             end;
          run;
 
          data _null_;
             set _mst;
 
             file print ods=(template='summ'
                columns=(level=level(generic=on)
                %do i = 1 %to &nby.;
                   c&i.=c&i.(generic=on)
                %end;
                %if (&ci^=) %then %do;
                   ci=ci(generic=on)
                %end;
 
                %if (&total=Y)   %then %do;
                   ctotal=ctotal(generic=on)
                %end;
 
                %if (&pvalues=Y) %then %do;
                   pvalue=pvalue(generic=on)
                %end;
 
             ));
             put _ods_;
          run;
 
       ods rtf close;
       ods listing;
 
       %if "&doctype"="0" %then %do;
          %put Created File: &outdoc..doc;
       %end;
 
       %else %do;
          %put Created File: &outdoc.;
       %end;
    %end;
 
    /**************************/
    /* prints the final table */
    /**************************/
    options linesize=128 pagesize=56;
    %if &print=Y %then %do;
       ods trace on;
       proc print data=_mst label noobs split='*';
          var %if (&debug=Y) %then %do;
                 nvar _line
              %end;
          level c1-c&nby ci ctotal pvalue p1 p2 p3 p4 p5 p6 p7 p9 p8 p10 p11 p12 p13;
          title "&ttitle1";
          %if "&ttitle2"^="" %then %do;
             title2 "&ttitle2";
          %end;
       run;
       ods trace off;
    %end;
 
    /******************************/
    /* creates the output dataset */
    /******************************/
    %if (&outdat^=) %then %do;
       data &outdat;
          length tit1-tit4 ft1-ft5 $100. ;
          set _mst;
          tit1=' '; tit2=' '; tit3=' '; tit4=' '; ft1=' '; ft2=' '; ft3=' '; ft4=' '; ft5=' ';
          if _n_=1 then do;
              oldline=_line;
              _line=0;
              nby=&nby;
              %do i = 1 %to &nby.;
                 byn&i.=&&byn&i;
                 by&i="&&by&i";
                 fby&i="&&fby&i";
              %end;
 
              nobs=&nobs.;
              pfoot="&pfoot";
              %if &pfoot=Y %then %do;
                 pft="&pft";
              %end;
 
              tit1="&ttitle1"; tit2="&ttitle2"; tit3="&ttitle3"; tit4="&ttitle4";
              ft1="&foot"; ft2="&foot2"; ft3="&foot3"; ft4="&foot4"; ft5="&foot5";
              %if (&date=Y) %then %do;
                 fdate="Y";
              %end;
              %else %do;
                 fdate="N";
              %end;
 
              %if (&ci=) %then %do;
                 haveci=0;
              %end;
              %else %do;
                 haveci=1;
              %end;
 
              %if (&total=N)   %then %do;
                 havetot=0;
              %end;
              %else %do;
                 havetot=1;
              %end;
 
              %if (&pvalues=N) %then %do;
                 havep=0;
              %end;
              %else %do;
                 havep=1;
              %end;
              output;
              _line=oldline;
           end;
           output;
        run;
     %end;
 
     /*************************************/
     /* cleans up the temporary data sets */
     /*************************************/
 
     proc datasets nolist;
        delete _c2_ _check _c_ _d01 _d02 _d1 _d2 _dall _f1 _n _f _e _e0
               _final _level _master _mst _tmp _tmp_ _sumry_ _x1
               _t _all _tot _p _mean _med _range _cv _blank _tot_
               _counts_ _lr1 _lr2 _lrmstr _tmp1_ _nmiss _quart
               _ttest _tmp1 _tmp2 %do i = 1 %to &nby; _c&i %end;
               _equality _est _estall _lr _medall _n2;
     run;
     quit;
 
     /*** Added 2/10/2011: Restores the ODS path to its original state and delete
          the entire SASUSER.Templat library of customized templates
      ***/
     proc template;
       delete lsttable;
       delete newtable;
       %if ("&outdoc"^="") %then %do; delete summ; %end;
       run;
       quit;
 
     /*
     ods path sashelp.tmplmst(read);
        proc datasets library=sasuser;
           delete templat(memtype=itemstor);
        run;
        quit;
     ods path sasuser.templat(update) sashelp.tmplmst(read);
     */
 
  %end;
  %else %do;
     %put ERROR: &errorwhy;
  %end;
 
  /****************************************/
  /* restores the user's original options */
  /****************************************/
  options validvarname=&validvn &sdate &snotes &snumb linesize=&ulinesize pagesize=&upagesize;
 
%mend table;
 
