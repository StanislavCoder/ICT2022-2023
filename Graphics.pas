//uses GraphWPF;
uses GraphABC;

type point = record
  x, y: real;
end;

type edge = record
 q, s: integer;
 d: real;
end;
 
function compare_edges(a,b: edge):integer;
begin
  if a.d>b.d then result:=1;
  if a.d<b.d then result:=-1;
  if a.d=b.d then result:=0;
end;

function read_points(var p: array of point) : integer;
begin
  var f := OpenRead('input.txt');
  var n := f.ReadlnInteger();
  p := new point [n];
  for var i := 0 to n - 1 do begin
    p[i].x := f.ReadReal();
    p[i].y := f.ReadReal();
  end;
  f.Close;
  result := n;
end;

procedure draw_points(var p:array of point);
begin
    Window.Maximize;
  var (xmin,xmax):=(p[0].x, p[0].x);
  var (ymin,ymax):=(p[0].y, p[0].y);
  for var i:=1 to p.Length-1 do begin
    if xmin>p[i].x then
      xmin:=p[i].x;
    if xmax<p[i].x then
      xmax:=p[i].x;
    if ymin>p[i].y then
      ymin:=p[i].y;
    if ymax<p[i].y then
      ymax:=p[i].y;   
  end;
  var k := Min(Window.Width / (xmax-xmin), Window.Height / (ymax-ymin));
//  SetMathematicCoords(k, -k*xmin, k*ymax);
  //SetMathematicCoords(k, 0, 0);
  //DrawGrid;
  
  for var i:=0 to p.Length-1 do
    Circle(round(k * p[i].x - k * xmin), round(-k * p[i].y + k * ymax), 2);
end;

procedure repaint(var c:array of integer; a,b:integer);
begin
  for var i:=0 to c.Length-1 do
    if c[i]=a then
      c[i]:=b;
end;

begin
  var p : array of point;
  var n := read_points(p);
  draw_points(p);
  
  p.Println;
  
  var d := new real [n, n];
  for var i:=0 to n-1 do
    for var j:=0 to n-1 do begin
      d[i, j] := sqrt(sqr(p[i].x-p[j].x)+sqr(p[i].y-p[j].y));
    end;
  d.Println;
  
  var edges:=new edge [n*(n-1) div 2];
  var cur:=0; // номер текущего ребра
  for var i:=0 to n-1 do begin
    for var j:=i+1 to n-1 do begin
      edges[cur].q:=i;
      edges[cur].s:=j;
      edges[cur].d:=sqrt(sqr(p[i].x-p[j].x)+sqr(p[i].y-p[j].y));
      cur:=cur+1;
    end;
  end;
  sort(edges,compare_edges);
  edges.Println;
  
  //KRUSKAL
  var color:=new integer [n]; // color[i] - цвет вершины #i
  for var i:=0 to n-1 do
    color[i]:=i;
  
  var weight:=0.0; // вес минимального остова
  var cnt:=0; // количество добавленных в остов рёбер
  var ind:=0; // индекс ребра
  while cnt<n-1 do begin
    if color[edges[ind].s]<>color[edges[ind].q] then begin
      weight+=edges[ind].d;
      repaint(color,color[edges[ind].q],color[edges[ind].s]);
      cnt+=1;
    end;
    ind+=1;
  end;
  writeln(weight);
end.