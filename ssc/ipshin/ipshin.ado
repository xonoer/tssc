*! version 1.0.10    20070611     C F Baum / Fabian Bornhorst
*  Kyung So In, M. Hashem Pesaran, Yongcheol Shin, Dept Applied Economics
*  Cambridge DP Dec 1997
*  1.0.1 1731 add demeaning option as default, N eval of psi
*  1.0.2 2706 correct handling of lags in regression
*  1.0.3 3408 change, per Liang suggestion re levinlin, to signed pval
*  1.0.4 3C23 change notation to match J.Metrics paper
*  1.0.5 4B19 add clarification for lags>8
*  1.0.6 5201 correction to prev fix 
*  1.0.7 5316 use of macro list requires v8
*  1.0.8 5422 correct ambiguity with scalar tst
*  1.0.9 6523 corr due to Piotr Lewandowski: must index through lags array from 1
*  1.0.10 7611 promote _getIPS to version 8.2, correct ref to lags when numlist provided

program define ipshin, rclass
	version 8.2
	syntax varname(ts) [if] [in] , Lags(numlist int >=0) [ Trend noDemean ]  
*
	qui tsset
	local id `r(panelvar)'
	local time `r(timevar)'
 	tempname Vals 
 	tempvar vvar
    local case 2
    local text "constant"
    if  "`trend'" != "" { 
        	local case 3
        	local text "constant & trend"
        	}
   	marksample touse
	markout `touse' `time'
	tsreport if `touse', report panel
	if r(N_gaps) {
		di in red "sample may not contain gaps"
		error 198
	}
	qui xtsum `time' if `touse'
	local N `r(n)'
	local T `r(Tbar)'
	if int(`T')*`N' ~= r(N) {
		di in red "panel must be balanced"
		error 198
		}
	local tmin `r(min)'
	local tmax `r(max)'
* 2706 cfb relocate following so that demeaned variable is used in lags
*
* copy variable to prevent alteration and allow ts ops
	qui gen double `vvar' = `varlist' if `touse'
	if "`trend'" ~= "" {
		local trend "`time'"
		}
	if "`demean'" == "" {
		local dm "cross-sectionally demeaned "
		forv t = `tmin'/`tmax' {
			qui { 
				su `vvar' if `time' == `t' & `touse'
				replace `vvar' = `vvar' - r(mean) if `time' == `t' & `touse'
				}
			}
		}

	local npi : word count `lags'
	local slags : list sort lags
	local maxlag : word `npi' of `slags'
* di in r "npi `npi' maxlag `maxlag'"		
* di in r "slags `slags'"
	local p 
	if `npi' == 1 {
		forv i=1/`N' {
			local ps`i' = `lags'
			local p "`p' `lags'"
			if `lags' > 0 {
* VVAR NOT VARLIST
*				local tps`i' "L(1/`lags')D.`varlist'"
				local tps`i' "L(1/`lags')D.`vvar'"
				}
			}
		scalar lavg = `lags'
		}
	else if `npi' ~= `N' {
		di in r "Error: For `N' panel units, either 1 or `N' lag lengths must be specified"
		error 198
		}
	else {
		scalar lavg = 0
		local p `lags'
		forv i = 1/`N' {
			local ps`i' : word `i' of `lags'
// corr: p should be the macro lags
//			local p "`p' `lags'"
			if `ps`i'' > 0 {
* VVAR NOT VARLIST
*				local tps`i' "L(1/`ps`i'')D.`varlist'"
				local tps`i' "L(1/`ps`i'')D.`vvar'"			
				scalar lavg = lavg + `ps`i''
				}
			}
			scalar lavg = lavg / `N'
		}

    di in gr _n "Im-Pesaran-Shin test for `dm'" in ye "`varlist'"  /* 
    */ _n in gr "Deterministics chosen: " in ye "`text'"

* define unit identifier
    qui tab `id' if `touse', matrow(`Vals') 
    local nvals = r(r)
    local i = 1
    while `i' <= `nvals' {
    	local val = `Vals'[`i',1]
    	local vals "`vals' `val'"
    	local i = `i' + 1
    	}
	scalar tbar = 0
	scalar nt = 0
* CORR: must index through lags from 1
	local j 0
	foreach i of local vals {
    	qui {
    		local ++j 
* noi di in r "`id' `i'  `tps`j''" 
* IPS eqn 4.2
    		reg D.`vvar' L.`vvar' `tps`j'' `trend' if `id' == `i' & `touse' 
    		mat b = e(b)
    		mat v = e(V)
    		scalar nt = nt + e(N)
    		scalar _tst = b[1,1]/sqrt(v[1,1])
