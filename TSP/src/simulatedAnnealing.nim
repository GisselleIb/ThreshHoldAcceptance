import graph
import solution
import distance


proc batch(T:float,s:Solution,g:Graph,L:int):(float,Solution)=
  var
    s=s
    i:int=0
    c:int=0
    r:float=0.0
    fs:float
    fnb:float
    nb:Solution

  while c < L and i < 3*L:
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

proc simulatedAnnealing*(T:float,s:Solution,g:Graph,epsilon:float=0.001):(Solution,float)=
  var
    s=s
    T=T
    L:int=5620
    q=high(BiggestFloat)
    p:float=0.0

  while T > epsilon:
    q=high(BiggestFloat)
    while p <= q:
      q=p
      (p,s)=batch(T,s,g,L)
      #echo "Solution: ", s
    T=0.95*T

  return (s,s.cost(g))


when isMainModule:
  var
    g:Graph[1092]
    s1,s2:Solution

  new(g)
  g.initGraph(1092)
  g.addNodes()

  s1.cities= @[ 1,2,3,4,5,6,7,163,164,165,168,172,327,329,331,332,333,489,490,491,
  492,493,496,653,654,656,657,661,815,816,817,820,823,871,978,979,980,981,982,984]
  s2.cities= @[1,2,3,4,5,6,7,8,9,11,12,14,16,17,19,20,22,23,25,26,27,74,75,151,163,
  164,165,166,167,168,169,171,172,173,174,176,179,181,182,183,184,185,186,187,297,
  326,327,328,329,330,331,332,333,334,336,339,340,343,344,345,346,347,349,350,351,
  352,353,444,483,489,490,491,492,493,494,495,496,499,500,501,502,504,505,507,508,
  509,510,511,512,520,652,653,654,655,656,657,658,660,661,662,663,665,666,667,668,
  670,671,673,674,675,676,678,815,816,817,818,819,820,821,822,823,825,826,828,829,
  832,837,839,840,871,978,979,980,981,982,984,985,986,988,990,991,995,999,1001,
  1003,1004,1037,1038,1073,1075]

  s1.initSolution(g)
  s2.initSolution(g)
  echo simulatedAnnealing(62000.0,s1,g)
  echo simulatedAnnealing(6200000.0,s2,g)
