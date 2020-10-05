/* Mergers */
/* Check invalid end states */

chan ProducerToSender = [0] of {bit};
chan ReceiverToConsumer = [0] of {bit};
chan SenderToReceiver = [0] of {bit, bit};
chan ReceiverToSender = [0] of {bit};

proctype Sender() {

bit sendTag = 1;
bit recTag;
bit msg;
chan msgs = [2] of {bit};

do
::nfull(msgs) -> ProducerToSender?msg; msgs!msg;
::msgs?<msg>; SenderToReceiver!msg, sendTag;
::ReceiverToSender?recTag; if
																											:: recTag==sendTag -> msgs?msg; sendTag = !sendTag;
																											:: recTag!=sendTag -> skip;
																											fi
od

}

proctype Receiver() {

chan msgs = [2] of {bit};
bit recTag;
bit sendTag;
bit msg;

do
::nfull(msgs) -> SenderToReceiver?msg, sendTag; if
																																															:: sendTag!=recTag -> msgs!msg; recTag = !recTag;
																																															:: sendTag==recTag -> skip;
																																															fi
::ReceiverToSender!recTag;
::msgs?msg; ReceiverToConsumer!msg;
od

}

proctype Producer() {

bit b;

do
::if
		::b=0;
		::b=1;
		fi
		ProducerToSender!b;
od

}

proctype Consumer() {

bit res;

do
::ReceiverToConsumer?res;
		printf("*** Received: %d", res);
od

}

init{
	atomic {
			run Sender();
			run Receiver();
			run Producer();
			run Consumer();
	}
}