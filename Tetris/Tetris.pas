uses GraphABC;

var
  score:integer;

Const
  FieldHeight = 20;
  FieldWidth = 10;
  AfterDraw = 20;

type 
  Field = array[-2..FieldWidth+15, -2..FieldHeight+4] of integer;
  Save = array[1..4] of integer;
  
procedure CreateField;
begin
  Window.Clear;
  Brush.Color := clWhite;
  Rectangle(14, 14, 316, 616 );
    SetFontSize(20);
  SetFontColor(clBlack);
  Brush.Color := clWhite;
  Rectangle(350, 400, 500, 500);
  TextOut(360, 410, 'Score');
  TextOut(360, 440, ' '+score);
end;
  
procedure ColorZ(z: integer);
begin
  case z of
    1: Brush.Color := clOrange;
    2: Brush.Color := clPurple;
    3: Brush.Color := clBlue;
    4: Brush.Color := clRed;
    5: Brush.Color := clLime;
    6: Brush.Color := clYellow;
    7: Brush.Color := clCadetBlue;
  end
end;  

procedure Square(x, y, z: integer);
begin
  if z<>0 then
  begin
    Brush.Color := clBlack;
    Rectangle(30*x-16, 30*y-16, 30*x+16, 30*y+16);
    ColorZ(z);
    Rectangle(30*x-14, 30*y-14, 30*x+14, 30*y+14);
  end;
end;

procedure DetailI(x, y, f, z: integer; var mass: field); {f = 1}
var
  i: integer;
begin
  if z<>1 then
    for i:=y-1 to y+2 do
      mass[x, i]:=f
  else
    for i:=x-1 to x+2 do
      mass[i, y]:=f
end;

procedure DetailJ(x, y, f, z: integer; var mass: field); {f = 2}
begin
  case z of
    1: begin mass[x-1, y]:=f; mass[x-1, y+1]:=f; mass[x, y]:=f; mass[x+1, y]:=f end;
    2: begin mass[x-1, y-1]:=f; mass[x, y+1]:=f; mass[x, y]:=f; mass[x, y-1]:=f end;    
    3: begin mass[x-1, y]:=f; mass[x+1, y-1]:=f; mass[x, y]:=f; mass[x+1, y]:=f end;    
    4: begin mass[x, y-1]:=f; mass[x, y+1]:=f; mass[x, y]:=f; mass[x+1, y+1]:=f end;
  end;
end;

procedure DetailL(x, y, f, z: integer; var mass: field); {f = 3}
begin
  case z of
    1: begin mass[x-1, y]:=f; mass[x, y]:=f; mass[x+1, y]:=f; mass[x+1, y+1]:=f end;
    2: begin mass[x-1, y+1]:=f; mass[x, y+1]:=f; mass[x, y]:=f; mass[x, y-1]:=f end;    
    3: begin mass[x-1, y]:=f; mass[x+1, y]:=f; mass[x, y]:=f; mass[x-1, y-1]:=f end;    
    4: begin mass[x, y-1]:=f; mass[x, y+1]:=f; mass[x, y]:=f; mass[x+1, y-1]:=f end;    
  end;   
end;

procedure DetailO(x, y, f, z: integer; var mass: field); {f = 4}
begin
  mass[x, y]:=f;
  mass[x+1, y]:=f;
  mass[x, y+1]:=f;
  mass[x+1, y+1]:=f
end;

procedure DetailS(x, y, f, z: integer; var mass: field); {f = 5}
begin
  case z of
    1: begin mass[x-1, y]:=f; mass[x, y]:=f; mass[x, y+1]:=f; mass[x+1, y+1]:=f end;
    2: begin mass[x, y+1]:=f; mass[x, y]:=f; mass[x+1, y]:=f; mass[x+1, y-1]:=f end;   
  end;  
end;

