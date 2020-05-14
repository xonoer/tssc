{smcl}
{hline}
help for {cmd:fvregen} {right:(Roger Newson)}
{hline}


{title:Regenerate {help fvvarlist:factor variables} in a {helpb parmest} output dataset}

{p 8 15}{cmd:fvregen} [{help varlist:{it:newvarlist}}] {ifin} [ {cmd:,}
 {cmdab:fr:om}{cmd:(}{varlist}{cmd:)}
 {cmdab:do:file}{cmd:(}{help do:{it:dofilename}}{cmd:)}
 {cmdab:fm:issing}{cmd:(}{help varname:{it:newvarname}}{cmd:)} ]


{title:Description}

{pstd}
{cmd:fvregen} is intended for use in output datasets (or resultssets) created by the programs {helpb parmest} or {helpb parmby}.
These are part of the {helpb parmest} package, which can be downloaded from {help ssc:SSC},
and which create output datasets (or resultssets),
with one observation per estimated parameter of a model fitted to an original dataset.
{cmd:fvregen} regenerates {help fvvarlist:factor variables} included in the model,
using information from the parameter names.
Each regenerated factor variable has non-missing values in observations corresponding to parameters
corresponding to levels of that factor,
or to combinations of levels of that factor and other factors in products or interactions.
In each observation,
the regenerated factors with non-missing values are the factors involved in the parameter corresponding to that observation,
and their values are the values of the levels of these factors corresponding to that parameter.
The regenerated factors may have the same {help type:storage types}, {help format:display formats},
{help label:value labels}, {help label:variable labels}
and {help char:variable characteristics} as the factor variables of the same names in the original dataset,
in which the model parameters were estimated.
This is made possible by running {help do:do-files} created by the {helpb descsave} package.
After the factors are generated, they can be listed,
and/or used in confidence interval plots generated by the {helpb eclplot} package,
and/or merged to create a table row variable using the {helpb factmerg} package.
The {helpb descsave}, {helpb eclplot} and {helpb factmerg} package
can all be downloaded from {help ssc:SSC}.


{title:Options}

{phang}
{cmd:from(}{it:varlist}{cmd:)} specifies a list of one or more input string variables,
containing parameter names in the form of {help fvexpand:expanded specific factor varlist elements},
from which the factors and their values are extracted.
If this option is absent, then {cmd:fvregen} attempts to extract the
factors from a single string variable named {cmd:parm},
which is the default name of the parameter name variable produced by the {helpb parmest} and {helpb parmby} modules
of the {helpb parmest} package.

{phang}
{cmd:dofile(}{it:dofilename}{cmd:)} specifies a Stata do-file to be called by {cmd:fvregen} after the
new factors have been created.
This do-file is usually created by {helpb descsave}, and contains commands
to reconstruct the new factors with the storage types, display formats, value labels,
variable labels and selected characteristics of the old factors with the same names in the original dataset.

{phang}
{cmd:fmissing(}{it:newvarname}{cmd:)} specifies the name of a new binary variable to be generated,
containing missing values for observations excluded by the {helpb if} and {helpb in} qualifiers,
1 for other observations in which all the generated factors are missing, and 0 for other observations
in which at least one of the generated factors is nonmissing.


{title:Remarks}

{pstd}
{cmd:fvregen} is typically used with the {helpb parmest} and {helpb descsave} packages to create a new dataset
with one observation per parameter of the most recently fitted model,
and data on the estimates, confidence intervals, P-values
and other attributes of these parameters.
These data are used to create tables and/or plots.
Confidence interval plots are often produced using the {helpb eclplot} package.
To merge multiple factor variabless and generate string variables containing the factor values, names and/or labels,
use the {helpb factmerg} package.
The {helpb parmest}, {helpb descsave}, {helpb eclplot} and {helpb factmerg} packages
can be downloaded from {help ssc:SSC}.

{pstd}
In {help version:Stata versions 7 to 10},
factors were included in models using the {helpb xi} command,
and factor variables in {helpb parmest} resultssets were regenerated using the {helpb factext} package,
which used information in the {help label:variable labels} of the indicator variables generated by {helpb xi}.
When {help version:Stata version 11} became available,
it became possible to use {help fvvarlist:factor variable lists} in {help estcom:estimation commands},
and the {cmd:fvregen} package was written to supersede {helpb factext}.


