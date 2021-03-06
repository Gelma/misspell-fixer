#!/usr/bin/env bash

export TEMP=/tmp/misspell-fixer-test/$$
export RUN=". misspell-fixer"
export LC_ALL=C
export SPELLING_ERR="$TEMP/self/spelling.txt"

oneTimeSetUp(){
    mkdir -p $TEMP $TEMP/self/
}

oneTimeTearDown(){
    rm -rf $TEMP
}

# copy code, but remove data which is not needed or we know it contains errors. ( like the dict )
setUp(){
    set +f
    cp -a ./* $TEMP/self/
    rm -R $TEMP/self/dict/*.dict
    rm $TEMP/self/rules/*.sed
    rm -R $TEMP/self/test/expected/
    rm $TEMP/self/test/expected*
    rm -R $TEMP/self/.git
    rm -R $TEMP/self/test/stubs
    rm -R $TEMP/self/X/
    rm -Rf $TEMP/self/shunit2*/
    rm -Rf $TEMP/self/doc/example*
    set -f
}

# run over own code, assume zero errors.
testSelf(){
    $RUN -s -D $TEMP/self/ > $SPELLING_ERR
    count=$(grep -c "^+" <$SPELLING_ERR)
    if [[ $count -eq 0 ]]; then
        echo "*** * * * * * * * * * * * * * * * * * * ***"
        echo "*** hurray, no spelling errors detected ***"
        echo "*** * * * * * * * * * * * * * * * * * * ***"
    else
        echo "*** * * * * * * * * * * * * * * * * * * ***"
        echo "*** those spelling errors found...      ***"
        echo "*** * * * * * * * * * * * * * * * * * * ***"
        cat $SPELLING_ERR
    fi
    assertEquals "found some spelling-errors. :-( " "$count" 0
}

suite(){
    suite_addTest testSelf
}


# load shunit2
. shunit2-2.1.7/shunit2
