#script (python)

from math import log

def minusln1over(x):
  if x <= 1:
    return 0
  else:
    return int(round( -1000 * log(float(1)/x) ))

#end.