procedure DetailT(x, y, f, z: integer; var mass: field); {f = 6}
begin
  case z of
    1: begin mass[x-1, y]:=f; mass[x, y]:=f; mass[x+1, y]:=f; mass[x, y+1]:=f end;
    2: begin mass[x-1, y]:=f; mass[x, y+1]:=f; mass[x, y]:=f; mass[x, y-1]:=f end;    
    3: begin mass[x-1, y]:=f; mass[x+1, y]:=f; mass[x, y]:=f; mass[x, y-1]:=f end;    
    4: begin mass[x, y-1]:=f; mass[x, y+1]:=f; mass[x, y]:=f; mass[x+1, y]:=f end;    
  end;   
end; 

procedure DetailZ(x, y, f, z: integer; var mass: field); {f = 7}
begin
  case z of
    1: begin mass[x+1, y]:=f; mass[x, y]:=f; mass[x, y+1]:=f; mass[x-1, y+1]:=f end;
    2: begin mass[x, y-1]:=f; mass[x, y]:=f; mass[x+1, y]:=f; mass[x+1, y+1]:=f end;   
  end;  
end;

procedure DeleteLine(q: integer; var mass: Field);
var
  i, j: integer;
begin
  for j:=q downto 2 do
    for i:=1 to FieldWidth do
      mass[i, j]:=mass[i, j-1];
  for i:=1 to FieldWidth do
    mass[i, 1]:=0;
end;
    
function CheckField(var mass: Field): integer; {Is line to be destroed?}
var
  i, j, k, c: integer;
begin
  c:=0;
  for i:=1 to FieldHeight do
  begin
    k:=0;
    for j:=1 to FieldWidth do
      if mass[j, i]<>0 then 
        k:=k+1;
    if k=FieldWidth then
    begin
      DeleteLine(i, mass);
      c:=c+1
    end
  end;
  CheckField:=c;
end;

procedure Create(var mass: Field);
var
  i, j: integer;
begin
  CreateField;
  for i:=1 to FieldWidth do
    for j:=1 to FieldHeight do
      Square(i, j, mass[i, j]);
  for i:=12 to 16 do
    for j:=2 to 5 do
       Square(i, j, mass[i, j]);
  Redraw;
  Sleep(AfterDraw)
end;


function IsDetailOk(var x, y, f, z: integer; var mass: field): boolean; {ћожно ли выполнить очередное действие? ѕроверка на границы/пересечени€ с другими детал€ми}
var
  i: integer;
begin
  IsDetailOk:=true;
  case f of
    1: case z of
         2:     for i:=y-1 to y+2 do if mass[x, i]<>0 then IsDetailOk:=false;
         1:     for i:=x-1 to x+2 do if mass[i, y]<>0 then IsDetailOk:=false;
       end;
    2: case z of
         1:  if (mass[x-1, y]<>0) or (mass[x-1, y+1]<>0) or (mass[x, y]<>0) or (mass[x+1, y]<>0) then IsDetailOk:=false;
         2:  if (mass[x-1, y-1]<>0) or (mass[x, y+1]<>0) or (mass[x, y]<>0) or  ( mass[x, y-1]<>0) then IsDetailOk:=false;
         3:  if (mass[x-1, y]<>0) or  (  mass[x+1, y-1]<>0) or  (  mass[x, y]<>0) or  (  mass[x+1, y]<>0)  then IsDetailOk:=false;
         4:  if (mass[x, y-1]<>0) or  ( mass[x, y+1]<>0) or  ( mass[x, y]<>0) or  ( mass[x+1, y+1]<>0) then IsDetailOk:=false;
       end;
    3: case z of
         1:  if (mass[x-1, y]<>0) or (mass[x, y]<>0) or (mass[x+1, y]<>0) or (mass[x+1, y+1]<>0) then IsDetailOk:=false;
         2:  if (mass[x-1, y+1]<>0) or (mass[x, y+1]<>0) or (mass[x, y]<>0) or (mass[x, y-1]<>0) then IsDetailOk:=false;
         3:  if (mass[x-1, y]<>0) or (mass[x+1, y]<>0) or (mass[x, y]<>0) or (mass[x-1, y-1]<>0) then IsDetailOk:=false;
         4:  if (mass[x, y-1]<>0) or (mass[x, y+1]<>0) or (mass[x, y]<>0) or (mass[x+1, y-1]<>0) then IsDetailOk:=false;
       end;
    4:  if (   mass[x, y]<>0) or (mass[x+1, y]<>0) or (mass[x, y+1]<>0) or (mass[x+1, y+1]<>0) then IsDetailOk:=false;
    5: case z of
         1:  if (mass[x-1, y]<>0) or ( mass[x, y]<>0) or (mass[x, y+1]<>0) or (mass[x+1, y+1]<>0) then IsDetailOk:=false;
         2:  if (mass[x, y+1]<>0) or ( mass[x, y]<>0) or (mass[x+1, y]<>0) or (mass[x+1, y-1]<>0) then IsDetailOk:=false;
       end;
    6: case z of
         1:  if (mass[x-1, y]<>0) or ( mass[x, y]<>0) or (mass[x+1, y]<>0) or (mass[x, y+1]<>0) then IsDetailOk:=false;
         2:  if (mass[x-1, y]<>0) or (mass[x, y+1]<>0) or (mass[x, y]<>0) or (mass[x, y-1]<>0)  then IsDetailOk:=false;
         3:  if (mass[x-1, y]<>0) or (mass[x+1, y]<>0) or (mass[x, y]<>0) or (mass[x, y-1]<>0)then IsDetailOk:=false;
         4:  if (mass[x, y-1]<>0) or ( mass[x, y+1]<>0) or (mass[x, y]<>0) or (mass[x+1, y]<>0) then IsDetailOk:=false;
       end;
    7: case z of
         1:  if (mass[x+1, y]<>0) or (mass[x, y]<>0) or (mass[x, y+1]<>0) or (mass[x-1, y+1]<>0) then IsDetailOk:=false;
         2:  if (mass[x, y-1]<>0) or (mass[x, y]<>0) or (mass[x+1, y]<>0) or (mass[x+1, y+1]<>0) then IsDetailOk:=false;
       end;
  end;
