'===============
' Drop-e  by Na 
'===============

'SAVE "NA_DRPE","11302"
'Package:
' SPU1,BGU0,BGU1,BGF0,SCU0

'LIST @LIST

PNLTYPE "OFF"
COLOR 0,0:CLS
GPAGE 1,1,1:GCLS 
GPAGE 0,0,0:GCLS 
SPPAGE 1:SPCLR 
SPPAGE 0:SPCLR 
BGPAGE 1:BGCLR 
BGPAGE 0:BGOFS 0,0,0:BGCLR 1
CLEAR
BGMSTOP 

?"Loading...
MEM$=""
SYSBEEP=0
SAVFILE$="MEM:NA_DRPE"
LOAD SAVFILE$,0

IF PACKAGE$=="11302" THEN @LDSKIP
LOAD "BGU0U:SLOP",0
LOAD "BGU1U:DROPE_LG",0
LOAD "SPU1U:NUM16",0
LOAD "SCU0U:DRP2",0
LOAD "BGF0U:HIRAKATA",0
BEEP 
@LDSKIP
SYSBEEP=1

BREPEAT 0,13,8
BREPEAT 1,13,8
BREPEAT 2,20,11
BREPEAT 3,20,11
SPPAGE 0
BGPAGE 0
GPAGE 0,0,0
GPRIO 1

FOR I=0 TO 3
 '252ハ゛ンノSPヲケス
 CHRSET "SPU3",240+I,"0"*64
 '52ハ゛ンノSPヲケス
 CHRSET "SPU0",208+I,"0"*64
NEXT

FOR I=0 TO 255
 'SPU1カラSPS1Lニコヒ゜-
 CHRREAD("SPU1",I),C$
 CHRSET "SPS1L",I,C$
 'BGF0カラBGU3ニコヒ゜-
 CHRREAD("BGF0",I),C$
 C2$=""
 FOR J=0 TO 63
  IF MID$(C$,J,1)=="0" THEN C2$=C2$+"3" ELSE C2$=C2$+"D"
 NEXT
 CHRSET "BGU3",I,C2$
 'BGF0カラBGF0Lニコヒ゜-
 CHRREAD("BGF0",I),C$
 CHRSET "BGF0L",I,C$
NEXT

GP=0

V_S=0 '〜-1:ヒョウシ゛ナシ(アニメフレ-ム) 0:ハンテイオワリ
V_T1=1
V_T2=2
V_BN=3
V_BC=4
V_BV=5
V_BP=6
V_X=7

'シュルイ
KMAX=26
DIM KC[KMAX]
DIM KBN[KMAX]
DIM KBC[KMAX]
DIM KBV[KMAX]
DIM KBP[KMAX]
DIM KX[KMAX]

DIM LV$[2]
LV$[0]="│л■л"
LV$[1]="а┰м├"
DIM HNT$[4]
HNT$[0]="е├"
HNT$[1]="Ы▲┼"
HNT$[2]="■мб"
HNT$[3]="ミス"

SVLEN=35
SVLEN1=17

'SE
BGMSET 128,"T480@86@D24B-6_<B-
BGMSET 129,"T480@86@D24<B-6_>B-
BGMSETD 140,@MTIT

'キョク
RESTORE @LIST
READ BGM_CNT
IF LEN(MEM$)<SVLEN*BGM_CNT THEN MEM$=MEM$+CHR$(0)*(SVLEN*BGM_CNT-LEN(MEM$))
DIM BGM_ID[BGM_CNT]
DIM BGM_VOL[BGM_CNT]
DIM BGM_TIT$[BGM_CNT]
DIM BGM_CMP$[BGM_CNT]
DIM BGM_LV[BGM_CNT,2]
DIM BGM_BG$[BGM_CNT]
FOR I=0 TO BGM_CNT-1
 READ ID,VOL,T$,C$,LV1,LV2
 BGM_ID[I]=ID
 BGM_VOL[I]=VOL
 BGM_TIT$[I]=T$
 BGM_CMP$[I]=C$
 BGM_LV[I,0]=LV1
 BGM_LV[I,1]=LV2
 BG$=""
 FOR J=0 TO 23
  BG$=BG$+"C"+HEX$(ASC(MID$(T$,J,1)+" ")+768,3)
 NEXT
 BGM_BG$[I]=BG$
NEXT
FOR I=0 TO BGM_CNT-1
 IF BGM_ID[I]>=128 THEN BGMSETD BGM_ID[I],"@M"+STR$(BGM_ID[I])
NEXT

CRB$="BG":CRI=&HDB:GOSUB @COLRD
BG_C$=C$
COLSET "BG",0,BG_C$
BGPAGE 1
BG_C1$="101020"
COLSET "BG",0,BG_C1$

VISIBLE 1,1,1,1,1,1

@TIT
GPAGE 1
SPPAGE 1
GCLS 
SPCLR

GPAGE 0
SPPAGE 0
BGPAGE 0
COLSET "BG",&HF6,"203880"
COLSET "BG",&HFF,"FFFFFF"
GCLS 
CLS
BGFILL 1,0,0,31,0,"801A"
'BGFILL 1,0,1,31,1,"80B380B4"
BGFILL 1,0,1,31,7,"8003"
BGOFS 1,0,-140

LOCATE 9,13:?"リス゛ムケ゛-ム
LOCATE 14,14:?"Drop-e

LOCATE 11,16:?"(c)2020 Na

LOCATE 13,19:?"Й Щ┝мбз
LOCATE 13,21:?"  ─кз
TSEL=0

BGMPLAY 0,140,70
TITCNT=0

@TITLOOP
 BX=256+12+8*SIN(RAD(TITCNT%360))
 BY=320+8+8*SIN(RAD(1.5*TITCNT%360))
 BGOFS 0,BX,BY
 
 VSYNC 1
 B=BUTTON(1)
 IF B AND 1+2 THEN BEEP 9:TSEL=!TSEL
 LOCATE 13,19:?MID$("Й ",TSEL,1)
 LOCATE 13,21:?MID$(" Й",TSEL,1)
 IF (B AND 16)>0 AND TSEL==0 THEN @MENULOAD
 IF (B AND 16)>0 AND TSEL==1 THEN @END
 
 TITCNT=(TITCNT+1.2)%720
GOTO @TITLOOP

@END
BEEP 4
BGMSTOP 0,1
ACLS
CHRINIT "BGU0U"
CHRINIT "BGU1U"
CHRINIT "SPU1U"
CHRINIT "SPS1L"
CHRINIT "BGF0U"
CHRINIT "BGF0L"
CHRINIT "BGU3L"
END


@MENULOAD
BEEP 3
BGMSTOP 0,0.5
COLSET "BG",&HF6,BG_C$
COLSET "BG",&HFF,BG_C$

MENUSCR=1
BGM=0

@MENU
CLS
GPAGE 1
SPPAGE 1
BGPAGE 1
GCLS
FOR I=0 TO 23
PNLSTR 0,I," "*32
NEXT
SPCLR
BGCLR

FOR I=0 TO 2
 SPSET I,92,12,0,0,0
 SPOFS I,24+I*28,58
 SPSCALE I,200
NEXT
FOR I=0 TO 5
 SPSET 30+I,64+10,0,0,0,0
 SPOFS 30+I,220-16*I,68
NEXT

GLINE 16,124,239,124,15
PNLSTR 9,17,"│┌□┌┝■ И Ш │┰м"
PNLSTR 16,17,"И",6
SPSET 3,92,0,0,0,0
SPOFS 3,66,150
SPSCALE 3,200
SPSET 4,64+13,0,0,0,0
SPOFS 4,98,160
PNLSTR 19,21,"/"+RIGHT$("  "+STR$(6*BGM_CNT),3)

STARNUM=0
FOR I=0 TO BGM_CNT-1
 STAR=ASC(MID$(MEM$,SVLEN*I,1))
 FOR J=0 TO 5
  IF STAR AND 1 THEN STARNUM=STARNUM+1
  STAR=STAR/2
 NEXT
NEXT
SV=STARNUM
FOR I=0 TO 1
 SPSET 5+I,64+10*(I>0 AND SV<10),0,0,0,0
 SPOFS 5+I,130-16*I,160
NEXT
SPANIM 5,SV%10+1,4,1
SPANIM 6,FLOOR(SV/10)+1,4,1


WAIT 1

GPAGE 0
SPPAGE 0
BGPAGE 0
GCLS
SPCLR
BGFILL 1,32,0,63,23,0
COLSET "BG",0,BG_C$
BG_MY=(40-30)/2
BG_MYG=BG_MY*8
BGOFS 0,256,BG_MYG-192
BGOFS 1,256,BG_MYG-192

LOCATE 0,23
?"↑↓:┥л┿┨┌ ←→:○л├□м А:Щ┝мбз Х:オ-ト ";
GFILL 0,183,255,191,26

NOBGM=0
MENUCNT=0
BGMSTOPCNT=0
MOVE=0
EXCHG=0
EX=0
GOSUB @MENU_LS
BGOFS 0,256,BG_MYG+36,15*MENUSCR
BGOFS 1,256,BG_MYG+36,15*MENUSCR
MENUSCR=0
GOSUB @MENU_LS1

VSYNC 1
@MENULOOP
 B=BUTTON(1)
 
 IF B AND 128 THEN AUTO=1:GOTO @GAME
 IF B AND 16 THEN AUTO=0:GOTO @GAME
 IF B AND 32 THEN BEEP 4:GOSUB @MENUWAIT:GOTO @TIT
 
 IF B AND 1 THEN MOVE=MOVE-1:BEEP 9
 IF B AND 2 THEN MOVE=MOVE+1:BEEP 9
 
 IF (B AND 4)>0 AND EXCHG==0 THEN EXCHG=-10:EX=!EX:BGMPLAY 129:GOSUB @MENU_LS1
 IF (B AND 8)>0 AND EXCHG==0 THEN EXCHG= 10:EX=!EX:BGMPLAY 128:GOSUB @MENU_LS1
 
 GOSUB @MENUFRM
GOTO @MENULOOP

@MENUFRM
 IF !BGMCHK(6) THEN BGMSTOPCNT=BGMSTOPCNT+1
 
 IF MOVE<0 THEN @MENU_UP
 IF MOVE>0 THEN @MENU_DN
 
 IF MENUCNT==15 THEN @MENU_MV
 
 IF (MENUCNT==20 OR BGMSTOPCNT>=120)AND !NOBGM THEN BGMPLAY 6,BGM_ID[BGM],BGM_VOL[BGM]:BGMSTOPCNT=0
 
 IF MENUCNT>15 AND EXCHG!=0 THEN @MENU_EX
 
@MENUFRME
 VSYNC 1
 IF MENUCNT<10000 THEN MENUCNT=MENUCNT+1
RETURN

