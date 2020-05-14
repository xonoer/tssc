*! 1.0.0 NJC 28 Oct 1998 after Stata Support Disk November 1990program define t2way5        version 5.0        local options "GRaph Summari(string) GEN(string) PSize(string)"        local options "`options' Quietly *"        local varlist "req ex min(2) max(2)"        local if "opt"        local in "opt"        parse "`*'"        parse "`varlist'", parse(" ")        if "`summari'" == "" {                di in r "invalid syntax"                exit 198        }        if "`psize'" == "" { local psize 100 }        local psize = `psize' * 6        if "`quietly'" == "" { local qd "di" }        else local qd "*"        tempvar med cfit citem rfit ritem gfit res radj cadj lfit        tempvar cmed rmed replace sr pres        qui {                preserve                if "`if'`in'" != "" { keep `if' `in' }                drop if `1' == . | `2' == . | `summari' == .                sort `2' `1' `summari'                by `2' `1' : gen `med' = /*                 */ (`summari'[(_N+1)/2] + `summari'[1+_N/2])/2                by `2' `1' : keep if _n == 1                replace `summari' = `med'                keep `summari' `2' `1'                sort `2' `summari'                count if `2' != `2'[_n-1]                local COLS = _result(1)                by `2' : gen `cfit' = /*                 */ (`summari'[(_N+1)/2] + `summari'[1+_N/2])/2                by `2': gen byte `citem' = _n != 1                sort `1' `summari'                count if `1' != `1'[_n-1]                local ROWS = _result(1)                by `1': gen `rfit' = `summari'[(_N+1)/2]                by `1': gen byte `ritem' = _n != 1                sort `summari'                gen `gfit' = `summari'[(_N+1)/2]                replace `rfit' = `rfit' - `gfit'                gen `res' = .                gen `radj' = .                gen `cadj' = .                gen `lfit' = .                while (`lfit' != `cfit' + `rfit') {                        replace `lfit' = `cfit' + `rfit'                        replace `res' = `summari' - (`cfit' + `rfit')                        sort `2' `res'                        by `2': replace `cadj' = `res'[(_N+1)/2]                        replace `cfit' = `cfit' + `cadj'                        replace `res' = `summari' - (`cfit' + `rfit')                        sort `1' `res'                        by `1': replace `radj' = `res'[(_N+1)/2]                        replace `rfit' = `rfit' + `radj'                }                sort `citem' `cfit'                by `citem' : gen `cmed' = `cfit'[(_N+1)/2]                replace `cfit' = `cfit' - `cmed'[_N]                gen `replace' = `cmed'[_N]                sort `ritem' `rfit'                by `ritem' : gen `rmed' = `rfit'[(_N+1)/2]                replace `rfit' = `rfit' - `rmed'[_N]                replace `gfit' = `gfit' + `rmed'[_N]                format `rfit' `gfit' `cfit' %7.0g        }        local fmt : format `summari'        `qd' _n in g "Grand effect: " in y `fmt' `gfit'[1]        `qd'        `qd' in g "Row       Label         Effect"        `qd' in g "------------------------------"        sort `ritem' `1'        local i = 1        while `i' <= `ROWS' {                local rval = `1'[`i']                local lbl : value label `1'                if "`lbl'" != "" { local rval : label `lbl' `rval' }                `qd' in g `i' _col(11) "`rval'" /*                 */ in y _col(21) `fmt' `rfit'[`i']                local val = `rfit'[`i']                if `i' <= 20 { local rlab "`rlab',`val'" }                local i = `i' + 1        }        `qd'        `qd' in g "Col       Label         Effect"        `qd' in g "------------------------------"        sort `citem' `2'        local i = 1        while `i' <= `COLS' {                local cval = `2'[`i']                local lbl : value label `2'                if "`lbl'" != "" { local cval : label `lbl' `cval' }                `qd' in g `i' _col(11) "`cval'" /*                  */ in y _col(21) `fmt' `cfit'[`i']                local val = `cfit'[`i']                if `i' <= 20 { local clab "`clab',`val'" }                local i = `i' + 1        }        label var `rfit' "Row Fit"        label var `cfit' "Column Fit"        label var `gfit' "Grand Fit"        qui if "`graph'" != "" {                replace `res' = `summari' - `lfit'                gen str1 `sr' = "+"                replace  `sr' = "o" if `res' < 0                gen `pres' = abs(`res')                summ `pres'                local sd = sqrt(_result(4))                local clab = substr("`clab'",2,.)                local rlab = substr("`rlab'",2,.)                noi graph `rfit' `cfit' [w=0.25*`sd'+abs(`res')], /*                    */ symbol([`sr']) ttick(`clab') rtick(`rlab') /*                    */ psize(`psize') xlabel ylabel `options'        }        if "`gen'" != "" {                local rname "`1'"                local cname "`2'"                parse "`gen'", parse(" ")                rename `rfit' `1'                rename `cfit' `2'                rename `gfit' `3'                sort `rname' `cname'                keep `rname' `cname' `*'                tempfile junk                qui save `junk'                restore                sort `rname' `cname'                merge `rname' `cname' using `junk'                drop _merge                exit        }end