program define dashlnversion 5.0*! ver 2.1.1 by Michael Blasnik* graphs a single dashed line from y0,x0 to y1,x1  parse "`*'", parse(",")local optlist `3'parse "`1'", parse(" ")local y0=`1'local x0=`2'local y1=`3'local x1=`4'local options "Begin More DRaw SAVing(str) DAsh(int 200)"local options "`options' SPace(real 150) Pen(int 2)"parse ", `optlist'"if "`begin'"!="" | "`more'`draw'"=="" {	global dashnum=0	local i=1	while "${dcmd`i'}"!="" | `i'<10 {		global dcmd`i'		local i=`i'+1		}	if "`begin'"!="" {local more "more"}}if "$dashnum"=="" {global dashnum=1}	else {global dashnum=$dashnum+1}if "`more'`draw'"!="" {global dcmd${dashnum} "`y0' `x0' `y1' `x1' `dash' `space' `pen'"}if "`more'"=="" | "`draw'"!="" {	if "`saving'"=="" {		gph open		}	else {		gph open, saving(`saving')		}	graph	local ay=_result(5)	local by=_result(6)	local ax=_result(7)	local bx=_result(8)	local line=0	while `line'<$dashnum {		local line=`line'+1		if $dashnum>1 {			local y0: word 1 of ${dcmd`line'}			local x0: word 2 of ${dcmd`line'}			local y1: word 3 of ${dcmd`line'}			local x1: word 4 of ${dcmd`line'}			local dash: word 5 of ${dcmd`line'}			local space: word 6 of ${dcmd`line'}			local pen: word 7 of ${dcmd`line'}		}		gph pen `pen'		local slopeG=(`ay'*(`y1'-`y0'))/(`ax'*(`x1'-`x0'))		if `slopeG'<. {			local step=sqrt(`dash'^2/((`slopeG')^2+1))			local xstep=`step'			local ystep=`step'*`slopeG'		}		else {			local ystep=`dash'			local xstep=0		}		local x0=`x0'*`ax'+`bx'		local y0=`y0'*`ay'+`by'		local x1=`x1'*`ax'+`bx'		local y1=`y1'*`ay'+`by'		local x=`x0'		local y=`y0'		if `xstep'!=0 {			local xstep=`xstep'*sign((`x1'-`x0')/`xstep')		}		if `ystep'!=0 {			local ystep=`ystep'*sign((`y1'-`y0')/`ystep')		}		if !((`x0'>32000 & `x1'>32000) | (`x0'<0 & `x1'<0) | /*		*/ (`y0'>23063 & `y1'>23063) | (`y0'<0 & `y1'<0)) {		while `x'<=max(`x0',`x1') & `x'>=min(`x0',`x1') & /* 		*/ `y'>=min(`y0',`y1') &  `y'<=max(`y0',`y1') {			local ygph1=`y'			local xgph1=`x'			local x=`x'+`xstep'			local y=`y'+`ystep'			local ygph2=`y'			local xgph2=`x'			if min(`ygph1',`xgph1',`ygph2',`xgph2')>=0 /*				*/ & max(`ygph1',`ygph2')<=23063 & /*				*/ max(`xgph1',`xgph2')<=32000 {			gph line `ygph1' `xgph1' `ygph2' `xgph2'			}			local x=`x'+(`space'/100)*(`xstep')			local y=`y'+(`space'/100)*(`ystep')		}		}	}			gph close}end