@MENU_UP
 IF BGM==0 THEN @MENUUPSKP
 IF MENUCNT>15 THEN @MENU_RMV
 IF MENUCNT<0 THEN @MENUFRME
 BGM=BGM-1
 EX=0:EXCHG=0
 GOSUB @MENU_LS
 BGOFS 0,256,BG_MYG+60
 BGOFS 0,256,BG_MYG+36,6
 BGOFS 1,256,BG_MYG+60
 BGOFS 1,256,BG_MYG+36,6
 GOSUB @MENU_LS1
 MENUCNT=-6
@MENUUPSKP
 MOVE=MOVE+1
GOTO @MENUFRME

@MENU_DN
 IF BGM==BGM_CNT-1 THEN @MENUDNSKP
 IF MENUCNT>15 THEN @MENU_RMV
 IF MENUCNT<0 THEN @MENUFRME
 BGM=BGM+1
 EX=0:EXCHG=0
 GOSUB @MENU_LS
 BGOFS 0,256,BG_MYG+12
 BGOFS 0,256,BG_MYG+36,6
 BGOFS 1,256,BG_MYG+12
 BGOFS 1,256,BG_MYG+36,6
 GOSUB @MENU_LS1
 MENUCNT=-6
@MENUDNSKP
 MOVE=MOVE-1
GOTO @MENUFRME

@MENU_LS

FOR I=0 TO 10
 L=I>=5
 IF BGM-5+I<0 THEN @MLSCLR
 IF BGM-5+I>=BGM_CNT THEN @MLSCLR
 BGPUT L,32+3,BG_MY+I*3,"C0AD"
 BGFILL L,32+4,BG_MY+I*3,63-4,BG_MY+I*3,"C0AE"
 BGPUT L,63-3,BG_MY+I*3,"C0AF"
 BGPUT L,32+3,BG_MY+I*3+1,"C0CD"
 BGFILL L,32+4,BG_MY+I*3+1,63-4,BG_MY+I*3+1,"C0CE"
 BGPUT L,63-3,BG_MY+I*3+1,"C0CF"
 BGPUT L,32+3,BG_MY+I*3+2,"C0ED"
 BGFILL L,32+4,BG_MY+I*3+2,63-4,BG_MY+I*3+2,"C0EE"
 BGPUT L,63-3,BG_MY+I*3+2,"C0EF"
'キョクタイトル
 BGFILL L,32+4,BG_MY+I*3+1,63-4,BG_MY+I*3+1,BGM_BG$[BGM-5+I]
@MLSSKIP
NEXT

GFILL 24-4,80-2,232+3,114,0

RETURN

@MENU_LS1

SVDATA$=MID$(MEM$,SVLEN*BGM,SVLEN)
STAR=ASC(SVDATA$)
SVDATA1$=MID$(SVDATA$,1+SVLEN1*EX,SVLEN1)
SCORE$=LEFT$(SVDATA1$,5)
OLDSCORE=VAL("&H"+SCORE$)
SCORE$=RIGHT$("     "+STR$(OLDSCORE),6)
HNT1$=RIGHT$("   "+STR$(VAL("&H"+MID$(SVDATA1$,5,3))),4)
HNT2$=RIGHT$("   "+STR$(VAL("&H"+MID$(SVDATA1$,8,3))),4)
HNT3$=RIGHT$("   "+STR$(VAL("&H"+MID$(SVDATA1$,11,3))),4)
HNT4$=RIGHT$("   "+STR$(VAL("&H"+MID$(SVDATA1$,14,3))),4)

GPAGE 1
SPPAGE 1

GFILL 24,21,255,39,0
GT$=BGM_TIT$[BGM]
GX=24:GY=21:GS=2:GOSUB @GPRT_L
PNLSTR 3,6,LV$[EX]
L1$="Lv."+RIGHT$(" "+STR$(BGM_LV[BGM,EX]),2)
PNLSTR 9,6,L1$
PNLSTR 17,7,"ハイスコア"
SI=30:SC=6:SZ=0:SV=OLDSCORE:GOSUB @SCSET

FOR I=0 TO 3
PNLSTR 6+6*I,12,HNT$[I]
NEXT
PNLSTR 7,13,HNT1$
PNLSTR 13,13,HNT2$
PNLSTR 19,13,HNT3$
PNLSTR 25,13,HNT4$

B=1+7*EX
FOR I=0 TO 2
 SPCHR I,92,12*((STAR AND B)==0),0,0,0
 B=B*2
NEXT

GPAGE 0
SPPAGE 0

RETURN

@MLSCLR
 BGFILL L,32+3,BG_MY+I*3,63-3,BG_MY+I*3+2,0
GOTO @MLSSKIP

@MENU_MV
BGFILL 1,32+3,BG_MY+5*3,63-3,BG_MY+5*3+2,0
IF !NOBGM THEN BGOFS 0,256,BG_MYG+40,6
IF !NOBGM THEN BGOFS 1,256,BG_MYG+32,6

GPUTCHR 24-4,80-2,"BGU0",&HAD,12,1
GPUTCHR 24-4,88-2,"BGU0",&HCD,12,1
GPUTCHR 24-4,96-2,"BGU0",&HCD,12,1
GPUTCHR 24-4,104-2,"BGU0",&HCD,12,1
GPUTCHR 24-4,104+2,"BGU0",&HED,12,1
FOR I=32-4 TO 224-4 STEP 8
 GPUTCHR I,80-2,"BGU0",&HAE,12,1
 GPUTCHR I,88-2,"BGU0",&HCE,12,1
 GPUTCHR I,96-2,"BGU0",&HCE,12,1
 GPUTCHR I,104-2,"BGU0",&HCE,12,1
 GPUTCHR I,104+2,"BGU0",&HEE,12,1
NEXT
GPUTCHR 224+4,80-2,"BGU0",&HAF,12,1
GPUTCHR 224+4,88-2,"BGU0",&HCF,12,1
GPUTCHR 224+4,96-2,"BGU0",&HCF,12,1
GPUTCHR 224+4,104-2,"BGU0",&HCF,12,1
GPUTCHR 224+4,104+2,"BGU0",&HEF,12,1

L1$=LV$[0]+" Lv."+RIGHT$(" "+STR$(BGM_LV[BGM,0]),2)
L2$=LV$[1]+" Lv."+RIGHT$(" "+STR$(BGM_LV[BGM,1]),2)
GDRAWMD 1
'None  11000011
'Front 11001100
'Back  11100011
'Fr+Bk 11101100
'  XOR 00010000

GT$=BGM_TIT$[BGM]:GX=32-2:GY=88:GS=1:GP=2:GOSUB @GPRT_L
GT$=BGM_CMP$[BGM]:GX=32-2:GY=96:GS=1:GP=2:GOSUB @GPRT_L
GT$=L1$:GX=224+2:GY=96:GS=1:GP=0:GOSUB @GPRT_R
GT$=L2$:GX=224+2:GY=96:GS=1:GP=2:GOSUB @GPRT_R
GP=0:GOSUB @GPRT_R
GDRAWMD 0

CRB$="BG":CRI=&HC3:GOSUB @COLRD
COLSET "GRP",&HCC,"FFFFFF"
COLSET "GRP",&HE3,C$
COLSET "GRP",&HEC,"FFFFFF"
FOR J=5 TO 3 STEP -1
CRB$="BG":CRI=&HD0+J:GOSUB @COLRD
COLSET "GRP",&HD0+J,C$
NEXT
COLSET "GRP",&HDC,C$
COLSET "GRP",&HF3,"FFFF00"
COLSET "GRP",&HFC,"FFFF00"
COLSET "GRP",&H10,BG_C$

GOTO @MENUFRME

@COLRD
COLREAD(CRB$,CRI),CR,CG,CB
C$=HEX$(CR,2)+HEX$(CG,2)+HEX$(CB,2)
RETURN

@MENU_RMV
BGMSTOP 6,1
BGOFS 0,256,BG_MYG+36,6
BGOFS 1,256,BG_MYG+36,6
'GFILL 24-4,80-2,232+3,112+1,0
MENUCNT=-6
GOTO @MENUFRME

@MENU_EX
'x 24-4 → 224+4+8 = 216
'y 80-2 → 104+2+8
GDRAWMD 1
IF EXCHG>0 THEN GFILL 20+21.6*(10-EXCHG),78,20+21.6*(11-EXCHG)-1,114,&H10
IF EXCHG<0 THEN GFILL 20+21.6*(-1-EXCHG),78,20+21.6*(-EXCHG)-1,114,&H10
GDRAWMD 0
EXCHG=EXCHG-SGN(EXCHG)
GOTO @MENUFRME

@MENUWAIT
BGMSTOP 6,1
NOBGM=1
FOR WT=1 TO 60
 GOSUB @MENUFRM
NEXT
RETURN

'---------------------------
@GAME

BEEP 32

BGFILL 1,32+3,BG_MY+5*3,63-3,BG_MY+5*3+2,0
BGOFS 0,512,BG_MYG+40,24
BGOFS 1,512,BG_MYG+32,24

GOSUB @MENUWAIT

'---------------------------
'キョクヨミコミ
ID=BGM_ID[BGM]
VOL=BGM_VOL[BGM]
FLABEL$="@F"+STR$(ID)+"EX"*EX
FM$=""
TIT$=BGM_TIT$[BGM]
CMP$=BGM_CMP$[BGM]
SCGMAXS=100000
SCGCLRS=80000
SCBASE=100000
SCBONUS=60000

'RESTORE @KDFLT
FOR I=0 TO KMAX-1
 'READ KC[I],KN[I],KX[I]
 KC[I]=3
 KBN[I]=-1
 KBC[I]=0
 KBV[I]=127
 KBP[I]=64
 KX[I]=100
NEXT
@KDFLT
DATA 3,47,100
DATA 4,48,100

ONPCNT=0
RESTORE FLABEL$
READ TMP
LOOPC=0
FOR I=0 TO F$!=""
 READ F$
 IF !VAL(F$) THEN @OCLOOPSKP
  LOOPC=LOOPC+1
  IF LOOPC<VAL(F$) THEN RESTORE FLABEL$+"_L"
  GOTO @ONPCNT_S
 @OCLOOPSKP
 IF LEFT$(F$,1)=="@" THEN READ C,BN,BC,BV,BP,X:GOTO @ONPCNT_S
 FOR I=0 TO LEN(F$)-1
  C=ASC(MID$(F$,I,1))
  IF C>=ASC("A") AND C<=ASC("Z") THEN ONPCNT=ONPCNT+2
  IF C>=ASC("a") AND C<=ASC("z") THEN ONPCNT=ONPCNT+1
 NEXT
 @ONPCNT_S
 I=0
NEXT
RESTORE FLABEL$
READ TMP
LOOPC=0

BGMSET 255,"T"+STR$(TMP)+"[$0=0R16$0=1R16]"

MSCNT=FLOOR(4*3600/TMP+.5) 'ROUNDノカワリ
MSLEN=202
TGX=86:TGY=104

'--------------------------
'カ゛メン
CLS
GPAGE 1
SPPAGE 1
GCLS 
SPCLR 

