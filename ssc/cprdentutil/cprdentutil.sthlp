{smcl}
{hline}
help for {cmd:cprdentutil}{right:(Roger Newson)}
{hline}


{title:Utilities for converting {browse "http://www.cprd.com":CPRD} entity data variables to numeric variables}

{p 8 21 2}
{cmd:cprdent_}{it:enttype} [ , {opt do:file(filename)} ]{p_end}

where {it:enttype} is an integer identifying a CPRD entity type.


{title:Description}

{pstd}
The {cmd:cprdentutil} library of programs is intended for use in datasets produced by the {helpb cprdutil} package.
The programs are used to input string variables with names of form {cmd:data}{it:x}, where {it:x} is an integer,
found in Stata datasets produced using the {helpb cprdutil} modules {helpb cprd_test} or {helpb cprd_additional},
and to output {help label:labelled} numeric variables,
containing the same information in a form usable by Stata statistical programs and understandable by human users.
The names and values of these numeric variables are chosen to define CPRD entities of types indicated by the entity type number,
such as test results for a specific kind of test (such as a blood metabolite measurement),
or additional information for a specific kind of clinical event (such as a height measurement).


{title:Options for commands in the {cmd:cprdentutil} library}

{phang}
{cmd:dofile(}{it:filename}{cmd:)} specifies the name of an existing {help do:Stata do-file},
usually created using the {cmd:dofile()} option of the {helpb cprd_xyzlookup} module of the {helpb cprdutil} package.
This do-file is executed by the {cmd:cprdentutil} module,
and usually creates a set of {help label:value labels},
some of which are then allocated to variables generated by the {cmd:cprdentutil} module.


{title:Remarks}

{pstd}
The {browse "http://www.cprd.com":Clinical Practice Research Datalink (CPRD)} is a database of information
from primary-care practices in the British Health Service.
Tab-delimited text data files of various types can be retrieved,
containing data on things known to these practices,
such as clinical events, additional information on clinical events, and tests.
These files can be read into Stata datasets, using the modules of the {helpb cprdutil} package.

{pstd}
The {helpb cprd_additional} and {helpb cprd_test} modules of the {helpb cprdutil} package create datasets
containing a numeric variable {cmd:enttype}, which specifies a CPRD entity type,
and also containing string variables with names beginning with {cmd:data},
such as {cmd:data1} and {cmd:data2}.
These string variables contain information on CPRD entities, of a type indicated by {cmd:enttype}.
These entity types determine how the {dmd:data}{it:x} variables should be read,
in order to evaluate new variables containing information on those entities.
For instance, entity type 1 is a blood pressure measurement,
and the {cmd:data}{it:x} variables in an observation whose {cmd:enttype} value is 1
contain information on the blood pressure measurement,
such as the systolic and diastolic values, the time of day when the measurement was made,
and the posture of the patient when the measurement was made.
There is a {cmd:cpdent_}{it:enttype} module for each of a list of commonly used {it:enttype} values.
For instance, {cmd:cprdent_1} inputs the existing string variables {cmd:data1} to {cmd:data7},
and creates new variables describibg a blood pressure measurement,
with {help label:variable labels and value labels}.


{title:Modules of the {cmd:cprdentutil} library}

{pstd}
The modules of the {cmd:cprdentutil} library, and the CPRD entities for which they are used, are listed as follows:

{p2colset 4 20 22 2}{...}
{p2col:Module}Entity description{p_end}
{p2line}
{p2col:{cmd:cprdent_1}}Blood pressure{p_end}
{p2col:{cmd:cprdent_4}}Smoking{p_end}
{p2col:{cmd:cprdent_5}}Alcohol{p_end}
{p2col:{cmd:cprdent_13}}Weight{p_end}
{p2col:{cmd:cprdent_14}}Height{p_end}
{p2col:{cmd:cprdent_26}}Current Diabetes status{p_end}
{p2col:{cmd:cprdent_87}}Family History{p_end}
{p2col:{cmd:cprdent_147}}Cardiovascular disease risk{p_end}
{p2col:{cmd:cprdent_163}}Serum cholesterol{p_end}
{p2col:{cmd:cprdent_175}}High density lipoprotein{p_end}
{p2col:{cmd:cprdent_177}}Low density lipoprotein{p_end}
{p2line}
{p2colreset}

{pstd}
There are many other CPRD enttypes.
Some are more commonly used than others.
A list of all entity types recognised by CPRD
can be found in the Stata datasets produced by {helpb cprd_entity},
which inputs a CPRD tab-delimited text dataset with 1 row per entity type,
and outputs a Stata dataset to memory, with 1 observation per entity type,
and data on the variables stored in the {cmd:data}{it:x} variables
for test records or additional clinical records of that entity type.


{title:Examples}

{pstd}
The following example asumes that the user has created a do-file {cmd:myxyzlookups.do},
using the {helpb cprd_xyzlookup} module of the {helpb cprdutil} paclage,
to create variable labels for all the CPRD {it:XYZ} lookups.
It inputs a CPRD test dataset using the {helpb cprd_test} module of the {helpb cprdutil} package
to create a dataset with1 observation per test event in memory.
It then drops all observations with a value of {cmd:enttype} other than 163,
which indicates a serum cholesterol measurement.
It then uses the {cmd:cprdent_163} module of {cmd:cprdentutil}
to create a list of 7 new variables, labelled informatively,
containing information on the serum cholesterol measurements.
It then uses {helpb summarize} to summarize the values of the serum cholesterol measurements,
and {helpb tabulate} to tabulate the units in which these values are measured.

{p 8 12 2}{cmd:. cprd_test using ./nonLookups/test.txt, clear dofile(myxyzlookups.do)}{p_end}
{p 8 12 2}{cmd:. keep if enttype==163}{p_end}
{p 8 12 2}{cmd:. describe, full}{p_end}
{p 8 12 2}{cmd:. cprdent_163, dofile(myxyzlookups.do)}{p_end}
{p 8 12 2}{cmd:. summarize value, de format}{p_end}
{p 8 12 2}{cmd:. tabulate unitofmeasure, miss}{p_end}

{pstd}
Note that a {cmd:cprdentutil} module such as {cmd:cprdent_163} should only be used
in a dataset of observations with the correct entity type,
as specified by the variable {cmd:enttype}.


{title:Saved results}

{pstd}
The modules of {cmd:cprdentutil} all save the following results in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(datavars)}}list of input text data variables used{p_end}
{synopt:{cmd:r(newvars)}}list of generated output variables{p_end}
{p2colreset}{...}


{title:Author}

{pstd}
Roger Newson, Imperial College London, UK.{break}
Email: {browse "mailto:r.newson@imperial.ac.uk":r.newson@imperial.ac.uk}


{title:Also see}

{psee}
{space 2}Help:  {browse "http://www.cprd.com":Clinical Practice Research Datalink (CPRD)}{break}
{helpb cprdutil} if installed
{p_end}
