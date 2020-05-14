*! version 1.1.0 , 22oct 98, Guy van Melle*!*! gen a matrix with obs counts (cols) on several (rows) discrete vars*! with same possible answers. Matrix will contain missing values if *! some counts are zero because matcell only reports discovered values *! (not unobserved ! sic)*!*! idea: fill data with an obs for each of the desired values*! then correct counts (-1) then drop added obs*!*! call: fulltab varlist [if] [in], vals(# [# [# ...]]]) mat(string) missing*!*! e.g. filltab rep78 rep79 if foreign==0, v(1 2 3 4 5) mat(A) miss*!      (assuming repair gradings for 1979 in auto.dta)*!*---------------prog def fulltab*---------------	loc varlist "req ex"	loc if "opt"	loc in "opt"	loc options "MISSing Vals(string) Mat(string)"	parse "`*'"	if "`vals'"=="" {		di in red "must specify values to be counted"		exit	}	if "`mat'"=="" {		di in red "must specify matrix to hold counts"		exit	}	parse "`vals'", parse (" ")	loc nval: word count `vals'	loc c 0	while `c'<`nval' {		loc c=`c'+1		loc val`c': word `c' of `vals'		confirm integer number `val`c''	}	parse "`varlist'", parse(" ")	loc nvar: word count `varlist'	tempvar touse tmp	preserve	mark `touse' `if' `in'	if "`missing'"!="" {markout `touse' `varlist'}	loc oldN=_N	loc newN=_N + `nval'	qui {		set obs `newN'		g `tmp'=(_n -`oldN')*(_n>`oldN')		replace `touse'=1 if `tmp'	}	tempname M	loc v 0	qui while `v'<`nvar' {		loc v=`v'+1		loc avar : word `v' of `varlist'		loc c 0			while `c'<`nval' {			loc c=`c'+1			replace `avar'=`val`c'' if `tmp'==`c'		}		tab `avar' if `touse', matcell(`M')		mat `M'=`M''		if `v'==1 {mat `mat'=`M'}		else      {mat `mat'=`mat' \ `M'}	}	mat `M' = J(`nvar',`nval',1)	mat `mat' = `mat' - `M'	mat rownames `mat' = `varlist'	mat li `mat'end