GPAGE 0
BGPAGE 0
SPPAGE 0
GCLS 
BGOFS 0,0,320
BGOFS 1,0,0

'コンホ゛
CRB$="BG":CRI=&H3F:GOSUB @COLRD
COLSET "GRP",&H3F,C$
COLSET "GRP",&H30,BG_C$

'ハイケイ
BGFILL 1,0,0,63,23,"D00B"
BGFILL 1,40,4,42,5,"D042D043D044D062D063D064"
CRB$="BG":CRI=&H06:GOSUB @COLRD
COLSET "BG",&H8A,C$

FOR I=0 TO 31
 SPSET I,252,0,0,0,0
 SPHOME I,8,8
 SPSETV I,V_S,-100
 SPOFS I,-16,-16
NEXT
SPOFS 31,TGX,TGY
SPSCALE 31,200

GT$=TIT$:GX=246:GY=132:GS=2:GOSUB @GPRT_R
GT$=CMP$:GX=246:GY=152:GS=1:GOSUB @GPRT_R
GT$=LV$[EX]+" Lv.":GX=214:GY=176:GS=1:GOSUB @GPRT_R
GT$=STR$(BGM_LV[BGM,EX]):GX=246:GY=170:GS=2:GOSUB @GPRT_R
GT$="[オ-トフ゜レイ]":GX=246:GY=116:GS=1
IF AUTO THEN GOSUB @GPRT_R


SPPAGE 1
GPAGE 1

PNLSTR 20,22,"START▼мгбз"

GT$="スコア":GX=24:GY=21:GS=2:GOSUB @GPRT_L
PNLSTR 3,7,"ハイスコア"
PNLSTR 23,7,SCORE$

'スコアケ゛-シ゛
SCGX=25:SCGY=44
SCGLEN=207
SCGX2=SCGX+FLOOR(SCGLEN*(SCGCLRS/SCGMAXS))
GLINE SCGX,SCGY-1,256-SCGX,SCGY-1,15
GLINE SCGX,SCGY+6,256-SCGX,SCGY+6,15
GLINE SCGX-1,SCGY,SCGX-1,SCGY+5,15
GLINE 256-SCGX+1,SCGY,256-SCGX+1,SCGY+5,15
COLSET "GRP",&HF8,"383838"
COLSET "GRP",&HF9,"282828"
COLSET "GRP",&HFA,"505050"
COLSET "GRP",&HFB,"404040"
COLSET "GRP",&HFC,"00F018"
COLSET "GRP",&HFD,"208030"
COLSET "GRP",&HFE,"FFA000"
COLSET "GRP",&HFF,"8C6028"
GFILL SCGX,SCGY,SCGX2,SCGY+3,&HF8
GFILL SCGX,SCGY+4,SCGX2,SCGY+5,&HF9
GFILL SCGX2,SCGY,256-SCGX,SCGY+3,&HFA
GFILL SCGX2,SCGY+4,256-SCGX,SCGY+5,&HFB

FOR I=0 TO 5
 SPSET 30+I,64+10*(I>0),0,0,0,0
 SX=220-16*I:SY=21
 SPSETV 30+I,0,SX
 SPSETV 30+I,1,SY
 SPOFS 30+I,SX,SY
 SPSET I,64+10,7,0,0,0
 SX=220-16*I:SY=10
 SPSETV I,0,SX
 SPSETV I,1,SY
 SPOFS I,SX,SY
NEXT

GX=150:GS=1
GT$=HNT$[0]:GY=78:GOSUB @GPRT_L
GT$=HNT$[1]:GY=98:GOSUB @GPRT_L
GT$=HNT$[2]:GY=118:GOSUB @GPRT_L
GT$=HNT$[3]:GY=138:GOSUB @GPRT_L
GT$="Ш└ж":GY=158:GOSUB @GPRT_L

FOR I=0 TO 3
 SPSET 10+I,64+10*(I>0),0,0,0,0
 SPSET 15+I,64+10*(I>0),0,0,0,0
 SPSET 20+I,64+10*(I>0),0,0,0,0
 SPSET 25+I,64+10*(I>0),0,0,0,0
 SPSET 40+I,64+10*(I>0),0,0,0,0
 SPOFS 10+I,226-16*I,73
 SPOFS 15+I,226-16*I,93
 SPOFS 20+I,226-16*I,113
 SPOFS 25+I,226-16*I,133
 SPOFS 40+I,226-16*I,153
NEXT

HNT1C=0:HNT1C_O=0
HNT2C=0:HNT2C_O=0
HNT3C=0:HNT3C_O=0
HNT4C=0:HNT4C_O=0
SCORE=0:SCORE_O=0
SCADD=0
SCA=0
SCE=0:SCS=0
COMBO=0:COMBO_O=0
MAXCMB=0:MAXCMB_O=0
REST=ONPCNT:REST_O=REST
SI=40:SC=4:SZ=0:SV=REST:GOSUB @SCSET

IF ONPCNT<=100 THEN SCORE_MX=100000+20000/3*SQR(ONPCNT)
IF ONPCNT>100 THEN SCORE_MX=100000+20000/3/ONPCNT*1000+100000/ONPCNT*(ONPCNT-100)

FOR I=0 TO 2
 SPSET 7+I,92,12,0,0,0
 SPOFS 7+I,24+I*28,80
 SPSCALE 7+I,200
NEXT

SPPAGE 0
GPAGE 0
FOR I=0 TO 3
 SPSET 32+I,64+10,0,0,0,0
 SPSETV 32+I,2,64
 SPSETV 32+I,1,48
NEXT


FEND=0
SPI=0
FX=0
FS=0
CNT=0
OA=-1
BGMPLAY 7,255

GOTO @LOOP


@GPRT_R
FOR I=1 TO LEN(GT$)
 GPUTCHR GX-I*8*GS,GY,"BGF0",ASC(RIGHT$(GT$,I)),GP,GS
NEXT
RETURN
@GPRT_L
FOR I=0 TO LEN(GT$)-1
 GPUTCHR GX+I*8*GS,GY,"BGF0",ASC(MID$(GT$,I,1)),GP,GS
NEXT
RETURN

LASTC=MAINCNTL
STARTCNT=MAINCNTL

@LOOP
 IF FX<12 THEN SPCHR 31,252+3*!(FX%4),2,0,0,0
 
 A=BGMGETV(7,0)
 IF A!=OA AND !FEND THEN GOSUB @FREAD
 OA=A
 
 BT=0
 
 IF !AUTO THEN GOSUB @BTN
 IF AUTO THEN GOSUB @AUTO
 
 GOSUB @HNT
 
 GOSUB @MOVE
 
 GOSUB @SCOR
 
 IF MAINCNTL<STARTCNT THEN STARTCNT=STARTCNT-524287-1
 CNT=MAINCNTL-STARTCNT
 BGOFS 1,CNT/2,0
 
 'FPS=FPS+1
 'IF MAINCNTL-LASTC>59 THEN LOCATE 0,0:?FPS,:FPS=0:LASTC=MAINCNTL
 
 IF FEND THEN FEND=FEND+1
 IF FEND==MSCNT+60 THEN BGMSTOP 6,5
 IF FEND==MSCNT+120 THEN @RESULT
 
 VSYNC 1
 
 IF BUTTON() AND 1024 THEN @QUIT
 
GOTO @LOOP

@FREAD
 IF FX-FS<LEN(FM$) THEN @FRSKIP
 
 FS=FX
 READ FM$
 
 @FRCHK
 IF FM$=="" THEN FEND=1:RETURN
 
 IF VAL(FM$) THEN @FLOOPCHK
 
 IF LEFT$(FM$,1)=="@" THEN @FKSET
 
@FRSKIP
 IF FX==16 THEN BGMPLAY 6,ID,VOL
 
 NT$=MID$(FM$,FX-FS,1)
 FX=FX+1
 
 IF NT$==" " THEN RETURN
 
 S=2
 K=ASC(NT$)-ASC("A")
 IF K>26 THEN K=ASC(NT$)-ASC("a"):S=1
 C=KC[K]
 BN=KBN[K]
 BC=KBC[K]
 BV=KBV[K]
 BP=KBP[K]
 X=KX[K]
 
 SPOFS SPI,-16,-16
 SPCHR SPI,181,C,0,0,0
 SPSETV SPI,V_S,S
 SPSETV SPI,V_T1,CNT
 SPSETV SPI,V_T2,CNT+MSCNT
 SPSETV SPI,V_BN,BN
 SPSETV SPI,V_BC,BC
 SPSETV SPI,V_BV,BV
 SPSETV SPI,V_BP,BP
 SPSETV SPI,V_X,X
 
 SPI=SPI+1 AND 31
RETURN

@FKSET
 NT$=RIGHT$(FM$,1)
 K=ASC(NT$)-ASC("A")
 READ C,BN,BC,BV,BP,X
 IF C!=-1 THEN KC[K]=C
 IF BN!=-1 THEN KBN[K]=BN
 IF BC!=-1 THEN KBC[K]=BC
 IF BV!=-1 THEN KBV[K]=BV
 IF BP!=-1 THEN KBP[K]=BP
 IF X!=-1 THEN KX[K]=X
 READ FM$
GOTO @FRCHK

@FLOOPCHK
 LOOPC=LOOPC+1
 IF LOOPC<VAL(FM$) THEN RESTORE FLABEL$+"_L"
 READ FM$
GOTO @FRCHK

@MOVE
 FOR I=0 TO 31
  STAT=SPGETV(I,V_S)
  IF STAT<-10 THEN @MVSKIP
  IF STAT<0 THEN @MVANCNT
  IF STAT==1 THEN SPSCALE I,100
  IF STAT==2 THEN SPSCALE I,140
  T1=SPGETV(I,V_T1)
  T2=SPGETV(I,V_T2)
  XP=SPGETV(I,V_X)
  XD=MSLEN*XP/100
  P=(T2-CNT)/(T2-T1)*1.1
  D=MSLEN*P
  IF D>XD THEN @MV0
  IF D>0 THEN @MV1
  IF D>-56 THEN @MV2
 @MV3
  X=30
  Y=TGY-(D+56)*1.5
  IF Y>192+16 THEN SPSETV I,V_S,-100
  GOTO @MV
 @MV2
  X=TGX+D
  Y=TGY
  GOTO @MV
 @MV1
  X=TGX+D*0.832 'COS
  Y=TGY-D*0.555 'SIN
  GOTO @MV
 @MV0
  X=TGX+XD*0.832
  Y=TGY-XD*0.555-(D-XD)
 @MV
  SPOFS I,X,Y
  SPANGLE I,360*P*4 'MSLEN/(16*PI())
 @MVSKIP
 NEXT
RETURN

@MVANCNT
  SPSETV I,V_S,STAT-1
  IF STAT==-10 THEN SPOFS I,-32,-32
GOTO @MVSKIP


