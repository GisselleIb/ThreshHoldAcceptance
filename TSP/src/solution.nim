import random
import algorithm
import graph
import distance

type
  Solution* =object
    cities* :seq[int]
    norm* :float

proc randomNeighbor*(s:Solution):Solution=
  var
    nb:Solution=s
    i:int=0
    j:int=0
    temp:int

  randomize()

  while i==j:
    i=rand(s.cities.len-1)
    j=rand(s.cities.len-1)

  temp=nb.cities[i]
  nb.cities[i]=nb.cities[j]
  nb.cities[j]=temp

  return nb


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
  return nd*s.maxDistance(g)


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
