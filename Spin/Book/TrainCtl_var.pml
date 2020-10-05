mtype = {arr, lea, awa, wai, bri, green, red};

chan fromEast = [0] of {mtype};
chan fromWest = [0] of {mtype};
mtype toE;
mtype toW;

proctype Train(chan outp; bool east){

mtype mode = awa;

bool taken;

do
::mode==awa -> if
															::atomic{mode=wai; outp!arr;}
															::skip
															fi
															taken=true;taken=false;
::mode==wai -> if
															::east & toE == green -> mode = bri;
															::!east & toW == green -> mode = bri;
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

proctype Controller(chan inE, inW){

bool nearE, nearW;
mtype msg;
mtype temp;

toE = red;
toW = red;

do
::inE?arr -> nearE = true
::inE?lea -> atomic{nearE = false; toE = red;} 
::nearE & !nearW & toE != green -> toE = green; 
::nearE & toW == red & toE != green -> toE = green;
::inW?arr -> nearW = true
::inW?lea -> atomic{nearW = false; toW = red;} 
::nearW & !nearE & toW != green -> toW = green;
::nearW & toE == red & toW != green -> toW = green;
od

}

init{
	atomic {
				run Train(fromEast, true);
				run Train(fromWest, false);
				run Controller(fromEast, fromWest);
				run Monitor();
	}
}

proctype Monitor(){
		assert(!(Train[1]:mode==bri & Train[2]:mode==bri))
}

ltl p { [](!(Train[1]:mode==bri & Train[2]:mode==bri)) }

ltl p1 { [](Train[1]:mode==wai -> <> Train[1]:mode==bri) }

ltl p2 { []<> Train[1]:taken -> ([](Train[1]:mode==wai -> <> Train[1]:mode==bri)) }

ltl p3 { [](Train[1]:mode==wai -> <> (Train[1]:mode==bri | Train[2]:mode==bri)) }
ltl p4 { [](Train[1]:mode==wai & Train[2]:mode==wai -> <> (Train[1]:mode==bri | Train[2]:mode==bri)) }
