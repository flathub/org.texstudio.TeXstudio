#!/usr/bin/env bash

cd .github
. scripts/get-version.sh > /dev/null
cd ..
RELEASE_OPENING_TAG="<release date=\"$RELEASE_DATE\" version=\"$TXS_VERSION\">"
DESCRIPTION_OPENING_TAG="<description>"
# turn links into plain text
# [#3458](https://github.com/texstudio-org/texstudio/pull/3458) -> #3458
sed -i -E 's|\[([^]]*)]\(([^)]*)\)|\1|g' utilities/manual/source/CHANGELOG.md
# pandoc turns ** into <strong/>, which is not supported
sed -i 's|**||g' utilities/manual/source/CHANGELOG.md
CHANGELOG=$(sed '/^[[:space:]]*$/d' utilities/manual/source/CHANGELOG.md | tail -n +2 | awk 'NR==2,/##/' | head -n -1 | pandoc --from markdown --to html5 )
DESCRIPTION_CLOSING_TAG="</description>"
RELEASE_CLOSING_TAG="</release>"

sed -i '/releases/,/releases/{//!d}' utilities/texstudio.metainfo.xml

if [ "$CHANGELOG" != "<li></li>" ]; then
	RELEASE_TAG=$RELEASE_OPENING_TAG$DESCRIPTION_OPENING_TAG$CHANGELOG$DESCRIPTION_CLOSING_TAG$RELEASE_CLOSING_TAG
else
	RELEASE_TAG=$RELEASE_OPENING_TAG$RELEASE_CLOSING_TAG
fi

# this avoids an issue with sed
# https://unix.stackexchange.com/a/360541/148421
cat utilities/texstudio.metainfo.xml | xmllint --format - | awk 'NR==1,/<releases>/' | echo "$(</dev/stdin)$RELEASE_TAG</releases></component>" > utilities/texstudio.metainfo.xml.new
rm utilities/texstudio.metainfo.xml
xmllint --format utilities/texstudio.metainfo.xml.new > utilities/texstudio.metainfo.xml && \
rm utilities/texstudio.metainfo.xml.new
