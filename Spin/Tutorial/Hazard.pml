/* https://www.geeksforgeeks.org/static-hazards-in-digital-logic/ */

/* declaration */
bit a, abar, b, c, cbar, d, f;
bit oldf;
bit n1, n2, n3; /* n3 for hazard removal */
bit newp;

#define AND3(x,y,z,out) (out != (x&&y&&z)) -> out = x&&y&&z
#define OR2(x,y,out) (out != (x||y)) -> out = x||y
#define OR3(x,y,z,out) (out != (x||y||z)) -> out = x||y||z
#define INV(in,out) (out != (1-in)) -> out = (1-in)

proctype netlist()
{
		do
		::
				if
				:: AND3(abar, cbar, d, n1);
				:: INV(cbar, c);
				:: AND3(b, c, d, n2);
				:: OR2(n1,n2,f); /* with hazard */
				/* :: OR3(n1,n2,n3, f); */ /* For hazard removal */
				/* :: AND3(abar, b, d, n3); */ /* For hazard removal */
				fi;
				newp=0
		od
}

proctype stimulus()
{
		do
		:: timeout ->
				atomic {
				newp=1;
				oldf=f;
				if
				:: abar = 1-abar
				:: b = 1-b
				:: cbar = 1-cbar
				:: d = 1-d
				fi;
				}
		od
}

init
{
		atomic{abar=0; cbar=0; b=0; d=0; newp=1 };
		atomic {
				run stimulus();
				run netlist()
		}
}

never {
		do
				:: skip
				:: (newp==0 && oldf != f) -> break /* transition */
		od;
		do
				:: ((newp==0) && (oldf != f))
				:: ((newp==0) && (oldf == f)) -> break /* spike/dip */
		od
}