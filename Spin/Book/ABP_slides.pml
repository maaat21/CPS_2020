chan msgFromSender = [0] of {byte, bit};
chan msgToReceiver = [0] of {byte, bit};
chan feedbackFromReceiver = [0] of {byte, bit};
chan feedbackToSender = [0] of {byte, bit};

inline createMsg(msg){
if
::msg=3;
::msg=4;
::msg=5;
::msg=6;
::msg=7;
::msg=8;
::msg=9;
::msg=10;
fi
}

proctype UnreliableFIFO(chan inp, outp){

chan channel = [1] of {byte, bit};

byte msg;
bit ab;

do
::nfull(channel) -> inp?msg, ab; channel!msg, ab;
::nempty(channel) -> channel?msg, ab; outp!msg, ab;
::nempty(channel) -> channel?[msg, ab]; outp!msg, ab; /* duplicate */
::nempty(channel) -> channel?msg, ab; /* loss */
od

}

proctype Sender(chan inp, outp){
bit sendBit = 0;
byte msg;
bit ab;

createMsg(msg); 
do
::outp!msg, sendBit;
::inp?0, ab; if
															::ab==sendBit -> createMsg(msg); sendBit = 1-sendBit;
															::else;
															fi
od

}

proctype Receiver(chan inp, outp){
bit rcvBit = 1;
byte msg;
bit ab;

do
::inp?msg, ab; if
															::ab!=rcvBit -> progress: printf("Received: %d", msg); rcvBit = 1-rcvBit;
															::else;
															fi
::outp!0, rcvBit;
od
}

init{
	atomic {
				run Sender(feedbackToSender, msgFromSender);
				run Receiver(msgToReceiver, feedbackFromReceiver);
				run UnreliableFIFO(msgFromSender, msgToReceiver);
				run UnreliableFIFO(feedbackFromReceiver, feedbackToSender);
	}
}

/* Check non progress cycles gives error, e.g. only working the back-chain */