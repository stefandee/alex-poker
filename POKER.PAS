program poker;
{ $F+ }
uses ptcgraph,ptccrt;
const mm=52;
      bt:array[1..10] of byte=(1,2,3,4,5,10,20,30,40,50);
type work=array[1..mm] of byte;
     hand=array[1..5] of byte;
     bettable=array[1..10] of byte;
     holdtable=array[1..5] of boolean;
var gd,gm:integer;
    cash,win,x:word;
    xxx,p,btp,i,j,k,bet,minibonus,holdsem,holdcont:byte;
    s:string;
    sem,cheksem:boolean;
    ch:char;
    aa,a,b:work;
    v:hand;
    hold:holdtable;
    doserror:integer;

procedure SOUND1;
begin
delay(300);
sound(150);
delay(100);
sound(100);
delay(100);
sound(50);
delay(100);
nosound;
end;

procedure SOUND2;
var i:byte;
begin
delay(500);
for i:=0 to 5 do begin
                 sound(500-i*50);
                 delay(100);
                 end;
nosound;
end;

procedure sound3(i:byte);
begin
delay(100);
sound(400+30*i);
delay(100);
nosound;
end;

procedure putDESK;
begin
setfillstyle(1,1);bar(0,0,639,479);
setfillstyle(1,11);bar(20,400,199,459);
setfillstyle(1,11);bar(220,400,429,459);
setfillstyle(1,11);bar(450,400,619,459);
end;

procedure putCASH;
begin
setfillstyle(1,11);bar(450,400,619,459);
str(cash,s);
settextstyle(0,0,4);
setcolor(0);
outtextxy(485,420,s);
end;

procedure putBET;
begin
setfillstyle(1,11);bar(220,400,429,459);
str(bet,s);
settextstyle(0,0,4);
setcolor(4);
outtextxy(240,420,'BET:');
setcolor(0);
outtextxy(360,420,s);
end;

procedure putSCORE;
begin
setfillstyle(1,11);bar(100,30,539,185);
settextstyle(0,0,1);
setcolor(12);
outtextxy(230,40,'5 OF A KIND');
str(bet*600,s);outtextxy(370,40,s);
if bet*300<500 then setcolor(0);
outtextxy(230,55,'ROYAL FLUSH');
str(bet*300,s);outtextxy(370,55,s);
if bet*80<500 then setcolor(0);
outtextxy(230,70,'STRIGHT FLUSH');
str(bet*80,s);outtextxy(370,70,s);
if bet*40<500 then setcolor(0);
outtextxy(230,85,'4 OF AKIND');
str(bet*40,s);outtextxy(370,85,s);
if bet*12<500 then setcolor(0);
outtextxy(230,100,'FULL HOUSE');
str(bet*12,s);outtextxy(370,100,s);
if bet*9<500 then setcolor(0);
outtextxy(230,115,'STRIGHT');
str(bet*9,s);outtextxy(370,115,s);
if bet*7<500 then setcolor(0);
outtextxy(230,130,'FLUSH');
str(bet*7,s);outtextxy(370,130,s);
if bet*5<500 then setcolor(0);
outtextxy(230,145,'3 OF A KIND');
str(bet*5,s);outtextxy(370,145,s);
if bet*3<500 then setcolor(0);
outtextxy(230,160,'2 PAIRS');
str(bet*3,s);outtextxy(370,160,s);
end;

procedure putMB;
begin
setfillstyle(1,11);bar(40,430,199,459);
settextstyle(0,0,1);
setcolor(0);
outtextxy(80,410,'MINI BONUS :');
settextstyle(0,0,2);
str(minibonus,s);
outtextxy(100,425,s);
end;

procedure putWIN(w:word);
begin
setfillstyle(1,11);bar(220,400,429,459);
str(w,s);
settextstyle(0,0,4);
setcolor(4);
outtextxy(220,420,'WIN:');
setcolor(0);
outtextxy(340,420,s);
end;

procedure putBACK(i:byte);
var x:byte;
begin
x:=200;
setfillstyle(1,15);
bar(30+(i-1)*120,x,130+(i-1)*120,x+150);
setfillstyle(9,7);
bar(37+(i-1)*120,x+7,123+(i-1)*120,x+143);
setcolor(0);rectangle(30+(i-1)*120,x,130+(i-1)*120,x+150);
putpixel(31+(i-1)*120,x+1,0);
putpixel(129+(i-1)*120,x+1,0);
putpixel(31+(i-1)*120,x+149,0);
putpixel(129+(i-1)*120,x+149,0);
end;

