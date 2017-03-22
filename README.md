The macros being modified in this repository are from a paper presention at [SGF 2012](http://support.sas.com/resources/papers/proceedings12/345-2012.pdf).

There are three macros: table, tablemrg, and stable. 

macro | description
--- | ---
table | produces demographics tables with tests of differences across groups. 
tablemrg | combines results from multiple calls to table.
stable | produce survival tables with median and cox statistics.

Kaitie's Wish List of Updates

1. Logistic Regression (STABLE Macro)  
   1. No logistic regression analyses are currently available with the macro.  Would be great to add this and format the output appropriately.  
   1. Small counts logistic regression  
   **Thought**: possibly create new ltable macro? Depends on how long/complex the code is surrounding the procedure.
1. Missing Options  
   1. Will do missing in the BY statement and include or exclude this group from analyses.  Will also display a missing level within a variable. It will not display missing BY values AND missing variables AND do analyses/summaries (only Ns).  
   **Thought**: I fear that this is very much baked into the fabric of the macro.  
   1. Would be nice to have a ‘Shell’ for data without missing values when other variables have missing values.  
   **Question**: unclear what is being asked for.  
   **Clarification**: So essentially when you ask for the missing option and a variable has missing values it will display that as a row with ‘Missing’ in the level variable and the number missing in each column.  However, if you specify the missing option and a variable has no missing values, the row with ‘Missing’ is NOT displayed.  This sometimes can be problematic when you want to merge tables together to make one big table as the _line variables gets kinda messed up.  So, I was thinking, it would be nice if when you specify the missing option a ‘Missing’ level ALWAYS shows up even if there isn’t any missing data and the columns just have ‘0’ in them.  
   **Thought**: seems like this shouldn't be too bad.
1. Dual By Statements  
   1. If you want to have two by groups (i.e. treatment within stratum) you have to make 4 different groups and the display doesn’t look great.  
   **Question**: is this merely because of the repeated text in the column header, or does it not look great in some other way?  
   1. Only does an analysis across all by variables. Would like to do across and between different BY groups.  
   **Thought**: can get around this by running the macro twice, then merging results. I doubt that a macro update could be made that would make the call any simpler than the two-call process. Will investigate the possibility of a nesting variable nonetheless.  
   **Thought**: the two-call process could run afoul of differing numbers of rows in the output for the two calls. Think about ways to possibly avoid this issue. Would be a potential problem for the nesting approach as well.
1. Output Shells  
   1. Would be AMAZING if when a table was output, a specs shell would also get output!  
   **Thought**: since table is built in a dataset first, and since all columns are character variables, should be straightforward to create a specs shell with the translate function.  
   **RESOLUTION**: added parameter OUTSHELL. Specify name of dataset to create with Xs in place of numbers. Then call `%tablemrg` with that dataset. Not perfect yet as the header N values are not converted to Xs. 
1. Character pvalues compatible with RhoTables  
   1. Currently p-values are output as character with ‘~’ to print super scripts. You either have to strip the pvalue of the superscript or find the correct numeric p-value to convert it to character before passing to RhoTables. Would be nice if this variable were already created.  
   **Thought**: should be straightforward with a new variable.  
   **Question**: would you want RT4-friendly syntax for superscripts in the new variable (pvalue_rt4), or simply strip out the superscript part (pvalue_plain), or both versions?  
   **RESOLUTION**: added numeric variables PVALUEN (the p-value itself) and PVALUESUP (the superscript) to OUTDAT. 
1. Spacing  
   1. Currently every variable has a space between it and the next variable in the table. For long tables, it would be nice to be able to remove that extra line space if needed.  
   **Thought**: should be straightforward with last-dot logic.  
   **RESOLUTION**: added parameter VARSPACE. Default is Y. Use N to remove space (i.e., empty row) between variables.
1. ODS Output Stream  
   1. Currently, only output option is RTF. It would be nice to have a PDF option.  
   **Thought**: seems likely to be straightforward, depending on whether or not RTF-centric ODS options are used. Possible implementation would be to introduce OUTRTF and OUTPDF as macro options (with OUTDOC taking a back seat). This is slightly entangled with the LIST= macro parameter.  
   **RESOLUTION**: added parameter OUTPDF. Specify full path and name of desired file. 
1. Put nbys in macro variables  
   1. Currently NBY is a variable in the output dataset. Would be GREAT if the BY variable names and numbers were put into macro variables to be later called by RhoTables.  
   **Thought**: should be straightforward.  
   **RESOLUTION**: already present as a local macro variable. Added %global statement to make accessible externally.
