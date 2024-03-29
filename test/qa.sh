#!/bin/bash

# Takes the basename of the test scrpt in /test-scripts as an argument,
# an additional argument if the test script requires it, and runs the test.
#
# Usage: ./qa t1x
#        ./qa testvoc reg

if [ $# -eq 0 ]
then
    testToRun=tat-rus.test
else
    testToRun=$1.test
fi

bash "test/$testToRun" "$2"
