@Echo off
cls
echo """""""""""""""""""""""""""""""""""""""""""""""""""
echo "                                      /\         " 
Echo "                                                 " 
echo "                 Go to iptvtalk.org for support  "
echo """""""""""""""""""""""""""""""""""""""""""""""""""
pause

rem Copying the dummy file, no header or footer
copy dummy.txt "N:\StreamSmartBox\NFPS EPG Grabber\bin\dummy.txt"
copy wg_guide_tc.xml "N:\StreamSmartBox\NFPS EPG Grabber\bin\wg_tc.xml"

cd bin

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
echo "striped webgrab"
pause

copy /b dummy.hdr + dummy_conv.txt + dummy.ftr dummyparsed.xml
rem copy /b dummy.hdr + wg_tc_strip.txt + dummy_conv.txt + dummy.ftr dummyparsed.xml

echo "combined"

copy dummyparsed.xml ..

del *.txt

pause

Echo Loading India
rem mc2xml -c IN -g 144103 -I dummyparsed.xml -R in.ren -o in.xml -D in.dat  -F -f -s -2 -d 48 -C in.chl -u -a

copy dummyparsed.xml ..

Echo Done. Thanks to Dualtalk and Dara for helping link channels to this source. 
Echo Thanks to everyone else who contributes on IPTVTALK.ORG 
pause