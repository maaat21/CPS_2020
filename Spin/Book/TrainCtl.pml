mtype = {arr, lea, awa, wai, bri, green, red};

chan fromEast = [0] of {mtype};
chan fromWest = [0] of {mtype};
chan toEast = [1] of {mtype};
chan toWest = [1] of {mtype};

proctype Train(chan inp, outp){

mtype mode = awa;
mtype sig;

bool taken;

do
::mode==awa -> if
															::atomic{mode=wai; outp!arr;}
															::skip
															fi
															taken=true;taken=false;
::mode==wai -> if
															::inp?[green] -> mode = bri;
															::else;
															fi
															taken=true;taken=false;
::mode==bri -> if
															::atomic{mode=awa; outp!lea;}
															::skip
															fi
															taken=true;taken=false;
od

}

proctype Controller(chan inE, inW, outE, outW){

bool nearE, nearW;
mtype msg;
mtype temp;

outE!red;
outW!red;

do
::inE?arr -> nearE = true
::inE?lea -> atomic{nearE = false; outE?temp; outE!red;} 
::nearE -> if
											::!nearW -> atomic{outE?temp; outE!green;} 
											::outW?[red] -> atomic{outE?temp; outE!green;}
											::else;
											fi
::inW?arr -> nearW = true
::inW?lea -> atomic{nearW = false; outW?temp; outW!red;} 
::nearW -> if
											::!nearE -> atomic{outW?temp; outW!green;}
											::outE?[red] -> atomic{outW?temp; outW!green;}
											::else;
											fi
od

}

init{
	atomic {
				run Train(toEast, fromEast);
				run Train(toWest, fromWest);
				run Controller(fromEast, fromWest, toEast, toWest);
				run Monitor();
	}
}

proctype Monitor(){
		assert(!(Train[1]:mode==bri & Train[2]:mode==bri))
}

ltl p { [](!(Train[1]:mode==bri & Train[2]:mode==bri)) }

ltl p1 { [](Train[1]:mode==wai -> <> Train[1]:mode==bri) }

ltl p2 { []<> Train[1]:taken -> ([](Train[1]:mode==wai -> <> Train[1]:mode==bri)) }

ltl p3 { [](Train[1]:mode==wai -> <> (Train[1]:mode==bri | Train[2]:mode==bri)) } /* Just the controller */
ltl p4 { [](Train[1]:mode==wai & Train[2]:mode==wai -> <> (Train[1]:mode==bri | Train[2]:mode==bri)) } /* Just the controller */