end;

procedure BeforeMove(var x, y, f, z: integer; var mass: field);
begin
  case f of
    1:  DetailI(x, y, 0, z, mass);
    2:  DetailJ(x, y, 0, z, mass);
    3:  DetailL(x, y, 0, z, mass);
    4:  DetailO(x, y, 0, z, mass);
    5:  DetailS(x, y, 0, z, mass);
    6:  DetailT(x, y, 0, z, mass);
    7:  DetailZ(x, y, 0, z, mass);
  end
end;


procedure AfterMove(var x, y, f, z: integer; var mass: field);
begin
  case f of
    1:  DetailI(x, y, f, z, mass);
    2:  DetailJ(x, y, f, z, mass);
    3:  DetailL(x, y, f, z, mass);
    4:  DetailO(x, y, f, z, mass);
    5:  DetailS(x, y, f, z, mass);
    6:  DetailT(x, y, f, z, mass);
    7:  DetailZ(x, y, f, z, mass);
  end
end;

procedure Zplus1(var f, z: integer);
begin
  case f of
    1, 5, 7: if z=2 then z:=z-1 else z:=z+1;
    2, 3, 6: if z=4 then z:=1 else z:=z+1
  end
end;

procedure Zminus1(var f, z: integer);
begin
  case f of
    1, 5, 7: if z=2 then z:=z-1 else z:=z+1;
    2, 3, 6: if z=1 then z:=4 else z:=z-1
  end
end;

procedure RotateDetail(var x, y, f, z: integer; var mass: Field);
var
  i: integer;
