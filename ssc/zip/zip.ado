*! version 1.2.0 Jesper Sorensen 072898program define zip    version 5.0    local options "Level(integer $S_level) LOgit(string) nolog TRace nobase"    if substr("`*'",1,1)=="," | "`*'"=="" {		if "$S_E_cmd"!="zip" { error 301 } 		parse "`*'"	}    else {	local varlist "req ex"    	local if "opt"	local in "opt"    	parse "`*'"    	if "`log'"=="nolog" {        	local pre1 "qui"        	}    	else local pre1 "noi"    	parse "`varlist'", parse(" ")    	local depv "`1'"    	mac shift 1    	local indv "`*'"    	tempvar b f V  f0 mysamp   	/* constant only model */    	if "`base'" ~="nobase" {        	ml begin        	ml function zip_ll        	ml method lf        	eq poisson : `depv'         	eq logit :         	ml model `b'= poisson logit , depv(100)        	ml sample `mysamp' `if' `in'        	`pre1' ml maximize `f0' `V'    	}	 /* estimate requested model */    	ml begin    	ml function zip_ll    	ml method lf    	eq poisson : `depv' `indv'    	if "`logit'" ~= "" {        	eq logit : `logit'    	}    	else {        	eq logit : `indv'    	}    	ml model `b'= poisson logit , depv(10)    	ml sample `mysamp' `if' `in'    	`pre1' ml maximize f V, `trace'    	if "`base'" ~="nobase" {        	ml post zip, title("Zero Inflated Poisson") lf0(`f0')    	}    	else {        	ml post zip, title("Zero Inflated Poisson")     	}	global S_E_cmd "zip"    }    ml mlout zip, level(`level')end 