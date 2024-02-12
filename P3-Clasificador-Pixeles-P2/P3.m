clc
% Leer la imagen
img = imread('mar.jpg');
num = input('Ingrese el número total de puntos que desea ingresar: ');

% Mostrar la imagen en una figura
figure;
imshow(img);

% Esperar a que el usuario seleccione un punto y obtener las coordenadas
[x, y] = ginput(num);
pixel_rgb = impixel(img, x, y);
% Mostrar las coordenadas en la consola
x = round(x);
y = round(y);
pixel_cielo = [];
pixel_mar = [];
pixel_arena = [];


for i = 1:num
    %Corregir, no entran los valores, los manda a else
    if (y(i,1) < 420 && y(i,1) >= 0)
        fprintf('Coordenadas del pixel cielo: (%d, %d) con sus tres canales rgb (%d %d %d)\n', x(i,1), y(i,1), pixel_rgb(i,1), pixel_rgb(i,2), pixel_rgb(i,3));
        pixel_cielo = vertcat(pixel_cielo, pixel_rgb(i,:));
    elseif (y(i,1) < 620 && y(i,1) >= 420)
        fprintf('Coordenadas del pixel mar: (%d, %d) con sus tres canales rgb (%d %d %d)\n', x(i,1), y(i,1), pixel_rgb(i,1), pixel_rgb(i,2), pixel_rgb(i,3));
        pixel_mar = vertcat(pixel_mar, pixel_rgb(i,:));
    elseif (y(i,1) < 1074 && y(i,1) >= 620)
        fprintf('Coordenadas del pixel arena: (%d, %d) con sus tres canales rgb (%d %d %d)\n', x(i,1), y(i,1), pixel_rgb(i,1), pixel_rgb(i,2), pixel_rgb(i,3));
        pixel_arena = vertcat(pixel_arena, pixel_rgb(i,:));
    else
        disp('Error')
    end

end

%-------------------Graficamos todos los puntos

figure(2);

plot3(pixel_cielo(:,1),pixel_cielo(:,2),pixel_cielo(:,3),  'ko', 'MarkerSize', 8, 'MarkerFaceColor','b')
grid on
hold on
plot3(pixel_mar(:,1),pixel_mar(:,2),pixel_mar(:,3),  ['ko'], 'MarkerSize', 8, 'MarkerFaceColor','r')
plot3(pixel_arena(:,1),pixel_arena(:,2),pixel_arena(:,3),  'ko', 'MarkerSize', 8, 'MarkerFaceColor','y')

legend('Puntos Cielo', 'Puntos Mar', 'Puntos Arena')