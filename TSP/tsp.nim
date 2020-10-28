import db_sqlite
import algorithm
import graph
import solution
import distance


proc normalizer(g:Graph,s:Solution):float=
  var
    suma:float
    l:seq[float]

  for n in 0..len(s.cities)-2:
    for m in n+1..len(s.cities)-1:
      var
        i=s.cities[n]
        j=s.cities[m]
      if g.cities[i][j].exists:
        l.add(g.cities[i][j].distance)

  sort(l,system.cmp[float],Descending)

  for i in countup(0,len(s.cities)-2):
    if i >= len(l):
      break
    suma=suma+l[i]

  return suma

proc cost(s:Solution,g:Graph):float=
  var sum=0.0
  for k in countup(0,len(s.cities)-2):
    var
      i=s.cities[k]
      j=s.cities[k+1]
      node=g.cities[i][j]
    if not node.exists:
      sum=sum+weight(s,node.distance,g)
    else:
      sum=sum+node.distance
      #echo g.cities[i][j]
  return sum/normalizer(g,s)


var
  g:Graph[1092]
  s1,s2:Solution

new(g)
g=g.initGraph(1092)
g=g.addNodes()


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

echo normalizer(g,s1)
echo cost(s1,g)
echo cost(s2,g)
