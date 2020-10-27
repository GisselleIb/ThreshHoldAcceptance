import graph
import random

type
  Solution* =object
    cities* :seq[int]


proc neighborhood*(s :Solution):seq[Solution]=
  var
    nb:Solution
    nbs:seq[Solution]

  for i in countup(0,len(s.cities)-1):
    for j in countup(i+1,len(s.cities)-1):
      nb=s
      nb.cities[i]=s.cities[j]
      nb.cities[j]=s.cities[i]
      nbs.add(nb)

  return nbs


proc randomNeighbor*(s:Solution):Solution=
  var
    nb:Solution=s
    i:int=0
    j:int=0

  randomize()
  while i==j:
    i=rand(s.cities.len-1)
    j=rand(s.cities.len-1)
  nb.cities[i]=s.cities[j]
  nb.cities[j]=s.cities[i]

  return nb
