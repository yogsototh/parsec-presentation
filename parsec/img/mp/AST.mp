% DPI 200
pair A,B,C,D,E,F,G,H;
d:=1.5u;
A=(0,0);
B=A shifted (-1.5d,-d);
C=B shifted (-d/2,-d);
D=C shifted (d,0);
E=B shifted (3d,0);
F=E shifted (-d,-d);
G=F shifted (d,0);
H=G shifted (d,0);

drawState(A, "\times");
drawState(B, "+");
drawState(C, "1");
drawState(D, "3");
drawState(E, "+");
drawState(F, "5");
drawState(G, "7");
drawState(H, "9");

drawEdge(A,B,"");
drawEdge(B,C,"");
drawEdge(B,D,"");
drawEdge(A,E,"");
drawEdge(E,F,"");
drawEdge(E,G,"");
drawEdge(E,H,"");