{title:Examples}

{pstd}
The following examples will work with the {hi:auto} data if the {help ssc:SSC} packages {helpb parmest} and {helpb eclplot} are installed.
They will create confidence
interval plots of the parameters corresponding to values of the factor {cmd:rep78}.
Note that the first example produces a plot of mean mileages for each repair record group,
whereas the second example produces a plot of mean differences in mileage
between each repair record group and the reference repair record group,
including a zero-width confidence interval around a zero mean difference for the reference repair record group itself.

{p 16 20}{inp:. sysuse auto, clear}{p_end}
{p 16 20}{inp:. parmby "regress mpg ibn.rep78, noconst", label norestore}{p_end}
{p 16 20}{inp:. fvregen rep78}{p_end}
{p 16 20}{inp:. eclplot estimate min95 max95 rep78}{p_end}

{p 16 20}{inp:. sysuse auto, clear}{p_end}
{p 16 20}{inp:. regress mpg i.rep78}{p_end}
{p 16 20}{inp:. parmest, label norestore}{p_end}
{p 16 20}{inp:. fvregen}{p_end}
{p 16 20}{inp:. eclplot estimate min95 max95 rep78, yline(0)}{p_end}

{pstd}
The following example will work with the {hi:auto} data if {helpb descsave} is installed in addition
to {helpb parmest} and {helpb eclplot}.
The reconstructed categorical variables {hi:rep78} and {hi:foreign} will have
the variable and value labels belonging to the variables of the same names in the original dataset.

{p 16 20}{inp:. sysuse auto, clear}{p_end}
{p 16 20}{inp:. tab foreign,gene(orig_) nolab}{p_end}
{p 16 20}{inp:. tempfile tf1}{p_end}
{p 16 20}{inp:. descsave, do(`"`tf1'"', replace)}{p_end}
{p 16 20}{inp:. parmby "regress mpg ibn.foreign i.rep78, noconst", label norestore}{p_end}
{p 16 20}{inp:. fvregen, do(`"`tf1'"')}{p_end}
{p 16 20}{inp:. describe}{p_end}
{p 16 20}{inp:. eclplot estimate min95 max95 rep78, yline(0)}{p_end}
{p 16 20}{inp:. eclplot estimate min95 max95 foreign, xlab(0 1)}{p_end}
{p 16 20}{inp:. list foreign rep78 estimate min95 max95 p}{p_end}

{pstd}
The following example demonstrates higher order interactions.
It will work with the {hi:auto} data
if {helpb descsave} is installed in addition to {helpb parmest}.

{p 16 20}{inp:. sysuse auto, clear}{p_end}
{p 16 20}{inp:. tempfile tf1}{p_end}
{p 16 20}{inp:. descsave, do(`"`tf1'"', replace)}{p_end}
{p 16 20}{inp:. parmby "regress mpg i.foreign#i.rep78", label norestore}{p_end}
{p 16 20}{inp:. fvregen, do(`"`tf1'"')}{p_end}
{p 16 20}{inp:. list foreign rep78 parm estimate min95 max95 p, nodisp}{p_end}

{pstd}
The {helpb parmest}, {helpb descsave} and {helpb eclplot} packages can be installed from {help ssc:SSC}.


{title:Saved results}

{pstd}
{cmd:fvregen} saves the following results in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(varlist)}}list of factor variables created{p_end}
{p2colreset}{...}


{title:Author}

{pstd}
Roger Newson, Imperial College London, UK.
Email: {browse "mailto:r.newson@imperial.ac.uk":r.newson@imperial.ac.uk}


{title:Also see}

{psee}
Manual:  {findalias frfvvarlists}, {manlink P fvexpand}, {manlink D describe}, {manlink D label}, {manlink G graph}, {manlink R xi}
{p_end}

{psee}
{space 2}Help:  {manhelp fvvarlist U:11.4.3 Factor variables}, {manhelp fvexpand P}, {manhelp describe D}, {manhelp label D}, {manhelp graph G}, {manhelp xi R}{break}
{helpb parmest}, {helpb descsave}, {helpb eclplot}, {helpb factmerg}, {helpb factext} if installed
{p_end}
