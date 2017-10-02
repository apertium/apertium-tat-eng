#!/usr/bin/env bash

## Given a colon separated (source language phrase, target language phrase)
## pair, inserts the pair/sl phrase into the bilingual dictionary/sl lexc file.
## at lines LEXC_TM_LINE and BIDIX_TM_LINE, formatting them appropriately.
##
## E.g., after you input "foo:bar" on the promt, the LEXC file will contain
## foo%<phrase%>:foo # ; ! ""
## on line LEXC_TM_LINE and the BIDIX file will contain
## <e><p><l>foo</l><r>bar</r></p></e>
## on line BIDIX_TM_LINE and both the morphological transducer and the bilingual
## dicitonary will be recompiled.
##
## Was written to be used along with
## 'watch -n 1 "cat some-text | apertium -d . sl-tl"
## or similar to see your modifications in action on the fly.

BIDIX="apertium-tat-eng.tat-eng.dix"
LEXC="../../languages/apertium-tat/apertium-tat.tat.lexc"

LEXC_TM_LINE=7981
BIDIX_TM_LINE=8368

while IFS=: read slphrase tlphrase ; do

    entry=`echo "${slphrase}:${tlphrase}" | sed 's|\(.*\):\(.*\)|<e><p><l>\1</l><r>\2</r></p></e>|g'`
    slphrase=`echo $slphrase | sed 's/ /% /g;s/.*/&%<phrase%>:& # ; ! ""/g'`

    sed -i "${LEXC_TM_LINE}i$slphrase" "$LEXC"
    sed -i "${BIDIX_TM_LINE}i\ \ \ \ $entry" "$BIDIX"

    cd ../../languages/apertium-tat/
    make

    cd ../../incubator/apertium-tat-eng/
    make

done
