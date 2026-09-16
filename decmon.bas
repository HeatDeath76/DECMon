10 print"          *** decmon v1.2 ***"
15 print
20 print"   *** by darin sunley - (c) 2026 ***"
23 print
25 print"   * type help/h/? for command list *"
30 b1$="":b2$="  ":rem pokeable buffers
35 sp=0:bf=0
40 def fnr(x)=(x/16-int(x/16))*16
50 suppress=0:r1=-1:r2=-1:sy=-1
60 ifsp<>1thenprint:print"decmon."
65 qm=-1:sep=1:dx=0:sp=0
70 fori=0to10:o$(i)="":nexti
80 sys 65487:c=peek(780)
90 ifc=13 then print:gosub1000:goto60
100 ifc<>34thengoto140
110 qm=qm*-1:goto160
140 ifc<>44andc<>32thengoto200
150 ifqm<>-1thengoto200
160 sep=sep+1:ifsep=0thendx=dx+1
180 ifdx>10thengoto270
190 goto80
200 o$(dx)=o$(dx)+chr$(c):sep=-1:goto80
269 rem=====flush=buffer==============
270 sys 65487:c=peek(780)
280 if c<>13 then goto270
285 print:print"?maximum of 10 params"
290 goto60
1000 rem======command=dispatcher======
1002 ifo$(0)="peek"thengoto1550
1010 ifo$(0)="poke"oro$(0)="g"thengoto3100
1020 ifo$(0)="dp"thengoto3570
1029 rem exit command
1030 ifo$(0)="x"thenend
1040 ifo$(0)="hd"thengoto1250
1050 ifo$(0)="dh"thengoto2300
1060 ifo$(0)="suppress"thengoto2500
1070 ifo$(0)="sys"oro$(0)="run"thengoto2600
1080 ifo$(0)="mem"thengoto3000
1090 ifo$(0)="pd"thengoto3510
1100 ifo$(0)="list"thengoto3300
1120 ifo$(0)="range"thengoto5000
1130 ifo$(0)="str"thengoto5200
1200 rem assembler command
1205 c$=left$(o$(0),1):c=asc(c$)
1210 if(c>47andc<58)<>0orc$="p"orc$="$"orc$="-"thengoto11000
1220 ifo$(0)="save"thengoto3700
1230 ifo$(0)="load"thengoto4070
1240 ifo$(0)="help"oro$(0)="h"oro$(0)="?"then goto4500
1242 ifo$(0)="split"thengoto5300
1243 ifo$(0)="comp"thengoto6900
1244 ifo$(0)="twosc"thengoto5400
1245 ifo$(0)="init"oro$(0)="new"thengoto6000
1246 ifo$(0)="grid"thengoto6500
1248 print"?not implemented: ";o$(0)
1249 return
1250 rem=====hd=command===============
1260 dx=1
1270 gosub 1400:rem hex recognizer
1280 if err$<>"" then printerr$:return
1290 printret:return
1400 rem=====hex=recognizer==========
1410 err$=""
1415 ifmid$(o$(dx),1,1)<>"$"thenerr$="?missing $":return
1420 if len(o$(dx))<2thenerr$="?invalid hex literal":return
1430 t=0
1440 fori=2tolen(o$(dx))
1450 c$=mid$(o$(dx),i,1)
1460 c=asc(c$)
1470 ifc<48orc>70thenerr$="?invalid hex char":return
1480 ifc>57andc<65thenerr$="?invalid hex char":return
1490 ifc>64andc<71thenc=c-55:goto1500
1495 c=c-48
1500 t=(t*16)+c
1510 nexti
1520 ret=t:return
1550 rem=====peek=command=============
1555 dx=1
1560 gosub 1700:rem address recognizer
1565 if err$<>"" then printerr$:return
1570 beg=ret
1575 en=ret+9:ifen>65535thenen=65535
1580 beg$=str$(beg):en$=str$(en)
1585 beg$=right$(beg$,len(beg$)-1)
1590 en$=right$(en$,len(en$)-1)+" "
1595 print:print beg$;
1600 print spc(40-len(beg$)-len(en$));
1605 print en$;
1610 fori=begtoen
1615 c=peek(i)
1620 c$=str$(c)
1625 c$=right$(c$,len(c$)-1)+" "
1630 if c<100 then c$="0"+c$
1635 if c<10 then c$="0"+c$
1640 print c$;
1645 nexti
1695 return
1700 rem=====address=recognizer=======
1710 err$=""
1715 ifo$(dx)=""thenerr$="?missing address":return
1720 c$=mid$(o$(dx),1,1)
1730 ifc$="$"thengosub1400:goto1760
1735 ifc$="p"andbf=0thengosub2100:goto1760
1740 gosub1900:goto 1760
1745 c=ret
1750 if(c<-128orc>65535)andbf=-1thenerr$="?address out of range":bf=0:return
1760 if(ret<0orret>65535)andbf=0thenerr$="?address out of range":bf=0:return
1765 if(ret<-128orret>255)andbf=1thenerr$="?byte out of range":bf=0:return
1768 ifret<0thenret=ret+256:print" "ret-256" =>";ret
1770 bf=0:return
1900 rem=====num=recognizer===========
1910 err$="":op=0
1915 ifo$(dx)=""then err$="?missing num":return
1920 s=0:t=0:mu=1:c$="":lc$="+":is=1
1930 c$=left$(o$(dx),1):c=asc(c$)
1940 if(c<48orc>57)andc<>45thenerr$="?invalid char":return
1950 ifc=45thenmu=-1:is=2
1960 fori=istolen(o$(dx))
1970 c$=mid$(o$(dx),i,1):c=asc(c$)
1975 if(c<48orc>57)andc<>45andc<>43thenerr$="?invalid char":return
1980 ifc>47andc<58thens=s*10+c-48
1990 if(c=45orc=43)and(lc$="-"orlc$="+")thenerr$="?adjacent signs":return
2000 ifc=45orc=43thent=t+mu*s:s=0:mu=1:op=1
2010 ifc=45thenmu=-1
2020 lc$=c$
2030 next i
2040 iflc$="-"orlc$="+"thenerr$="?exp ends with sign":return
2050 t=t+mu*s
2055 ifop=1thenprint " "o$(dx)" =>";t
2060 ret=t:return
2100 rem=====page/offset recognizer===
2110 err$="":pg=0:of=0:t=0:col=0
2115 iflen(o$(dx))<2thenerr$="?missing page":return
2120 fori=2tolen(o$(dx))
2130 c=asc(mid$(o$(dx),i,1))
2140 if(c<48)or(c>57andc<>58)thenerr$="?invalid char":return
2155 ifc=58andcol=1thenerr$="?too many colons":return
2160 ifc>47andc<58thent=t*10+c-48
2165 ifc=58thenpg=t:t=0:col=1
2170 nexti
2180 ifcol=0thenpg=t:goto2190
2185 of=t
2190 ifpg<0orpg>255thenerr$="?page out of range":return
2200 ifof<0orof>255thenerr$="?offset out of range":return
2210 ret=pg*256+of:return
2300 rem=====dh=command===============
2310 dx=1
2320 gosub 1900:rem num recognizer
2321 if err$<>"" then printerr$:return
2322 ifret<0thenprint"?number out of range":return
2325 c=ret
2327 gosub2330:print" "c$:return
2328 rem=====dh=support=function======
2330 c$=""
2340 t=fnr(c)
2350 ift>9then t$=chr$(t+55):goto2370
2360 t$=chr$(t+48)
2370 c$=t$+c$
2380 c=(c-t)/16
2390 ifc>0thengoto2340
2393 iflen(c$)=1thenc$="0"+c$
2395 c$="$"+c$
2400 return
2500 rem====suppress=command==========
2501 dx=1
2510 ifo$(dx)<>""thengoto2520
2512 print"suppress is ";
2515 ifsuppress=1thenprint"on. pokes are suppressed.":return
2516 print"off. pokes are active.":return
2520 if o$(dx)="on"then suppress=1:print"pokes are suppressed":return
2530 if o$(dx)="off"then suppress=0:print"pokes are active":return
2540 print"?bad param. specify on or off":return
2600 rem======sys=command=============
2610 dx=1
2620 ifo$(dx)<>""thengoto2720
2630 ifsy=-1thenprint"?no previous sys/run address":return
2640 ret=sy:goto2760
2720 gosub 1700:rem address recognizer
2730 if err$<>"" then printerr$:return
2760 ifo$(dx)=""thenprint" sys"ret
2770 sy=ret:sys ret:return
3000 rem======mem=command=============
3010 v=peek(45)+256*peek(46)
3015 s=peek(51)+256*peek(52)
3020 t=peek(55)+256*peek(56)
3025 printtab(3)"v:code end/vars start:";tab(27)v
3030 printtab(3)"s:string heap bottom:";tab(27)s
3035 printtab(3)"t:top of basic ram:";tab(27)t
3040 printtab(3)"gap size (s-v):";tab(27)s-v;"bytes"
3045 printtab(3)"special area:    49152-53247"
3050 printtab(3)"cassette buffer: 828-1019"
3060 printtab(3)"zero page bytes: 251-254"
3090 return
3100 rem=====poke=command=============
3110 dx=1
3120 gosub 1700:rem address recognizer
3130 if err$<>"" then printerr$:return
3140 add=ret
3150 dx=2
3160 ifleft$(o$(dx),1)="$"then gosub1400:goto3180
3170 gosub 1900:rem num recognizer
3180 if err$<>"" then printerr$:return
3185 if ret>255 then print"?byte param too large":return
3190 byte=ret
3200 if suppress=1thengoto3240
3205 rem:thenprint" poke";add;"[left],";byte
3210 ifo$(0)<>"g"thenprint" poke";add;",";byte
3215 ifo$(0)="g"thensp=1
3220 poke add,byte
3230 goto 3260
3240 rem print" pokes suppressed"
3245 rem:print" would poke";add;"[left],";byte
3250 print" would poke";add;",";byte
3260 dx=dx+1:add=add+1
3265 if dx>10thengoto3290
3270 ifo$(dx)<>""thengoto3160
3290 return
3300 rem=====list=command=============
3310 err$="":pg=20
3320 dx=1
3322 ifr1=-1orr2=-1thengoto3325
3323 ifo$(dx)=""thenbeg=r1:en=r2:goto3392
3325 ifo$(dx)=""then print"?address required":return
3330 gosub 1700:rem address recognizer
3340 if err$<>"" then printerr$:return
3350 beg=ret
3360 dx=2
3370 ifo$(dx)="" then en=ret:goto3397
3380 gosub 1700:rem address recognizer
3390 if err$<>"" then printerr$:return
3391 en=ret
3392 ifen<begthenprint"?end address too small":return
3396 print
3397 if beg+pg>en then pg=en-beg
3400 fori=begtobeg+pg
3405 c$=str$(i):c$=right$(c$,len(c$)-1)
3410 printc$;peek(i)
3420 nexti
3425 ifi>=en then return
3430 print"any key to continue, return to end"
3440 geta$:ifa$=""thengoto3440
3450 ifasc(a$)=13thengoto3500
3460 beg=beg+pg+1
3470 ifbeg<=enthengoto3397
3500 return
3510 rem=====pd=command===============
3520 dx=1
3530 gosub 2100:rem pd recognizer
3540 if err$<>"" then printerr$:return
3550 printret:return
3570 rem=====dp=command===============
3580 dx=1:d$=""
3590 gosub 1900:rem num recognizer
3595 if err$<>"" then printerr$:return
3600 ifret<0thenprint"?number out of range":return
3610 c=ret
3620 pg=int(c/256):of=c-(pg*256)
3630 pg$=str$(pg):of$=str$(of)
3635 pg$=right$(pg$,len(pg$)-1)
3636 of$=right$(of$,len(of$)-1)
3640 print" p";pg$;":";of$:return
3700 rem=====save=command=============
3710 dx=1
3720 ifo$(dx)=""thenprint"?file name required":return
3725 b1$=o$(dx)
3727 dx=2
3730 ifo$(dx)<>"1"ando$(dx)<>"8"thenprint"?device num error":return
3735 dv=asc(o$(dx))-48
3740 dx=3
3750 ifo$(dx)=""thenprint"?address required":return
3760 gosub 1700:rem address recognizer
3770 if err$<>"" then printerr$:return
3780 beg=ret
3790 dx=4
3800 ifo$(dx)=""thenprint"?end address required":return
3810 gosub 1700:rem address recognizer
3820 if err$<>"" then printerr$:return
3830 en=ret+1:rem save excludes last byte in range
3835 rem==============================
3840 poke780,15:poke781,dv:poke782,255:sys65466
3841 rem==============================
3845 poke 780,len(b1$)
3850 v=peek(45)+256*peek(46)
3860 lo=v+3: hi=v+4
3880 poke781,peek(lo):poke782,peek(hi)
3882 sys65469
3885 rem==============================
3890 poke 780,251
3900 eh=int(en/256):el=en-eh*256
3910 poke 781,el: poke 782,eh
3920 bh=int(beg/256):bl=beg-bh*256
3930 lo=v+10:hi=v+11
3935 print:print"saving ";b1$
3940 b2=peek(lo)+256*peek(hi)
3950 pokeb2,peek(251):pokeb2+1,peek(252)
3960 poke251,bl: poke252,bh
3970 sys65496
3980 poke251,peek(b2):poke252,peek(b2+1)
3990 if(peek(783)and1)=0thengoto4060
4000 print"?save failed. err code";peek(780);"."
4010 print" see prg page 306."
4020 print" see readst kernal call (sys65463)"
4030 print" (prg pg.292) for more details."
4040 print" please back up important code"
4050 print" changes manually."
4060 return
4070 rem=====load=command=============
4080 dx=1
4090 ifo$(dx)=""thenprint"?file name required":return
4100 b1$=o$(dx)
4105 dx=2
4110 ifo$(dx)<>"1"ando$(dx)<>"8"thenprint"?device num error":return
4120 dv=asc(o$(dx))-48
4130 rem==============================
4140 poke780,15:poke781,dv:poke782,255:sys65466
4150 rem==============================
4160 poke 780,len(b1$)
4170 v=peek(45)+256*peek(46)
4180 lo=v+3: hi=v+4
4190 poke781,peek(lo):poke782,peek(hi)
4200 sys65469
4210 rem==============================
4220 poke 780,0
4225 print:print"loading ";b1$
4230 sys65493
4240 if(peek(783)and1)=0thengoto4290
4250 print"?load failed. err code";peek(780);"."
4255 ifpeek(780)=4thenprint"?file not found."
4260 print" see prg page 306."
4270 print" see readst kernal call (sys65463)"
4280 print" (prg pg.292) for more details."
4290 return
4500 rem=====help=command=============
4501 print"[addr=49152,$c01a,p192:23 byte=173,$ff]":print
4510 print"suppress [on/off] :suppress pokes, asm"
4520 print"poke <addr> <byte> [byte...]  :poke"
4530 print"<addr> <byte> [addr/byte] [byte]: asm"
4540 print"init/new <addr> <addr> [byte] :fill ram"
4550 print"sys/run [addr] :run starting at address":print
4560 print"range [addr addr] :set default list rng"
4570 print"list [addr addr]  :list memory range"
4580 print"peek <addr>       :show memory"
4585 print"grid <addr> [num] :editable hex dump"
4590 print"save "chr$(34)"filename"chr$(34)",8 <addr> <addr>"
4600 print"load "chr$(34)"filename"chr$(34)",8"
4610 print"hd/dh <num>  :hex <-> decimal conv"
4620 print"pd/dp <addr> :pg/offset <-> dec conv"
4630 print"split <addr> :addr->low byte,high byte"
4635 print"comp <l byte> <h byte> :bytes -> addr"
4640 print"twosc <num>  :brnch inter -> two's comp"
4650 print"mem          :show free memory"
4660 print"help/h/?     :show this screen"
4670 print"x            :exit to basic":return
5000 rem=====range=command============
5010 dx=1:add=-1
5020 ifo$(dx)<>"" then goto 5050
5030 if r1=-1 or r2=-1 then print"?no range specified":return
5040 print"default range is"r1"-"r2:return
5050 ifo$(dx)=""thenprint"?address required":return
5060 gosub 1700:rem address recognizer
5070 iferr$<>""thenprinterr$:return
5080 add=ret
5090 dx=2
5100 ifo$(dx)=""thenprint"?end address required":return
5110 gosub 1700:rem address recognizer
5120 iferr$<>""thenprinterr$:return
5125 if ret<addthenprint"a2 must be larger than a1":return
5130 r2=ret:r1=add
5140 print"default range is now"r1"-"r2
5150 return
5200 rem=====str=command==============
5201 print"?not implemented: str":return
5300 rem=====split=command============
5310 dx=1
5320 gosub 1700:rem addr recognizer
5330 if err$<>"" then printerr$:return
5340 c=ret
5350 pg=int(c/256):of=c-(pg*256)
5360 printof;pg
5370 c=of:gosub2330:print" ";c$;
5380 c=pg:gosub2330:print" ";c$:return
5400 rem=====twosc=command============
5410 dx=1
5420 gosub 1900:rem num recognizer
5430 if err$<>""then print err$:return
5440 c=ret:gosub5470
5450 iferr$<>""then print err$:return
5455 print" "c-256"=>"c
5460 printc;:gosub2330:printc$:return
5470 rem=====twosc=support=function===
5540 ifc<-128orc>127thenerr$="?branch interval must be -128 to 127":return
5550 ifc<0thenc=c+256
5560 return
6000 rem=====init=command=============
6003 ifsuppress=1thenprint"pokes are suppressed. "o$(0)" disabled.":return
6005 beg=-1:en=-1:byte=-1
6010 ifdx<2thenprint"?start and end addresses required":return
6020 dx=1:gosub 1700
6030 if err$<>"" then printerr$:return
6040 beg=ret
6050 dx=2:gosub 1700
6060 if err$<>"" then printerr$:return
6070 if ret<begthenprint"?end address too small":return
6080 en=ret:dx=3
6090 ifo$(dx)=""thenbyte=96:print" default fill byte is 96 (rts)":goto6220
6100 bf=1:gosub 1700
6200 if err$<>"" thenprinterr$:return
6210 byte=ret
6220 print:print" !!! warning !!!"
6230 print" this operation will overwrite *all*"
6240 print" memory between"beg"and"en"!!!"
6250 print:print" type y e s (with spaces) to proceed:"
6260 input a$
6270 ifa$<>"y e s"thenprint" operation canceled":return
6280 print" overwriting"beg"to"en"with"byte
6290 fori=begtoen:pokei,byte:nexti
6300 print" operation complete, memory initialized":return
6500 rem=====grid=command=============
6510 dx=1
6520 gosub 1700:rem address recognizer
6530 iferr$<>""thenprinterr$:return
6540 add=ret
6550 dx=2:ifo$(dx)=""thenret=7:goto6598
6560 gosub1900:rem num recognizer
6570 iferr$<>""thenprinterr$:return
6580 ifret<1thenret=1:print"minimum displayed lines = 1"
6590 if ret>20thenret=20:print"max displayed lines = 20"
6595 ret=ret-1
6598 print
6600 fori=0toret
6610 byte=add+i*8
6615 c=byte:gosub2330
6620 print"g "c$" ";
6630 forj=0to7
6640 t=byte+j
6650 ift>65535thenprint:return
6660 c=peek(t)
6670 gosub2330:rem dh function
6680 ifj<7thenprintc$" ";:goto6690
6685 printc$
6690 nextj
6710 nexti
6720 return
6900 rem=====comp=command=============
6910 dx=1:bf=1
6920 gosub 1700:rem address recognizer
6930 iferr$<>""thenprinterr$:return
6940 add=ret
6950 dx=2:bf=1
6960 gosub 1700:rem address recognizer
6965 iferr$<>""thenprinterr$:return
6970 c=256*ret+add
6980 printc;
6990 gosub2330:print" ";c$
7000 return
11000 rem=====assembler=command=======
11025 ifdx<1thenprint"asm requires address and byte":return
11040 byte=-1:b2=-1:b3=-1
11050 dx=0
11060 gosub 1700:rem address recognizer
11070 iferr$<>""thenprinterr$:return
11080 add=ret
11090 dx=1:bf=1:gosub 1700:rem byte
11100 iferr$<>""thenprinterr$:return
11120 byte=ret
11160 dx=2:bf=-1:ifo$(dx)=""then goto11450
11170 gosub 1700:rem address recognizer
11180 iferr$<>""thenprinterr$:return
11190 ifret<256thenb2=ret:goto11290
11200 b3=int(ret/256):b2=ret-(b3*256):goto11450
11290 dx=3:ifo$(dx)=""then goto11450
11300 bf=1:gosub 1700:rem byte recognzr
11400 iferr$<>""thenprinterr$:return
11410 b3=ret
11450 ifsuppress=1thengoto11550
11460 poke add, byte
11470 print" poke"add","byte
11480 ifb2=-1thengoto12000
11490 poke add+1, b2
11500 print" poke"add+1","b2
11510 ifb3=-1thengoto12000
11520 poke add+2, b3
11530 print" poke"add+2","b3
11540 goto 12000
11550 print" would poke"add","byte
11560 ifb2=-1thengoto12000
11570 print" would poke"add+1","b2
11580 ifb3=-1thengoto12000
11590 print" would poke"add+2","b3
12000 sp=1:return
