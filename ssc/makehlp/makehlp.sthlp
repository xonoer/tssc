{smcl}
{* *! version 2.01  2 Oct 2018}{...}
{viewerjumpto "Syntax" "examplehelpfile##syntax"}{...}
{viewerjumpto "Description" "examplehelpfile##description"}{...}
{viewerjumpto "Options" "examplehelpfile##options"}{...}
{viewerjumpto "Remarks" "examplehelpfile##remarks"}{...}
{viewerjumpto "Examples" "examplehelpfile##examples"}{...}
{title:Title}
{phang}
{bf:makehlp} {hline 2} Automatically create a help file

{marker syntax}{...}
{title:Syntax}
{p 8 17 2}
{cmdab:makehlp}
[{cmd:,}
{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt f:ile(string)}} specifies the adofile excluding the .ado extension.{p_end}
{synopt:{opt r:eplace}} specifies that the old help file is replaced.{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

{marker description}{...}
{title:Description}
{pstd}
{cmd:makehlp} creates help files automatically from a Stata ado file. This should save developers some time as
the helpfiles are not exactly WYSIWYG.

{pstd}
Now allows text to be inserted in the original ado-file that contains the title, description, options, see also, examples,
emails and institutes. The commented text must start with START HELP FILE and end with END HELP FILE. There are various
text boxes such as title[] which contains the text for the title. Note do not use [ or ] in the text descriptor. Similarly
the description text is within desc[ ], etc.. An example is below that generates all the text 
required in a help file.

{pstd}
Avoid using the text `mh_line' in your code as this will create an infinite loop.

{pstd}
If you comment out a line of code with the return statements then this program will still pick them
up and think you are trying to return something .e.g  /*return local whatever ="3" */.
It is possible to handle this problem internally but would make the resulting code 
too slow so better to remove code that is not needed.

{pstd}
Note: occasionally there is a need to allow special characters e.g. : in the examples section executable lines, for this use char 58 in brackets (thanks to Adrian Sayers for  this tip).

{asis}

/* START HELP FILE
title[a command to give the parameters of the single stage Gehan design]

desc[
 {cmd:sampsi_gehan} calculates the sample sizes for the first and second stages of the Gehan design
    (1961).
]
opt[beta() specifies the first stage maximum probability of seeing no responses.]
opt[p1() specifies the desired probability of response.]
opt[se()  specifies the desired standard error in the second stage.]
opt[start() specifies the smallest n to start the search from.]
opt[precp() specifies the probability used in the standard error formula.]


opt2[precp() specifies the probability used in the standard error formula.
and I wanted more than one line for the longer  descriptions of the
option precp() later in the help file]

example[
 {stata sampsi_gehan, p1(0.2) beta(0.05) se(0.1) precp(0.4)}
]
author[Prof Adrian Mander]
institute[Cardiff University]
email[mandera@cardiff.ac.uk]

return[n1 The first stage sample size]
return[p1 The interesting p1 ]
return[beta The type 2 error]
return[se Standard error]
return[n2 The second stage sample size]

freetext[]

references[
Gehan, E.A. (1961) The Determination of the Number of Patients Required in a Preliminary and 
Follow-Up Trial of a New Chemotherapeutic Agent. Journal of Chronic Diseases, 13, 346-353.
]

seealso[
{help sampsi_fleming} (if installed)  {stata ssc install sampsi_fleming} (to install this command)

{help simon2stage} (if installed)   {stata ssc install simon2stage} (to install this command)

]

END HELP FILE */
{smcl}


{marker options}{...}
{title:Options}
{dlgtab:Main}
{phang}
{opt f:ile(string)} specifies the adofile excluding the .ado extension.

{phang}
{opt r:eplace} specifies that the old help file is replaced.


{marker examples}{...}
{title:Examples}

{phang} {cmd: makehlp, file(sampsi_gehan) replace}

{title:Author}
{p}
{p_end}
{pstd}
Adrian Mander, Cardiff University, Cardiff, UK.

{pstd}
Email {browse "mailto:mandera@cardiff.ac.uk":mandera@cardiff.ac.uk}