*    		di in r "`i'  tstat " _tst
    		scalar tbar = tbar + _tst
    		}
	}

	_getIPS, case(`case') n(`N')  t(`T') lags(`p')
*
	scalar tbar = tbar/`N'
	scalar psi = sqrt(`N') * (tbar - r(muadj))/sqrt(r(sigadj))
* 3408 calc as one-tailed test 	scalar pval = 1-norm(abs(psi))
	scalar pval = norm(psi)
    noi di in gr _n "t-bar test, N,T = (`N',`T')" /*
    */ _col(35) "Obs = " nt _col(48) _n "Augmented by " lavg " lags (average) " 
    if (`maxlag' > 8) { 
    	noi di in r "IPS tables not applicable to lag > 8: W[t-bar] not reliable" 
    	}
    noi di in gr _n "    t-bar" _col(15) "cv10"  _col(25) "cv5"  _col(35) "cv1" /* 
    */ _col(41) "W[t-bar]" _col(53) "P-value"
    noi di in ye %9.3f tbar _col(10) %9.3f r(cv10) _col(20) %9.3f r(cv5) _col(30) /*
	*/ %9.3f r(cv1) _col(39) %9.3f psi _col(49) %9.3f pval 
	return local depvar `varlist'
	return scalar nobs=e(N)
	return scalar N=`N'
	return scalar T=`T'
	return scalar tbar=tbar
	return scalar cv10=r(cv10)
	return scalar cv5=r(cv5)
	return scalar cv1=r(cv1)
	return scalar wtbar=psi
	return scalar pval=pval
	return local lags `lags'
	return local determ `text'
	end		

program define _getIPS, rclass
	version 8.2
    syntax , Case(string) N(string) T(string) Lags(numlist int >=0)
*           di in r "args `case' `n' `t' | `lags' |"  

    tempname en te msda1 msda5 msda10 mu sig smu ssig
    local capt `t'
    local capn `n'
	scalar `smu' = 0
	scalar `ssig' = 0 
* IPS Table 2, mean and std dev of tbar stat
	mat `en' = ( 5,7,10,15,20,25,50,100, 999)
	mat `te' = ( 5,10,15,20,25,30,40,50,60,70,100,999)
	if `case' == 2 {
    	mat `msda1' = (-3.79, -2.66, -2.54, -2.50, -2.46, -2.44, -2.43, -2.42, -2.42, -2.40, -2.40, -2.40 \ /*
    	*/ -3.45, -2.47, -2.38, -2.33, -2.32, -2.31, -2.29, -2.28, -2.28, -2.28, -2.27, -2.27 \ /*
    	*/ -3.06, -2.32, -2.24, -2.21, -2.19, -2.18, -2.16, -2.16, -2.16, -2.16, -2.15, -2.15 \ /*
    	*/ -2.79, -2.14, -2.10, -2.08, -2.07, -2.05, -2.04, -2.05, -2.04, -2.04, -2.04, -2.04 \ /*
    	*/ -2.61, -2.06, -2.02, -2.00, -1.99, -1.99, -1.98, -1.98, -1.98, -1.97, -1.97, -1.97 \ /*
    	*/ -2.51, -2.01, -1.97, -1.95, -1.94, -1.94, -1.93, -1.93, -1.93, -1.93, -1.92, -1.92 \ /*
    	*/ -2.20, -1.85, -1.83, -1.82, -1.82, -1.82, -1.81, -1.81, -1.81, -1.81, -1.81, -1.81 \ /*
    	*/ -2.00, -1.75, -1.74, -1.73, -1.73, -1.73, -1.73, -1.73, -1.73, -1.73, -1.73, -1.73 )
    	mat `msda5' = (-2.76, -2.28, -2.21, -2.19, -2.18, -2.16, -2.16, -2.15, -2.16, -2.15, -2.15, -2.15 \ /*
    	*/ -2.57, -2.17, -2.11, -2.09, -2.08, -2.07, -2.07, -2.06, -2.06, -2.06, -2.05, -2.05 \ /*
    	*/ -2.42, -2.06, -2.02, -1.99, -1.99, -1.99, -1.98, -1.98, -1.97, -1.98, -1.97, -1.97 \ /*
    	*/ -2.28, -1.95, -1.92, -1.91, -1.90, -1.90, -1.90, -1.89, -1.89, -1.89, -1.89, -1.89 \ /*
    	*/ -2.18, -1.89, -1.87, -1.86, -1.85, -1.85, -1.85, -1.85, -1.84, -1.84, -1.84, -1.84 \ /*
    	*/ -2.11, -1.85, -1.83, -1.82, -1.82, -1.82, -1.81, -1.81, -1.81, -1.81, -1.81, -1.81 \ /*
    	*/ -1.95, -1.75, -1.74, -1.73, -1.73, -1.73, -1.73, -1.73, -1.73, -1.73, -1.73, -1.73 \ /*
    	*/ -1.84, -1.68, -1.67, -1.67, -1.67, -1.67, -1.67, -1.67, -1.67, -1.67, -1.67, -1.67 )
    	mat `msda10' = (-2.38, -2.10, -2.06, -2.04, -2.04, -2.02, -2.02, -2.02, -2.02, -2.02, -2.01, -2.01 \ /*
    	*/ -2.27, -2.01, -1.98, -1.96, -1.95, -1.95, -1.95, -1.95, -1.94, -1.95, -1.94, -1.94 \ /*
    	*/ -2.17, -1.93, -1.90, -1.89, -1.88, -1.88, -1.88, -1.88, -1.88, -1.88, -1.88, -1.88 \ /*
    	*/ -2.06, -1.85, -1.83, -1.82, -1.82, -1.82, -1.81, -1.81, -1.81, -1.81, -1.81, -1.81 \ /*
    	*/ -2.00, -1.80, -1.79, -1.78, -1.78, -1.78, -1.78, -1.78, -1.78, -1.77, -1.77, -1.77 \ /*
    	*/ -1.96, -1.77, -1.76, -1.75, -1.75, -1.75, -1.75, -1.75, -1.75, -1.75, -1.75, -1.75 \ /*
    	*/ -1.85, -1.70, -1.69, -1.69, -1.69, -1.69, -1.68, -1.68, -1.68, -1.68, -1.69, -1.69 \ /*
    	*/ -1.77, -1.64, -1.64, -1.64, -1.64, -1.64, -1.64, -1.64, -1.64, -1.64, -1.64, -1.64 )