@AUTO
 FOR J=SPI TO SPI+31
  I=J AND 31
  
  IF SPGETV(I,V_S)<=0 THEN @ATSKIP
  T2=SPGETV(I,V_T2)
  IF CNT<T2 THEN J=J+32:GOTO @ATSKIP 'RETURN
  
  BT=BT+1
  J=J+32':GOTO @ATSKIP
  'RETURN
  
 @ATSKIP
 NEXT
RETURN

@HNT
 BN0=-1
 FOR J=SPI TO SPI+31
  I=J AND 31
  STAT=SPGETV(I,V_S)
  IF STAT<=0 THEN @HNTSKIP
  
  T2=SPGETV(I,V_T2)
  FRM=CNT-T2
  '-:ハヤイ +:オソイ
  IF FRM<-15 THEN J=J+32:GOTO @HNTEND 'RETURN
  
  BN=SPGETV(I,V_BN)
  BC=SPGETV(I,V_BC)
  BV=SPGETV(I,V_BV)
  BP=SPGETV(I,V_BP)
  IF BN0<0 THEN BN0=BN:BC0=BC:BV0=BV:BP0=BP
  
  IF !BT AND FRM>5 THEN @HNT4
  IF !BT THEN J=J+32:GOTO @HNTEND 'RETURN
  
 @HNTREDO
  BT=BT-1
  IF BN>=0 THEN BEEP BN,BC,BV,BP
  IF STAT==1 THEN SPSETV I,V_S,-1
  IF STAT==2 THEN SPSETV I,V_S,1
  
  IF ABS(FRM)<=2 THEN @HNT1
  IF ABS(FRM)<=4 THEN @HNT2
  
 @HNT3 'Bad
  IF STAT==1 THEN SPCHR I,252,0,0,0,0
  HNT3C=HNT3C+1
  COMBO=0
  REST=REST-1
  GOTO @HNTSKIP
  
 @HNT4 'Miss
  SPSETV I,V_S,0
  HNT4C=HNT4C+STAT
  COMBO=0
  SCADD=-FLOOR(SCBASE/ONPCNT+.5)
  SCORE=SCORE+SCADD
  REST=REST-STAT
  GOTO @HNTSKIP
  
 @HNT2 'OK
  IF STAT==1 THEN SPCHR I,48,0,0,0,0
  IF STAT==1 THEN SPANIM I,5,2,1
  HNT2C=HNT2C+1
  COMBO=COMBO+1
  IF COMBO>=MAXCMB THEN MAXCMB=COMBO
  IF COMBO>=100 THEN SCADD=SCBASE+SCBONUS ELSE SCADD=SCBASE+COMBO*(SCBONUS/100)
  SCADD=FLOOR(SCADD/ONPCNT*.6+.5)
  SCORE=SCORE+SCADD
  REST=REST-1
  GOTO @HNTSKIP
  
 @HNT1 'Good
  IF STAT==1 THEN SPCHR I,248,0,0,0,0
  IF STAT==1 THEN SPANIM I,5,2,1
  HNT1C=HNT1C+1
  COMBO=COMBO+1
  IF COMBO>=MAXCMB THEN MAXCMB=COMBO
  IF COMBO>=100 THEN SCADD=SCBASE+SCBONUS ELSE SCADD=SCBASE+COMBO*(SCBONUS/100)
  SCADD=FLOOR(SCADD/ONPCNT+.5)
  SCORE=SCORE+SCADD
  REST=REST-1
  
 @HNTSKIP
  IF BT>0 AND STAT==2 THEN STAT=1:GOTO @HNTREDO
 @HNTEND
 NEXT
 IF BN0<0 THEN BN0=KBN[0]:BC0=KBC[0]:BV0=KBV[0]:BP0=KBP[0]
 IF BT AND BN0>=0 THEN BEEP BN0,BC0,BV0,BP0
RETURN

@BTN
 B_=BUTTON()
 B=B_ AND NOT OB
 OB=B_
 
 FOR I=0 TO 9
  IF B AND 1 THEN BT=BT+1
  B=B/2
 NEXT
 
' IF TCHST AND !OT THEN BT=BT+1
' OT=TCHST
RETURN

@SCOR
SPPAGE 1
GPAGE 1
 
 SI=30
 IF SCORE<0 THEN SCORE=0
 IF SCORE!=SCORE_O THEN SC=6:SZ=0:SV=SCORE:GOSUB @SCSET:GOSUB @SCMOV
 IF SCORE!=SCORE_O THEN GOSUB @SCDRAW
 SCORE_O=SCORE
 
 SI=0
 IF SCADD THEN SC=6:SZ=-1:SV=SCADD:GOSUB @SCSET:GOSUB @SCMOV2
 SCADD=0
 SCADDC=SCADDC-1
 IF SCADDC==0 THEN GOSUB @SCADCLR
 
 SI=10
 IF HNT1C!=HNT1C_O THEN SC=4:SZ=0:SV=HNT1C:GOSUB @SCSET
 HNT1C_O=HNT1C
 
 SI=15
 IF HNT2C!=HNT2C_O THEN SC=4:SZ=0:SV=HNT2C:GOSUB @SCSET
 HNT2C_O=HNT2C
 
 SI=20
 IF HNT3C!=HNT3C_O THEN SC=4:SZ=0:SV=HNT3C:GOSUB @SCSET
 HNT3C_O=HNT3C
 
 SI=25
 IF HNT4C!=HNT4C_O THEN SC=4:SZ=0:SV=HNT4C:GOSUB @SCSET
 HNT4C_O=HNT4C
 
 SI=40
 IF REST!=REST_O THEN SC=4:SZ=0:SV=REST:GOSUB @SCSET
 REST_O=REST
 
SPPAGE 0
GPAGE 0
 
 SI=32:SC=4
 IF COMBO!=COMBO_O THEN SZ=-1:SV=COMBO:GOSUB @SCSET:GOSUB @SCCET:GOSUB @SCMOV
 IF COMBO>=100 AND COMBO_O<100 THEN GOSUB @SCCOL
 IF COMBO<100 AND COMBO_O>=100 THEN GOSUB @SCCOL
 IF COMBO_O==0 AND COMBO>0 THEN GT$="コンホ゛":GX=51:GY=70:GS=1:GOSUB @GPRT_L
 IF COMBO==0 AND COMBO_O>0 THEN GFILL 50,70,81,77,0
 COMBO_O=COMBO
 
RETURN

@SCSET
 CHG=-1
 SLE=0
 SCM=(SV<0):SCM_=SCM
 FOR I=0 TO SC-1
  IF SZ!=1 AND (SZ==-1 OR I!=0) AND SV==0 THEN SC1=10+2*SCM:SCM=0:GOTO @SCSCHR
  SLE=I+1
  SPREAD(SI+I),DM,DM,DM,DM,CH
  OSC1=CH%512-64
  SC1=ABS(SV%10):SV=SGN(SV)*FLOOR(ABS(SV/10))
  IF SC1==OSC1 THEN @SCSKIP
  CHG=I
 @SCSCHR
  IF SC1!=10 THEN SLE=I+1
  SPCHR SI+I,64+SC1
 @SCSKIP
 NEXT
RETURN
@SCMOV
 FOR I=0 TO CHG
  'SPREAD(SI+I),SX,SY
  SX=SPGETV(SI+I,0)
  SY=SPGETV(SI+I,1)
  SPOFS SI+I,SX,SY-4
  SPOFS SI+I,SX,SY,4
 NEXT
RETURN
@SCCET
 IF CHG<0 THEN RETURN
 FOR I=0 TO SLE-1
  SX=SPGETV(SI+I,2)
  SY=SPGETV(SI+I,1)
  SX=SX+16*(SLE/2-I-1)
  SPOFS SI+I,SX,SY
  SPSETV SI+I,0,SX
 NEXT
RETURN
@SCMOV2
 FOR I=0 TO SLE-1
  SX=SPGETV(SI+I,0)
  SY=SPGETV(SI+I,1)
  SPREAD(SI+I),DM,DM,DM,DM,CH
  SPCHR SI+I,CH%512,7+2*SCM_,0,0,0
  SPOFS SI+I,SX+8,SY
  SPOFS SI+I,SX,SY,8
 NEXT
 SCADDC=30
RETURN
@SCADCLR
 FOR I=0 TO 5
  SPCHR SI+I,64+10
 NEXT
RETURN
@SCCOL
 FOR I=0 TO SC-1
  SPREAD(SI+I),DM,DM,DM,DM,CH
  SPCHR SI+I,CH%512,3*(COMBO>=100),0,0,0
 NEXT
 GDRAWMD 1
 GFILL 51,70,82,77,&H30
 GDRAWMD 0
RETURN
@SCDRAW
 'SCS=SCGLEN*(SCORE_O/SCGMAXS)
 'IF SCS>SCGLEN THEN SCS=SCGLEN
 'SCS=SCGX-1+FLOOR(SCS)
 SCS=SCE
 IF SCS<SCGX-1 THEN SCS=SCGX-1
 
 SCE=SCGLEN*(SCORE/SCGMAXS)
 IF SCE>SCGLEN THEN SCE=SCGLEN
 SCE=SCGX-1+FLOOR(SCE)
 'SCB=SCGX-1+FLOOR(SCGLEN*.65)
 
 GDRAWMD 1
 IF SCE>SCS THEN GFILL SCS+1,SCGY,SCE,SCGY+5,&H04
 IF SCS>SCE THEN GFILL SCE+1,SCGY,SCS,SCGY+5,&H04
 GDRAWMD 0

RETURN


@QUIT
PNLSTR 20,22,"          "
BGMSTOP 6,1.5
WAIT 90

GOTO @MENU

@RESULT
SPPAGE 1
GPAGE 1
CLR=0
'SCE=SCGLEN*(SCORE/SCORE_MX)/.9
'IF SCE>=SCGLEN*.65 THEN CLR=1
IF SCORE>=SCGCLRS THEN CLR=1
IF CLR==1 AND REST+HNT3C+HNT4C==0 THEN CLR=2
IF CLR==2 AND HNT2C==0 THEN CLR=3

FOR I=0 TO 2
 IF CLR>I THEN SPCHR 7+I,92,0,0,0,0:BEEP 7:WAIT 20
NEXT

IF CLR==0 THEN GT$="┝┷Щ╂├":GX=30
IF CLR==1 THEN GT$="クリア":GX=46:GP=3
IF CLR==2 THEN GT$="フルコンホ゛":GX=24:GP=3
IF CLR==3 THEN GT$="ハ゜-フェクト":GX=14:GP=3
GY=116:GS=2:GOSUB @GPRT_L
GP=0

IF CLR==0 THEN BEEP 8

IF AUTO OR SCORE<=OLDSCORE THEN @HS_SKIP
WAIT 30
GT$="ハイスコア":GX=26:GY=144:GS=2:GOSUB @GPRT_L
GT$="└┼┝л!":GX=38:GY=164:GS=2:GOSUB @GPRT_L
BEEP 5

@HS_SKIP

