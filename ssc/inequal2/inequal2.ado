*! This version 1/98 (amended by Ph.Van Kerm)*! version 2.1.0  9/8/94 (original by Edward Whitehouse)        * This file is -inequal.ado- by Edward Whitehouse published in* STB-23 with slight modifications by Philippe Van Kerm, FUNDP,1998.* Compared to the original -inequal.ado- : ** (1) -inequal2.ado- includes the GE(-1) measure;* (2) -inequal2.ado- computes ranks differently for the computation*     of the Gini measure with weighted data;* (3) -inequal2.ado- accepts aweights.* (4) -inequal2.ado- sets global macros.pr def inequal2  version 5.0  set more 1  local varlist "req ex max(1)"  local if "opt"  local in "opt"  local weight "fweight aweight"  parse "`*'"  di in green "inequality measures of " in yellow "`varlist'"  di in green _d(78) "-"  quietly {     preserve    tempvar touse i tmptmp temp    mark `touse' `if' `in' [`weight'`exp']    markout `touse' `varlist'     keep if `touse'==1    su `varlist' [`weight'`exp']    local mn = _result(3)    local tot = _result(2)    local vari = _result(4)    sort `varlist'    local wt : word 2 of `exp'    if "`wt'"=="" {gen `i' = _n                   local wt = 1}    else {  gen `tmptmp' = sum(`wt')	    gen `i' = ((2*`tmptmp')-`wt'+1)/2 }* relative mean deviation    gen `temp' = sum(`wt'*abs(`varlist'-`mn'))     local rmd = `temp'[_N]/(2*`mn'*`tot')* coefficient of variation    local cov = `vari'^0.5/`mn'* standard deviation of logs    replace `temp' = log(`varlist')    su `temp' [`weight'`exp']    local sdl = (_result(4))^0.5* gini    replace `temp' = sum(`wt'*`i'*(`varlist'-`mn'))    local gini = (2*`temp'[_N])/(`tot'^2*`mn')* mehran     replace `temp' = sum(`wt'*`i'*(2*`tot'+1 -`i')*(`varlist' - `mn'))    local mehran = (3*`temp'[_N])/(`tot'^3*`mn')* piesch    replace `temp' = sum(`wt'*`i'*(`i'-1)*(`varlist'-`mn'))    local piesch = 3*`temp'[_N]/(2*`tot'^3*`mn')* kakwani    replace `temp' = sum(`wt'*((`varlist'^2+`mn'^2)^0.5))    local kakwani = (1/(2-2^0.5))*((`temp'[_N]/(`tot'*`mn')-2^0.5))* theil     replace `temp' = sum(`wt'*((`varlist'/`mn')*(log(`varlist'/`mn'))))    local theil = `temp'[_N]/`tot'* mean log deviation    replace `temp' = sum(`wt'*(log(`mn'/`varlist')))    local mld = `temp'[_N]/`tot'* GE -1    replace `temp' = sum(`wt'*(`mn'/`varlist'))    local ge_1 = ((`temp'[_N]/`tot')-1)/2    }    di in green "relative mean deviation " _col(40) in yellow `rmd'    di in green "coefficient of variation" _col(40) in yellow `cov'    di in green "standard deviation of logs" _col(40) in yellow `sdl'    di in green "Gini coefficient" _col(40) in yellow `gini'    di in green "Mehran measure" _col(40) in yellow `mehran'    di in green "Piesch measure" _col(40) in yellow `piesch'    di in green "Kakwani measure" _col(40) in yellow `kakwani'    di in green "Theil entropy measure" _col(40) in yellow `theil'    di in green "Theil mean log deviation measure" _col(40) in yellow `mld'    di in green "Entropy measure GE -1" _col(40) in yellow `ge_1'    di in green _d(78) "-"    global S_1 = `rmd'    global S_2 = `cov'    global S_3 = `sdl'    global S_4 = `gini'    global S_5 = `mehran'    global S_6 = `piesch'    global S_7 = `kakwani'    global S_8 = `theil'    global S_9 = `mld'    global S_10 = `ge_1'	    restoreend