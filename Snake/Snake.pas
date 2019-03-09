uses CRT;

label play;

type

arr = array[1..80, 1..25] of 0..3;    {0 - empty
                                       1 - snake\wall
                                       2 - food
                                       3 - snake after meal}

coord = array[1..2] of integer;

list = ^node;
node = record
  inf: coord;
  next, pred: list;
end;
  
var
  b: boolean;
  x: arr;
  snake :list;
  dx, dy, v, spmode, glob, score, c : integer;
  
  
procedure CreateFood(var mas: arr);
var
  x, y: integer;
begin
  x:=random(2, 79);
  y:=random(2, 24);
  if mas[x, y]=0 then
  begin
    mas[x, y]:=2;
    gotoxy(x, y);
    textcolor(4);
    write('x')
  end
  else 
    CreateFood(mas)
end;
  
procedure pushsnake(a, b: integer; var snake: list);
var
  q: list;
begin
  q:=snake^.pred;
  new(snake^.pred);
  snake^.pred^.inf[1]:=a;
  snake^.pred^.inf[2]:=b;
  snake^.pred^.next:=snake;
  snake^.pred^.pred:=q;
  snake:=snake^.pred;
  q^.next:=snake;
end;

procedure popsnake(var snake:list);
var 
  q: list;
begin
  if snake=snake^.pred then
  begin
    dispose(snake);
    snake:=nil
  end
  else
  begin
    q:=snake^.pred^.pred;
    dispose(snake^.pred);
    snake^.pred:=q;
    q^.next:=snake;
  end
end;
  
procedure settable(a, b : integer; var x: arr); 
var 
  i: integer;
begin
  textbackground (a);
  textcolor(b);
    clrscr;
    for i:= 1 to 80 do
    begin
      write('"');
      x[i, 1]:=1
    end;
    for i:=2 to 25 do
    begin
      gotoxy(1, i);
      write('"');
      x[1, i]:=1;
      gotoxy(80, i);
      x[80, i]:=1;
      write('"')
    end;
    gotoxy(2, 25);
    for i:=2 to 79 do
    begin
      write('"');
      x[i, 25]:=1
    end;
end;

procedure initsnake(var x: arr; var snake: list);
var 
  i: integer;
begin
    new(snake);
    snake^.inf[1]:=38;
    snake^.inf[2]:=10;
    new(snake^.next); 
    snake^.pred:=snake^.next; 
    snake^.next^.inf[1]:=37;
    snake^.next^.inf[2]:=10;
    snake^.next^.pred:=snake;
    snake^.next^.next:=snake;

    gotoxy(37, 10);
    for i:=1 to 1 do
    begin
      write('o');
      x[37+i, 10]:=1
    end;
    write('@');
    x[38, 10]:=1;
end;

procedure speedmode(var dx, dy: integer);
begin
  case readkey of
  'a', 'A', 'Ô','ô' : begin 
                        if (dx = 0) then 
                          begin 
                            dx:=-1; 
                            dy:=0
                          end 
                      end;
  's', 'û', 'Û', 'S' : begin 
                         if (dy = 0) then 
                         begin 
                           dx:=0; 
                           dy:=1 
                         end 
                       end;
  'd', 'â', 'D', 'Â' : begin 
                         if (dx = 0) then 
                         begin 
                           dx:=1; 
                           dy:=0; 
                         end
                       end;
  'w', 'ö', 'W', 'Ö' : begin 
                         if (dy = 0) then
                           begin
                             dx:=0;
                             dy:=-1; 
                           end;
                       end;
  'r', 'ê', 'R', 'k' : begin textcolor(0); readln end
  end
end;

procedure speedmodeproc;
begin
  spmode:=spmode-10
end;
  
procedure stepafterdeath(var mas: arr; var snake: list);
var
  x, y: integer;
begin
  x:=snake^.pred^.inf[1];
  y:=snake^.pred^.inf[2];
  textcolor(15);
  gotoxy(x, y);
  if mas[x, y] = 3 then
  begin
    mas[x, y]:=1;
    write('o')
  end
  else
  begin
    mas[x, y]:=0;
    write(' ');
    popsnake(snake)
  end;
end;

function step(var mas: arr; var snake: list): boolean;
var
  x, y: integer;
begin
x:=snake^.pred^.inf[1];
  y:=snake^.pred^.inf[2];
  textcolor(15);
  gotoxy(x, y);
  if mas[x, y] = 3 then
  begin
    mas[x, y]:=1;
    write('o')
  end
  else
  begin
    mas[x, y]:=0;
    write(' ');
    popsnake(snake)
  end;
  step:=true;
  x:=snake^.inf[1];
  y:=snake^.inf[2];
  gotoxy(x, y);
  if mas[x, y] = 3 then
  begin
    textcolor(2);
    write('o')
  end
  else
  begin
    textcolor(15);
    write('o')
  end;
  
  textcolor(15);
  x:=x+dx;
  y:=y+dy;
  gotoxy(x, y);
  case mas[x, y] of
    0: begin write('@'); mas[x, y]:=1; end;
    1: begin write('@'); step:=false; end;
    2: begin textcolor(2); write('@'); mas[x, y]:=3; CreateFood(mas); score:=score+1; if glob < 15 then begin glob:=glob+1; speedmodeproc end end;
    3: begin write('@'); step:=false; end;
  end;
  pushsnake(x, y, snake);
end;

begin
    SetWindowTitle('Snake');
    HideCursor;
    TextBackground(0);
    ClrScr;
    gotoxy(35, 13);
    TextColor(15);
    write('Welcome Snake!');
    Delay(1750);
    ClearLine; 
play:
    score:=0;
    spmode:=200; 
    for i:integer:=1 to 80 do
      for j:integer:=1 to 25 do
        x[i, j]:=0;
    gotoxy(60, 5);
    TextColor(15);
    gotoxy(25, 13);
    write('Control snake by "w", "a", "s", "d"');
    ClearLine;
    gotoxy(25, 10);
    ClearLine;
    gotoxy(35, 15);
    write('Chose the level');
    gotoxy(25, 17);
    write('1 - noob, 2 - easy, 3 - medium, 4 - hard');
    gotoxy(40, 20);
    read(v);
   
    case v of
      1: glob:=13;
      2: glob:=10;
      3: glob:=5;
      4: glob:=1;
    else
      begin
        gotoxy(30, 22);
        write('Incorrect input. Bye.');
        gotoxy(25, 24);
        exit
      end
    end;
       
    snake:=nil;
    b:=true;
    dx:=0;
    dy:=1;
    settable(0, 15, x);
    initsnake(x, snake);
    CreateFood(x);
    while b do
    begin
      Delay(spmode);
      if keypressed then
        speedmode(dx, dy);  
      b:=step(x, snake);
    end;
    while snake <> nil do
    begin
      stepafterdeath(x, snake);
      Delay(spmode)
    end;
    
    settable(0, 15, x);
    gotoxy(37, 9);
    write('Score: ', score);
    gotoxy(37, 12);
    write('Game over');
    Delay(1500);
    gotoxy(25, 15);
    write('Press 1 if you want to continue game');
    gotoxy(40, 18);
    read(c);
    gotoxy(20, 15);
    ClearLine;
    gotoxy(40, 18);
    write(' ');
    if c=1 then goto play;
    gotoxy(20, 21);
  readln
end.