CRB$="BG":CRI=&H3F:GOSUB @COLRD
COLSET "GRP",&H3F,C$
COLSET "GRP",&H30,BG_C1$

RSLTCNT=0
GDRAWMD 1
@RSLTLOOP
VSYNC 1
RSLTCNT=(RSLTCNT+1)%12
IF RSLTCNT==0 THEN GFILL 26,144,117,179,&H30
IF !BUTTON(2) THEN @RSLTLOOP
GDRAWMD 0

GOSUB @SAV

GOTO @MENU

@SAV
IF AUTO THEN RETURN
IF SCORE<=OLDSCORE THEN RETURN
IF CLR>=1 THEN STAR=STAR OR 1+EX*7
IF CLR>=2 THEN STAR=STAR OR 2+EX*14
IF CLR>=3 THEN STAR=STAR OR 4+EX*28
SVDATA$=CHR$(STAR)+RIGHT$(SVDATA$,34)
SVDATA1$=HEX$(SCORE,5)
SVDATA1$=SVDATA1$+HEX$(HNT1C,3)
SVDATA1$=SVDATA1$+HEX$(HNT2C,3)
SVDATA1$=SVDATA1$+HEX$(HNT3C,3)
SVDATA1$=SVDATA1$+HEX$(HNT4C,3)
SVDATA$=SUBST$(SVDATA$,1+SVLEN1*EX,SVLEN1,SVDATA1$)
MEM$=SUBST$(MEM$,SVLEN*BGM,SVLEN,SVDATA$)
SAVE SAVFILE$
RETURN

'---------------------------
@LIST
DATA 7
DATA 14,85,"BGM14","フ゜リセット",1,5
DATA 152,120,"リス゛ミカルГチャイム","オリシ゛ナル",2,6
DATA 153,115,"BGM11(アレンシ゛)","フ゜リセット",2,7
DATA 150,80,"Get Started!","オリシ゛ナル",3,7
DATA 23,95,"BGM23","フ゜リセット",4,8
DATA 2,90,"BGM02","フ゜リセット",4,10
DATA 151,127,"│кжд┌вШ","オリシ゛ナル",5,10

@F2
DATA 190
DATA "@A",3,52,-1024,-1,-1,-1
DATA "@B",5,53,-256,-1,-1,-1
DATA "@C",4,58,0,-1,-1,20
DATA "@D",10,54,0,-1,-1,60

DATA "        
@F2_L
DATA "a   b       b       b       b   
DATA "a   b       b       b       b   

DATA "A     c     c       b       b   
DATA "A     c     c         c     b   
DATA "A     c     c       b       b   
DATA "A     c     c         c     c   

DATA "a   b   c       a   b   c       
DATA "a   b   c       a   b   D   D   

DATA "A     b     a     a     a   b   
DATA "a   C           a   C           
DATA "A     b     a     a     a   b   
DATA "a   C           a   C   d   d   
DATA "a       a       a   a   c   c   
DATA "2"
DATA ""


@F2EX
DATA 190
DATA "@A",3,52,-1024,-1,-1,-1
DATA "@B",5,53,-256,-1,-1,-1
DATA "@C",4,58,0,-1,-1,20
DATA "@D",10,54,-1,-1,-1,60

DATA "aaaaddd 
@F2EX_L
DATA "A ddB d a d B d a ddB d a d B d 
DATA "A ddB d a d B d a ddB d a d B d 

DATA "A d b C a d C b a d B d a d B d 
DATA "A d b C a d C b a d C b C d b d 
DATA "A d b C a d C b a d B d a d B d 
DATA "A d b C a d C b a d C b C d C d 

DATA "A d B d ccd c d A d B d ccd c d 
DATA "A d B d ccd c d A d B d CdddCdd 

DATA "A b c A b c B d a d   dda d b d 
DATA "A d C d C d b d A d C d C d b d 
DATA "A b c A b c B d a d   dda d b d 
DATA "A d C d C d b d A d C d Cdd Cddd
DATA "A a ddd A a ddd A a ddd Cdd Cdd 
DATA "2"
DATA ""

@F14
DATA 140
DATA "@A",3,29,-1000,-1,-1,-1
DATA "@B",4,27,-3000,-1,-1,60
DATA "@C",6,26,0,-1,-1,35
@F14_L
DATA "a       a       a       a   b   
DATA "a       a       a       a   b   
DATA "a       a       a   b       c   
DATA "a       a       a       a   b   
DATA "a       c       a       c       
DATA "b               a   a   a       
DATA "2"
DATA ""

@F14EX
DATA 140
DATA "@A",3,29,-1000,-1,-1,-1
DATA "@B",4,27,-3000,-1,-1,75
DATA "@C",6,26,0,-1,-1,55
DATA "@D",10,28,-700,-1,-1,25
@F14EX_L
DATA "a d b c   a b c a b bd  c d   dd
DATA "a d b c   a b c a b bd  c d   dd
DATA "a b a b a bd  c a b   c d d bbbb
DATA "a d b c   a b c a b bd  c d   dd
DATA "a d bbd a d b d a d bbd a d b d 
DATA "a a a a a aaa a D c D c D c c   
DATA "2"
DATA ""


@F150
DATA 170
DATA "@A",3,52,-1,-1,-1,-1
DATA "@B",5,53,-1,-1,-1,70
DATA "@C",4,57,-1,100,-1,30

DATA "a     a         b     b         
DATA "A     a         B     b   c     

DATA "a     a         a     b         
DATA "a     a         a     b     c   
DATA "a     a         a     b         
DATA "a     a         a     b     c   

DATA "a     a         a     b     b   
DATA "a     a         a     b     c   
DATA "a     a         a     b     b   
DATA "a     a         a     b     c   

DATA "a     a     b   a     b     b   
DATA "a     a     a   a     b     c   
DATA "a     a     b   a     b     b   
DATA "a     a     a   a     b     c   

DATA "A     a     b   A     b     b   
DATA "A     a     a   A     b     c   
DATA "A     a     b   A     b     b   
DATA "A     a     a   A     b     c   

DATA "a     a     b   a     a     b   
DATA "a     a     b   a     c   c     
DATA "A     a     b   A     a     b   
DATA "A     a     b   A     c   c     
DATA "A   a   B   b   
DATA ""

@F150EX
DATA 170
DATA "@A",3,52,-1,-1,-1,-1
DATA "@B",5,53,-1,-1,-1,70
DATA "@C",4,57,-1,100,-1,30
DATA "@G",6,54,-200,100,-1,50

DATA "@P",2,55,-683,40,-1,10
DATA "@R",2,55,0,40,-1,10
DATA "@S",2,55,341,40,-1,10
DATA "@T",2,55,683,40,-1,10
DATA "@U",2,55,1024,40,-1,10

DATA "R a a b a a R a S a a b a a S a 
DATA "R aga b a a R a S aga b agb b b 

DATA "R a b a a a b a a g b a a g b a 
DATA "P a b a a a b a a g b a a g b ag
DATA "R a b a a a b a a g b a a g b a 
DATA "P a b a a a b a a g b a a g b ag

DATA "R a b a a agb a a agb a a g b a 
DATA "P a b a a agb a a agb a a g b ag
DATA "R a b a a agb a a agb a a g b a 
DATA "P a b a a agb a a agb a a g b ag

DATA "R a b c a bgc a a agb a a b c a 
DATA "P a b c a bgc a a agb a a b c ag
DATA "R a b c a bgc a a agb a a b c a 
DATA "P a b c a bgc a a agb a a b c ag

DATA "S agb c a bgc a a agb a a bgc a 
DATA "R agb c a bgc a a agb a a bgc ag
DATA "S agb c a bgc a a agb a a bgc a 
DATA "R agb c a bgc a a agb a a bgc ag

DATA "R a a b a a R a S a a b a a S a 
DATA "T a a b a a T a U a a b a P c a 
DATA "R aga b aga R a S aga b aga S a 
DATA "T aga b aga T a U aga b a P c ag

DATA "C g C g C g C g 
DATA ""

@F151
DATA 144
DATA "@A",3,31,-1536,-1,-1,-1
DATA "@B",5,30,-1024,95,-1,60
DATA "@C",4,26,-1,-1,-1,30

DATA "a   b   a   b   a   b   a   c   
DATA "a   b   a   b   a   b   c   c   
DATA "a   b   a   b b a   b   b  c  c 
DATA "a   b   a   b b a   b   c  c  c 

DATA "a   b   a   b b a   b   a  c  b 
DATA "a   b   a   b b a   b   b  c  c 
DATA "a   b   a   b b a   b   a  c  b 
DATA "a   b   a   b b a   b   c  c  c 
DATA "A   b   a   b b A   b   a  c  b 
DATA "A   b   a   b b A   b a b  c  c 
DATA "A   b   a   b b A   b   a  c  b 
DATA "A   b   a   b b A   b a c  c  c 

DATA "A   b   a  c  a A   b   a  c  a 
DATA "A   b   a  c  a A   b   a   b b 
DATA "A   b   a  c  a A   b   a  c  a 
DATA "A   b   a  c  a A   b   a a a a 
DATA "a   b   a  a  b a   b   a  a  b 
DATA "a   b   a  a  b a   b   a   c c 
DATA "a   b   a  a  b a   b   a  a  b 
DATA "a   b   a  a  b a   b   c c c c 

DATA "a   b   a  c b  a   b   a  c b  
DATA "a   b   a  c b  a   b   c   c   
DATA "a   b   a  c b  a   b   a  c b  
DATA "a   b   a  c b  a   b   c c c c 
DATA "A   b   a  c b  A   b   a  c b  
DATA "A   b   a  c b  A   b   c   c   
DATA "A   b   a  c b  A   b   a  c b  
DATA "A   b   a  c b  A   b   c c c c 
DATA "A   A   C   C   A
DATA ""

@F151EX
DATA 144
DATA "@A",3,31,-1536,-1,-1,-1
DATA "@B",5,30,-1024,95,-1,60
DATA "@C",4,26,-1,-1,-1,30
DATA "@D",10,27,-512,-1,-1,45

DATA "A aabaa a dacda A aabaa a dabda 
DATA "A aabaa a dacda A aabaa a dabdca
DATA "A aabaa a dacdb A aabaa abd cd b
DATA "A aabaa a dacdb A aabaa abd cdab

DATA "aaaab   a d  cb a aab ddabd cd b
DATA "aaaab   a d  cb a db dc db dc  b
DATA "aaaab   a d  cb a aab ddabd cd b
DATA "aaaab   a d  cb a db dc db dcaab
DATA "A aab   a d  cb A a b ddabd cd b
DATA "A aab   a d  cb A db dc db dc  b
DATA "A aab   a d  cb A a b ddabd cd b
DATA "A aab   a d  cb A  B  C  B  Caab

