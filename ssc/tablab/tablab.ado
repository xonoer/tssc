program def tablab*! NJC 1.0.0 8 Jan 1998    version 5.0    local varlist "req ex max(1)"    local if "opt"    local in "opt"    local options "*"    parse "`*'"    tempvar nolabel    qui gen `nolabel' = `varlist'    label var `nolabel' "`varlist' without labels"    tab `varlist' `nolabel' `if' `in', `options'end