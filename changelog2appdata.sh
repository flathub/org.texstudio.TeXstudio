#!/usr/bin/env bash

. .github/scripts/get-version.sh > /dev/null
RELEASE_OPENING_TAG="<release date=\"$RELEASE_DATE\" version=\"$TXS_VERSION\">"
DESCRIPTION_OPENING_TAG="<description>"
CHANGES="<p>Changes:</p>"
LIST_OPENING_TAG="<ul>"
CHANGELOG=$(sed -e '/./!Q' utilities/manual/CHANGELOG.txt | tail -n +3 | sed -e 's|-\ |<li>|g' | sed -e 's|$|</li>|g')
CHANGELOG="${CHANGELOG//
/\\n}"
LIST_CLOSING_TAG="</ul>"
DESCRIPTION_CLOSING_TAG="</description>"
RELEASE_CLOSING_TAG="</release>"

sed -i '/releases/,/releases/{//!d}' utilities/texstudio.appdata.xml
sed -e "s|<releases>|<releases>$RELEASE_OPENING_TAG$DESCRIPTION_OPENING_TAG$CHANGES$LIST_OPENING_TAG$CHANGELOG$LIST_CLOSING_TAG$DESCRIPTION_CLOSING_TAG$RELEASE_CLOSING_TAG|g" -i utilities/texstudio.appdata.xml

cp utilities/texstudio.appdata.xml utilities/texstudio.appdata.xml.bak
xmllint --format utilities/texstudio.appdata.xml.bak > utilities/texstudio.appdata.xml
rm utilities/texstudio.appdata.xml.bak