* pad mu, sig with last row for larger T
    	mat `mu' = (-1.558, 0, 0, 0, 0, 0, 0, 0, 0\-1.504, -1.488, -1.319, -1.306, -1.171, 0, 0, 0, 0\ /*
    	*/ -1.514, -1.503, -1.387, -1.366, -1.260, -1.239, 0, 0, 0\-1.522, -1.516, -1.428, -1.413, -1.329, -1.313, -1.238, 0, 0\ /*
    	*/ -1.520, -1.514, -1.443, -1.433, -1.363, -1.351, -1.289, -1.273, -1.212\-1.526, -1.519, -1.460, -1.453, -1.394, -1.384, -1.331, -1.319, -1.266\ /*
    	*/ -1.523, -1.520, -1.476, -1.471, -1.428, -1.421, -1.380, -1.371, -1.329\-1.527, -1.524, -1.493, -1.489, -1.454, -1.451, -1.418, -1.411, -1.377\ /*
    	*/ -1.519, -1.519, -1.490, -1.486, -1.458, -1.454, -1.427, -1.423, -1.393\-1.524, -1.522, -1.498, -1.495, -1.470, -1.467, -1.444, -1.441, -1.415\ /*
    	*/ -1.532, -1.530, -1.514, -1.512, -1.495, -1.494, -1.476, -1.474, -1.456\-1.532, -1.530, -1.514, -1.512, -1.495, -1.494, -1.476, -1.474, -1.456)
    	mat `sig' =  (2.648, 0, 0, 0, 0, 0, 0, 0, 0\1.069, 1.255, 1.421, 1.759, 2.080, 0, 0, 0, 0\ /*
    	*/ 0.923, 1.011, 1.078, 1.181, 1.279, 1.420, 0, 0, 0\0.851, 0.915, 0.969, 1.037, 1.097, 1.171, 1.237, 0, 0\ /*
    	*/ 0.809, 0.861, 0.905, 0.952, 1.005, 1.055, 1.114, 1.164, 1.217\0.789, 0.831, 0.865, 0.907, 0.946, 0.980, 1.023, 1.062, 1.105\ /*
    	*/ 0.770, 0.803, 0.830, 0.858, 0.886, 0.912, 0.942, 0.968, 0.996\0.760, 0.781, 0.798, 0.819, 0.842, 0.863, 0.886, 0.910, 0.929\ /*
    	*/ 0.749, 0.770, 0.789, 0.802, 0.819, 0.839, 0.858, 0.875, 0.896\0.736, 0.753, 0.766, 0.782, 0.801, 0.814, 0.834, 0.851, 0.871\ /*
    	*/ 0.735, 0.745, 0.754, 0.761, 0.771, 0.781, 0.795, 0.806, 0.818\0.735, 0.745, 0.754, 0.761, 0.771, 0.781, 0.795, 0.806, 0.818)
    	}
    if `case' == 3 {
        mat `msda1' = (-8.12, -3.42, -3.21, -3.13, -3.09, -03.05, -3.03, -3.02, -3.00, -3.00, -2.99, -2.99 \ /*
        */ -7.36, -3.20, -3.03, -2.97, -2.94, -2.93, -2.90, -2.99, -2.88, -2.87, -2.86, -2.86 \ /*
        */ -6.44, -3.03, -2.88, -2.84, -2.82, -2.79, -2.78, -2.77, -2.76, -2.75, -2.75, -2.75 \ /*
        */ -5.72, -2.86, -2.74, -2.71, -2.69, -2.68, -2.67, -2.65, -2.66, -2.65, -2.64, -2.64 \ /*
        */ -5.54, -2.75, -2.67, -2.63, -2.62, -2.61, -2.59, -2.60, -2.59, -2.58, -2.58, -2.58 \ /*
        */ -5.16, -2.69, -2.61, -2.58, -2.58, -2.56, -2.55, -2.55, -2.55, -2.54, -2.54, -2.54 \ /*
        */ -4.50, -2.53, -2.48, -2.46, -2.45, -2.45, -2.44, -2.44, -2.44, -2.44, -2.43, -2.43 \ /*
        */ -4.00, -2.42, -2.39, -2.38, -2.37, -2.37, -2.36, -2.36, -2.36, -2.36, -2.36, -2.36 )
        mat `msda5' = (-4.66, -2.98, -2.87, -2.82, -2.80, -2.79, -2.77, -2.76, -2.75, -2.75, -2.75, -2.75 \ /*
        */ -4.38, -2.85, -2.76, -2.72, -2.70, -2.69, -2.68, -2.67, -2.67, -2.66, -2.66, -2.66 \ /*
        */ -4.11, -2.74, -2.66, -2.63, -2.62, -2.60, -2.60, -2.59, -2.59, -2.58, -2.58, -2.58 \ /*
        */ -3.88, -2.63, -2.57, -2.55, -2.53, -2.53, -2.52, -2.52, -2.52, -2.51, -2.51, -2.51 \ /*
        */ -3.73, -2.56, -2.52, -2.49, -2.48, -2.48, -2.48, -2.47, -2.47, -2.46, -2.46, -2.46 \ /*
        */ -3.62, -2.52, -2.48, -2.46, -2.45, -2.45, -2.44, -2.44, -2.44, -2.44, -2.43, -2.43 \ /*
        */ -3.35, -2.42, -2.38, -2.38, -2.37, -2.37, -2.36, -2.36, -2.36, -2.36, -2.36, -2.36 \ /*
        */ -3.13, -2.34, -2.32, -2.32, -2.31, -2.31, -2.31, -2.31, -2.31, -2.31, -2.31, -2.31 )
        mat `msda10' = (-3.73, -2.77, -2.70, -2.67, -2.65, -2.64, -2.63, -2.63, -2.62, -2.63, -2.62, -2.62 \ /*
        */ -3.60, -2.68, -2.62, -2.59, -2.58, -2.57, -2.57, -2.56, -2.56, -2.55, -2.55, -2.55 \ /*
        */ -3.45, -2.59, -2.54, -2.52, -2.51, -2.51, -2.50, -2.50, -2.50, -2.49, -2.49, -2.49 \ /*
        */ -3.33, -2.52, -2.47, -2.46, -2.45, -2.45, -2.44, -2.44, -2.44, -2.44, -2.44, -2.44 \ /*
        */ -3.26, -2.47, -2.44, -2.42, -2.41, -2.41, -2.41, -2.40, -2.40, -2.40, -2.40, -2.40 \ /*
        */ -3.18, -2.44, -2.40, -2.39, -2.39, -2.38, -2.38, -2.38, -2.38, -2.38, -2.38, -2.38 \ /*
        */ -3.02, -2.36, -2.33, -2.33, -2.33, -2.32, -2.32, -2.32, -2.32, -2.32, -2.32, -2.32 \ /*
        */ -2.90, -2.30, -2.29, -2.28, -2.28, -2.28, -2.28, -2.28, -2.28, -2.28, -2.28, -2.28 )
        mat `mu' = (-2.463, 0, 0, 0, 0, 0, 0, 0, 0\-2.166, -2.173, -1.914, -1.922, -1.750, 0, 0, 0, 0 \ /*
        */ -2.167, -2.169, -1.999, -1.977, -1.823, -1.804, 0, 0, 0\-2.168, -2.172, -2.047, -2.032, -1.911, -1.888, -1.778, 0, 0 \ /*
        */ -2.167, -2.172, -2.074, -2.065, -1.968, -1.955, -1.868, -1.851, -1.761\-2.172, -2.173, -2.095, -2.091, -2.009, -1.998, -1.923, -1.912, -1.835\ /*
        */ -2.173, -2.177, -2.120, -2.117, -2.057, -2.051, -1.995, -1.986, -1.925\-2.176, -2.180, -2.137, -2.137, -2.091, -2.087, -2.042, -2.036, -1.987\ /*
        */ -2.174, -2.178, -2.143, -2.142, -2.103, -2.101, -2.065, -2.063, -2.024\-2.174, -2.176, -2.146, -2.146, -2.114, -2.111, -2.081, -2.079, -2.046\ /*
        */ -2.177, -2.179, -2.158, -2.158, -2.135, -2.135, -2.113, -2.112, -2.088\-2.177, -2.179, -2.158, -2.158, -2.135, -2.135, -2.113, -2.112, -2.088)
        mat `sig' = (13.859, 0, 0, 0, 0, 0, 0, 0, 0\1.132, 1.453, 1.627, 2.482, 3.947, 0, 0, 0, 0\ /*
        */ 0.869, 0.975, 1.036, 1.214, 1.332, 1.590, 0, 0, 0\0.763, 0.845, 0.882, 0.983, 1.052, 1.165, 1.243, 0, 0\ /*
        */ 0.713, 0.769, 0.796, 0.861, 0.913, 0.991, 1.055, 1.145, 1.208\0.690, 0.734, 0.756, 0.808, 0.845, 0.899, 0.945, 1.009, 1.063\ /*
        */ 0.655, 0.687, 0.702, 0.735, 0.759, 0.792, 0.828, 0.872, 0.902\0.633, 0.654, 0.661, 0.688, 0.705, 0.730, 0.753, 0.786, 0.808\ /*
        */ 0.621, 0.641, 0.653, 0.674, 0.685, 0.705, 0.725, 0.747, 0.766\0.610, 0.627, 0.634, 0.650, 0.662, 0.673, 0.689, 0.713, 0.728\ /*
        */ 0.597, 0.605, 0.613, 0.625, 0.629, 0.638, 0.650, 0.661, 0.670\0.597, 0.605, 0.613, 0.625, 0.629, 0.638, 0.650, 0.661, 0.670)
        }
*
	forv i = 1/`capn' {
		local pi : word `i' of `lags'
    	forv t=1/12 {
    		if `capt' <= `te'[1,`t'] {
    			forv p = 0/8 {
    				if `pi' == `p' {
 					scalar `smu' = `smu' + `mu'[`t',`p'+1]
    				 	scalar `ssig' = `ssig' + `sig'[`t',`p'+1]
	    				continue,break
    					}
    				}
    			continue,break
    			}
    		}
    	}
    return scalar muadj = `smu' / `capn'
    return scalar sigadj = `ssig' / `capn'
    forv t=1/12 {
    	if `capt' <= `te'[1,`t'] {
    		forv n = 1/9 {
    			if `capn' <= `en'[1,`n'] {
    				return scalar cv1 = `msda1'[`n',`t']
    				return scalar cv5 = `msda5'[`n',`t']
    				return scalar cv10 = `msda10'[`n',`t'] 
*    		di in r "setting cv's for `n' `t' "  `msda1'[`n',`t']  				
    				continue,break
    				}
    			}
    		continue,break
    		}
    	}
	end
