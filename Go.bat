@Echo off
Z:\
cd "Z:\Documents\Arduino\NFPS EPG Grabber"
cls
echo """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
echo "                                                /\                   " 
echo "          ______  _________.__. ____  ____   ___\/  _____ _          " 
echo "          \____ \/  ___<   |  |/ ___\/  _ \ /    \ /  ___/           "
echo "          |  |_> >___ \ \___  \  \__(  <_> )   |  \\___ \            "
echo "          |   __/____  >/ ____|\___  >____/|___|  /____  >           "
echo "          |__|       \/ \/         \/           \/     \/            "
echo "              _______  _____________________  _________              "
echo "              \      \ \_   _____/\______   \/   _____/              "
echo "              /   |   \ |    __)   |     ___/\_____  \               "
echo "             /    |    \|     \    |    |    /        \              "
echo "             \____|__  /\___  /    |____|   /_______  /              "
echo "                     \/     \/                      \/               "
echo "            ________            ___.  ___.                           "
echo "           /  _____/___________ \_ |__\_ |__   ___________           "
echo "          /   \  __\_  __ \__  \ | __ \| __ \_/ __ \_  __ \          "
echo "          \    \_\  \  | \// __ \| \_\ \ \_\ \  ___/|  | \/          "
echo "           \______  /__|  (____  /___  /___  /\___  >__|             "
echo "                  \/           \/    \/    \/     \/                 "
Echo "                                                                     "           
echo "                   Go to iptvtalk.org for support                    "
echo """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
cd bin
If exist mc2xml.exe goto 2
cls
Echo downloading mc2xml
echo
wget  --content-disposition http://originaldll.com/download/40275.exe
:2
if exist  mc2xml.exe goto 3
cls
echo Problem getting mc2xml.  Go to http://mc2xml.awardspace.info/ and download it and pace it in the bin folder.
goto end
cls
:3



Echo Press F for Full , E For English , B for Both
Choice /c:FEB /T 5 /D B
IF ERRORLEVEL 3 GOTO Both
IF ERRORLEVEL 2 GOTO English
IF ERRORLEVEL 1 GOTO Full


:Full
Echo Grabbing Full List

copy chans2correct.txt chans2correct.xml
copy dummy.body dummy.txt

Webgrab+plus
copy "C:\Windows\Temp\WG_guide.xml" .

xmltv_time_correct wg_guide.xml wg_tc.xml

cls
echo "process webgrab and dummy"

set Day=%Date:~7,2%
set Mth=%Date:~4,2%
set Yr=%Date:~10,4%

call datemath %Yr% %Mth% %Day% + 1
set Day1=%_ymd_str%
call datemath %Yr% %Mth% %Day% + 2
set Day2=%_ymd_str%
call datemath %Yr% %Mth% %Day% + 3
set Day3=%_ymd_str%

copy dummy.txt dummy1.txt
copy dummy.txt dummy2.txt
copy dummy.txt dummy3.txt

rem setting time for Midnight, Pacific Daylight Time

sed.exe -e "s/20150513213/%Yr%%Mth%%Day%070/g" dummy1.txt > dummy1_1.txt
sed.exe -e "s/2016051322/%Day1%07/g" dummy1_1.txt > dummy1_conv.txt

sed.exe -e "s/20150513213/%Day1%070/g" dummy2.txt > dummy2_1.txt
sed.exe -e "s/2016051322/%Day2%07/g" dummy2_1.txt > dummy2_conv.txt

sed.exe -e "s/20150513213/%Day2%070/g" dummy3.txt > dummy3_1.txt
sed.exe -e "s/2016051322/%Day3%07/g" dummy3_1.txt > dummy3_conv.txt

copy /b dummy1_conv.txt + dummy2_conv.txt + dummy3_conv.txt dummy_conv.txt

echo "complete dummy dupe"

sed.exe -e $d wg_tc.xml > wg_tc_strip1.txt
sed.exe -e 1,2d wg_tc_strip1.txt > wg_tc_strip.txt
echo "stripped webgrab"

rem copy /b dummy.hdr + dummy_conv.txt + dummy.ftr dummyparsed.xml
copy /b dummy.hdr + wg_tc_strip.txt + dummy_conv.txt + dummy.ftr dummyparsed.xml

echo "combined"


cls

