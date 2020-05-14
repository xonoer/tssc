*!version 1.0.0 : 1-30-95  J. Hilbe : ver 1.2  10-23-95 * GLM: Logistic regression, binomial/bernoulli* disp=dispersion scale factor; phi=overdispersed parameter to be estimated* options: tolerance level, iteration, offset, ln offset, nolog, odds ratio,* no constant, grouped binomial, residuals, level, analytic and freq weights.program define _binom  version 4.0  local varlist "req ex"  #delimit ;  local options "`options' LTolera(real -1) ITerate(integer 0)       Offset(string) LNOffset(string) EForm LEvel(integer $S_level)       noCONStant NOLog Group RESidual DISP(real 1.0) PHI(real 1.0) t";  #delimit cr  local weight "fweight aweight"  local in "opt"  local if "opt"  parse "`*'"  parse "`varlist'",parse(" ")  qui  {    tempvar w wt mu eta m ym touse u ll dev oldev n z ofs cdisp chi scal ll0  local y "`1'"  mac shift  if "`group'" != "" {    local m = "`1'"    mac shift  }  else { local m = 1 }  count  local nobs = _result(1)  if `ltolera'<0  { local ltolera 1e-6 }  if `iterate'<=0 { local iterate 50 }  if `level'<10 | `level'>99  { local level 95 }  if "`constan'"  !=""  { local cons "nocons" }  if "`eform'"    !=""  { local eform "eform(OR)" }  if "`offset'"   !=""  { gen `ofs' = `offset' }     else { gen `ofs' = 0 }  if "`lnoffset'" !=""  { gen `ofs' = ln(`offset') }     else  {        drop `ofs'        gen `ofs' = 0     }  gen byte `touse'=1 `in' `if'  replace `touse'=0 if `y'==. | `touse'==.  if "`exp'" !="" {     gen float `wt' `exp' if `touse'     replace `wt'=. if `wt'<=0     replace `touse'=0 if `wt'==.     if ("`weight'"=="aweight")  {        sum `wt'        replace `wt' = `wt'/_result(3)     }  }  else gen float `wt' = `touse' if `touse'  qui reg `y' `*' if `touse'  mac list  local nobs=_result(1)  replace `ofs'=`ofs' if `touse'  gen `ym'=`y'/`m' if `touse'  gen `w' = 1 if `touse'  gen `ll' = 0 if `touse'  gen `ll0'= 0 if `touse'  * BINOMIAL INITIALIZATION  local i = 1  local ddev = 1  gen `z'    = 0 if `touse'  gen `dev'  = 0 if `touse'  gen `oldev'= 1 if `touse'  gen `u'    = 0 if `touse'  * MODEULE TO CALCULATE LL0  gen `scal' = 1+(`m'-1)*`phi' if `phi'!=1.0  replace `scal'=1 if `phi'==1.0  gen `mu' = `m'* (`y'+0.5)/(`m'+1) if `touse'      gen `eta' = ln(`mu'/(`m'-`mu')) if `touse'  while ((abs(`ddev')>`ltolera' & `i'<`iterate') | (`i'==0))  {    replace `u' = `m'*(`y'-`mu')/(`scal'*`disp'*`mu'*(`m'-`mu'))    replace `w'= (`scal'*`disp'*`mu'*(`m'-`mu'))/`m'    replace `z' = `eta' + `u' - `ofs'    regress `z'  [iw=`w'*`wt'], mse1 dep(`y') `cons' dof(100000)    cap drop `eta'    predict `eta'     replace `eta' = `eta' + `ofs'    replace `mu' = `m'/(1+exp(-`eta'))    replace `oldev' = `dev'    #delimit ;    replace `dev' = `m'*ln((`m'-`y')/(`m'-`mu')) if (`y'==0);    replace `dev' = `y'*ln(`y'/`mu') if (`y'==`m');    replace `dev' = `y'*ln(`y'/`mu')+(`m'-`y')*ln((`m'-`y')/(`m'-`mu')) if                      (`y'!=0 & `y'!=`m');    #delimit cr    replace `dev' = sum(`dev'*`wt')    replace `dev' = 2 * `dev'[_N]/(`scal'*`disp')    replace `ll0'  = `y'*ln(`mu'/`m')+(`m'-`y')*ln(1-(`mu'/`m'))    replace `ll0'  = sum(`ll0'*`wt')    replace `ll0'  = `ll0'[_N]    local ddev = `dev' - `oldev'    local i = `i' + 1}* MAIN MODULE  replace `scal' = 1+(`m'-1)*`phi' if `phi'!=1.0  replace `scal'=1 if `phi'==1.0  replace `mu' = `m'* (`y'+0.5)/(`m'+1) if `touse'      replace `eta' = ln(`mu'/(`m'-`mu')) if `touse'  local i = 1  local ddev=1  while ((abs(`ddev')>`ltolera' & `i'<`iterate') | (`i'==0))  {    replace `u' = `m'*(`y'-`mu')/(`scal'*`disp'*`mu'*(`m'-`mu'))    replace `w'= (`scal'*`disp'*`mu'*(`m'-`mu'))/`m'    replace `z' = `eta' + `u' - `ofs'    regress `z' `*' [iw=`w'*`wt'], mse1 dep(`y') `cons' dof(100000)    cap drop `eta'    predict `eta'     replace `eta' = `eta' + `ofs'    replace `mu' = `m'/(1+exp(-`eta'))    replace `oldev' = `dev'    #delimit ;    replace `dev' = `m'*ln((`m'-`y')/(`m'-`mu')) if (`y'==0);    replace `dev' = `y'*ln(`y'/`mu') if (`y'==`m');    replace `dev' = `y'*ln(`y'/`mu')+(`m'-`y')*ln((`m'-`y')/(`m'-`mu')) if                      (`y'!=0 & `y'!=`m');    #delimit cr    replace `dev' = sum(`dev'*`wt')    replace `dev' = 2 * `dev'[_N]/(`scal'*`disp')    replace `ll'  = `y'*ln(`mu'/`m')+(`m'-`y')*ln(1-(`mu'/`m'))    replace `ll'  = sum(`ll'*`wt')    replace `ll'  = `ll'[_N]    if "`nolog'"==""  {       noi di in gr `i' " deviance:  " in ye %9.4f `dev' in /*        */ gr " Loglikelihood:  " in ye %9.4f `ll'    }    local ddev = `dev' - `oldev'    local i = `i' + 1}local pdev = `dev'gen `chi' = (`y'-`mu')^2 / (`scal'*`mu'*(1-`mu'/`m')) if `touse'replace `chi' = sum(`chi'*`wt')replace `chi' = `chi'[_N]local pred = _result(3)local df = `nobs'-`pred'-("`cons'"=="")if ("`weight'" == "fweight")  {   tempvar fwt   egen `fwt' = sum(`wt')   local fobs = `fwt'   local df = `fobs' - `pred'-1   if "`constan'"!=""  {      local df = `fobs - `pred'   }}local df = `nobs'-`pred'-("`cons'"=="")gen `cdisp' = `chi'/`df' if `touse'local pdisp = `cdisp'local pr2 = 1-(`ll'[_N]/`ll0'[_N])local ch2 = -2*(`ll0'[_N]-`ll'[_N])noi di in gr _n "Resid DF   = " in ye %9.0g `df' in /*   */ gr _col(55) "No obs.     = " in ye %9.0g `nobs'noi di in gr "Chi2       = " in ye %9.0g `chi' in /*   */ gr _col(55) "Deviance    = " in ye %9.0g `dev'noi di in gr "Dispersion = " in ye %9.0g `cdisp' in /*   */ gr _col(55) "Prob>chi2   = " in ye %9.0g chiprob(`df',`dev')noi di in gr _col(55) "Dispersion  = " in ye %9.0g `dev'/`df' noi di in gr "CHI2(" in ye `pred' in gr ")    = " in ye %9.0g `ch2'noi di in gr "Prob>CHI2  = " in ye %9.0g chiprob(`pred',`ch2') in /*  */ gr _col(55) "Pseudo R2   = " in ye %9.0g `pr2' _nnoi di in gr  "logistic regression: William's procedure"if "`scale'"!="c"|"`scale'"=="" { qui regress `z' `*' [iw=`w'*`wt'], mse1dof(100000) }if "`scale'"=="c" { qui regress `z' `*' [iw=`w'*`wt'/`pdisp'], mse1dof(100000) }    qui regress,  noheader `eform' level(`level') if "`t'"!="" { noi regress,  noheader `eform' level(`level') }else {tempname b Vmat `b' = get(_b)mat `V' = get(VCE)mat post `b' `V', depname(`y') obs(`nobs')noi mat mlout, level(`level') `eform'}noi di in gr "Log Likelihood = " in ye `ll'local llt = `ll'local alp = `phi'local ch2 = `chi'local dv  = `dev'global S_1 `nobs'global S_2 `llt'global S_3 `alp'global S_4 `ch2'global S_5 `df'global S_6 `pdisp'global S_7 `dv'if"`residual'"!="" {   tempvar yhat stdp Hat Presid Dresid Aresid Spear Sdev pp  gen `Dresid'=1  gen `yhat' = `mu'  gen `pp' = `yhat'/`m'  predict `stdp',stdp  gen `Hat'=(`stdp'^2 * `yhat'*(1-`pp'))  gen `Presid' = (`y'-`yhat')/sqrt(`yhat'*(1-`pp'))  replace `Dresid' = `m'*log((`m'-`y')/(`m'-`yhat')) if (`y'==0)  replace `Dresid' = `y'*log(`y'/`yhat') if (`y'==`m')  #delimit ;  replace `Dresid' = `y'*log(`y'/`yhat') + (`m'-`y') *          log((`m'-`y')/(`m'-`yhat')) if (`y'~=0 & `y'~=`m');  #delimit cr  replace `Dresid' = sqrt(2*`Dresid')  replace `Dresid' = -`Dresid' if (`y'-`yhat')<0  gen `Aresid' = (2.0533902*ibeta(2/3,2/3,(`y'/`m')))- /*   */ (2.0533902*ibeta(2/3,2/3,(`pp')))  replace `Aresid' = `Aresid'/(((`pp'*(1-`pp'))^(1/6))*sqrt((1-`Hat')/`m'))  gen `Spear' = `Presid'/sqrt(1-`Hat')  gen `Sdev'  = `Dresid'/sqrt(1-`Hat')  gen _mu = `mu'  gen _lp = `eta'  gen _Pear = `Presid'  gen _Dev  = `Dresid'  gen _Hat  = `Hat'  gen _Anscom = `Aresid'  gen _StandP = `Spear'  gen _StandD = `Sdev'  }}end