begin
  BeforeMove(x, y, f, z, mass);
  Zplus1(f, z);
  if IsDetailOk(x, y, f, z, mass) then
  begin
   Zminus1(f, z);
   case f of
    1: begin 
         if z<>1 then
           for i:=y-1 to y+2 do
             mass[x, i]:=0     
         else
           for i:=x-1 to x+2 do
             mass[i, y]:=0;
        if z=1 then
          z:=z+1
        else
          z:=z-1;
        DetailI(x, y, f, z, mass);
       end;
    2: begin 
           case z of
             1: begin mass[x-1, y]:=0; mass[x-1, y+1]:=0; mass[x, y]:=0; mass[x+1, y]:=0 end;
             2: begin mass[x-1, y-1]:=0; mass[x, y+1]:=0; mass[x, y]:=0; mass[x, y-1]:=0 end;    
             3: begin mass[x-1, y]:=0; mass[x+1, y-1]:=0; mass[x, y]:=0; mass[x+1, y]:=0 end;    
             4: begin mass[x, y-1]:=0; mass[x, y+1]:=0; mass[x, y]:=0; mass[x+1, y+1]:=0 end;
           end;
         if z<4 then
           z:=z+1
         else
           z:=1;
         DetailJ(x, y, f, z, mass); 
       end;
    3: begin 
         case z of
           1: begin mass[x-1, y]:=0; mass[x, y]:=0; mass[x+1, y]:=0; mass[x+1, y+1]:=0 end;
           2: begin mass[x-1, y+1]:=0; mass[x, y+1]:=0; mass[x, y]:=0; mass[x, y-1]:=0 end;    
           3: begin mass[x-1, y]:=0; mass[x+1, y]:=0; mass[x, y]:=0; mass[x-1, y-1]:=0 end;    
           4: begin mass[x, y-1]:=0; mass[x, y+1]:=0; mass[x, y]:=0; mass[x+1, y-1]:=0 end;    
         end;
         if z<4 then
           z:=z+1
         else
           z:=1;
         DetailL(x, y, f, z, mass); 
       end;
    4: begin
         mass[x, y]:=0;
         mass[x+1, y]:=0;
         mass[x, y+1]:=0;
         mass[x+1, y+1]:=0;
         DetailO(x, y, f, z, mass);
       end;
    5: begin 
         case z of
           1: begin mass[x-1, y]:=0; mass[x, y]:=0; mass[x, y+1]:=0; mass[x+1, y+1]:=0 end;
           2: begin mass[x, y+1]:=0; mass[x, y]:=0; mass[x+1, y]:=0; mass[x+1, y-1]:=0 end;   
         end; 
         if z=1 then
           z:=z+1
         else
           z:=z-1;         
         DetailS(x, y, f, z, mass);
       end;
    6: begin
         case z of
            1: begin mass[x-1, y]:=0; mass[x, y]:=0; mass[x+1, y]:=0; mass[x, y+1]:=0 end;
            2: begin mass[x-1, y]:=0; mass[x, y+1]:=0; mass[x, y]:=0; mass[x, y-1]:=0 end;    
            3: begin mass[x-1, y]:=0; mass[x+1, y]:=0; mass[x, y]:=0; mass[x, y-1]:=0 end;    
            4: begin mass[x, y-1]:=0; mass[x, y+1]:=0; mass[x, y]:=0; mass[x+1, y]:=0 end;    
         end;
         if z<4 then
           z:=z+1
         else
           z:=1;
         DetailT(x, y, f, z, mass);
       end;
    7: begin
         case z of
           1: begin mass[x+1, y]:=0; mass[x, y]:=0; mass[x, y+1]:=0; mass[x-1, y+1]:=0 end;
           2: begin mass[x, y-1]:=0; mass[x, y]:=0; mass[x+1, y]:=0; mass[x+1, y+1]:=0 end;   
         end;
         if z=1 then
           z:=z+1
         else
           z:=z-1; 
         DetailZ(x, y, f, z, mass);
       end
  end;
  Create(mass);
  end
  else
  begin
    Zminus1(f, z);
    AfterMove(x, y, f, z, mass)
  end
    
end;
  
  

procedure MoveDetailDown(var x, y, f, z: integer; var mass: Field);
var
  i: integer;
