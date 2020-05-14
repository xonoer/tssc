* test -xtavplot-* version 1.0.1  3nov2019 by John Luke Gallup (jlgallup@pdx.edu)capture set trace offset tracedepth 1set more offcapture qui log using test_xtavplot, replacecd "~/Documents/econ/research/stata/ado/personal/xtavplot/"cscript "xtavplot for xtreg models fe, be & re" adofile xtavplotaboutwhich xtavplotuse nlswork, clearlocal x_av "ttl_exp"foreach m in fe be re mle pa { 	di as txt _newline "Model: `m'"	// x_av included in preceding -xtreg-	qui xtreg ln_w `x_av' age tenure not_smsa, `m'	scalar b = _b[`x_av']	capture noisily xtavplot `x_av', debug	if c(rc)==0 {		di as txt "   _b from xtreg     =  " as result %18.16f scalar(b)		di as txt "   _b from reg ey ex =  " as result %18.16f r(b_check)		di as txt "   diff in _b:  " as result %18.16f (scalar(b)-r(b_check)) 		assert reldif(scalar(b), r(b_check)) < 1e-13		}	// x_av not included in preceding -xtreg-	qui xtreg ln_w age tenure not_smsa, `m'	capture noisily xtavplot `x_av', debug	if c(rc)==0 {		di 		di as txt "   _b for x not included =  " as result %18.16f r(b_check)		di as txt "   diff in _b:  " as result %18.16f (scalar(b)-r(b_check)) 		assert reldif(scalar(b), r(b_check)) < 1e-13		}}// test for factor variables in varlist//		for included x and not included xxtreg ln_w c.age#c.age ttl_exp age tenure, fextavplot c.age#c.agextreg ln_w ttl_exp age tenure, fextavplot c.age#c.ageif (c(stata_version)<12) rcof "xtavplot c.age##c.age" == 198else rcof "xtavplot c.age##c.age" == 103rcof "xtavplot i.age" == 198// -------- test that -generate()- option works ----------local x_av "ttl_exp"foreach m in be fe re { 	di as txt _newline "Model: `m'"	// x_av included in preceding -xtreg-	qui xtreg ln_w `x_av' age tenure not_smsa, `m'	scalar b = _b[`x_av']	scalar se = _se[`x_av']	if "`m'"=="be" local dof = e(df_r)	else local dof = e(N) - e(df_m) - 1	xtavplot `x_av', gen(e_x e_y) debug nodisplay	noi di as txt "   r(b_check)        =  " as result %18.16f r(b_check)	_regress e_y e_x, nocons dof(`dof')	di as txt "   b from xtreg, `m'   =  " as result %18.16f scalar(b)	di as txt "   _b from e_y on e_x =  " as result %18.16f _b[e_x]	di as txt "   reldif = " as result %18.16f reldif(_b[e_x],scalar(b)) 	assert reldif(_b[e_x],scalar(b)) < 1e-13		di as txt "   se from xtreg, `m'   =  " as result %18.16f scalar(se)	di as txt "   _se from e_y on e_x =  " as result %18.16f _se[e_x]	di as txt "   reldif = " as result %18.16f reldif(_se[e_x],scalar(se)) 	assert reldif(_se[e_x],scalar(se)) < 1e-13		drop e_x e_y	// x_av NOT included in preceding -xtreg-	qui xtreg ln_w age tenure not_smsa, `m'	xtavplot `x_av', gen(e_x e_y) debug nodisplay	noi di as txt "   r(b_check)        =  " as result %18.16f r(b_check)	_regress e_y e_x, nocons dof(`dof')	di as txt "   b from xtreg, `m'   =  " as result %18.16f scalar(b)	di as txt "   _b from e_y on e_x =  " as result %18.16f _b[e_x]	di as txt "   reldif = " as result %18.16f reldif(_b[e_x],scalar(b)) 	assert reldif(_b[e_x],scalar(b)) < 1e-13		di as txt "   se from xtreg, `m'   =  " as result %18.16f scalar(se)	di as txt "   _se from e_y on e_x =  " as result %18.16f _se[e_x]	di as txt "   reldif = " as result %18.16f reldif(_se[e_x],scalar(se)) 	assert reldif(_se[e_x],scalar(se)) < 1e-13		drop e_x e_y}// ------ test for varname problems ------	qui xtreg ln_w age tenure not_smsa, fe	// no varname	rcof "xtavplot" == 100	// too many variables	rcof "xtavplot `x_av' age" == 103// ------ test for existence of previous estimates ------	ereturn clear	rcof "xtavplot `x_av'" == 301// ----------- test that EXCLUDED x variable is OK -----------//  "cannot include dependent variable"	qui xtreg ln_w age tenure not_smsa, fe	rcof "xtavplot ln_w" == 398//  "x has missing values"	gen miss_test = ttl_exp if _n>10000	qui xtreg ln_w age tenure not_smsa, fe	rcof "xtavplot c.miss_test#c.miss_test" == 398	drop miss_test// check for collinearity of variable x with depvar or rhs or ivar	qui xtreg ln_w age tenure not_smsa, fe	gen coll_test = ln_w*2	rcof "xtavplot coll_test" == 459	replace coll_test = tenure+1	rcof "xtavplot coll_test" == 459	replace coll_test = idcode/3	rcof "xtavplot coll_test" == 459	drop coll_test// ----------- test that INCLUDED x variable is OK -----------// check for "x was dropped from model"	gen coll_x = ttl_exp+1	qui xtreg ln_w coll_x ttl_exp age tenure not_smsa, fe	if (c(stata_version)<12) rcof "xtavplot coll_x" == 399	else rcof "xtavplot ttl_exp" == 399	drop coll_x	// ----------- test xtavplots -----------foreach m in fe be re { 	di as txt _newline "Model: `m'"	// x_av included in preceding -xtreg-	qui xtreg ln_w ttl_exp age tenure not_smsa, `m'	xtavplots}// ----------- test -addmeans- option -----------foreach m in fe be re { 	di as txt _newline "Model: `m'"	// x_av included in preceding -xtreg-	if "`m'"=="fe" local wgt "[aw=birth_yr]"	else local wgt	qui xtreg ln_w ttl_exp age tenure not_smsa `wgt', `m'	capture drop samp	gen samp = e(sample)	capture noisily xtavplot `x_av', addmeans	ret li	scalar ybar = r(ybar)	scalar xbar = r(xbar)	sum ln_w if samp `wgt'	assert reldif(r(mean),scalar(ybar)) < 1e-13		sum `x_av' if samp `wgt'	assert reldif(r(mean),scalar(xbar)) < 1e-13	}display "test_xtavplot completed successfully!"qui log closewindow manage forward results