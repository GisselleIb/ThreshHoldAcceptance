import algorithm
import graph
import distance
import random


type
  Solution* =object
    cities* :seq[int]
    norm* :float
    maxD*:float
    c*:float



proc getWeight(s,:Solution,i,j:int,g:Graph):float=
  var
    m:int=s.cities[i]
    n:int=s.cities[j]
    e=g.cities[m][n]
  if e.exists:
    return e.distance
  else:
    return s.weight(e.distance,g)


proc randomNeighbor*(s:Solution,g:Graph):(int,int,float64)=
  var
    i,j:int=0
    length=s.cities.len
    r:float64=s.c*s.norm

  while i==j:
    i=rand(length-1)
    j=rand(length-1)

  if i>0:
    r=r-s.getWeight(i-1,i,g)
    r=r+s.getWeight(i-1,j,g)

  if i < length-1:
    r=r-s.getWeight(i,i+1,g)
    r=r+s.getWeight(j,i+1,g)

  if j>0:
    r=r-s.getWeight(j-1,j,g)
    r=r+s.getWeight(j-1,i,g)

  if j < length-1:
    r=r-s.getWeight(j,j+1,g)
    r=r+s.getWeight(i,j+1,g)

  if i-1 == j or i+1 == j:
    r=r+(2*s.getWeight(i,j,g))

  return (i,j,r/s.norm)


proc maxDistance*(s:Solution,g:Graph):float=
  var
    max=0.0

  for n in countup(0,len(s.cities)-2):
    for m in countup(n+1,len(s.cities)-1):
      var
        i=s.cities[n]
        j=s.cities[m]

      if g.cities[i][j].exists and g.cities[i][j].distance > max:
        max=g.cities[i][j].distance

  return max

proc weight*(s:Solution,nd:float,g:Graph):float=
  return nd*s.maxD


proc normalizer*(s:Solution,g:Graph):float=
  var
    suma:float
    l:seq[float]

  for n in 0..len(s.cities)-2:
    for m in n+1..len(s.cities)-1:
      var
        i=s.cities[n]
        j=s.cities[m]
        node=g.cities[i][j]
      if node.exists:
        l.add(node.distance)

  sort(l,system.cmp[float],Descending)

  for i in countup(0,len(s.cities)-2):
    if i >= len(l):
      break
    suma=suma+l[i]

  return suma

proc cost*(s:Solution,g:Graph):float=
  var
    sum:float=0.0

  for k in countup(0,len(s.cities)-2):
    var
      i=s.cities[k]
      j=s.cities[k+1]
      node=g.cities[i][j]
    if not node.exists:
      sum=sum+s.weight(node.distance,g)
    else:
      sum=sum+node.distance
      #echo g.cities[i][j]
  return sum/s.norm

proc initSolution*(s:var Solution,cities:seq[int],g:Graph)=
  s.cities=cities
  s.norm=s.normalizer(g)
  s.maxD=s.maxDistance(g)
  s.c=s.cost(g)


proc swap*(s:var Solution,r:float,i,j:int)=
  var temp=s.cities[i]
  s.cities[i]=s.cities[j]
  s.cities[j]=temp
  s.c=r
