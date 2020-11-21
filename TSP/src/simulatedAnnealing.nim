import graph
import solution
import distance
import random
import times

## Module that contains the necessary procedures for the main algorithm: simulated annealing.

proc acceptedPercentage*(s:Solution,T:float,g:Graph):float=
  ## Calculates the percentage of solutions accepted given a temperature ``T``.

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


proc binarySearch*(s:Solution,g:Graph,T1,T2,P:float,epsilon:float=0.001):float=
  ## Recursive binary search for an optimal initial temperature.

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
  ## Procedure for calculating an optimal temperature for the given solution.
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



proc batch*(T:float,s:Solution,g:Graph,L:int):(float,Solution)=
  ## Generates a batch of L accepted solutions, returns the average of the
  ## accepted solutions and the last solution accepted.
  ## Each solution s' is a solution in the neighborhood of the current solution
  ## s, and it is only accepted if it happens that *f(s') <= f(s)+T* where
  ## *f(x)* is the cost of the solution and ``T`` is the current temperature.
  ## This procedure is optimized so generate a neighbour solution cost
  ## will take constant time.
  var
    s=s
    bestSol=s.c
    i:int=0
    c:int=0
    r:float=0.0
    fs:float
    fnb:float
    m,n:int

  while c < L and i < 3*L:
    (m,n,fnb)=s.randomNeighbor(g)
    fs=s.c
    if fnb <= fs+T:
      s.swap(fnb,m,n)
      c=c+1
      r=r+fnb
      if fnb < bestSol:
        bestSol=fnb
    else:
      i=i+1
  #echo bestSol, " ", s.c

  return (r/float(L),s)


proc simulatedAnnealing*(T:float,s:Solution,g:Graph,epsilon:float=0.0001):Solution=
  ## Threshold accepting algorithm, a variation of simulated annealing.
  ## Given a solution, a graph and an initial temperature, calculates
  ## an optimal solution. The algorithm ends when the temperature reach 0.0001
  ## and the cooling factor used is 0.95.
  var
    s=s
    T=T
    L:int=int(len(s.cities)*(len(s.cities)-1)/2)
    q=high(BiggestFloat)
    p:float=0.0
    time:float

  while T > epsilon:
    q=high(BiggestFloat)
    time= cpuTime()
    while p <= q:
      if cpuTime()-time > 1.0:
        break
      q=p
      (p,s)=batch(T,s,g,L)
    T=0.95*T
    #echo "S: ", s.c
  return s
