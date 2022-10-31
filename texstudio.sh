#!/bin/bash

cd /app/texlive/lib/perl5/site_perl/
perl_version=$(ls)
# add paths of TeXlive Flatpak extension binaries
export PATH=/usr/bin:/app/bin:/app/texlive/bin:/app/texlive/bin/x86_64-linux:/app/texlive/bin/aarch64-linux
# add include paths for Perl @INC variable
export PERL5LIB=/app/texlive/lib/perl5/site_perl/$perl_version/:/app/texlive/lib/perl5/$perl_version/
# add library paths
export LD_LIBRARY_PATH=/app/texlive/lib/:/app/texlive/lib/perl5/$perl_version/x86_64-linux/CORE/:/app/texlive/lib/perl5/$perl_version/aarch64-linux/CORE/
texstudio "$@"
