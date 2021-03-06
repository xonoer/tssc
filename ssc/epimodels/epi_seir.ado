program define epi_seir, rclass
	
    version 16.0

	syntax , [beta(real 0.00) gamma(real 0.00) sigma(real 0.00) ///
	          mu(real 0.00) nu(real 0.00) ///
	         susceptible(real 0.00) exposed(real 0.00) ///
			  infected(real 0.00) recovered(real 0.00) ///
			 days(real 30) day0(string) percent nograph colormodel clear ///
			 newframe(string) *]

	local datefmt "%dCY-N-D"
	
	if (`"`colormodel'"'!="") local lc `"color(blue orange red green)"'
	
	local modeltitle = "SEIR Model"
	local totpop = `susceptible' + `exposed' + `infected' + `recovered'
	epimodels_util check_total_population `totpop'
	epimodels_util check_day0_date `day0'
	epimodels_util check_days `days'
	
	local iterations= /*100* */ `days'
	tempname M		 
	mata epimodels_seir("`M'")
	
	local mcolnames "t S E I R"
	local varlabels "Time Susceptible Exposed Infected Recovered"
	
	local indexi = strpos(strupper(subinstr(`"`mcolnames'"', " ", "", .)),"I")

	// todo: if {opt nodata} has been specified, do not put data to any dataset
	// todo: if frame name has been specified, put the data into that frame
	// todo: potentially calculate fully (with step 0.01), but report only the integer nodes.
	// todo: expose the step
	
	if (`"`percent'"'=="percent") {
	  tempname Z
	  matrix `Z' = `M'[1..`=rowsof(`M')',2..5] * 100 / `totpop'
	  matrix `M' = `M'[1..`=rowsof(`M')',1] , `Z'
	  local ylabel="% of population"
	  local mcolnames = `"`=strlower("`mcolnames'")'"'
	  local digits=2
	  local tc=""
	}
	else {
	  local ylabel="Population"
	  local digits=0
	  local tc="c"
	  local yf = "ylabel(,format(%20.4gc))"
	}

	matrix colnames `M' = `mcolnames'
		  
	`clear'
	quietly svmat double `M', names(col)
	
	label variable t "Time, days"
	label variable `:word 2 of `mcolnames'' "`:word 2 of `varlabels''"
	label variable `:word 3 of `mcolnames'' "`:word 3 of `varlabels''"
	label variable `:word 4 of `mcolnames'' "`:word 4 of `varlabels''"
	label variable `:word 5 of `mcolnames'' "`:word 5 of `varlabels''"
	
	epimodels_util makedatevar t, day0(`"`day0'"') datefmt("`datefmt'")

	return matrix seir=`M'
	
	epimodels_util ditable t, ///
	    days(`days') day0(`"`day0'"') ///
		modeltitle(`"`modeltitle'"') ///
		varlabels(`"`varlabels'"') ylabel(`"`ylabel'"') ///
        mcolnames(`"`mcolnames'"') indexi(`indexi') ///
		datefmt(`"`datefmt'"') digits(`digits') comma(`tc') `percent'		

	return scalar maxinfect=r(maxinfect)
	return scalar t_maxinfect=r(t_maxinfect)
	return scalar d_maxinfect=r(d_maxinfect)
	
	if (`"`graph'"'=="nograph") exit
	
	twoway line `:word 2 of `mcolnames'' `:word 3 of `mcolnames'' ///
	            `:word 4 of `mcolnames'' `:word 5 of `mcolnames'' t, ///
	   legend(cols(1) ring(0) pos(2) region(lwidth(none) )) ///
	   xtitle("`:variable label t'") ytitle("`ylabel'") ///
	   title("`modeltitle'") `yf' `lc' xlabel(, grid) `options'
end

// END OF FILE