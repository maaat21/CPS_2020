mtype = {GRE, YEL, RED};
proctype TrafficLight() {

mtype mode = GRE;
do
::mode=GRE; mode=YEL; mode=RED;
od
}

init{
			run TrafficLight();
}

ltl p { [](TrafficLight[1]:mode!=RED) }
ltl p2 { <>(TrafficLight[1]:mode==RED) }
