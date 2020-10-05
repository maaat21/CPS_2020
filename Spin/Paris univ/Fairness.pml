//Enforce through the verification panel option

byte x;

active proctype A(){
	do:: x=2;
	progress: skip
	od
}

active proctype B(){
	do
	:: x=3;
	od
}
