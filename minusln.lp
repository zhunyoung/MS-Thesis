#script (python)

from math import log

def minusln(x):
  if x <= 0:
    return 999999
  else:
    return int(round( -1000 * log(x/float(1000)) ))

#end.