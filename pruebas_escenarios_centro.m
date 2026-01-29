load variables_menos_x_y_ebx_eby.mat

EBx=50
EBy=50

Eminima=0.01
n=100

load escenario.mat

porcentaje_ch=0.1;
porcentaje_sch=0.04;

for k=1:15,

    x=X(k,:);
    y=Y(k,:);

[FND(k) HND(k) LND(k)] =cascada_2_tier_sostenibilidad_mediana(x,y,x_max,y_max,n,stop,porcentaje_ch,porcentaje_sch,EBx,EBy,Eo,ETX,ERX,Efs,Eamp,EDA,packetSize,controlPacketSize,Eminima);

end