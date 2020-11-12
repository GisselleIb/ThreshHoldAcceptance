import graph
import solution
import distance
import random


proc acceptedPercentage(s:Solution,T:float,g:Graph):float=
  var
    s=s
    m,n:int
    c:int=0
    fnb:float
    N:int=int(len(s.cities)*(len(s.cities)-1)/2)

  for i in countup(1,N):
    (m,n,fnb)=s.randomNeighbor(g)
    if fnb <= s.c+T:
      c=c+1
      s.swap(fnb,m,n)

  return c/N


proc binarySearch(s:Solution,g:Graph,T1,T2,P:float,epsilon:float=0.001):float=
  var
    p:float
    Tm:float=(T1+T2)/2

  if T2-T1 < epsilon:
    return Tm
  p=acceptedPercentage(s,Tm,g)
  if abs(P-p) < epsilon:
    return Tm
  if p > P:
    return binarySearch(s,g,T1,Tm,P)
  else:
    return binarySearch(s,g,Tm,T2,P)


proc initialTemperature*(s:Solution,T:float,P:float,g:Graph,epsilon:float=0.001):float=
  var
    T=T
    p:float=acceptedPercentage(s,T,g)
    T1,T2:float

  if abs(P-p) <= epsilon:
    return T
  if p < P:
    while p<P:
      T=2*T
      p=acceptedPercentage(s,T,g)
      T1=T/2
      T2=T
  else:
    while p>P:
      T=T/2
      p=acceptedPercentage(s,T,g)
    T1=T
    T2=2*T

  return binarySearch(s,g,T1,T2,P)



proc batch(T:float,s:Solution,g:Graph,L:int):(float,Solution,Solution)=
  var
    s=s
    i:int=0
    c:int=0
    r:float=0.0
    fs:float
    fnb:float
    m,n:int
    bestSol:Solution

  while c < L and i < 3*L:
    (m,n,fnb)=s.randomNeighbor(g)
    fs=s.c
    if fnb <= fs+T:
      s.swap(fnb,m,n)
      c=c+1
      r=r+fnb
      bestSol=s
      #if fnb < fs:
      #  echo s
    else:
      i=i+1

  return (r/float(L),s,bestSol)


proc simulatedAnnealing*(T:float,s:Solution,g:Graph,epsilon:float=0.0001):(Solution,Solution)=
  var
    s=s
    T=T
    bestSol:Solution=s
    L:int=int(len(s.cities)*(len(s.cities)-1)/2)
    q=high(BiggestFloat)
    p:float=0.0

  while T > epsilon:
    q=high(BiggestFloat)
    while p <= q:
      q=p
      (p,s,bestSol)=batch(T,s,g,L)
    T=0.95*T
    #echo "S: ", s.c
  return (s,bestSol)
