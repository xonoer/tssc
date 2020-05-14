{smcl}
{* *! version 1.0  1dec2008}{...}
{cmd:help msregress} 
{hline}

{title:Title}

{p2colset 5 19 21 2}{...}
{p2col :{hi:msregress} {hline 2}}MS-robust
regression{p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 15 2}
{cmdab:msregress}
{depvar}
[{indepvars}]
{ifin}
[{cmd:,} {it:options}]

{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}

{synopt :{opt noc:onstant}}suppress constant term{p_end}
{synopt :{opt dummies(dummies)}}is compulsury and is used to declare dummy variables{p_end}
{synopt :{opt outlier}}generate outlyingness measures{p_end}
{synopt :{opt graph}}generate the outlier identification  graphical tool{p_end}
{synopt :{opt replic}}set the number of sub-sampling to consider{p_end}


{synoptline}

{title:Description}

{pstd}
{opt msregress} fits an MS-estimator of regression of {depvar} on {varlist}. 
An MS-estimator of regression is a robust fitting approach which minimizes
a (rho) function of the regression residuals which is even, non decreasing 
for positive values and less increasing than the square function which is 
appropriate when some dummy variables are among the explanatory.
The function used here is a Tukey Biweight.


{pstd}


{title:Options}

{dlgtab:Model}

{phang}
{opt noconstant}; see
{helpb estimation options##noconstant:[R] estimation options}.


{dlgtab:Algorithm}

{phang}


{phang}
{opt dummies(dummies)}; If several dummy variables are present among the explanatory variables, the S-estimator algorithm
could fail. An MS-estimator can be used instead by declaring which are the dummy variables in the model.

{phang}
{opt graph}; Displays a graphic where outliers are flagged according to their type.
 
{phang}
{opt outlier}; Four outlyingness measures are calculated. The first (MS_stdres) contains the robust standardized residuals, 
the second (MS_outlier) flags outliers in the vertical dimension (i.e. observations associated with robust standardized 
residual larger than 2.25), the third (Robust_distance) contains robust distances and the fourth (MCD_outlier) flags outliers in the 
horizontal dimension (i.e. observations associated with robust distances larger than the 97.5th percentile of a Chi-quared).

{phang}
{opt replic}; The number of subsets associated to the underlying algorithm is set by default using the formula
replic=log(1-0.99)/log(1-(1-0.2)^({it:p}+1)) where {it:p} is the number of explanatory variables. This can be changed using the replic option.

{pstd}

{title:Saved results}

{pstd}
{cmd:msregress} saves the following in {cmd:e()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:e(scale)}}robust residual scale{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom{p_end}
{synoptset 15 tabbed}{...}

{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:msregress}{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse auto}{p_end}

{pstd}MS-robust regression{p_end}
{phang2}{cmd:. xi: msregress  price mpg headroom trunk weight length turn displacement gear_ratio, dummies(i.rep78 foreign)}

{pstd}Same as above, but calling the graphical tool{p_end}
{phang2}{cmd:. xi: msregress  price mpg headroom trunk weight length turn displacement gear_ratio, dummies(i.rep78 foreign) graph}


{title:References}


{pstd}Dehon, C., Gassner, M. and Verardi, V. (2008), "Beware of "Good" Outliers and Overoptimistic Conclusions", forthcoming
in the Oxford Bulletin of Economics and Statistics

{pstd}Rousseeuw, P. J. and Yohai, V. (1987), "Robust Regression by Means of S-estimators", in Robust and Nonlinear Time Series
Analysis, edited by J. Franke, W. H�rdle and D. Martin, Lecture Notes in Statistics No. 26, Springer Verlag, 
Berlin, pp. 256-272.

{pstd}Rousseeuw, P. J. and van Zomeren, B. (1990), "Unmasking Multivariate Outliers and Leverage Points", 
Journal of the American Statistical Association, 85, pp. 633-639.

{pstd}Salibian-Barrera, M. and Yohai, V. (2006). "A fast algorithm for S-regression estimates". Journal
of Computational and Graphical Statistics, 15, 414-427.

{title:Also see}

{psee}
Online:  {manhelp qreg R}, {manhelp regress R};{break}
{manhelp rreg R}, {help mmregress}, {help sregress}, {help mregress}, {help mcd}
{p_end}

