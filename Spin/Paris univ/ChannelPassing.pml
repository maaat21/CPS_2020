chan glob = [1] of { chan };

active proctype A(){
	chan loc = [1] of { byte }
	byte var
	glob!loc;
	loc?var;
}

active proctype B(){
	chan who;
	glob?who;
	who!100;
}
