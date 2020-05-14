/*     levene: Levene's test is used to test the null hypothesis that multiple                 population variances (corresponding to multiple samples) are equal.     Version 1.2     By: Herv� CACI (hcaci@wanadoo.fr)     History: Version 1.0 (October 17, 1998) = original release              Version 1.1 (October 29, 1998) = fixed an output minor bug              Version 1.2 (April 30, 2004) = fixed a major bug*/program define leveneversion 5.0/* Parse standard Stata commands */local varlist "required existing max(1)"local if "optional"local in "optional"local options "by(string)"parse "`*'"parse "`varlist'", parse(" ")/* If/in implementation */tempvar tousemark `touse' `if' `in'markout `touse' `1'/* Compute the absolute deviations for each group */quietly egen means=mean(`1') if `touse', by(`by')quietly gen dev=abs(`1' - means) if `touse'/* Compute the ANOVA Statistics */quietly oneway dev `by' if `touse'/* Output results */di in gr _n _col(16) "Analysis of Variance"di in gr _col(5)"Source" _col(25)"SS" _col(36)"df" _col(44)"MS"di in gr _dup(50) "-"di in gr "Between groups" _col(21) _result(2) /**/ _col(35) _result(3) /**/ _col(41) _result(2)/_result(3)di in gr " Within groups" _col(21) _result(4) /**/ _col(35) _result(5) /**/ _col(41) _result(4)/_result(5)di in gr _dup(50) "-"di in gr "    Total" _col(21) _result(2)+_result(4) /**/ _col(35) _result(3)+_result(5)di in gr _n "Levene's T-test for equal variances: T= " %3.2f _result(6) /**/ "  Prob > T = " %5.4f fprob(_result(3), _result(5), _result(6))quietly drop means devend