Echo Loading PBS
mc2xml -c us -g 53532 -I dummyparsed.xml -C wisc.chl -R wisc.ren -o wisc.xml -D wisc.dat -F -s -2 -d 48 -u -a -f
cls
Echo Loading India
mc2xml -c IN -g 144103 -I wisc.xml -R in.ren -o in.xml -D in.dat  -F -f -s -1 -d 48 -C in.chl -u -a
cls
Echo Loading Istanbul Turkey
mc2xml -c TR -g 34000 -I in.xml -R turk.ren -o turk.xml -D turk.dat  -F -f -s -1 -d 48 -C turk.chl -u -a
cls
Echo Loading France
mc2xml -c FR -g 75007 -I turk.xml -R fr.ren -o fr.xml -D fr.dat  -F -f -s -1 -d 48 -C fr.chl -u -a
cls
Echo Loading Hotbird Premium
mc2xml -c DE -g 10115 -R hb13p.ren -I fr.xml -o hb13p.xml -D hb13p.dat  -F -f -s -1 -d 48 -C hb13p.chl -u -a
cls
Echo Loading Terrestriches analoges Fernsehen
mc2xml -c DE -g 10115 -R taf.ren -I hb13p.xml -o taf.xml -D taf.dat -F -s -1 -d 48 -C taf.chl -f -u -a
cls
Echo Loading Italian Lineup
mc2xml -c it -g 00153 -R it.ren -I taf.xml -o it.xml -D it.dat -F -s -1 -d 48 -C it.chl -f -u -a
cls
Echo Loading Canadian Lineup
mc2xml -c ca -g T5J 2B2 -R ca.ren -I it.xml -o ca.xml -D ca.dat -F -s -1 -d 48 -C ca.chl -f -u -a
cls
Echo Loading Latino Lineup
mc2xml -c mx -g 10000 -R latin_tp.ren -I ca.xml -o latin_tp.xml -D latin_tp.dat -F -s -1 -d 48 -C latin_tp.chl -f -u -a
cls
Echo Loading Latino Skymex
mc2xml -c mx -g 10000 -I latin_tp.xml -R latin_skymex.ren -o latin_skymex.xml -D latin_skymex.dat -F -s -1 -d 48 -C latin_skymex.chl -f -u -a
cls
Echo Loading DTV
mc2xml -c US -g 10001 -R dtv.ren -o dtv.xml -D dtv.dat -I latin_skymex.xml -F -C dtv.chl -s -1 -d 48 -f -u -a
cls
Echo Loading Miami Locals
mc2xml -c US -g 33101 -R mia.ren -o mia.xml -D mia.dat -F -C mia.chl -I dtv.xml -s -1 -d 48 -f -u -a
cls
Echo Loading US
mc2xml -c US -g 10001 -R us.ren -I mia.xml -o US.xml -D US.dat -F -C US.chl -s -1 -d 48 -f -u -a
cls
Echo Loading UK
mc2xml -c gb "WC2E 9RZ"  -o US-UK.xml -D UK.dat -I US.xml -R uk.ren -F -f -C UK.chl -s -1 -d 48 -f -u -a
cls
Echo Loading Ireland
mc2xml -c IR -g 0 -R ire.ren -o complete.xml -D ire.dat -I US-UK.xml -F -C ire.chl -s -1 -d 48 -f -u -a
cls
Echo Marking New Episodes
sed.exe -e "/<title lang=/ s/"*"/[New!]/g" < "complete.xml" > "NFPSF.xml"
move NFPSF.xml ..
copy wg_guide.xml ..
del *.xml
del dummy*.txt
cd ..
cls
goto end




:english
Echo Grabbing English list
copy wg_guide.xml .
cd bin
copy chans2correct.txt chans2correct.xml
copy dummyeng.body dummy.txt
cls
if exist wg_guide.xml goto 4

Webgrab+plus
cls
copy C:\Windows\Temp\WG_guide.xml .
:4
cls
xmltv_time_correct wg_guide.xml wg_tc.xml

cls
echo "process webgrab and dummy"

set Day=%Date:~7,2%
set Mth=%Date:~4,2%
set Yr=%Date:~10,4%

call datemath %Yr% %Mth% %Day% + 1
set Day1=%_ymd_str%
call datemath %Yr% %Mth% %Day% + 2
set Day2=%_ymd_str%
call datemath %Yr% %Mth% %Day% + 3
set Day3=%_ymd_str%

copy dummy.txt dummy1.txt
copy dummy.txt dummy2.txt
copy dummy.txt dummy3.txt

rem setting time for Midnight, Pacific Daylight Time

sed.exe -e "s/20150513213/%Yr%%Mth%%Day%070/g" dummy1.txt > dummy1_1.txt
sed.exe -e "s/2016051322/%Day1%07/g" dummy1_1.txt > dummy1_conv.txt

