*! version 2.0.1 JMGarrett 01May98/*  Program to graph predicted values for linear regression models         *//*  02/20/95  Joanne M. Garrett                                            *//*  Form:  regpred y x, from(#) to(#) inc(#) adj(cov_list) options         *//*  Options required: from(#), to(#), increment(#)                         *//*  Options allowed: class(var), poly, adjust, model, graph, nolist        *//*  Note:  X variable must be continuous (interval or ordinal)             */program define regpred  version 4.0  #delimit ;  local options "From(real 1) To(real 1) Inc(real 1) Poly(real 0)         CLass(string) Model Adjust(string) NOList GRaph T1title(string)        T2title(string) L1title(string) L2title(string) Level(real 95) *" ;  #delimit cr  local varlist "req ex min(2) max(2)"  local if "opt"  parse "`*'"  parse "`varlist'", parse(" ")  preserve  if ("`class'"~="" & `poly'~=0) {    disp in red "Polynomial terms will not work with class() option"    exit    }  capture keep `if'  local varlbly : variable label `1'  local yvar="`1'"  local varlblx : variable label `2'  local xvar="`2'"  quietly drop if `xvar'==. | `yvar'==.  if "`class'"~="" {     local clvar="`class'"     quietly drop if `clvar'==.     local varlblc: variable label `class'     }* If there are covariates, drop missing values, calculate means  parse "`adjust'", parse(" ")    local numcov=0  local i=1  while "`1'"~="" {    local equal=index("`1'","=")    if `equal'==0  {       local cov`i'="`1'"       local mcov`i'="mean"       }    if `equal'~=0  {       local cov`i'=substr("`1'",1,`equal'-1)       local mcov`i'=substr("`1'",`equal'+1,length("`1'"))       }    quietly drop if `cov`i''==.    local covlist `covlist' `cov`i''    local covdisp `covdisp' `1'    local i=`i'+1    macro shift    local numcov=`i'-1    }  local i=1  while `i'<=`numcov' {    if "`mcov`i''"=="mean" {      quietly sum `cov`i''      local mcov`i'=_result(3)      }    local i=`i'+1    }  keep `yvar' `xvar' `clvar' `covlist'* If there is a class variable, set up dummy variables and interactions  if "`class'"~="" {     quietly tab `clvar', gen(clss)     local numcat=_result(2)     local i=2     while `i'<=`numcat' {       quietly gen Xxclss`i'=`xvar' * clss`i'       local clist `clist' clss`i'       local ilist `ilist' Xxclss`i'       local i=`i'+1       }     }* If polynomial terms are requested, create them  if `poly'==2  {     gen x_sq=`xvar'^2     local polylst="x_sq"     }  if `poly'==3  {     gen x_sq=`xvar'^2     gen x_cube=`xvar'^3     local polylst="x_sq x_cube"     }  * Run regression models and test for interaction if class specified  if "`model'"~=""  {     reg `yvar' `xvar' `polylst' `covlist' `clist' `ilist'     more     }  if "`model'"==""  {     quietly reg `yvar' `xvar' `polylst' `covlist' `clist' `ilist'     }  local newn=_result(1)  if "`class'"~="" {    quietly test `ilist'    local df1=_result(3)    local df2=_result(5)    local f=_result(6)    local probf=fprob(`df1', `df2', `f')    }* If there is a class variable, retain values for later  if "`class'"~="" {     tempvar count     quietly gen `count'=1     sort `clvar'     collapse `count', by(`clvar')     local class1=`clvar'     local i=2       while `i'<=`numcat' {         local class`i'=`clvar'[_n+`i'-1]         local i=`i'+1         }     }* Generate the values of x to calculate the predicted values  drop _all  local i=`from'  while `i'<`to'  {    local i=`i'+`inc'    }  if `i'>`to'  {    local to=`i'-`inc'    }  local newobs=((`to'-`from')/`inc')+1  local newobs=round(`newobs',1)  quietly range `xvar' `from' `to' `newobs'  label var `xvar' "`varlblx'"  if `poly'==2  {     gen x_sq=`xvar'^2     }  if `poly'==3  {     gen x_sq=`xvar'^2     gen x_cube=`xvar'^3     }  local i=1  while `i'<=`numcov'  {    quietly gen `cov`i''=`mcov`i''    local i=`i'+1    }* If interaction, expand data, create dummy and interaction variables  if "`class'"~=""  {     quietly expand `numcat'     sort `xvar'     quietly by `xvar': gen `clvar'=_n     local i=1     while `i'<=`numcat'  {       quietly replace `clvar'=`class`i'' if `clvar'==`i'       local i=`i'+1       }     quietly tab `clvar', gen(clss)     local numcat=_result(2)     local i=2     while `i'<=`numcat' {       quietly gen Xxclss`i'=`xvar' * clss`i'       local clist `clist' clss`i'       local ilist `ilist' Xxclss`i'       local i=`i'+1       }      }* Calculate the predicted values and 95% confidence intervals  predict pred_y  predict se, stdp  local z=invnorm((1-`level'/100)/2)  gen lower=pred_y+`z'*se  gen upper=pred_y-`z'*se* List results  if "`class'"~="" {sort `clvar' `xvar'}  if "`nolist'"~="nolist"  {     display "  "     display in green "Predicted Values and `level'% Confidence Intervals"     display "  "     display in gr"  Outcome:" in yel "       `varlbly' -- $S_E_depv"     display in gr"  X Variable:" in yel"    `varlblx' -- `xvar'"     if "`class'"~="" {        display in gr "  Class:" in yel "         `varlblc' -- `clvar'"        display in gr "  Interaction:" in yel "   `xvar' by `clvar'"        }     if `poly'==2 | `poly'==3  {        display in gr "  Polynomials:" in yel "   `polylst'"        }     if `numcov'>0 {display in gr "  Covariates:" in yel "    `covdisp'"}     if `numcov'==0 {display in gr "  Covariates:" in yel "    (none)"}     display in gr "  Observations:" in yel "  `newn'"     if "`class'"=="" {list `xvar' pred lower upper}     if "`class'"~="" {       by `clvar': list `xvar' pred lower upper       disp "  "       #delimit ;         disp in green "  Test for interaction of" in yellow         " `xvar' * `class'" in green ":";       #delimit cr       disp "  "       disp in green "    F(`df1', `df2') =  " in yellow %6.2f `f'       if `probf'>=.0001 {         disp in green "    Prob > F   =   " in yellow %7.4f `probf'         }       if `probf'<.0001 {         disp in green "    Prob > F   <   " in yellow "0.0001"         }       }     if "`graph'"~="" {more}     }* Graph results if requested  if "`graph'"~=""  {    if "`l1title'"=="" & "`class'"~="" {       if "`varlbly'"=="" {         local l1title "Predicted Values for $S_E_depv"         }       if "`varlbly'"~="" {         local l1title "Predicted Values for `varlbly'"         }       }    if "`l1title'"=="" & "`class'"=="" {       local l1title "Predicted Values and 95% CI"       if "`l2title'"=="" {         if "`varlbly'"=="" {local l2title "for $S_E_depv" }         if "`varlbly'"~="" {local l2title "for `varlbly'" }         }       }    if "`class'"~="" & "`l2title'"=="" {       if "`varlblc'"=="" {local l2title "By Categories of `clvar'"}       if "`varlblc'"~="" {local l2title "By Categories of `varlblc'"}       }    if "`class'"=="" {      #delimit ;       graph pred_y upper lower `xvar', sort c(sss) s(Oii) l1("`l1title'")        l2("`l2title'") `options' ;      #delimit  cr      }    if "`class'"~="" {      rename pred_y _P      local clval : value label `clvar'      if "`clval'"~="" {         local i=1         while `i'<=`numcat' {           local clbl`i' " label `clval' `class`i''           local i=`i'+1           }         }      local i=2      local cval "`class1'"      while `i'<=`numcat' {        local cval "`cval' " "`class`i''"        local i=`i'+1        }      reshape groups `clvar' `cval'      reshape vars _P      reshape cons `xvar'      reshape wide      local i=1      while `i'<=`numcat' {        if "`clval'"~="" {label var _P`class`i'' "`clvar' = `clbl`i''"}           else          {label var _P`class`i'' "`clvar' = `class`i''"}        local i=`i'+1        }      #delimit ;        graph _P* `xvar', l1("`l1title'") l2("`l2title'") `options' ;      #delimit  cr      }    }end