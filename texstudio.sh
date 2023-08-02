#!/bin/bash

 if [ -d /app/texlive ]
 then
     cd /app/texlive/lib/perl5/site_perl/
     perl_version=$(ls)
     # add paths of TeXlive Flatpak extension binaries
     export PATH=/usr/bin:/app/bin:/app/texlive/bin:/app/texlive/bin/x86_64-linux:/app/texlive/bin/aarch64-linux
     # add include paths for Perl @INC variable
     export PERL5LIB=/app/texlive/lib/perl5/$perl_version:/app/texlive/lib/perl5/site_perl/$perl_version
     # add library paths
     export LD_LIBRARY_PATH=/app/texlive/lib:/app/texlive/lib/perl5/$perl_version/x86_64-linux/CORE
fi
 
# taken from
# https://dev.languagetool.org/http-server
# linked here:
# https://github.com/languagetool-org/languagetool
# make sure to kill java so we don't end up with lots of unused LanguageTool server instances
# https://stackoverflow.com/questions/6674327/redirect-all-output-to-file-in-bash
/app/jre/bin/java -cp /app/languagetool/languagetool-server.jar org.languagetool.server.HTTPServer --port 8081 --allow-origin > /dev/null 2>&1 & texstudio "$@" && pkill -SIGKILL java