procedure putCARDS(i:byte);
var x,y:byte;
    s:string;
begin
x:=200;
setfillstyle(1,15);
bar(30+(i-1)*120,x,130+(i-1)*120,x+150);
setcolor(0);rectangle(30+(i-1)*120,x,130+(i-1)*120,x+150);
putpixel(31+(i-1)*120,x+1,0);
putpixel(129+(i-1)*120,x+1,0);
putpixel(31+(i-1)*120,x+149,0);
putpixel(129+(i-1)*120,x+149,0);
setcolor((((aa[v[i]]-2)div 3)-1)*4);
settextstyle(0,0,2);
s:=chr(aa[v[i]]);
outtextxy(40+(i-1)*120,x+10,s);
outtextxy(105+(i-1)*120,x+125,s);
settextstyle(1,0,7);
y:=((v[i]-1) div 4)+1;
case y of
1:outtextxy(67+(i-1)*120,x+30,'A');
10:begin outtextxy(55+(i-1)*120,x+30,'1');outtextxy(80+(i-1)*120,x+30,'0');end;
11:outtextxy(67+(i-1)*120,x+30,'J');
12:outtextxy(67+(i-1)*120,x+30,'Q');
13:outtextxy(67+(i-1)*120,x+30,'K');
else str(y,s);outtextxy(67+(i-1)*120,x+30,s);
end;
end;

procedure putCARD(i,j:byte);
begin
setfillstyle(1,15);bar(30+i*50,j,30+i*50+100,j+150);
setfillstyle(9,7);bar(37+i*50,j+7,123+i*50,j+143);
setcolor(0);rectangle(30+i*50,j,130+i*50,j+150);
putpixel(31+i*50,j+1,0);
putpixel(129+i*50,j+1,0);
putpixel(31+i*50,j+149,0);
putpixel(129+i*50,j+149,0);
end;

procedure showCARD(i,h:byte);
var x,y:byte;
begin
x:=20;
setfillstyle(1,15);bar(30+i*100-i*50,20,30+i*100-i*50+100,170);
setcolor(0);rectangle(30+i*50,20,130+i*50,170);
putpixel(31+(i-1)*120,x+1,0);
putpixel(129+(i-1)*120,x+1,0);
putpixel(31+(i-1)*120,x+149,0);
putpixel(129+(i-1)*120,x+149,0);
setcolor((((aa[a[p]]-2)div 3)-1)*4);
settextstyle(0,0,2);
s:=chr(aa[a[p]]);
outtextxy(40+i*50,x+10,s);
outtextxy(105+i*50,x+125,s);
settextstyle(1,0,6);
y:=((a[p]-1) div 4)+1;
case y of
1:outtextxy(67+i*50,x+30,'A');
10:begin outtextxy(55+i*30,x+30,'1');outtextxy(80+i*50,x+30,'0');end;
11:outtextxy(67+i*50,x+30,'J');
12:outtextxy(67+i*50,x+30,'Q');
13:outtextxy(67+i*50,x+30,'K');
else str(y,s);outtextxy(67+i*50,x+30,s);
end;
end;

procedure setCARDS;
var i:byte;
begin
for i:=1 to 52 do begin
aa[i]:=3;aa[i+1]:=4;aa[i+2]:=5;aa[i+3]:=6;
i:=i+3;
end;
end;

procedure HAZARD;
var i,j,k:byte;
    f:text;
begin
randomize;
for i:=mm downto 2 do begin
j:=1+random(i);
k:=a[i];a[i]:=a[j];a[j]:=k;
end;
end;

procedure CHOISE(w:word;x:byte;var w1:word);
var i,h:byte;
    ch:char;