sed.exe -e "s/20150513213/%Day1%070/g" dummy2.txt > dummy2_1.txt
sed.exe -e "s/2016051322/%Day2%07/g" dummy2_1.txt > dummy2_conv.txt

sed.exe -e "s/20150513213/%Day2%070/g" dummy3.txt > dummy3_1.txt
sed.exe -e "s/2016051322/%Day3%07/g" dummy3_1.txt > dummy3_conv.txt

copy /b dummy1_conv.txt + dummy2_conv.txt + dummy3_conv.txt dummy_conv.txt

echo "complete dummy dupe"

sed.exe -e $d wg_tc.xml > wg_tc_strip1.txt
sed.exe -e 1,2d wg_tc_strip1.txt > wg_tc_strip.txt
echo "stripped webgrab"

rem copy /b dummy.hdr + dummy_conv.txt + dummy.ftr dummyparsed.xml
copy /b dummy.hdr + wg_tc_strip.txt + dummy_conv.txt + dummy.ftr dummyparsed.xml

echo "combined"

Echo Loading PBS
mc2xml -c us -g 53532 -I dummyparsed.xml -C wisc.chl -R wisc.ren -o wisc.xml -D wisc.dat -F -s -2 -d 48 -u -a -f
cls
Echo Loading Canadian Lineup
mc2xml -c ca -g T5J 2B2 -I wisc.xml -R ca.ren  -o ca.xml -D ca.dat -F -s -5 -d 48 -C ca.chl -f -u -a
cls
REM Echo Loading Latino Lineup
REM mc2xml -c mx -g 10000 -R latin_tp.ren -I ca.xml -o latin_tp.xml -D latin_tp.dat -F -s -5 -d 48 -C latin_tp.chl -f -u -a
REM cls
Echo Loading DTV
mc2xml -c US -g 10001 -R dtv.ren -o dtv.xml -D dtv.dat -I ca.xml -F -C dtv.chl -s -5 -d 48 -f -u -a
cls
Echo Loading Miami Locals
mc2xml -c US -g 33101 -R mia.ren -o mia.xml -D mia.dat -F -C mia.chl -I dtv.xml -s -5 -d 48 -f -u -a
cls
Echo Loading US
mc2xml -c US -g 10001 -R us.ren -I mia.xml -o US.xml -D US.dat -F -C US.chl -s -5 -d 48 -f -u -a
cls
Echo Loading UK
mc2xml -c gb "WC2E 9RZ"  -o US-UK.xml -D UK.dat -I US.xml -R uk.ren -F -f -C UK.chl -s -5 -d 48 -f -u -a
cls
Echo Loading Ireland
mc2xml -c IR -g 0 -R ire.ren -o complete.xml -D ire.dat -I US-UK.xml -F -C ire.chl -s -5 -d 48 -f -u -a
cls
Echo Marking New Episodes
sed.exe -e "/<title lang=/ s/"*"/[New!]/g" < "complete.xml" > "NFPSE.xml"
move NFPSE.xml ..
del *.xml
del dummy*.txt
cd ..
del wg_guide.xml
cls
goto end



:both 
Echo Grabbing Both Lists

copy chans2correct.txt chans2correct.xml
copy dummy.body dummy.txt
Webgrab+plus
cls
copy C:\Windows\Temp\WG_guide.xml .
xmltv_time_correct wg_guide.xml wg_tc.xml

cls
echo "process webgrab and dummy"

set Day=%Date:~7,2%
set Mth=%Date:~4,2%
set Yr=%Date:~10,4%

call datemath %Yr% %Mth% %Day% + 1
set Day1=%_ymd_str%
call datemath %Yr% %Mth% %Day% + 2
set Day2=%_ymd_str%
call datemath %Yr% %Mth% %Day% + 3
set Day3=%_ymd_str%

copy dummy.txt dummy1.txt
copy dummy.txt dummy2.txt
copy dummy.txt dummy3.txt

rem setting time for Midnight, Pacific Daylight Time

sed.exe -e "s/20150513213/%Yr%%Mth%%Day%070/g" dummy1.txt > dummy1_1.txt
sed.exe -e "s/2016051322/%Day1%07/g" dummy1_1.txt > dummy1_conv.txt

sed.exe -e "s/20150513213/%Day1%070/g" dummy2.txt > dummy2_1.txt
sed.exe -e "s/2016051322/%Day2%07/g" dummy2_1.txt > dummy2_conv.txt

