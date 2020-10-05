active proctype A(){
byte var;
byte to;
	 {
				do
				:: var++;
				od;
		} unless
		{
				if
				:: (var > 10) -> do
																					::(var>0) -> var--;
																					:: timeout -> break;
																					od
				/* :: timeout -> skip; Timeout does not go here */
				fi
				var = 37;
		}
}
