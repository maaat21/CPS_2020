mtype = {GRE, YEL, RED};
bit inp;

proctype TrafficLight() {

mtype mode = GRE;
do
::mode=GRE; if
												::inp -> mode=YEL; mode=RED;
												::else -> mode=GRE;
												fi;
od
}

proctype Decisor() {
do
::inp=1;
::inp=0;
od
}

init{
			run TrafficLight();
			run Decisor();
}

ltl p { [](TrafficLight[1]:mode!=RED) }
ltl p2 { <>(TrafficLight[1]:mode==RED) } /* False. Needs weak fairness */
ltl p3 { [](TrafficLight[1]:mode==YEL -> <>(TrafficLight[1]:mode==RED)) }
ltl p4 { [](TrafficLight[1]:mode==GRE -> <>(TrafficLight[1]:mode==RED)) } /* False. Needs weak fairness */