DATA "Aaa Bdd   acbda Aaa Bdd   acbda 
DATA "Aaa Bdd c a bda Aaa Bdd c a bdc 
DATA "Aaa Bdd   acbda Aaa Bdd   acbda 
DATA "Aaa Bdd c a bda Aaa Bdd c a aaaa
DATA "Aaaabdd A acb a Aaaabdd A acb a 
DATA "Aaaabdd C a b a Aaaabdd C a b c 
DATA "Aaaabdd A acb a Aaaabdd A acb a 
DATA "Aaaabdd C acb c Aaaabdd C acb c 

DATA "A aaba aA ddbcb A aaba aAbddbc b
DATA "A aaba aA ddbcb A aaBaa AbddCd b
DATA "A aaba aA ddbcb A aaba aAbddbc b
DATA "A aaba aA ddbcb A aaBaa AbddCd b
DATA "Aac Bac Aacdb c Aac Bac Abcdb cb
DATA "Aac Bac Aacdb c Aac Bac AbcdCd b
DATA "Aac Bac Aacdb c Aac Bac Abcdb cb
DATA "Aac Bac Aacdb c Aac Bac AbvdCd b
DATA "A aaAdddAaaaAbccA
DATA ""

@F23
DATA 120
DATA "@A",3,52,-256,-1,-1,-1
DATA "@B",5,53,-512,-1,-1,10
DATA "@C",4,54,-256,-1,-1,50
@F23_L
DATA "a   a  c    c   a   a  c    c   
DATA "a   a  c    c   a   a   b   b b 
DATA "A   a  c    c   a   a  c    c   
DATA "A   a  c    c   a   a   b   b b 
DATA "a  b  a  a  b   a  b  a  c  b   
DATA "a   b  c    b   a   b  c    b   
DATA "A   b   a   b   a   b   a   b c 
DATA "A   b   a   b   a   a   b b b b 
DATA "2"
DATA ""

@F23EX
DATA 120
DATA "@A",3,52,-256,-1,-1,-1
DATA "@B",5,53,-512,-1,-1,10
DATA "@C",4,54,-256,-1,-1,50
@F23EX_L
DATA "A b a bcA b a ccA b a bcA b a c 
DATA "A b a bcA b a ccA b a bcA baCccc
DATA "A b a bcA baa ccA b a bcA baa c 
DATA "A b a bcA baa ccA b a bcA baCccc
DATA "AcbacabcAcbacac AcbacabcAcbacac 
DATA "A bca b A bca c AccBccAccBccAccc
DATA "A b a bcA b a bcA b a bcA baa c 
DATA "A b a bcAcb a bcAcbcacbcAcacCccc
DATA "2"
DATA ""

@F152
DATA 140
DATA "@A",3,31,2500,-1,-1,-1
DATA "@B",5,30,-650,-1,-1,60
DATA "@C",4,60,-400,100,-1,40
DATA "c       c       c               
DATA "c       c       c               
DATA "A       a       a       a   b   
DATA "A       a       a       a   b   

DATA "A       a   b   a       a   c   
DATA "A       a   b   a       c   c   
DATA "A       a   b   a       a   c   
DATA "A       a   b   a       c   c   
DATA "A   b   a   b   a       a   c   
DATA "A   b   a   b   a       c   c   
DATA "A   b   a   b   a       a   c   
DATA "A   b   a   b   a       c   c   

DATA "A       a   c   B       a   c   
DATA "A       a   c   B       a   c   
DATA "A   b   a   c   A   b   a   c   
DATA "A   b   a   c   A   b   c   c   
DATA ""

@F152EX
DATA 140
DATA "@A",3,31,2500,-1,-1,-1
DATA "@B",5,30,-650,-1,-1,60
DATA "@C",4,60,-400,100,-1,40
DATA "@D",10,27,500,-1,-1,20

DATA "A d c d c d c d A d   d   d   d 
DATA "A d c d c d c d A d   d   d   d 
DATA "A d c d a d a d A d c d a d   d 
DATA "A d c d a d a d A d c d a d c c 

DATA "A d b d a d b c A d b d a d c c 
DATA "A d b d a dc  c A d b d a d c c 
DATA "A d b d a d b c A d b d a d c c 
DATA "A d b d a dc  c A d b d a c c c 
DATA "A d b d a d b c A d b d a d c c 
DATA "A d b d a dc  c A d b d a d c c 
DATA "A d b d a d b c A d b d a d c c 
DATA "A d b d a dc  c A d b d a c c c 

DATA "A d b d a b B   A d b d a b B   
DATA "A d b d a b B c A d b d a b B c 
DATA "A d b d a d b d A d b d a d b d 
DATA "A d b d a d b   A d b d a b B   

DATA "A d c d c d c d A d b d a d c   
DATA "A d c d c d c d A d b d a d c   
DATA "A d c d c d c d A d b d a d c   
DATA "A d c d c d c d A d b d c c ccc 
DATA "A d c d c d c d A d b d a d c   
DATA "A d c d c d c d A d b d a d c   
DATA "A d c d c d c d A d b d a d c   
DATA "A d c d c d c d A d b d c c ccc 

DATA "A d b d c d b d c d b d c d b   
DATA "A d b d c d b d c d b d c d c d 
DATA "A d b d c d b d c d b d c d b   
DATA "A d b d c d b d c d b d c d c c 
DATA ""

@F153
DATA 154
DATA "@A",2,61,-1900,-1,-1,-1
DATA "@B",4,62,-4096,-1,-1,40

DATA "  
@F153_L
DATA "a   b   a       a   b   a       
DATA "a   b   a       a   b   b       
DATA "a   b   a       a   b   a       
DATA "a   b   a   b   b   a   a       
DATA "A   b   a   b   a   a   a       
DATA "A   b   a   b   a   a   b       
DATA "A   b   a   b   a   a   a       
DATA "A       A       b   b   b   b   
DATA "2"
DATA ""

@F153EX
DATA 154
DATA "@A",2,61,-1900,-1,-1,-1
DATA "@B",4,62,-4096,-1,-1,40
DATA "@C",10,56,4600,-1,-1,30

DATA "cc
@F153EX_L
DATA "A b aab aab a bba c c c c c c bb
DATA "A b aab aab a bba c c c c c c bb
DATA "A b aab aab a bba c c c c c a a 
DATA "A b a b A   A   A cca a a   a a 
DATA "A b a b a cca b A b a b a c c a 
DATA "A b a b a cca b A b a b a c c c 
DATA "A b a b a cca b A b a b a c c a 
DATA "A b a b a c a b A b ab ac c cccc
DATA "2"
DATA ""
'---------------------------

@M150
DATA"T170
DATA"{E1=@E127,90,100,124}
DATA"{E2=@E127,70,80,124}

DATA":10@144{E1}V85L8
DATA"CRRCRRC4 D-RRD-RRD-4
DATA"V80
DATA"CRRCRRC4 D-RRD-RD-4.

DATA"[
DATA"@145V85
DATA"{A0=
DATA" B24_<C12_C4>G4.E8._E16_C C4CD4EC4
DATA" A24_B-12_B-4F4.D8._D16_>B- B-4B-<C4DE4}
DATA"[{A0}]2
DATA"V80[{A0}]2
DATA"V75[{A0}]2
DATA"V70
DATA"[A-4.F4.D-4 >A-4A-B-4<D->A-4<
DATA" G4.E4.C4 >G4GA4<CG4]2

DATA"@144V85
DATA"{B0=
DATA" CRRCRRC4 D-RRD-RRD-4
DATA" DRRDRRD4 E-RRE-RE-4.}
DATA"{B0}
DATA"V80{B0}
DATA"GRGRB-4B4
DATA"]

DATA":11@144{E1}V80L8
DATA"R1R1
DATA"GRRGRRG4 A-RRA-RA-4.

DATA"[
DATA"@145
DATA"[R1R1 R1R1]2
DATA"{A1=
DATA" F24_G12_G4E4.C8._C16_>G G4GA4<C>G4<
DATA" E24_F12_F4D4.>B-8._B-16_F F4FG4B-<C4}
DATA"[{A1}]2
DATA"V75[{A1}]2
DATA"V70
DATA"[F4.D-4.>A-4 F4FF4A-F4<
DATA" E4.C4.>G4E4EE4G<C4]2

DATA"@144V80
DATA"R1R1 R1R1
DATA"GRRGRRG4 A-RRA-RRA-4
DATA"ARRARRA4 B-RRB-RB-4.
DATA"CRCRF4F4
DATA"]

DATA":2@144{E1}V70L8O4
DATA"ERR2E4 FRR2F4
DATA"ERRERRE4 FRRFRF4.

DATA"[@147{E2}V80O5
DATA"[R1R1 R1R1]4
DATA"D24_E12DEE32_F8..E24F24E24DC DE8._E16_>GG&G2<
DATA"C24_D12CDD32_E8..DCD16C16& C1
DATA"D24_E12DEE32_F8..E24F24E24DC DE8._E16_>GG&G2<
DATA"C24_D12CDD32_E8..DEF16G16& G1

DATA"@146V75
DATA"G16_A-2...F4.._F16_D-D-2 C2..E16F16G1
DATA"G16_A-2...B-4.._B-16_A-A-2 G2..A16B16<C1>

DATA"@144{E1}V70O4
DATA"ERR2E4 FRR2F4
DATA"F+RR2F+4 GRR4.G4.
DATA"ERRERRE4 FRRFRRF4
DATA"F+RRF+RRF+4 GRRGRG4.
DATA"ERERD4D4
DATA"]

DATA":3@147{E2}V80L8O5
DATA"R1R1 R1R1

DATA"[
DATA"[R1R1 R1R1]6

DATA"@146V75
DATA"E-16_F2...D-4.._D-16_>A-A-2 G2..<C16D16E1
DATA"E-16_F2...F2F2 E2..E16E16E1

DATA"@147V80
DATA"[R1R1 R1R1]2
DATA"R1
DATA"]

DATA":4@274@E127,90,60,127
DATA"V90L8O3
DATA"[[C<C>]4[D-<D->]4]2

DATA"[
DATA"[[C<C>]8[>B-<B-]7C<C>
DATA" [C<C>]8[>B-<B-]6[C<C>]2]3
DATA"[[D-<D->]8[C<C>]8]2

DATA"[[C<C>]4[D-<D->]4
DATA" [D<D>]4[E-<E->]4]2
DATA"[C<C>]2>B-<B->B<B
DATA"]

DATA":12@275@E127,100,80,127
DATA"V90L4P45
DATA"C2.C D-2.D-
DATA"C2.C D-2&D-8D-.

DATA"[
DATA"[[C.C.C]2
DATA" >B-.B-.B- B-.B-.<C
DATA" [C.C.C]2
DATA" >B-.B-.B- B-.B-<C.]3
DATA"[D-.D-.D-]2
DATA"[C.C.C]2
DATA"[D-.D-.D-]2
DATA"C.C.C4 C.CC.

DATA"C2.C D-2.D-
DATA"D2.D E-2&E-8E-.
DATA"C.C.C D-.D-.D-
DATA"D.D.D E-.E-E-.
DATA"CC>B-B<
DATA"]