sed.exe -e "s/20150513213/%Day2%070/g" dummy3.txt > dummy3_1.txt
sed.exe -e "s/2016051322/%Day3%07/g" dummy3_1.txt > dummy3_conv.txt

copy /b dummy1_conv.txt + dummy2_conv.txt + dummy3_conv.txt dummy_conv.txt

echo "complete dummy dupe"

sed.exe -e $d wg_tc.xml > wg_tc_strip1.txt
sed.exe -e 1,2d wg_tc_strip1.txt > wg_tc_strip.txt
echo "stripped webgrab"

rem copy /b dummy.hdr + dummy_conv.txt + dummy.ftr dummyparsed.xml
copy /b dummy.hdr + wg_tc_strip.txt + dummy_conv.txt + dummy.ftr dummyparsed.xml

echo "combined"

Echo Loading PBS
mc2xml -c us -g 53532 -I dummyparsed.xml -C wisc.chl -R wisc.ren -o wisc.xml -D wisc.dat -F -s -2 -d 48 -u -a -f
cls
Echo Loading India
mc2xml -c IN -g 144103 -I wisc.xml -R in.ren -o in.xml -D in.dat  -F -f -s -1 -d 48 -C in.chl -u -a
cls
Echo Loading Istanbul Turkey
mc2xml -c TR -g 34000 -I in.xml -R turk.ren -o turk.xml -D turk.dat  -F -f -s -1 -d 48 -C turk.chl -u -a
cls
Echo Loading France
mc2xml -c FR -g 75007 -I turk.xml -R fr.ren -o fr.xml -D fr.dat  -F -f -s -1 -d 48 -C fr.chl -u -a
cls
Echo Loading Hotbird Premium
mc2xml -c DE -g 10115 -R hb13p.ren -I fr.xml -o hb13p.xml -D hb13p.dat  -F -f -s -1 -d 48 -C hb13p.chl -u -a
cls
Echo Loading Terrestriches analoges Fernsehen
mc2xml -c DE -g 10115 -R taf.ren -I hb13p.xml -o taf.xml -D taf.dat -F -s -1 -d 48 -C taf.chl -f -u -a
cls
Echo Loading Italian Lineup
mc2xml -c it -g 00153 -R it.ren -I taf.xml -o it.xml -D it.dat -F -s -1 -d 48 -C it.chl -f -u -a
cls
Echo Loading Canadian Lineup
mc2xml -c ca -g T5J 2B2 -R ca.ren -I it.xml -o ca.xml -D ca.dat -F -s -1 -d 48 -C ca.chl -f -u -a
cls
Echo Loading Latino Lineup
mc2xml -c mx -g 10000 -R latin_tp.ren -I ca.xml -o latin_tp.xml -D latin_tp.dat -F -s -1 -d 48 -C latin_tp.chl -f -u -a
cls
Echo Loading Latino Skymex
mc2xml -c mx -g 10000 -I latin_tp.xml -R latin_skymex.ren -o latin_skymex.xml -D latin_skymex.dat -F -s -1 -d 48 -C latin_skymex.chl -f -u -a
cls
Echo Loading DTV
mc2xml -c US -g 10001 -R dtv.ren -o dtv.xml -D dtv.dat -I latin_skymex.xml -F -C dtv.chl -s -1 -d 48 -f -u -a
cls
Echo Loading Miami Locals
mc2xml -c US -g 33101 -R mia.ren -o mia.xml -D mia.dat -F -C mia.chl -I dtv.xml -s -1 -d 48 -f -u -a
cls
Echo Loading US
mc2xml -c US -g 10001 -R us.ren -I mia.xml -o US.xml -D US.dat -F -C US.chl -s -1 -d 48 -f -u -a
cls
Echo Loading UK
mc2xml -c gb "WC2E 9RZ"  -o US-UK.xml -D UK.dat -I US.xml -R uk.ren -F -f -C UK.chl -s -1 -d 48 -f -u -a
cls
Echo Loading Ireland
mc2xml -c IR -g 0 -R ire.ren -o complete.xml -D ire.dat -I US-UK.xml -F -C ire.chl -s -1 -d 48 -f -u -a
cls
Echo Marking New Episodes
sed.exe -e "/<title lang=/ s/"*"/[New!]/g" < "complete.xml" > "NFPSF.xml"
sed.exe -e "s/+0000/-0100/g" < "NFPSF.xml" > "NFPSFD.xml"
move NFPSFD.xml ..
move NFPSF.xml ..
del *.xml
del dummy*.txt
cd ..
cls