begin
  BeforeMove(x, y, f, z, mass);
  y:=y+1;
  if IsDetailOk(x, y, f, z, mass) then
  begin
  y:=y-1;
  case f of
    1: begin
         if z<>1 then
           for i:=y-1 to y+2 do
             mass[x, i]:=0
         else
           for i:=x-1 to x+2 do
             mass[i, y]:=0;
         DetailI(x, y+1, f, z, mass);  
       end;
    2: begin 
           case z of
             1: begin mass[x-1, y]:=0; mass[x-1, y+1]:=0; mass[x, y]:=0; mass[x+1, y]:=0 end;
             2: begin mass[x-1, y-1]:=0; mass[x, y+1]:=0; mass[x, y]:=0; mass[x, y-1]:=0 end;    
             3: begin mass[x-1, y]:=0; mass[x+1, y-1]:=0; mass[x, y]:=0; mass[x+1, y]:=0 end;    
             4: begin mass[x, y-1]:=0; mass[x, y+1]:=0; mass[x, y]:=0; mass[x+1, y+1]:=0 end;
           end;
         DetailJ(x, y+1, f, z, mass); 
       end;
    3: begin 
         case z of
           1: begin mass[x-1, y]:=0; mass[x, y]:=0; mass[x+1, y]:=0; mass[x+1, y+1]:=0 end;
           2: begin mass[x-1, y+1]:=0; mass[x, y+1]:=0; mass[x, y]:=0; mass[x, y-1]:=0 end;    
           3: begin mass[x-1, y]:=0; mass[x+1, y]:=0; mass[x, y]:=0; mass[x-1, y-1]:=0 end;    
           4: begin mass[x, y-1]:=0; mass[x, y+1]:=0; mass[x, y]:=0; mass[x+1, y-1]:=0 end;    
         end; 
         DetailL(x, y+1, f, z, mass); 
       end;
    4: begin
         mass[x, y]:=0;
         mass[x+1, y]:=0;
         mass[x, y+1]:=0;
         mass[x+1, y+1]:=0;
         DetailO(x, y+1, f, z, mass);
       end;
    5: begin 
         case z of
           1: begin mass[x-1, y]:=0; mass[x, y]:=0; mass[x, y+1]:=0; mass[x+1, y+1]:=0 end;
           2: begin mass[x, y+1]:=0; mass[x, y]:=0; mass[x+1, y]:=0; mass[x+1, y-1]:=0 end;   
         end; 
         DetailS(x, y+1, f, z, mass);
       end;
    6: begin
         case z of
            1: begin mass[x-1, y]:=0; mass[x, y]:=0; mass[x+1, y]:=0; mass[x, y+1]:=0 end;
            2: begin mass[x-1, y]:=0; mass[x, y+1]:=0; mass[x, y]:=0; mass[x, y-1]:=0 end;    
            3: begin mass[x-1, y]:=0; mass[x+1, y]:=0; mass[x, y]:=0; mass[x, y-1]:=0 end;    
            4: begin mass[x, y-1]:=0; mass[x, y+1]:=0; mass[x, y]:=0; mass[x+1, y]:=0 end;    
         end; 
         DetailT(x, y+1, f, z, mass);
       end;
    7: begin
         case z of
           1: begin mass[x+1, y]:=0; mass[x, y]:=0; mass[x, y+1]:=0; mass[x-1, y+1]:=0 end;
           2: begin mass[x, y-1]:=0; mass[x, y]:=0; mass[x+1, y]:=0; mass[x+1, y+1]:=0 end;   
         end;
         DetailZ(x, y+1, f, z, mass);
       end
  end;
  y:=y+1;
  Create(mass);
  end
  else
  begin
    y:=y-1;
    AfterMove(x, y, f, z, mass);
  end;
end;



procedure MoveDetailLR(var x, y, f, z, a: integer; var mass: Field);  {a=0 - left, a=1 - right}
var
  i: integer;
