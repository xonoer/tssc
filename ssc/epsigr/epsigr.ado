pr de epsigr* Saves graph as epsi-file.*! 0.1 HS, Nov 24, 2000version 6.0syntax [varlist(default=none)] [using] [aw fw iw] [if] [in] /**/ [, SAving(string) GPHopt(string) *]qui {if "`saving'" ~= "" {  tokenize "`saving'", parse(",")  local savfile `1'  local replace `3'  if index("`savfile'", ".eps") == 0 {    local savfile = "`savfile'.eps"  }  if "`replace'" ~= "replace" {    confirm new file `savfile'  }  tempfile gphfile psfile  if "`varlist'" ~= "" {    gr `varlist' `weight' `if' `in', `options' saving(`gphfile')  }  else {    if "`using'" == "" {      gr, saving(`gphfile')    }    else {      gr `using', `options' saving(`gphfile')    }  }  gphpen -dps `gphopt' `gphfile' -o`psfile'  !ps2epsi `psfile' `savfile'  }else {  if "`varlist'" ~= "" {    gr `varlist' `weight' `if' `in', `options'  }  else {    if "`using'" == "" {      gr    }    else {      gr `using', `options'    }  }}}end