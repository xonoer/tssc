*  version 1.0.0 06Mar2013 MLB

cd "c:/mijn documenten/projecten/stata/qenv/1.3.1"
mata:
mata clear

mata set matastrict on

mata mlib create lqenv10 , replace

void qenv_bound10(
       string scalar tousename,
       string rowvector newnames,
       real scalar reps,
       real scalar level, 
	   pointer scalar f,
       real scalar n, 
       real scalar stat1,
       real scalar stat2,
       real scalar overall)
{

real matrix compare, envelope
real colvector x
real scalar L, l1, l2, U, u1, u2, i, j
if (overall) {
	real matrix rank
	real rowvector colminrank, colmaxrank
	real scalar lr, orate
}

compare = J(n, reps, .)

for (j = 1; j <= reps; j++) {
       compare[.,j] = sort((*f)(n, 1, stat1, stat2), 1)
}

L = reps * (100 - level)/200
U = reps * (100 + level)/200

if (overall == 1) {
	rank = J(n,reps,.)
	for (j = 1; j <= n; j++) {
		rank[j,.] = invorder(order(compare[j,.]', 1))'
	}
	colminrank = colmin(rank)
	colmaxrank = colmax(rank)
	for (lr = ceil(L); lr >= 1 ; lr--) {
		orate = sum((colminrank:<= lr) :| (colmaxrank:>=(reps - lr))) / ( reps - 1 )
		if ( (orate*100) < (100-level)) break
	}
	L = lr 
	U = reps- lr
	st_local("orate", strofreal(orate))
}

l1 = ceil(L)
l2 = l1 + (L == l1) 
if (l1 == 0) l1 = 1 

u1 = ceil(U)
u2 = u1 + (U == u1)
if (u2 == reps + 1) u2 = reps

envelope = J(n, 2, .)
for (i = 1; i <= n; i++) {
       x = sort(compare[i,]', 1)
       envelope[i,] = ((x[l1] + x[l2])/2, (x[u1] + x[u2])/2)
}
newnames = tokens(newnames)
(void) st_addvar("float", newnames)
st_store(., newnames, tousename, envelope)

}
mata mlib add lqenv10 qenv_bound10()

real matrix qenv_rnormal10(
		real scalar r, 
		real scalar c, 
		real scalar mean, 
		real scalar sd)
{
 return(rnormal(r,c,mean,sd))
}
mata mlib add lqenv10 qenv_rnormal10()

real matrix qenv_rgamma10(
		real scalar r, 
		real scalar c, 
		real scalar alpha, 
		real scalar beta)
{
 return(rgamma(r,c,alpha,beta))
}
mata mlib add lqenv10 qenv_rgamma10()

real matrix qenv_rF10( 		
		real scalar r, 
		real scalar c, 
		real scalar dfnum, 
		real scalar dfdenom)
{
	real matrix chi1, chi2

	chi1 = rchi2(r,c,dfnum)/dfnum
	chi2 = rchi2(r,c,dfdenom)/dfdenom
	return( chi1:/chi2 )
}
mata mlib add lqenv10 qenv_rF10()

real matrix qenv_rbeta10(
		real scalar r, 
		real scalar c, 
		real scalar alpha, 
		real scalar beta)
{
 return(rbeta(r,c,alpha,beta))
}
mata mlib add lqenv10 qenv_rbeta10()

end