begin
  BeforeMove(x, y, f, z, mass);
  if a=0 then x:=x-1 else x:=x+1;
  if IsDetailOk(x, y, f, z, mass) then
  begin
   if a=1 then x:=x-1 else x:=x+1;
  case f of
    1: begin 
         if z<>1 then
           for i:=y-1 to y+2 do
             mass[x, i]:=0
         else
           for i:=x-1 to x+2 do
             mass[i, y]:=0;
         if a=0 then 
           DetailI(x-1, y, f, z, mass)
         else
           DetailI(x+1, y, f, z, mass)
       end;
    2: begin 
           case z of
             1: begin mass[x-1, y]:=0; mass[x-1, y+1]:=0; mass[x, y]:=0; mass[x+1, y]:=0 end;
             2: begin mass[x-1, y-1]:=0; mass[x, y+1]:=0; mass[x, y]:=0; mass[x, y-1]:=0 end;    
             3: begin mass[x-1, y]:=0; mass[x+1, y-1]:=0; mass[x, y]:=0; mass[x+1, y]:=0 end;    
             4: begin mass[x, y-1]:=0; mass[x, y+1]:=0; mass[x, y]:=0; mass[x+1, y+1]:=0 end;
           end;
         if a=0 then 
           DetailJ(x-1, y, f, z, mass)
         else
           DetailJ(x+1, y, f, z, mass) 
       end;
    3: begin 
         case z of
           1: begin mass[x-1, y]:=0; mass[x, y]:=0; mass[x+1, y]:=0; mass[x+1, y+1]:=0 end;
           2: begin mass[x-1, y+1]:=0; mass[x, y+1]:=0; mass[x, y]:=0; mass[x, y-1]:=0 end;    
           3: begin mass[x-1, y]:=0; mass[x+1, y]:=0; mass[x, y]:=0; mass[x-1, y-1]:=0 end;    
           4: begin mass[x, y-1]:=0; mass[x, y+1]:=0; mass[x, y]:=0; mass[x+1, y-1]:=0 end;    
         end; 
         if a=0 then 
           DetailL(x-1, y, f, z, mass)
         else
           DetailL(x+1, y, f, z, mass)
       end;
    4: begin
         mass[x, y]:=0;
         mass[x+1, y]:=0;
         mass[x, y+1]:=0;
         mass[x+1, y+1]:=0;
         if a=0 then 
           DetailO(x-1, y, f, z, mass)
         else
           DetailO(x+1, y, f, z, mass)
       end;
    5: begin 
         case z of
           1: begin mass[x-1, y]:=0; mass[x, y]:=0; mass[x, y+1]:=0; mass[x+1, y+1]:=0 end;
           2: begin mass[x, y+1]:=0; mass[x, y]:=0; mass[x+1, y]:=0; mass[x+1, y-1]:=0 end;   
         end; 
         if a=0 then 
           DetailS(x-1, y, f, z, mass)
         else
           DetailS(x+1, y, f, z, mass)
       end;
    6: begin
         case z of
            1: begin mass[x-1, y]:=0; mass[x, y]:=0; mass[x+1, y]:=0; mass[x, y+1]:=0 end;
            2: begin mass[x-1, y]:=0; mass[x, y+1]:=0; mass[x, y]:=0; mass[x, y-1]:=0 end;    
            3: begin mass[x-1, y]:=0; mass[x+1, y]:=0; mass[x, y]:=0; mass[x, y-1]:=0 end;    
            4: begin mass[x, y-1]:=0; mass[x, y+1]:=0; mass[x, y]:=0; mass[x+1, y]:=0 end;    
         end; 
         if a=0 then 
           DetailT(x-1, y, f, z, mass)
         else
           DetailT(x+1, y, f, z, mass)
       end;
    7: begin
         case z of
           1: begin mass[x+1, y]:=0; mass[x, y]:=0; mass[x, y+1]:=0; mass[x-1, y+1]:=0 end;
           2: begin mass[x, y-1]:=0; mass[x, y]:=0; mass[x+1, y]:=0; mass[x+1, y+1]:=0 end;   
         end;
         if a=0 then 
           DetailZ(x-1, y, f, z, mass)
         else
           DetailZ(x+1, y, f, z, mass)
       end
  end;
  if a=0 then 
    x:=x-1
  else 
    x:=x+1;
  Create(mass);
  end
  else
  begin
    if a=1 then x:=x-1 else x:=x+1;
    AfterMove(x, y, f, z, mass);
  end;
end;



procedure CreateDetail(var x, y, f, z: integer; var mass: field);
begin
  MoveDetailDown(x, y, f, z, mass);
end;

procedure PushSave(x, y, f, z: integer; var mass: Save);
begin
  mass[1]:=x;
  mass[2]:=y;
  mass[3]:=f;
  mass[4]:=z
