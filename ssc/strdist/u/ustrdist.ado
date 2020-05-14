
*! version 1.2  09dec2017 Michael D Barker Felix Pöge

/*******************************************************************************
Michael Barker
mdb96@georgetown.edu

Felix Pöge
felix.poege@ip.mpg.de

ustrdist.ado file
Implements distance calculation between two strings using Stata 14's unicode
functions. Uses Levenstein distance as metric.

Thanks to Sergio Correia for his suggestions on how to improve strdist's
performance.

*******************************************************************************/

version 14

*** Check arguments and call appropriate sub-routine
program define ustrdist, rclass
    syntax anything [if] [in] , [Generate(name) MAXdist(integer -1)]

	if `maxdist' < 1 & `maxdist' != -1 {
		noi di as text "Invalid argument maxdist (`maxdist'). The Levenstein distance without limitation will be computed."
		local maxdist 0
	}
	
    gettoken first remain : anything , qed(isstring1)
    gettoken second remain : remain , qed(isstring2)
    if `"`remain'"' != "" error 103

    * Two string scalar version
    if `isstring1' & `isstring2' ustrdist0var `if' `in' , first(`"`first'"') second(`"`second'"') gen(`generate') maxdist(`maxdist')

    * One or two string variable version
    else {

        local strscalar ""

        if `isstring1' {
            local strscalar = `"`first'"'
            local first ""
        }
        else if `isstring2' {
            local strscalar = `"`second'"'
            local second ""
        }

        ustrdist12var `first' `second' `if' `in' , m(`"`strscalar'"') gen(`generate') maxdist(`maxdist')
    } 

    * Return values generated by subroutines
    return scalar d = r(d)
    return local strdist "`r(strdist)'"
end

*** One or two variable command
program define ustrdist12var , rclass
    syntax varlist(min=1 max=2 string) [if] [in] , [Match(string)] [GENerate(name) MAXdist(integer 0)] 
    tempvar touse
    mark `touse' `if' `in'

	if `maxdist' < 1 {
		local maxdist 0
	}
	
    *** Declare default and confirm newvarname 
    if `"`generate'"' == "" local generate "strdist"
    confirm new variable `generate'

    tokenize "`varlist'"
    if "`2'"=="" mata: umatalev1var("`1'" , `"`match'"' , "`generate'" , "`touse'", `maxdist')
    else         mata: umatalev2var("`1'" ,  "`2'"      , "`generate'" , "`touse'", `maxdist')
    
    return local strdist "`generate'"
end

*** Two string scalar command
program define ustrdist0var, rclass
    syntax [if] [in] , [first(string) second(string) Generate(name) MAXdist(integer 0)]
    marksample touse

	if `maxdist' < 1 {
		local maxdist 0
	}
	
    tempname dist
    mata: st_numscalar("`dist'" , ufastlev(`"`first'"' , `"`second'"', `maxdist'))

    if `"`generate'"' != "" {
        confirm new variable `generate' 
        generate int `generate' = `dist' if `touse'
        return local strdist "`generate'"
    }
    
    display as result `dist'
    return scalar d = `dist'

end

mata:
/******************************************************************************
   Terminology Note
   key: string to measure each observation against
   trymatch: one of many potential matches to be measured against the key
   TRIES: Nx1 vector of all "trymatch"s
******************************************************************************/

void umatalev1var(string scalar varname, string scalar key, 
                  string scalar newvar , string scalar touse, | real scalar maxdist) {

    string colvector TRIES
    real colvector dist
    numeric t
	
	if (args()<5 | maxdist < 1) maxdist = 0
    
    TRIES = st_sdata(. , varname , touse) // Nx1 string vector with potential matches 
    dist = J(rows(TRIES),1,.)             // Nx1 real vector to hold lev distances to each match

    for (t = 1; t <= rows(TRIES); t++) { 
        dist[t] = ufastlev(key, TRIES[t,1], maxdist) // save distance
    } 
    st_store(., st_addvar("int", newvar), touse, dist)
}

void umatalev2var(string scalar var1   , string scalar var2, 
                  string scalar newvar , string scalar touse, | real scalar maxdist) {

    string colvector TRIES
    string colvector KEYS
    real colvector dist
    numeric t
	
	if (args()<5 | maxdist < 1) maxdist = 0
                  
    KEYS  = st_sdata(., var1, touse) 
    TRIES = st_sdata(., var2, touse) // Nx1 string vector with potential matches 
    dist = J(rows(TRIES), 1, .)      // Nx1 real vector to hold lev distances to each match
    
    for (t = 1; t <= rows(TRIES); t++) {
        dist[t] = ufastlev(KEYS[t, 1], TRIES[t, 1], maxdist)
    } 
    st_store(., st_addvar("int", newvar), touse, dist)
}

real scalar ufastlev(string scalar a, string scalar b, | real scalar maxdist)
{
    real scalar len_a, len_b, i, j, cost
    real vector v0, v1, chars_a, chars_b
	   
	if (args()<3 | maxdist < 1) maxdist = . // Ensure that maxdist is positive or missing
    
	if (a==b) return(0) // Shortcut if strings are the same   
	len_a = ustrlen(a)
    len_b = ustrlen(b)
    if (maxdist < . & abs(len_a - len_b) > maxdist) return(.) // Shortcut if we know we will exceed maxdist
    if (len_a==0 | len_b==0) return(len_a + len_b) // Shortcut if one is empty

    // Code based on:
    // https://en.wikipedia.org/wiki/Levenshtein_distance#Iterative_with_two_matrix_rows
    
    v0 = 0::len_b
    v1 = J(len_b+1, 1, .)
    
	// The usual algorithm in strdist (next two lines) does not give correct
	// results for unicode strings
	// chars_a = ascii(a)
    // chars_b = ascii(b)

	// Adjustment for unicode characters
	// ascii() returns a list of bytes for unicode characters.
	// The code below maps this list of bytes to a single integer. Ideally,
	// there would be a function like ascii() which does this mapping, but I
	// do not know of any. The mapping does not give back the proper unicode
	// value, but at least it is bijective.
	chars_a = J(len_a, 1, .)
	for (i=1; i<=len_a; i++) {
		c = ascii(usubstr(a, i, 1))
		if (length(c) == 1) {
			chars_a[i] = c[1]
		}
		else if (length(c) == 2) {
			chars_a[i] = c[1]*256 + c[2]
		}
		else if (length(c) == 3) {
			chars_a[i] = c[1]*65536 + c[2]*256 + c[3]
		}
		else if (length(c) == 4) {
			chars_a[i] = c[1]*16777216 + c[2]*65536 + c[3]*256 + c[4]
		}
		else {
			printf("Unicode should have 1-4 byte groups, but there are %f. Please contact the authors.\n", length(c))
		}
	}
	
	chars_b = J(len_b, 1, .)
	for (i=1; i<=len_b; i++) {
		c = ascii(usubstr(b, i, 1))
		if (length(c) == 1) {
			chars_b[i] = c
		}
		else if (length(c) == 2) {
			chars_b[i] = c[1]*256 + c[2]
		}
		else if (length(c) == 3) {
			chars_b[i] = c[1]*65536 + c[2]*256 + c[3]
		}
		else if (length(c) == 4) {
			chars_b[i] = c[1]*16777216 + c[2]*65536 + c[3]*256 + c[4]
		}
		else {
			printf("Unicode should have 1-4 byte groups, but there are %f. Please contact the authors.\n", length(c))
		}
	}

	// Algorithm with stopping condition
	if (maxdist < .) {
		for (i=1; i<=len_a; i++) {
			v1[1] = i
			for (j=1; j<=len_b; j++) {
				cost = chars_a[i] != chars_b[j]
				v1[j + 1] = minmax(( v1[j] + 1, v0[j+1] + 1, v0[j] + cost ))[1]
			}
			swap(v0, v1)
			// If the minimum necessary edit distance is exceeded, stop
			if (minmax(v0)[1] > maxdist) return(.)
		}
		// Final check: Is the edit distance really not exceeded?
		if (v0[len_b+1] > maxdist) return(.)
		return(v0[len_b+1])
	}
	// Algorithm without stopping condition
	else {
		for (i=1; i<=len_a; i++) {
			v1[1] = i
			for (j=1; j<=len_b; j++) {
				cost = chars_a[i] != chars_b[j]
				v1[j + 1] = minmax(( v1[j] + 1, v0[j+1] + 1, v0[j] + cost ))[1]
			}
			swap(v0, v1)
		}
		return(v0[len_b+1])
	}
}

end

