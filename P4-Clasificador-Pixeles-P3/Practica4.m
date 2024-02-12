clc
clear all
close all all
warning off all

% Lectura de la imagen
a = imread("mar.jpg");
[m,n]=size(a);

cielo = input('Ingrese el número de puntos que desea en el cielo: ');
mar = input('Ingrese el número de puntos que desea en el mar: ');
arena = input('Ingrese el número de puntos que desea en la arena: ');

figure(1);
dato=imref2d(size(a));
imshow(a,dato)

%generando las clasificaciones con num aleatorios
 c1x = randi([10,1070],1,cielo);
 c1y = randi([10,410],1,cielo);

 c2x = randi([10,1070],1,mar);
 c2y = randi([411,620],1,mar);

 c3x = randi([10,1070],1,arena);
 c3y = randi([621,1070],1,arena);

 %asigna los valores RGB del plano 

 hold on;
 grid on;
 z1=impixel(a,c1x(1,:),c1y(1,:));
 plot(c1x(1,:),c1y(1,:),'ob','Markersize',5, 'MarkerFaceColor','b');

 z2=impixel(a,c2x(1,:),c2y(1,:));
 plot(c2x(1,:),c2y(1,:),'or','Markersize',5, 'MarkerFaceColor','r');

 z3=impixel(a,c3x(1,:),c3y(1,:));
 plot(c3x(1,:),c3y(1,:),'og','Markersize',5, 'MarkerFaceColor','g');

 double total_cielo;
 double total_mar;
 double total_arena;
 
 total_cielo = sum(z1)/cielo;
 total_cielo = round(total_cielo);

 total_mar = sum(z2)/mar;
 total_mar = round(total_mar);

 total_arena = sum(z3)/arena;
 total_arena = round(total_arena);

%Lectura de datos de usuario
usuario = 0;
while usuario == 0
    clear desconocido;
    figure(2);
    desconocido = impixel(a);
    
    figure(3);
    %guardamos la informacion sobre el plano
    
    plot3(total_mar(1,1),total_mar(1,2),total_mar(1,3), 'ko', 'MarkerSize', 10, 'MarkerFaceColor','r')
    grid on
    hold on
    plot3(total_arena(1,1),total_arena(1,2),total_arena(1,3), 'ko', 'MarkerSize', 10, 'MarkerFaceColor','g')
    plot3(total_cielo(1,1),total_cielo(1,2),total_cielo(1,3), 'ko', 'MarkerSize', 10, 'MarkerFaceColor','b')
    plot3(desconocido(1,1),desconocido(1,2),desconocido(1,3), 'ko', 'MarkerSize', 10, 'MarkerFaceColor','k')
    
    
    plot3(z3(:,1),z3(:,2),z3(:,3), 'go', 'MarkerSize', 5, 'MarkerFaceColor','g')
    plot3(z2(:,1),z2(:,2),z2(:,3), 'ro', 'MarkerSize', 5, 'MarkerFaceColor','r')
    plot3(z1(:,1),z1(:,2),z1(:,3), 'bo', 'MarkerSize', 5, 'MarkerFaceColor','b')
    
    legend('Mar','Arena','Cielo','Desconocido')
    
    distancia_mar = sqrt((total_mar(1,1) - desconocido(1,1))^2 + (total_mar(1,2) - desconocido(1,2))^2 + (total_mar(1,3) - desconocido(1,3))^2);
    distancia_cielo = sqrt((total_cielo(1,1) - desconocido(1,1))^2 + (total_cielo(1,2) - desconocido(1,2))^2 + (total_cielo(1,3) - desconocido(1,3))^2);
    distancia_arena = sqrt((total_arena(1,1) - desconocido(1,1))^2 + (total_arena(1,2) - desconocido(1,2))^2 + (total_arena(1,3) - desconocido(1,3))^2);
    
    arreglo_distancias = min([distancia_cielo, distancia_mar, distancia_arena]);
    
    
    if arreglo_distancias == distancia_mar
        disp('Las cordenadas coinciden con mar')
    
    elseif arreglo_distancias == distancia_cielo
        disp('Las cordenadas coinciden con cielo')
    
    else 
        disp('Las cordenadas coinciden con la arena')
    end
    usuario = input('Introduzca 0 si quiere verificar otro pixel o 1 si quiere salir:');

end
disp('Fin del programa, gracias por usarlo :)')

