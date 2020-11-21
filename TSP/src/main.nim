import os
import graph
import strutils
import sequtils
import solution
import random
import simulatedAnnealing

## Main module to run the Threshold Acceptance algorithm. Recieves the name of
## the database, the instance used as a solution and a list of seeds

when isMainModule:
  var
    params:seq[string]=commandLineParams()
    g:Graph[1092]
    seeds:seq[int]
    sds:seq[string]
    cities:seq[string]
    s:Solution
    T:float

  sds=split(strip(params[2],chars={'[',']',' '}),',')
  seeds=map(sds,parseInt)
  let file=open(params[1])
  for line in file.lines:
    cities=concat(cities,split(strip(line,chars={'[',']',' '}),{','}))
  file.close()

  while any(cities,proc (x:string):bool= return x == ""):
    cities.delete(cities.find(""))

  new(g)
  g.initGraph(1092,params[0])
  s.initSolution(map(cities,parseInt),g)

  for seed in seeds:
    randomize(seed)
    echo "SEED: ",seed
    T=initialTemperature(s,1000.0,0.9,g)
    var s=simulatedAnnealing(T,s,g)
    echo s