DATA":5@128V127L8O2
DATA"[C]

DATA":6@128V127L8O2
DATA"[D4.D4.D4]3D4.D4DDD

DATA"[
DATA"[[R4D4R4D4]7R4D4RDDD]4

DATA"[[D4.D4.D4]3D4.D4DDD]2
DATA"D4D4DDDD
DATA"]

DATA":7@128V90L16O2
DATA"[F+8G+F+G+8F+8G+F+G+8F+8G+8]3
DATA" F+8G+F+G+8F+8G+F+G+8G+8G+G+

DATA"[
DATA"[[F+8G+F+F+8G+8]15
DATA"  F+8G+F+G+8G+G+]4

DATA"[[F+8G+F+G+8F+8G+F+G+8F+8G+8]3
DATA"  F+8G+F+G+8F+8G+F+G+8G+8G+G+]2
DATA"[F+8G+F+]3G+8G+G+
DATA"]

DATA":8@128V115L1O3P70
DATA"AAAA2&A8A4.

DATA"[
DATA"[A[R]7]3
DATA"A[R]3A[R]3

DATA"[AAAA2&A8A4.]2
DATA"A4A4A4A4
DATA"]

DATA":9@151V70L8Q2P55
DATA"{A9=C<A>Q4C>Q2D16<<Q2G16>Q2}
DATA"[CR>F+R<]7{A9}
DATA"[
DATA"[[CR<AR>]7{A9}]8
DATA"[CR>F+R<]7C>F+<Q4CQ2>F+<
DATA"[CR>F+R<]7{A9}
DATA"CR<AR>C<A>Q4CQ2<G>
DATA"]

DATA 0

'---------------------------
@M151
DATA "T144
DATA ":0@366V100L8Q6>>>
DATA "[[AR]4]8
DATA "[[AR]4]16
DATA "[ARARR4.A]8[[AR]4]8
DATA "[[AR]4]16ARARAAAA
DATA "A

DATA ":1@129@E127,95,0,127
DATA " L16V127@D-88>>
DATA "{SD=@V127E@V0}
DATA "{A1=R4{SD}R8.R4{SD}R8.}
DATA "{B1=R4{SD}R8.R4{SD}R{SD}R}
DATA "{C1=R4{SD}R8.R{SD}R8{SD}R8{SD}}
DATA "[{A1}]4[{B1}{C1}]2
DATA "[{B1}{C1}]8
DATA "[{A1}]15{C1}
DATA "[{B1}{C1}]8R1
DATA "{SD}

DATA "{E2=@E125,122,0,127V55}
DATA ":2@129L16{E2}>>
DATA "{A2=@D-64G+G+(15@D0A+)15@D-64G+@D0}
DATA "{D2=(7@D0[A+32]5R.)7}
DATA "{F2=@ERV127@D-128<D8C8>BAGF{E2}}
DATA "{B2={A2}{D2}{F2}}
DATA "{C2=@D-64G+G+@ER@D0A+8{E2}}
DATA "{G2=G+8G+8G+G+F+F+
DATA " @ERV127@D-128<DDCC>B32B32A32A32GF{E2}}
DATA "[R1]4[{A2}]12{B2}
DATA "[[{A2}]28{B2}]2
DATA "[{C2}]31{D2}
DATA " [{A2}]30@ER@D0[A+8]4{E2}
DATA "[{A2}]28{B2}[{A2}]31{D2}
DATA "{G2}

DATA "{O4=@E127,50,0,90O6B1}
DATA "{I4=@E3,127,127,127O5R4B2&B8.._<BR32}
DATA ":4@151V40L1P45
DATA "[R]3{I4}{O4}[R]3
DATA "[R]16
DATA "[{O4}[R]6{I4}]2
DATA "[{O4}[R]6{I4}]2{O4}

DATA "{I4}

DATA ":13@146@E127,100,0,127
DATA " L16V70Q6P45>>
DATA "{GB=GGGG <G>GGG GG<B->G <A>G<G>G}
DATA "{FB=FFFF <F>FFF FF<A>F <G>F<F>F}
DATA "{EB=E-E-E-E- <E->E-E-E- E-E-<G>E- <F>E-<E->E-}
DATA "{FB_=F+F+F+F+ <F+>F+F+F+ F+F+<A>F+ <G>F+<F+>F+}
DATA "{GB_=GGGG <G>GGG GG<B>G <A>G<G>G}
DATA "{EB_=EEEE <E>EEE EE<G>E <F+>E<E>E}
DATA "[[{GB}]3{FB}]2
DATA "[{GB}{FB}{EB}{FB_}]4
DATA "[{GB}{EB}{FB}{FB_}]4
DATA "[{GB_}{FB_}{EB_}{FB_}]4GGGGG2._>>G<<

DATA "[G]16

DATA ":14@144@E127,90,0,127
DATA " L16@V42V0Q7
DATA "{GA=P40B-<P60DP80GP60D>}
DATA "{FA=P40A<P60CP80FP60C>}
DATA "{EA=P40GP60B-<P80E->P60B-}
DATA "{DA=P40F+P60A<P80D>P60A}
DATA "{GA_=P40B<P60DP80GP60D>}
DATA "{FA_=P40B<P60DP80F+P60D>}
DATA "{EA_=P40G<P60CP80EP60C>}
DATA "{GA}(8{GA}(8{GA}(8{GA}(8
DATA "{GA}(8{GA}(8{GA}(8{GA}(8
DATA "{GA}(8{GA}(8{GA}(8{GA}(8
DATA "{FA}(8{FA}(8{FA}(8{FA}(7
DATA "[{GA}]12[{FA}]4
DATA "P64[[G4]4[A4]4[G4]4[F+4]4]2
DATA "[[{GA}]4[{FA}]4[{EA}]4[{DA}]4]2
DATA "[R1]16
DATA "V0
DATA "[R1]4
DATA "{GA_}(8{GA_}(8{GA_}(8{GA_}(8
DATA "{FA_}(8{FA_}(8{FA_}(8{FA_}(8
DATA "{EA_}(8{EA_}(8{EA_}(8{EA_}(8
DATA "{DA}(8{DA}(8{DA}(8{DA}(7
DATA "[[{GA_}]4[{FA_}]4[{EA_}]4[{DA}]4]2
DATA "G4_G2._>>G<<

DATA "P64B-GD>B-[B-]12

DATA "{P=@92@E127,7,0,115
DATA " @ML48,1,4,48V100P70}
DATA ":5{P}L1
DATA "[GGGF]2
DATA "[GAGF+]4
DATA "[GGAA]4
DATA "[GF+GF+]4G4R2.
DATA "G

DATA ":6{P}L1
DATA "[DDDC]2
DATA "[DFE-D]4
DATA "[DE-FE-]4
DATA "[DDED]4D4R2.
DATA "D

DATA ":7{P}L1>
DATA "[B-B-B-A]2
DATA "[B-<C>B-A]4
DATA "[B-B-<CC>]4
DATA "[BB<C>A]4B4R2.
DATA "B-

DATA "{E10A=@E90,80,80,110}
DATA "{E10L=@E70,80,100,110}
DATA "{V10=V45}
DATA ":10@145{E10A}
DATA " @MP24,1,8,24L8{V10}P80
DATA "G.R.G.R.B-_B-16_A16
DATA "G.R.G.R.F_F16_G16
DATA "G.R.G.R.B-_B-16_A16
DATA "F.R.A.R.F+_F+16_G16
DATA "G.R.G.R.B-_B-16_<C16>
DATA "G.R.G.R.F_F16_G16
DATA "G.R.G.R.B-_B-16_<C16>
DATA "B-.R.A.R.F+_F+16_G16
DATA "{V10}(5
DATA "{A10=
DATA "G16A16B-16<C16D4.C.>B-.
DATA " A4.B-16A.G.F.
DATA "E-16F16G16A16B-4.A.G.
DATA " F+.G.A.G.F+4
DATA "G16A16B-16<C16D4.E-.D.
DATA " C4.D16C.>B-.A.
DATA "G16F16E-16F16G4.F.E-.
DATA " D.E-.F+.B-.}
DATA "{A10}A._A16_G
DATA "{A10}A.R16
DATA "@147{E10L}@MOF{V10}
DATA "G32_B-4...&B-.<C._C16_D16
DATA " E-2E-.D.E-
DATA "E-32_F4...D8.E-.F8
DATA " E-2D4._D16_F16
DATA ">B-32_<D4...&D.F._F16_G16
DATA " E-2E-.F.G
DATA "G32_A4...A.G.F
DATA " E-2F+4._F+8_>F+
DATA "G2&G.A.B-
DATA " B-2B-.<C.D>
DATA "A2B-.A.G
DATA " F+2A4.<C
DATA "D2&D.F.G
DATA " G2G.A.B-
DATA "<C2C.E-.F
DATA " E-4D4F+8_F+16_>F+16A8_<A8>>
DATA "@145{E10A}@MON{V10}(10
DATA "{C10=
DATA "D2E8_E16_GG8A.
DATA " F+2F+8_F+16_AA8B.
DATA "E2E8_E16_CC8E.
DATA " F+4A8._A16_GG8._G16_AF+4
DATA "G2G8_G16_BB8G.
DATA " B2B8_B16_<DD8E.
DATA "C2C8_C16_>AA8G.
DATA " A4<C8._C16_D>B8._B16_<C>}
DATA "{C10}A8._A16_D
DATA "{C10}A8._A16_G
DATA "{E10L}G4_G2._>>G<<
DATA "R1

DATA 0

'---------------------------
@MTIT
DATA"T158
DATA":0@146@E127,40,0,127
DATA"V75L8O4
DATA"{A0=<C2RCRC& C2RCR>B-& B-2..B-& B-2&B-B4.
DATA"    <C2RCRC& C2RCRF& F2..D& D2&D>B4.}
DATA"{B0=<C2&C>B4. B-2&B-B-4. A2&AA4. B2&BB4.
DATA"    <C2&C>A4. B2&BB4. G2&GA4. B2&BB4.}
DATA"{C0=[<C2&CC4.> A2&AA4. A2&AA4. B2&BB4.]2}
DATA"
DATA"{A0}[[{A0}]2 [{B0}]2 [{C0}]3]

DATA":1@146@E127,40,0,127
DATA"V75L8O4
DATA"{A1=G2RGRG& G2RGRF& F2..F+& F+2&F+G4.
DATA"    G2RGRG& G2RGRB-& B-2..F+& F+2&F+G4.}
DATA"{B1=G2&GG4. F2&FF4. F2&FF4. G2&GG4.
DATA"    F2&FF4. G2&GG4. E2&EF4. G2&GG4.}
DATA"{C1=[G2&GG4. E2&EE4. F2&FF4. G2&GG4.]2}
DATA"
DATA"{A1}[[{A1}]2 [{B1}]2 [{C1}]3]

