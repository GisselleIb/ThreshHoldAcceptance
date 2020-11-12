import os
import graph
import strutils
import sequtils
import solution
import distance
import random
import simulatedAnnealing

when isMainModule:
  var
    params:seq[string]=commandLineParams()
    g:Graph[1092]
    seeds:seq[int]
    seedsN:seq[int]
    sds:seq[string]
    cities:seq[string]
    ex:bool=true
    s:Solution
    T:float

  sds=split(strip(params[2],chars={'[',']',' '}),',')
  seeds=map(sds,parseInt)

  echo len(seeds)
  let file=open(params[1])
  for line in file.lines:
    cities=concat(cities,split(strip(line,chars={'[',']',' '}),{','}))

  while any(cities,proc (x:string):bool= return x == ""):
    cities.delete(cities.find(""))

  new(g)
  g.initGraph(1092,params[0])
  s.initSolution(map(cities,parseInt),g)

  #for seed in seeds:
    #randomize(seed)
    #echo "SEED: ",seed
    #T=initialTemperature(s,1000.0,0.9,g)
    #var c=simulatedAnnealing(T,s,g)
    #echo c
  echo s.c
