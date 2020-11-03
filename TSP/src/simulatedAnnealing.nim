import graph
import solution
import distance


proc batch(T:float,s:Solution,g:Graph,L:int=100):(float,Solution)=
  var
    s=s
    i:int=0
    c:int=0
    r:float=0.0
    fs:float
    fnb:float
    nb:Solution

  while c < L and i < 4*L:
    nb=s.randomNeighbor()
    fs=s.cost(g)
    fnb=nb.cost(g)
    if fnb <= fs+T:
      s=nb
      c=c+1
      r=r+fnb
    else:
      i=i+1

  return (r/float(L),s)

proc simulatedAnnealing(T:float,s:Solution,g:Graph,epsilon:float=0.01):(Solution,float)=
  var
    s=s
    T=T
    q=high(BiggestFloat)
    p:float=0.0

  while T > epsilon:
    q=high(BiggestFloat)
    while p <= q:
      q=p
      (p,s)=batch(T,s,g)
      #echo "q: ", q
    T=0.65*T
    #echo "T: ",T
  return s