end;

procedure PopSave(var x, y, f, z: integer; var mass: Save);
begin
  x:=mass[1];
  y:=mass[2];
  f:=mass[3];
  z:=mass[4]
end;



var
  field1: field;
  x, x1, y, y1, z, z1, f, f1, a: integer;
  b, bool, c: boolean;
  ss: save;


procedure Click(x, y, but: integer);
begin
  if (x>=80) and (x<=240) and (y>=300) and (y<=340) and (but=1) then
    bool:=true;
  if (x>=80) and (x<=240) and (y>=250) and (y<=280) and (but=1) then
    c:=true;
end;  

  
procedure GameOver;
begin
  b:=false;
  SetFontSize(30);
  SetFontColor(clRed);
  Brush.Color := clWhite;
  TextOut(80, 250, 'Game Over');
  Redraw;
  Sleep(10);
  ClearWindow;
  Sleep(3000);
  Redraw;
  SetFontSize(20);
  SetFontColor(clBlack);
  Brush.Color := clWhite;
  Rectangle(79, 249, 240, 290);
  Rectangle(80, 299, 240, 340);
  TextOut(85, 253, 'New Game');
  TextOut(140, 303, 'Exit');
  Redraw;
  Sleep(10);
    repeat
      OnMouseMove:=Click;
      Sleep(50);
    until bool or c;
    score := 0;
end;
  
procedure Reaction(q: integer);
begin
  case q of
    VK_Left: begin a:=0; MoveDetailLR(x, y,f ,z, a, field1); end;
    VK_Up: RotateDetail(x, y, f, z, field1);
    VK_Right: begin a:=1; MoveDetailLR(x, y,f ,z, a, field1); end;
    VK_Down: MoveDetailDown(x, y, f, z, field1);
  end
end;

function fq(f: integer): integer;
begin
  case f of
    1, 4: fq:=1;
    2, 3, 6: fq:=2;
    5, 7: fq:=3
  end
end;


procedure Main;
var
  i, j: integer;
begin
  b:=false;
  CreateField;
  Redraw;
  Sleep(AfterDraw);
  for i:=-2 to FieldWidth+15 do
    for j:=-2 to FieldHeight+3 do
      if (i<1) or (i>FieldWidth) or (j<1) or (j>FieldHeight) then
        field1[i, j]:=10; 
  for i:=1 to FieldWidth do
    for j:=1 to FieldHeight do
      field1[i, j]:=0;
  for i:=12 to 16 do
    for j:=2 to 5 do
      field1[i, j]:=0;
  z:=1;
  f:=random(1, 7);
  x:=5;
  y:=0;
  CreateDetail(x, y, f, z, field1);
  f1:=random(1, 7);
  x1:=14;
  y1:=4;
  z1:=1;
  OnKeyDown:=Reaction;  
  repeat
    CreateDetail(x1, y1, f1, z1, field1);  
    BeforeMove(x, y, f, z, field1);
    PushSave(x, y, f, z, ss);
    y:=y+1;
    if not IsDetailOk(x, y, f, z, field1) then
    begin
      PopSave(x, y, f, z, ss);
      AfterMove(x, y, f, z, field1);
      ClearWindow;
      score:=score+round(10*power(4, CheckField(field1))*fq(f)*(FieldHeight+1-y));
      TextOut(440, 440, ' '+score);
      Sleep(AfterDraw);
      if y<2 then
      begin
        GameOver;
        b:=true;
      end;
      z:=1;
      f:=f1;
      x:=5;
      y:=0;
      BeforeMove(x1, y1, f1, z1, field1);
      CreateDetail(x, y, f, z, field1);
      f1:=random(1, 7);
      x1:=14;
      y1:=4;
      CreateDetail(x1, y1, f1, z1, field1);
    end
    else
    begin
      y:=y-1;
      MoveDetailDown(x, y, f, z, field1)
    end;
    Sleep(100);
  until b
  
end;

begin
  MaximizeWindow;
  LockDrawing;
  repeat
    c:=false;
    Main;
    textout(x, y, '');
  until bool;
  CloseWindow;
end.