@Echo off
Echo Welcome to psycon's NFPS EPG Grabber
mc2xml -c mx -g 10000 -R latin_skymex.ren -o latin_skymex.xml -D latin_skymex.dat -F -d 48 -C latin_skymex.chl -f -u
Echo Done. 