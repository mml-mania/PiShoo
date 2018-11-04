'PiShoo
option strict

'vars
var GEND=0,GTYPE=0
var G_XSW=640, G_XSH=360, G_XSA=16/9
var G_WIDTH=16
var G_CW=40, G_CH=22

var oldfs, oldx, oldy, oldw, oldh
var oldsw, oldsh, oldsa
var i,clk$[60]

'for xinput
var CTL_UP=   pow(2,#BID_UP)
var CTL_DOWN= pow(2,#BID_DOWN)
var CTL_LEFT= pow(2,#BID_LEFT)
var CTL_RIGHT=pow(2,#BID_RIGHT)
var CTL_A=    pow(2,#BID_A)
var CTL_B=    pow(2,#BID_B)
var CTL_X=    pow(2,#BID_X)
var CTL_Y=    pow(2,#BID_Y)
var CTL_LB=   pow(2,#BID_LB)
var CTL_RB=   pow(2,#BID_RB)
var CTL_START=pow(2,#BID_START)
var CTL_LT=   pow(2,#BID_LT)
var CTL_RT=   pow(2,#BID_RT)
var CTL_BACK= pow(2,#BID_BACK)
var CTL_LS=   pow(2,#BID_LS)
var CTL_RS=   pow(2,#BID_RS)
var CTL_HOME= pow(2,#BID_HOME)

'initialize
xscreen out oldsw, oldsh, oldsa
xscreen G_XSW, G_XSH, G_XSA
width out oldfs
width G_WIDTH
console out oldx, oldy, oldw, oldh
console 0,0,G_CW,G_CH
clk$[0]="000"
for i=1 to 59
 clk$[i]=format$("%03D",floor(1000*i/60))
next

while 1
 call "title" out GTYPE
 if (GTYPE == 1) or (GTYPE == 2) then
  call "rensha", GTYPE
 elseif (GTYPE == 9) then
  break
 endif
 wait 1
wend
'game end
quit
end

def quit
 bgmstop
 xscreen oldsw,oldsh,oldsa
 width oldfs
 console oldx,oldy,oldw,oldh
 acls
end

def title out GTYPE
 'title gamen
 var b, i
 var titlestr1$, titlestr2$
 var menumax=11 '10+terminate
 var items
 var item_no, item_id[menumax], item_str$[menumax], item_len[menumax]
 var cx, cy, cw, ch, menuw, menux, menuy
 var c_item
 gcls:cls

 'print title
 titlestr1$="Pi Shooting"
 titlestr2$="Select game mode"
 
 color #WHITE
 cprint g_CW,titlestr1$,6
 cprint g_CW,titlestr2$,8
 'menu
 'read menu item
 restore @MENUITEM
 for item_no=0 to menumax-1
  read item_id[item_no], item_str$[item_no]
  if item_id[item_no] == 0 then
   items=item_no
   break
  else
   item_len[item_no]=len(item_str$[item_no])
  endif
 next
 
 'print menu items
 menuw=max(item_len)
 menux=floor((G_CW-menuw)/2)
 menuy=10
 for i=0 to items-1
  locate menux,menuy+i
  print item_str$[i]
 next i

 'menu select
 c_item=0
 locate menux-1, menuy+c_item: print ""
 while 1
  b=button(2,-1,0)
  if (b and CTL_DOWN) or (b and CTL_BACK) then
   locate menux-1, menuy+c_item: print " "
   inc c_item
   if items<=c_item then c_item=0
   locate menux-1, menuy+c_item: print ""
  endif
  if (b and CTL_UP) then
   locate menux-1, menuy+c_item: print " "
   dec c_item
   if c_item<0 then c_item=items-1
   locate menux-1, menuy+c_item: print ""
  endif
  if (b and CTL_A) or (b and CTL_B) or (b and CTL_START) then
   GTYPE=item_id[c_item]
   break
  endif
  vsync 1
 wend
 
 @MENUITEM
 data 1,"SHOOTING A"
 data 2,"SHOOTING AB"
 data 9,"EXIT"
 data 0,"z" 'terminate
end

def rensha GTYPE
 var exit=#FALSE
 var msg$,typebtn$,b
 var bhist[3,600],bhit,sf,restf,rests
 if GTYPE==1 then
  typebtn$="A"
 elseif GTYPE==2 then
  typebtn$="A/B"
 endif

 'game main loop
 while exit==#FALSE
  gcls:cls
  bhit=0
  cprint g_CW,"Push "+typebtn$+" button to start",6
  wait 1 'flush button()
  'wait start
  while 1
   b=button(2,-1,0)
   if GTYPE==1 then
    if b and CTL_A then
     bhist[0,0]=bhit+1
     bhist[1,0]=1
     bhist[2,0]=0
     inc bhit
     break
    endif
   elseif GTYPE==2 then
    if b and CTL_A then
     bhist[0,0]=bhit+1
     bhist[1,0]=1
     bhist[2,0]=0
     inc bhit
     break
    endif
    if b and CTL_B then
     bhist[0,0]=bhit+1
     bhist[1,0]=2
     bhist[2,0]=0
     inc bhit
     break
    endif
   endif
   vsync 1
  wend

  'start!!
  vsync 1 'flush button()
  locate 14,10
  print "shots       sec"
  sf=MAINCNT
  while 1
   if MAINCNT-sf>=600 then break
   restf=599-(MAINCNT-sf)
   'rests=floor(restf/60)
   rests=ceil(restf/60)
   locate 23,10
   if 1<rests and rests<=3 then
    color #YELLOW
   elseif rests<=1 then color #RED
   else color #WHITE
   endif
   'print str$(rests)+"."+clk$[restf mod 60]
   print format$("%2D",rests)
   locate 10,10
   b=button(2,-1,0)
   if GTYPE==1 then
    if b and CTL_A then
     bhist[0,bhit]=bhit+1
     bhist[1,bhit]=1
     bhist[2,bhit]=MAINCNT-sf
     inc bhit
    endif
   elseif GTYPE==2 then
    if b and CTL_A then
     bhist[0,bhit]=bhit+1
     bhist[1,bhit]=1
     bhist[2,bhit]=MAINCNT-sf
     inc bhit
    endif
    if b and CTL_B then
     bhist[0,bhit]=bhit+1
     bhist[1,bhit]=2
     bhist[2,bhit]=MAINCNT-sf
     inc bhit
    endif
   endif
   color #WHITE
   print format$("%3D",bhit)
   vsync 1
  wend

  'result
  color #WHITE
  locate 10,15:print "Result"
  locate 11,16:print "Total: "+str$(bhit)+" hits"
  locate 11,17:print "Rensha:"+str$(bhit/10)+" rensha/sec"
  'for i=0 to bhit-1
  ' print bhist[0,i],bhist[1,i],bhist[2,i]
  'next

  'retry?
  wait 60
  locate 10,19:print "Push A button to retry."
  locate 10,20:print "Push B button to menu."
  while 1
   b=button(2,-1,0)
   if b and CTL_A then break
   if b and CTL_B then
    exit=#TRUE
    break
   endif
   vsync 1
  wend
 wend
end

def cprint console_width, string$, locate_y
 'centering and print
 locate floor((console_width-len(string$))/2),locate_y
 print string$
end

