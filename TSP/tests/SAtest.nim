import ../src/graph
import ../src/simulatedAnnealing
import ../src/solution
import unittest

when isMainModule:

  suite "Test simulated Annealing":

    setup:
      var
        g:Graph[1092]
        solution40,solution150:Solution
        c40,c150:float
        t1,t2:float

      new(g)
      g.initGraph(1092)
      g.addNodes()

      solution40.cities= @[ 1,2,3,4,5,6,7,163,164,165,168,172,327,329,331,332,333,489,490,491,
      492,493,496,653,654,656,657,661,815,816,817,820,823,871,978,979,980,981,982,984]
      solution150.cities= @[1,2,3,4,5,6,7,8,9,11,12,14,16,17,19,20,22,23,25,26,27,74,75,151,163,
      164,165,166,167,168,169,171,172,173,174,176,179,181,182,183,184,185,186,187,297,
      326,327,328,329,330,331,332,333,334,336,339,340,343,344,345,346,347,349,350,351,
      352,353,444,483,489,490,491,492,493,494,495,496,499,500,501,502,504,505,507,508,
      509,510,511,512,520,652,653,654,655,656,657,658,660,661,662,663,665,666,667,668,
      670,671,673,674,675,676,678,815,816,817,818,819,820,821,822,823,825,826,828,829,
      832,837,839,840,871,978,979,980,981,982,984,985,986,988,990,991,995,999,1001,
      1003,1004,1037,1038,1073,1075]

      solution40.initSolution(g)
      solution150.initSolution(g)

      t1=initialTemperature(solution40,1000.0,0.9,g)
      t2=initialTemperature(solution50,1000.0,0.9,g)

      c40=simulatedAnnealing(t1,solution40,g)[1]
      c150=simulatedAnnealing(t2,solution150,g)[1]


    test "Normalizer of solution":
      check solution40.norm <= 180836110.430000007
      check solution150.norm <= 723059620.720000267

    test "Cost of solution":
      check solution40.cost(g) <= 3305585.454990047
      check solution150.cost(g) <= 6152051.625245281

    test "Simulated Annealing":
      check c40 <= 1.0
      check c150 <= 1.0
