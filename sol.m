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
    %DH        =Horas de sol en el dia
    %t            =Correccion del tiempo en minutos
    %  Angulos del colector
    %beta      =angulo con respecto al norte
    %psi        =angulo con respecto al sur
%-------------------------------------------------------------------
%Declaracion de vectores de dias y horas
N(1:365)=1:365;                              %para los dias del año
h(1,1:24)=0:23;                                %para las horas del dia
theta(1,1:25)=-180:15:180;             %Horas angulares del dia
phi=19.602378                                            %Latitud del lugar
lambda=-155.487192;                                  %Longitud
for i=1:1:24
x(1:365,i)=(2*pi/365)*(N-1+((h(1,i)-12)/24));
end

y=(360*(N-1))/(365.2422);

%Calculo de la declinacion del sol 24/365
    delta=(0.006918-0.399912*cos(x)+0.070257*sin(x)-0.006758*cos(2*x)+0.000907*sin(2*x)-0.002697*cos(3*x)+0.001480*sin(3*x))/pi*180;

%Calculo de angulo de elevacion y azimut del sol 24/365
for j=1:1:25
alfa(1:365,j)=asind(sind(delta(:,12))*sind(phi)+cosd(delta(:,12))*cosd(theta(1,j))*cosd(phi));
azimut(1:365,j)=real(acosd((sind(delta(:,12))*cosd(phi)-cosd(delta(:,12))*cosd(theta(1,j))*sind(phi))./cosd(alfa(:,j))));
end

%Ecuacion del tiempo
et=12+(0.1236*sind(y)-0.0043*cosd(y))+(0.1583*sind(2*y)+0.0608*cosd(2*y));

%Longitud del tiempo estándar del lugar
li=(29+7)/15;

%Hora solar
for i=1:1:24
ts(1:365,i) = h(1,i) - et(1,1:365) - li;
end

%hora de salida y puesta del sol
    rise(1:365,1)=real(acosd(((-sind(phi)*sind(delta(:,12)))-sind(-.8333))./(cosd(phi)*cosd(delta(:,12)))));
    rise(1:365,2)=12-(rise(1:365,1)/15);
    set(1:365,1)=real(acosd(((-sind(phi)*sind(delta(:,12)))-sind(-.8333))./(cosd(phi)*cosd(delta(:,12)))));
    set(1:365,2)=12+(set(1:365,1)/15);
    
    %horas de sol para cada dia
DH=(real(acosd(-tand(phi)*(tand(delta(:,12))))))/7.5;

psi=0;
beta(1:181,1)=-90:1:90;
E(181,1)=0;
%Intensidad de la radiacion en un colector
for k=1:1:181
I(1:365,1:25)=sind(beta(k,1))*(cosd(alfa).*cosd(azimut))+sind(alfa)*cosd(beta(k,1));
%Generara una nueva matriz de intensidades para cada angulo de inclinacion,
%se busca que los sume y se obtenga una grafica de E (suma de las I) vs beta
E(k,1)=-sum(sum(I));
end