DATA":2@80@E127,20,0,127
DATA"@V110L8O5{V=V105}
DATA"{A2={V}C)10C(10D)5E4C>(5B)5G {V})10 E4.(5 G4<)5CD E  
DATA" {V})10>B-)5B-(5<(5CD4.E(5D&  D2 C>(5B4)10<D
DATA"    {V}E)10E(10F)5G4E (5D)5C {V})10>G4.(5<C4 )5EF>B-<
DATA" {V})10 D )5D (5 (5EF4.G(5F+& F+2}
DATA"
DATA"[R1]8
DATA"[
DATA" {A2}D(5>B4)10G< {A2}D(5E)15G(5B
DATA"
DATA"{V}
DATA" <C2&C>)5B4.(5 B-1 A2&A)5F4.(5 G1
DATA" F2&F)5E4.(5 D1 E2&E)5F4.(5 D1
DATA"{V}
DATA" G2&G)5G4.(5 F2&F)5E4.(5 D2&D)5F4.(5 E1
DATA" F2&F)5A4.(5 G2&G)5E4.(5 G2&G)5A4.(5 G2&GF4.
DATA"
DATA"{V}
DATA" E2&E)10F(5ED(5 C2)10CD(5EC(5 F2&F)10G(5F E (5 D1
DATA" G2&G)10A(5GF(5 E2)10EF(5GE(5 A2&A)10A(5B<C>(5 B2)5A(5G4.
DATA" E4)20CE4(10F(5ED(5 C4)20D>B<(10CD(5EC(5 F4)20EF4(10G(5F E (5 D4)20CD4(5>B4.<(15
DATA" G4)20EG4(10A(5GF(5 E4)20F D (10EF(5GE(5 A4)20FA4(10A(5B<C>(5 B)20<C>(15B)5A)5B(10<C(5D4
DATA" C1[R1]7
DATA"]

DATA":3@80@E127,127,127,127Q8
DATA"{F=)2B)2A+)2A)2G+)2G)2F+)2F)2E)2D+)2D)2C+)2C}
DATA"{A3=@V60V127L32O8C>{F}>{F}>{F}>{F}>{F}>)2B)2A+)2AR1R1}
DATA"
DATA"[{A3}]2
DATA"[
DATA" [R1]8 {A3}[R1]4
DATA"
DATA" [R1]8
DATA" [R1]8
DATA"
DATA"@V60V127O6L8Q7
DATA" [[E]8[C]8[F]8[D]8]4
DATA "Q8
DATA" [{A3}]2
DATA"]

DATA":4@144@E127,90,100,127
DATA"V90L8O2
DATA"{C4=E<C>GC4}
DATA"{B_4=F<D>B-D4}
DATA"{BA4=F+<D>B-D4}
DATA"{F4=F<C>AC4}
DATA"{E4=EBG>B4<}
DATA"{G4=G<D>BD4}
DATA"{A4=E<C>AC4}
DATA"
DATA"{_A4={C4}EGC {C4}EGB- {B_4}FB-D {BA4}F+BG}
DATA"{_B4={C4}EGC {B_4}FB-D {F4}FAC {E4}EG>B<
DATA" {F4}FAC {G4}GBD {E4}EG>B< {G4}GBD}
DATA"{_C4=[{C4}EGC {A4}EAC {F4}FAC {G4}GBD]2}
DATA"
DATA"[{_A4}]2[[{_A4}]4[{_B4}]2[{_C4}]3]
DATA"

DATA ":7@151V65L8O6
DATA "{A7=>B64_<F64R16.}
DATA "[[RR{A7}R]15RR{A7}{A7}]

DATA ":9@151V80L8Q2O4
DATA "[CRRCRCRR]

DATA ":8@151V35L8O7
DATA "[Q1BQ2B]
DATA 0

'---------------------------
@M152
DATA"T140
DATA":0@11V90L8<
DATA"{S0=C4E4D4>B4&B2&BGAB<C4E4F4}
DATA"{S0}D4&D1{S0}G4&G1
DATA"[
DATA"{A0=C2&C>B<CDE2&ECEGF4.ED.E16F.D16E2&EDED
DATA"    C2&CCEGA2&AAGFG4.AB.A16G.F+16G2&G}
DATA" {A0}DED
DATA" {A0}DE>B<
DATA" C2.DC>B-2.<D>B-<E2.CGF2&FDEF
DATA" A2&ADFAG2&GCDED2&DEDEC1
DATA" {S0}D4&D1{S0}G4&G2AGFE
DATA" {S0}D4&D1{S0}G4&G2&GGAB
DATA" <C4>R4C4R4E4R4C4R4F4R4>B-4<R4D4R4>B-4B4<
DATA" G4R4C4R4E4R4C4R4F4R4>B-4<R4D4R4>B-4B4<
DATA"]
DATA":1@14V70L8<
DATA"{S0}D4&D1{S0}D4&D1
DATA"[
DATA" [R1]16
DATA" [R1]8
DATA" [R1]8
DATA" {S0}D4&D1{S0}D4&D1
DATA" [R1]8
DATA"]
DATA"
DATA":2@74V55L8<<
DATA"{C2=@E124,127,127,60C4R2.@ER}
DATA"{S2=C4E4D4>B4<{C2}C4E4F4D4{C2}
DATA"    C4E4D4>B4<{C2}C4E4F4D4}
DATA"R1{S2}
DATA"[
DATA" {C2}[R1]7
DATA" >E2..G<C1D4.C>B.<C16D.C16>B1
DATA" G2..<EF2..ED4.EF.E16D.C16>B1
DATA" G1F1G1A1<D1C1>B1<C1
DATA" R1{S2}{C2}{S2}
DATA" {C2}R1R1R1C1>G1B-1F2.G4<
DATA"]
DATA"
DATA":3@1V80L8
DATA"[E4E4D4D4&D4R2D4]4
DATA"[
DATA" [[RE]8[RF]4[RE]4[RE]4[RF]4[RD]8]2
DATA" [RE]3D4[RD]3D4[RE]3E4[RF]3E4
DATA" [RF]3F4[RE]3E4[RD]3E4REREERE4
DATA" [RERERDRD&D4R2D4]8
DATA" [[RE]8[RD]8]2
DATA"]
DATA":4@1V80L8
DATA"[C4C4>B4B4B<CDEFE>B4<
DATA" C4C4>B4B4B<CDEFG>B4<]2
DATA"[
DATA" [[RC]8[RC]4>[RB]4<[RC]4[RC]4>[RB]8<]2
DATA" [RC]3>B4[RB-]3B-4<[RC]3C4[RC]3C4
DATA" [RD]3D4[RC]3C4>[RB]3B4<RCRCCRC4
DATA" [RCRC>RBRBB<CDEFE>B4<
DATA"  RCRC>RBRBB<CDEFG>B4<]4
DATA" [[RC]8>[RB-]7RB<]2
DATA"]
DATA"
DATA":5@43V70L4>>
DATA"[<C2>B2G1]4
DATA"[
DATA" [[<C>G]4[AF]2[BG]2[<C>G]2[AF]2BGBF+[BG]2]2
DATA" [<C>G]2[B-F]2[GE]2AFAE
DATA" [AF]2[<C>G]2[BG]2[<C>G]2
DATA" [<C>G[BG]3]8
DATA" [[<C>G]4[B-F]3B-G]2
DATA"]
DATA"
DATA":6@128V100L4>>
DATA"C1C1C1C1[CCCC]3CCCC8C8
DATA"[
DATA" [CDCD]16
DATA" [CDCD]7CDC8D8D
DATA" [CDCD]16
DATA" [CDCD]8
DATA"]
DATA":7@128V80L8>>
DATA"[[RG+]4]8
DATA"[
DATA" [[RG+]4]16
DATA" [[RG+]4]7[RG+]3G+4
DATA" [[RG+]4]16
DATA" [[RG+]4]8
DATA"]
DATA"
DATA 0

'---------------------------
@M153
DATA"T154
DATA"{E=@E127,70,0,120Q7}
DATA":0@107{E}V110L16

DATA"A<C[
DATA"{A0=D8C24D24C24C>AG8
DATA"  G24A24G24GFC8>A<C}
DATA"{A0}C16_D8.&D2R8A<C
DATA"{A0}>F16_G8.&G2<R8A<C
DATA"{A0}C16_D8.&D2D8F8
DATA"G16._G16._FGD8G8
DATA" A16._A16._G16_A<C8._C16_>A
DATA" <C16_D2...>

DATA"{B0=G8D24C24D24F8G8
DATA"  A8<C24>A24<C24>A8<C8>
DATA"  A<D>A<DE16_F16D8>}
DATA"{B0}B-16_<C16>A8A8D8
DATA"{B0}B-16_<C16C+8D8F8>
DATA"{B0}B-16_<C16>A8A8D8
DATA"F2 E2
DATA"C+EAC+EAC+E A4A24A24A24A<C
DATA"]

DATA":1@106
DATA"V110L16Q6

DATA"R8[
DATA"A8A<DF8F8 FF8FFD>DF
DATA" R8DFFGGA A8AGA8<C8>
DATA"A8A<DF8F8 FF8FFD>DF
DATA" R8DFF8G8 A8G8A8<C8>
DATA"A8A<DF8F8 FF8FFD>DF
DATA" R8DFFGGA AGGFF8D8
DATA"GDFG8DFG AFGA<C8>A8
DATA" <CDAFD>AFD D4.R8

DATA"L8
DATA"[>B-B-<F>B-< CCAC
DATA" DDAD CCAC]3
DATA">B-B-<F>B- B-B-<E>B-<
DATA"[A16]16
DATA"]

DATA":2@77V100L8

DATA"R8[
DATA"[R1]7R2.A<C>

DATA"{A2=<C24_D12>A<C24_D12>A<C24_D12C>}
DATA"{A2}A24_B-12<C> A2.._A8_G
DATA"{A2}<E24_F12E- D2.._D8_C>
DATA"{A2}A24_B-12<C> A2.._A8_G
DATA"F24_G12DGB-G24_A12EA<C
DATA" C16_C+8.C16_C+8.C16_C+4&C+16_C+8_C>
DATA"]

DATA":3@107{E}V85L8O2

DATA"R8[
DATA"[F<F>]2G<G>A<A> <[D<D>]4>
DATA"[F<F>]2G<G>A<A> [G<G>]4
DATA"[F<F>]2G<G>A<A> <[D<D>]4>
DATA"[G<G>]2A<A>A<A> <[D<D>]4>

DATA"[[B-<B->]2<[C<C>]2 [D<D>]3C<C>>]3
DATA"[B-<B->]2<[C<C>]2 [C+<C+>]4
DATA"]

DATA":4V120O3
DATA"{A=@116F+}{B=@117C+}
DATA"R8[
DATA"[[L8{A}{B}]4]15
DATA"L8{A}{B}L16{A}L8{B}L16{A}L8{B}{A}L16{B}{B}{B}{B}
DATA"]

DATA 0