label en;
begin
setfillstyle(1,11);bar(10,10,629,185);
for i:=0 to x-1 do
    begin
    putwin(w);

    p:=p+1;
    if p>mm then p:=1;
    if aa[a[p]]>4 then h:=1
                  else h:=0;

    repeat
    repeat
    putcard(i,20);
    until keypressed;
    ch:=readkey;if ch=#27 then begin sem:=true;goto en;end;
    until (ch=#13) or (ch='9') or (ch='0');
    if h=0 then case ch of '9':begin
                               w:=w*2;
                               showcard(i,p);
                               putwin(w);
                               w1:=w;
                               end;
                           '0':begin
                               showcard(i,h);
                               w1:=0;
                               goto en;
                               end;
                           #13:begin
                               w1:=w;
                               goto en;
                               end;
                end
           else case ch of '0':begin
                               w:=w*2;
                               showcard(i,h);
                               putwin(w);
                               w1:=w
                               end;
                           '9':begin
                               showcard(i,h);
                               w1:=0;
                               goto en;
                               end;
                           #13:begin
                               w1:=w;
                               goto en;
                               end;
                end;
end;
en:
end;

procedure order;
var s:boolean;
    i,k:byte;
begin
for i:=1 to 5 do b[i]:=i;
repeat
s:=true;
for i:=1 to 4 do
if v[b[i]]>v[b[i+1]] then begin
                          k:=b[i];
                          b[i]:=b[i+1];
                          b[i+1]:=k;
                          s:=false;
                          end;
until s;
end;

procedure holdcard(i:byte);
begin
    hold[i]:=not hold[i];
    setcolor(14);
    if hold[i] then begin
               settextstyle(1,0,3);
               outtextxy(50+(i-1)*120,350,'HOLD');
              {sound3(i);}
               holdsem:=holdsem+1;
               end
          else begin
               setfillstyle(1,1);
               holdsem:=holdsem-1;
               bar(50+(i-1)*120,350,150+(i-1)*120,380);
               end;
end;

procedure wincard(i:byte);
begin
    setcolor(12);
    settextstyle(1,0,3);
    outtextxy(60+(i-1)*120,350,'WIN');
end;

procedure TWOPAIRS;
begin win:=bet*3;
      putcash;
      putbet;
      putmb;
      choise(win,7,x);
      win:=x;
      cash:=cash+win;
      putcash;
      putbet;
end;

procedure BRELAN;
begin win:=bet*5;
      putcash;
      putbet;
      putmb;
      choise(win,7,x);
      win:=x;
      cash:=cash+win;
      putcash;
      putbet;
end;

procedure STRIGHT;
begin win:=bet*7;
      putcash;
      putbet;
      putmb;
      choise(win,6,x);
      win:=x;
      cash:=cash+win;
      putcash;
      putbet;
end;

procedure COLOR;
begin win:=bet*9;
      putcash;
      putbet;
      putmb;
      choise(win,6,x);
      win:=x;
      cash:=cash+win;
      putcash;
      putbet;
end;

procedure FULLHOUSE;
begin win:=bet*12;
      putcash;
      putbet;
      putmb;
      choise(win,6,x);
      win:=x;
      cash:=cash+win;
      putcash;
      putbet;
end;

procedure CAREU;
begin win:=bet*40;
      putcash;
      putbet;
      putmb;
      choise(win,5,x);
      win:=x;
      cash:=cash+win;
      putcash;
      putbet;
end;

procedure STRFLUSH;
begin win:=bet*80;
      putcash;
      putbet;
      putmb;
      choise(win,5,x);
      win:=x;
      cash:=cash+win;
      putcash;
      putbet;
end;

procedure ROYALFLUSH;
begin win:=bet*300;
      putcash;
      putbet;
      putmb;
      choise(win,3,x);
      win:=x;
      cash:=cash+win;
      putcash;
      putbet;
end;

procedure erase;
var i:byte;
begin
for i:=1 to 5 do hold[i]:=false;
end;

procedure chekCOLOR;
var i,k:byte;
begin
k:=aa[v[1]];
for i:=2 to 5 do
if aa[v[i]]<>k then exit;
color;
end;

procedure chekSTRIGHT;
var i,k,s:byte;
begin
order;
if (int((v[b[1]]-1)/4)+1=int((v[b[2]]-1)/4)) and
   (int((v[b[2]]-1)/4)+1=int((v[b[3]]-1)/4)) and
   (int((v[b[3]]-1)/4)+1=int((v[b[4]]-1)/4)) and
   (int((v[b[4]]-1)/4)+1=int((v[b[5]]-1)/4)) then
   begin
   k:=aa[v[1]];s:=1;
   for i:=2 to 5 do
   if aa[v[i]]=k then inc(s);
   if (s=5) and (k=5) then royalflush
                      else if s=5 then strflush
                                  else stright;
   end;
   setfillstyle(1,1);
   bar(50,350,630,380);
end;

procedure chekVAL;
var i:byte;
begin
order;
if (int((v[b[1]]-1)/4)=int((v[b[2]]-1)/4)) and
   (int((v[b[1]]-1)/4)=int((v[b[3]]-1)/4)) and
   (int((v[b[1]]-1)/4)=int((v[b[4]]-1)/4)) then begin
                                                setfillstyle(1,1);
                                                bar(50,350,630,380);
                                                for i:=1 to 4 do
                                                wincard(b[i]);
                                                careu;
                                                setfillstyle(1,1);
                                                bar(50,350,630,380);
                                                exit;end;
if (int((v[b[2]]-1)/4)=int((v[b[3]]-1)/4)) and
   (int((v[b[2]]-1)/4)=int((v[b[4]]-1)/4)) and
   (int((v[b[2]]-1)/4)=int((v[b[5]]-1)/4)) then begin
                                                setfillstyle(1,1);
                                                bar(50,350,630,380);
                                                for i:=2 to 5 do
                                                wincard(b[i]);
                                                careu;
                                                setfillstyle(1,1);
                                                bar(50,350,630,380);
                                                exit;end;

if (int((v[b[1]]-1)/4)=int((v[b[2]]-1)/4)) and
   (int((v[b[1]]-1)/4)=int((v[b[3]]-1)/4)) and
   (int((v[b[4]]-1)/4)=int((v[b[5]]-1)/4)) then begin
                                                setfillstyle(1,1);
                                                bar(50,350,630,380);
                                                for i:=1 to 5 do
                                                wincard(b[i]);
                                                fullhouse;
                                                setfillstyle(1,1);
                                                bar(50,350,630,380);
                                                exit;end;
if (int((v[b[1]]-1)/4)=int((v[b[2]]-1)/4)) and
   (int((v[b[3]]-1)/4)=int((v[b[4]]-1)/4)) and
   (int((v[b[3]]-1)/4)=int((v[b[5]]-1)/4)) then begin
                                                setfillstyle(1,1);
                                                bar(50,350,630,380);
                                                for i:=1 to 5 do
                                                wincard(b[i]);
                                                fullhouse;
                                                setfillstyle(1,1);
                                                bar(50,350,630,380);
                                                exit;end;

if (int((v[b[1]]-1)/4)=int((v[b[2]]-1)/4)) and
   (int((v[b[1]]-1)/4)=int((v[b[3]]-1)/4)) then begin
                                                setfillstyle(1,1);
                                                bar(50,350,630,380);
                                                for i:=1 to 3 do
                                                wincard(b[i]);
                                                brelan;
                                                setfillstyle(1,1);
                                                bar(50,350,630,380);
                                                exit;end;
if (int((v[b[2]]-1)/4)=int((v[b[3]]-1)/4)) and
   (int((v[b[2]]-1)/4)=int((v[b[4]]-1)/4)) then begin
                                                setfillstyle(1,1);
                                                bar(50,350,630,380);
                                                for i:=2 to 4 do
                                                wincard(b[i]);
                                                brelan;
                                                setfillstyle(1,1);
                                                bar(50,350,630,380);
                                                exit;end;
if (int((v[b[3]]-1)/4)=int((v[b[4]]-1)/4)) and
   (int((v[b[3]]-1)/4)=int((v[b[5]]-1)/4)) then begin
                                                setfillstyle(1,1);
                                                bar(50,350,630,380);
                                                for i:=3 to 5 do
                                                wincard(b[i]);
                                                brelan;
                                                setfillstyle(1,1);
                                                bar(50,350,630,380);
                                                exit;end;

if (int((v[b[1]]-1)/4)=int((v[b[2]]-1)/4)) and
   (int((v[b[3]]-1)/4)=int((v[b[4]]-1)/4)) then begin
                                                setfillstyle(1,1);
                                                bar(50,350,630,380);
                                                for i:=1 to 4 do
                                                wincard(b[i]);
                                                twopairs;
                                                setfillstyle(1,1);
                                                bar(50,350,630,380);
                                                exit;end;
if (int((v[b[1]]-1)/4)=int((v[b[2]]-1)/4)) and
   (int((v[b[4]]-1)/4)=int((v[b[5]]-1)/4)) then begin
                                                setfillstyle(1,1);
                                                bar(50,350,630,380);
                                                for i:=1 to 2 do
                                                wincard(b[i]);
                                                for i:=4 to 5 do
                                                wincard(b[i]);
                                                twopairs;
                                                setfillstyle(1,1);
                                                bar(50,350,630,380);
                                                exit;end;
if (int((v[b[2]]-1)/4)=int((v[b[3]]-1)/4)) and
   (int((v[b[4]]-1)/4)=int((v[b[5]]-1)/4)) then begin
                                                setfillstyle(1,1);
                                                bar(50,350,630,380);
                                                for i:=2 to 5 do
                                                wincard(b[i]);
                                                twopairs;
                                                setfillstyle(1,1);
                                                bar(50,350,630,380);
                                                exit;end;
if ((int((v[b[1]]-1)/4)=int((v[b[2]]-1)/4)) and
   ((int((v[b[1]]-1)/4)>9)or(int((v[b[1]]-1)/4)=0)))
   then begin
        setfillstyle(1,1);
        bar(50,350,630,380);
        inc(minibonus,bet);
        putmb;
       {sound2;}
        exit;end;
if ((int((v[b[2]]-1)/4)=int((v[b[3]]-1)/4)) and
   ((int((v[b[2]]-1)/4)>9)or(int((v[b[2]]-1)/4)=0)))
   then begin
        setfillstyle(1,1);
        bar(50,350,630,380);
        inc(minibonus,bet);
        putmb;
       {sound2;}
        exit;end;
if ((int((v[b[3]]-1)/4)=int((v[b[4]]-1)/4)) and
   ((int((v[b[3]]-1)/4)>9)or(int((v[b[3]]-1)/4)=0)))
   then begin
        setfillstyle(1,1);
        bar(50,350,630,380);
        inc(minibonus,bet);
        putmb;
       {sound2;}
        exit;end;
if ((int((v[b[4]]-1)/4)=int((v[b[5]]-1)/4)) and
   ((int((v[b[4]]-1)/4)>9)or(int((v[b[4]]-1)/4)=0)))
   then begin
        setfillstyle(1,1);
        bar(50,350,630,380);
        inc(minibonus,bet);
        putmb;
       {sound2;}
        exit;end;
end;

procedure chekFIRST;
var serv,i,caract:byte;
begin
if ((aa[v[1]]=aa[v[2]])and(aa[v[2]]=aa[v[3]])and
   (aa[v[3]]=aa[v[4]])) then begin
                             for i:=1 to 4 do
                             holdcard(i);
                             exit;end;
if ((aa[v[2]]=aa[v[3]])and(aa[v[3]]=aa[v[4]])and
   (aa[v[4]]=aa[v[5]])) then begin
                             for i:=2 to 5 do
                             holdcard(i);
                             exit;end;
if ((aa[v[1]]=aa[v[3]])and(aa[v[3]]=aa[v[4]])and
   (aa[v[4]]=aa[v[5]])) then begin
                             holdcard(b[1]);
                             for i:=3 to 5 do
                             holdcard(i);
                             exit;end;
if ((aa[v[1]]=aa[v[2]])and(aa[v[2]]=aa[v[4]])and
   (aa[v[4]]=aa[v[5]])) then begin
                             for i:=1 to 2 do
                             holdcard(i);
                             for i:=4 to 5 do
                             holdcard(i);
                             exit;end;
if ((aa[v[1]]=aa[v[2]])and(aa[v[2]]=aa[v[3]])and
   (aa[v[3]]=aa[v[5]])) then begin
                             holdcard(5);
                             for i:=1 to 3 do
                             holdcard(i);
                             exit;end;
if ((aa[v[1]]=aa[v[2]])and(aa[v[2]]=aa[v[3]])and
   (aa[v[3]]=aa[v[4]])and(aa[v[4]]=aa[v[5]])) then begin
                             for i:=1 to 5 do
                             holdcard(i);
                             caract:=1;
                             exit;end;
order;
if (int((v[b[1]]-1)/4)=int((v[b[2]]-1)/4)) and
   (int((v[b[1]]-1)/4)=int((v[b[3]]-1)/4)) and
   (int((v[b[1]]-1)/4)=int((v[b[4]]-1)/4)) then begin
                                                for i:=1 to 4 do
                                                holdcard(b[i]);
                                                exit;end;
if (int((v[b[2]]-1)/4)=int((v[b[3]]-1)/4)) and
   (int((v[b[2]]-1)/4)=int((v[b[4]]-1)/4)) and
   (int((v[b[2]]-1)/4)=int((v[b[5]]-1)/4)) then begin
                                                for i:=2 to 5 do
                                                holdcard(b[i]);
                                                exit;end;

if (int((v[b[1]]-1)/4)=int((v[b[2]]-1)/4)) and
   (int((v[b[1]]-1)/4)=int((v[b[3]]-1)/4)) and
   (int((v[b[4]]-1)/4)=int((v[b[5]]-1)/4)) then begin
                                                for i:=1 to 5 do
                                                holdcard(b[i]);
                                                caract:=2;
                                                exit;end;
if (int((v[b[1]]-1)/4)=int((v[b[2]]-1)/4)) and
   (int((v[b[3]]-1)/4)=int((v[b[4]]-1)/4)) and
   (int((v[b[3]]-1)/4)=int((v[b[5]]-1)/4)) then begin
                                                for i:=1 to 5 do
                                                holdcard(b[i]);
                                                caract:=2;
                                                exit;end;

if (int((v[b[1]]-1)/4)=int((v[b[2]]-1)/4)) and
   (int((v[b[1]]-1)/4)=int((v[b[3]]-1)/4)) then begin
                                                for i:=1 to 3 do
                                                holdcard(b[i]);
                                                exit;end;
if (int((v[b[2]]-1)/4)=int((v[b[3]]-1)/4)) and
   (int((v[b[2]]-1)/4)=int((v[b[4]]-1)/4)) then begin
                                                for i:=2 to 4 do
                                                holdcard(b[i]);
                                                exit;end;
if (int((v[b[3]]-1)/4)=int((v[b[4]]-1)/4)) and
   (int((v[b[3]]-1)/4)=int((v[b[5]]-1)/4)) then begin
                                                for i:=3 to 5 do
                                                holdcard(b[i]);
                                                exit;end;

if (int((v[b[1]]-1)/4)=int((v[b[2]]-1)/4)) and
   (int((v[b[3]]-1)/4)=int((v[b[4]]-1)/4)) then begin
                                                for i:=1 to 4 do
                                                holdcard(b[i]);
                                                exit;end;
if (int((v[b[1]]-1)/4)=int((v[b[2]]-1)/4)) and
   (int((v[b[4]]-1)/4)=int((v[b[5]]-1)/4)) then begin
                                                for i:=1 to 2 do
                                                holdcard(b[i]);
                                                for i:=4 to 5 do
                                                holdcard(b[i]);
                                                exit;end;
if (int((v[b[2]]-1)/4)=int((v[b[3]]-1)/4)) and
   (int((v[b[4]]-1)/4)=int((v[b[5]]-1)/4)) then begin
                                                for i:=2 to 5 do
                                                holdcard(b[i]);
                                                exit;end;
if (int((v[b[1]]-1)/4)=int((v[b[2]]-1)/4)) then begin
                                                holdcard(b[1]);
                                                holdcard(b[2]);
                                                exit;end;
if (int((v[b[2]]-1)/4)=int((v[b[3]]-1)/4)) then begin
                                                holdcard(b[2]);
                                                holdcard(b[3]);
                                                exit;end;
if (int((v[b[3]]-1)/4)=int((v[b[4]]-1)/4)) then begin
                                                holdcard(b[3]);
                                                holdcard(b[4]);
                                                exit;end;
if (int((v[b[4]]-1)/4)=int((v[b[5]]-1)/4)) then begin
                                                holdcard(b[4]);
                                                holdcard(b[5]);
                                                exit;end;

if holdsem=5 then begin
                  repeat until keypressed;
                  ch:=readkey;
                  case ch of
                  '1':begin erase;holdcard(1);serv:=1;end;
                  '2':begin erase;holdcard(2);serv:=2;end;
                  '3':begin erase;holdcard(3);serv:=3;end;
                  '4':begin erase;holdcard(4);serv:=4;end;
                  '5':begin erase;holdcard(5);serv:=5;end;
                  '9':begin setfillstyle(1,1);
                            bar(50,350,630,380);
                            erase;
                            inc(btp);
                            if cash<bt[btp] then btp:=1;
                            if btp=11 then btp:=1;
                            bet:=bt[btp];
                            putbet;
                            putscore;
                            putmb;
                            hazard;
                            p:=0;
                            end;
                  end;
                  repeat until keypressed;
                  ch:=readkey;
                  case ch of
                  '1': if serv=1 then begin end;
                  '2': if serv=2 then begin end;
                  '3': if serv=3 then begin end;
                  '4': if serv=4 then begin end;
                  '5': if serv=5 then begin end;
                  end;
                  end;
end;

procedure INIT;
begin
clrscr;
{gd:=0;
initgraph(gd,gm,'C:\BIN\BP\BGI');}
gd:=Vga;
gm:=VgaHi;
initgraph(gd,gm,'');
for i:=1 to mm do a[i]:=i;
setcards;
cash:=100;
btp:=1;
minibonus:=5;
cheksem:=false;
sem:=false;
for i:=1 to 5 do hold[i]:=false;
holdsem:=0;
holdcont:=0;
end;

label loop;


{############################################################################}
{#################  M  A  I  N          P  R  O  G  R  A  M #################}
{############################################################################}

begin

init;

p:=0;
hazard;
for i:=1 to 5 do putback(i);
bet:=bt[btp];
putdesk;
putcash;
putbet;
putscore;
putmb;
for i:=1 to 5 do putback(i);
repeat
ch:=readkey;
case ch of
'9':begin
    inc(btp);
    if btp=11 then btp:=1;
    bet:=bt[btp];
    putbet;
    putscore;
    hazard;
    p:=0;
    end;
end;
until ch=#13;
repeat
dec(cash,bet);
if cash<bet then begin
                 if cash>0 then begin
                 repeat
                 dec(btp);
                 bet:=bt[btp];
                 until cash>=bet;
                 end;
                 end;
bet:=bt[btp];
putcash;
putbet;
putscore;
putmb;
if holdsem=0 then begin hazard;holdcont:=0;end;
if holdsem>0 then inc(holdcont);
if holdcont=2 then begin
                         for i:=1 to 5 do hold[i]:=false;
                         setfillstyle(1,1);
                         bar(50,350,630,380);
                         holdsem:=0;
                         holdcont:=0;
                         end;
for i:=1 to 5 do if not hold[i] then putback(i);
for i:=1 to 5 do if not hold[i] then begin
                 p:=p+1;
                 if p>mm then p:=1;
                 v[i]:=a[p];
                 end;
                 delay(300);
for i:=1 to 5 do if not hold[i] then begin
                 putcards(i);
                {sound1;}
                 end;
if (hold[1] or hold[2]) or (hold[2] or hold[3]) or
   (hold[3] or hold[4]) or (hold[4] or hold[5]) then begin
                                                     chekval;
                                                     chekstright;
                                                     chekcolor;
                                                     end;
chekfirst;
xxx:=btp;
repeat
ch:=readkey;
case ch of
'1':begin if xxx<>btp then goto loop;holdcard(1);end;
'2':begin if xxx<>btp then goto loop;holdcard(2);end;
'3':begin if xxx<>btp then goto loop;holdcard(3);end;
'4':begin if xxx<>btp then goto loop;holdcard(4);end;
'5':begin if xxx<>btp then goto loop;holdcard(5);end;
'9':begin
    setfillstyle(1,1);
    bar(50,350,630,380);
    for i:=1 to 5 do hold[i]:=false;
    inc(btp);
    if btp=11 then btp:=1;
    if cash<bt[btp] then repeat
                         dec(btp);
                         until cash>=bt[btp];
    bet:=bt[btp];
    putbet;
    putscore;
    putmb;
    hazard;
    p:=0;
    end;
end;
loop:until (ch=#13) or (ch=#27);
setfillstyle(1,1);bar(5,5,634,185);
if cash=0 then begin putcash;delay(3000);exit; end;
bet:=bt[btp];
putcash;
putbet;
putscore;
putmb;
until ch=#27;

closegraph;
end.