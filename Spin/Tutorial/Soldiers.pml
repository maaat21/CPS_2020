#define N           4
#define soldier     byte

#define MSCTIME     printf("MSC: %d\n", time)
#define IF          if ::
#define FI          :: else fi
#define max(x,y)    ((x>y) -> x : y)

#define select_soldier(x) \
if                        \
:: here[0] -> x=0         \
:: here[1] -> x=1         \
:: here[2] -> x=2         \
:: here[3] -> x=3         \
fi ;                      \
here[x] = 0

#define all_gone    (!here[0] && !here[1] && !here[2] && !here[3])
#define all_here    (here[0] && here[1] && here[2] && here[3])

#define outoftime   time > 60

#define ARRIVED(s1,s2)     printf("@%d, ARRIVED: %d, %d\n", time, s1, s2)
#define BACK(s1)     printf("@%d, BACK: %d\n", time, s1)

chan unsafe_to_safe = [0] of {soldier, soldier} ;
chan safe_to_unsafe = [0] of {soldier} ;
chan stopwatch = [0] of {soldier} ;

int time=0;

proctype Timer()
{
end:
  do
  ::  stopwatch ? 0 -> atomic { time=time+5  ; MSCTIME }
  ::  stopwatch ? 1 -> atomic { time=time+10 ; MSCTIME }
  ::  stopwatch ? 2 -> atomic { time=time+20 ; MSCTIME }
  ::  stopwatch ? 3 -> atomic { time=time+25 ; MSCTIME }
  od 
}

proctype Unsafe()
{
  bit     here[N] ;
  soldier s1, s2 ;
  here[0] = 1 ; 
  here[1] = 1 ; 
  here[2] = 1 ; 
  here[3] = 1 ;

  do
  ::  select_soldier(s1) ;
      select_soldier(s2) ;
      unsafe_to_safe ! s1, s2 ;
      IF all_gone -> break FI ;
      safe_to_unsafe ? s1 ;
      here[s1] = 1 ;
      stopwatch ! s1 ;
						BACK(s1);
  od
}


proctype Safe()
{
  bit     here[N] ;
  soldier s1, s2 ;

  do
  ::  unsafe_to_safe ? s1, s2 ;
      here[s1] = 1 ;
      here[s2] = 1 ;
      stopwatch ! max(s1, s2) ;
						ARRIVED(s1, s2);
      IF all_here -> break FI ;
      select_soldier(s1) ;
      safe_to_unsafe ! s1;
  od
}

init
{
		atomic
		{
				run Safe();
				run Unsafe();
				run Timer();
		}
}

ltl p0 {<>(time > 60)}

