*! version 1.0 Z.WANG  07Nov1999 program define lrdrop1, nclass  version 6.0  syntax [, FP(str) FChi(str) ]  if "`e(cmd)'"=="" {    di in r "last estimates not found"    exit 301  }   local yvar "`e(depvar)'"  local cmd "`e(cmd)'"  if "`e(cmd)'"=="cox" {    if "`e(cmd2)'"!="" {      local cmd `e(cmd2)'      local yvar    }     else {	  di in gr "Please use stcox instead of cox in the last model."	  exit	}  }  if "`e(cmd2)'"=="streg" {    local cmd "`e(cmd2)'"    local dist dist(`e(cmd)')    local yvar  }    if "`e(offset)'"!="" {    tempvar off     gen `off'=`e(offset)'    lab var `off' "`e(offset)'"    local offset offset(`off')  }  if "`e(vcetype)'"~="" {     local robust r  }  if "`e(clustvar)'"~="" {    local cluster cluster(`e(clustvar)')  }  local ops `offset' `robust' `cluster' `dist'  tempvar smpl  qui gen `smpl'=e(sample)  mat bs=e(b)   local xnames : colnames(bs)   _xnam `xnames'  local xnames `r(alln)'  local vnum =`r(vnum)'  local factn `r(factn)'  if "`factn'"=="" {local factn 0}  qui `cmd' `yvar' `xnames' if `smpl', `ops'  local aic0=-2*e(ll)+2*(e(df_m)+`factn')  local dev0=-2*e(ll)  local rdf0=e(N)-(e(df_m)+`factn')  local mdf0=e(df_m)  * Display Table  if "`fp'"=="" {    local fp "%9.4f"   }  if "`fchi'"=="" {    local fchi "%9.2f"   }    local right=index(`"logit logistic poisson stcox probit streg regress"', `"`cmd'"')  if `right'==0 { di in b "AIC may not be correct for `cmd'"}  di in gr "Likelihood Ratio Tests: drop 1 term"    di in gr "`cmd' regression"  di in gr "number of obs = " in ye e(N)  di in gr _dup(72) "-"  di in gr %8s "`yvar'" _col(10) %6s `"Df"' _col(17) %9s  `"Chi2"'  /*    */  _col(29)  %9s `"P>Chi2"' _col(42)  %9s  `"-2*log ll "'  /*    */ 	_col(53) %6s `" Res. Df"'  _col(63) `" AIC"'  di in gr _dup(72) "-"  token `xnames'   di in gr "Original Model" in ye _col(40) `fchi' `dev0'  _col(52) /*    */ %6.0f `rdf0' _col(60) `fchi' `aic0'  local xs `xnames'  local i=1  while `i'<=`vnum'{     local i_1=`i'-1    _newx, xvar(`xs') pick(``i'')     local newx `r(newlst)'    qui `cmd' `yvar' `newx' if `smpl', `options'    local dev = -2*e(ll)    local mdf=e(df_m)       local aic=`dev'+2*(`mdf'+`factn')    local chi=`dev' - `dev0'    local df = `mdf0'-`mdf'    local p = chiprob(`df',`chi')    local rdf= `rdf0'-`df'    di in gr  %8s "-``i''" in ye %6.0f _col(10) `df' /*      */ _col(17) `fchi' `chi' _col(29) `fp'  /*      */ `p' _col(40) `fchi' `dev'  _col(52)  /*      */ %6.0f `rdf'  _col(60)  `fchi' `aic'    local i =`i'+1  } di in gr _dup(72) "-"di in gr "Terms dropped one at a time in turn."qui `cmd' `yvar' `xnames' if `smpl', `options'endprogram define _ab, rclass  token `0', parse(" _")  unab cat:`1'*  return local cname "`1'*"  token `cat'  local i=1  while "``i''"!=""{    local i=`i'+1  }  return scalar catdf=`i'-1endprogram define _xnam, rclass  while "`1'"!=""{      if substr("`1'", 1,1)!="_"{      local xlist `xlist' `1'    }      else {      local factn=`factn'+1    }    mac shift  }  token `xlist'  local i=1   while "`1'"!=""{    if substr("`1'", 1,1)=="I"{      _ab `1'      local catdf=r(catdf)      local xnam`i' `r(cname)'      mac shift `catdf'    }    else {      local xnam`i' `1'      mac shift    }    local alln `alln' `xnam`i''    local i=`i'+1  }  return local alln `alln'  return local vnum=`i'-1  return local factn `factn'end  program define _newx, rclass  syntax[, Xvar(str) Pick(str)]    token `xvar'  while "`1'"!="" {      if  "`1'"!="`pick'" {	    local newlst "`newlst' `1'"      }	  mac shift	}  return local newlst `newlst'end