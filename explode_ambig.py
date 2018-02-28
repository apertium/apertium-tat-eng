# git clone https://github.com/goavki/streamparser.git streamparser

from streamparser.streamparser import parse_file, readingToString
import sys
for blank, lu in parse_file(sys.stdin, withText=True):
    print(blank+" ".join("^{}/{}$".format(lu.wordform, readingToString(r))
                         for r in lu.readings),
          end="")
print("")