cd bin
copy C:\Windows\Temp\WG_guide.xml .
copy chans2correct.txt chans2correct.xml
copy dummyeng.body dummy.txt
cls

xmltv_time_correct wg_guide.xml wg_tc.xml

cls
echo "process webgrab and dummy"

set Day=%Date:~7,2%
set Mth=%Date:~4,2%
set Yr=%Date:~10,4%

call datemath %Yr% %Mth% %Day% + 1
set Day1=%_ymd_str%
call datemath %Yr% %Mth% %Day% + 2
set Day2=%_ymd_str%
call datemath %Yr% %Mth% %Day% + 3
set Day3=%_ymd_str%

copy dummy.txt dummy1.txt
copy dummy.txt dummy2.txt
copy dummy.txt dummy3.txt

rem setting time for Midnight, Pacific Daylight Time

sed.exe -e "s/20150513213/%Yr%%Mth%%Day%070/g" dummy1.txt > dummy1_1.txt
sed.exe -e "s/2016051322/%Day1%07/g" dummy1_1.txt > dummy1_conv.txt

sed.exe -e "s/20150513213/%Day1%070/g" dummy2.txt > dummy2_1.txt
sed.exe -e "s/2016051322/%Day2%07/g" dummy2_1.txt > dummy2_conv.txt

sed.exe -e "s/20150513213/%Day2%070/g" dummy3.txt > dummy3_1.txt
sed.exe -e "s/2016051322/%Day3%07/g" dummy3_1.txt > dummy3_conv.txt

copy /b dummy1_conv.txt + dummy2_conv.txt + dummy3_conv.txt dummy_conv.txt

echo "complete dummy dupe"

sed.exe -e $d wg_tc.xml > wg_tc_strip1.txt
sed.exe -e 1,2d wg_tc_strip1.txt > wg_tc_strip.txt
echo "stripped webgrab"

rem copy /b dummy.hdr + dummy_conv.txt + dummy.ftr dummyparsed.xml
copy /b dummy.hdr + wg_tc_strip.txt + dummy_conv.txt + dummy.ftr dummyparsed.xml

echo "combined"

Echo Loading PBS
mc2xml -c us -g 53532 -I dummyparsed.xml -C wisc.chl -R wisc.ren -o wisc.xml -D wisc.dat -F -s -2 -d 48 -u -a -f
cls
Echo Loading Canadian Lineup
mc2xml -c ca -g T5J 2B2 -I wisc.xml -R ca.ren  -o ca.xml -D ca.dat -F -s -5 -d 48 -C ca.chl -f -u -a
cls
REM Echo Loading Latino Lineup
REM mc2xml -c mx -g 10000 -R latin_tp.ren -I ca.xml -o latin_tp.xml -D latin_tp.dat -F -s -5 -d 48 -C latin_tp.chl -f -u -a
REM cls
Echo Loading DTV
mc2xml -c US -g 10001 -R dtv.ren -o dtv.xml -D dtv.dat -I ca.xml -F -C dtv.chl -s -5 -d 48 -f -u -a
cls
Echo Loading Miami Locals
mc2xml -c US -g 33101 -R mia.ren -o mia.xml -D mia.dat -F -C mia.chl -I dtv.xml -s -5 -d 48 -f -u -a
cls
Echo Loading US
mc2xml -c US -g 10001 -R us.ren -I mia.xml -o US.xml -D US.dat -F -C US.chl -s -5 -d 48 -f -u -a
cls
Echo Loading UK
mc2xml -c gb "WC2E 9RZ"  -o US-UK.xml -D UK.dat -I US.xml -R uk.ren -F -f -C UK.chl -s -5 -d 48 -f -u -a
cls
Echo Loading Ireland
mc2xml -c IR -g 0 -R ire.ren -o complete.xml -D ire.dat -I US-UK.xml -F -C ire.chl -s -5 -d 48 -f -u -a
cls
Echo Marking New Episodes
sed.exe -e "/<title lang=/ s/"*"/[New!]/g" < "complete.xml" > "NFPSE.xml"
sed.exe -e "s/+0000/-0100/g" < "NFPSE.xml" > "NFPSED.xml"
move NFPSED.xml ..
move NFPSE.xml ..
del *.xml
del dummy*.txt
cd ..
cls


:end
git commit -am autorefresh
cls
git push
cls
Echo                           psycon's EPG Grabber has finished. 
echo         Thanks to Dualtalk and Dara for helping link channels to this source. 
Echo              Thanks to everyone else who contributes on IPTVTALK.ORG 
Echo                     Waiting for Reload - press ctrl + c to quit now
timeout /t 18000
go
