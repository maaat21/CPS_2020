mtype {MSG, ACK};
chan toS = [2] of {mtype, bit};
chan toR = [2] of {mtype, bit};
bit nack;

proctype Sender(chan in, out)
{
	bit sendbit, recvbit;
	
	do
			:: out ! MSG, sendbit ->
							in ? ACK, recvbit;
							if
							:: recvbit == sendbit ->
									sendbit = 1-sendbit;
							:: else nack=1;
							fi
	od
}

proctype Receiver(chan in, out)
{
		bit recvbit;
		do
				:: in ? MSG(recvbit) ->
						out ! ACK(recvbit);
		od
}


init
{
		run Sender(toS, toR);
		run Receiver(toR, toS);
}

ltl p0 { <> (nack > 0) }
ltl p1 { [] (nack == 0) }
