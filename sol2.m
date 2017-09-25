%Programa para determinar aspectos geométricos del sol
%-------------------------------------------------------------------
%Variables
    %delta      = Angulo de declinación
    %h           = Hora del día
    %omega   = Angulo horario
    %phi        = Latitud
    %N           = Día del año
    %x            = Variable
    %alfa        =Angulo de elevacion
    %azimut   =Angulo con respecto al norte
    %rise        =Hora de salida del sol
    %set         =Hora de puesta del sol
    %DH         =Horas de sol en el dia
%-------------------------------------------------------------------
%Declaracion de vectores de dias y horas
N(1:365)=1:365;                         %para los dias del año
h(1,1:24)=0:23;                          %para las horas del dia
theta(1,1:25)=-180:15:180;       %Horas angulares del dia
phi=29;                                      %Latitud del lugar

for i=1:1:24
x(1:365,i)=(2*pi/365)*(N-1+((h(1,i)-12)/24));
end

%Calculo de la declinacion del sol 24/365
    delta=(0.006918-0.399912*cos(x)+0.070257*sin(x)-0.006758*cos(2*x)+0.000907*sin(2*x)-0.002697*cos(3*x)+0.001480*sin(3*x))/pi*180;

%Calculo de angulo de elevacion y azimut del sol 24/365
for j=1:1:25
alfa(1:365,j)=asind(sind(delta(:,12))*sind(phi)+cosd(delta(:,12))*cosd(theta(1,j))*cosd(phi));
azimut(1:365,j)=real(acosd((sind(delta(:,12))*cosd(phi)-cosd(delta(:,12))*cosd(theta(1,j))*sind(phi))./cosd(alfa(:,j))));
end

%hora angular de salida y puesta del sol
    rise(1:365,1)=real(-acosd(-tand(phi)*tand(delta(:,12))));
    rise(1:365,2)=(rise(1:365,1)/15)+12;              %Conversion de angulos a horas 
    set(1:365,1)=real(acosd(-tand(phi)*tand(delta(:,12))));
    set(1:365,2)=(set(1:365,1)/15)+12;                %Conversion de angulos a horas

%horas de sol para cada dia
DH=(real(acosd(-tand(phi)*(tand(delta(:,12))))))/7.5;