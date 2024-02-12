%clear all;
clc;

paisaje = imread('paisaje.png');

pixel_montania = impixel(paisaje);
pixel_cielo = impixel(paisaje);
pixel_pasto = impixel(paisaje);

imshow(paisaje);


total_montania = sum(pixel_montania)/5;
total_montania = round(total_montania);

total_cielo = sum(pixel_cielo)/5;
total_cielo = round(total_cielo);

total_pasto= sum(pixel_pasto)/5;
total_pasto = round(total_pasto);


% desconocido = input("Ingrese 3 valores R G B: ");
desconocido = impixel(paisaje);

plot3(total_montania(1,1),total_montania(1,2),total_montania(1,3), 'ro', 'MarkerSize', 10, 'MarkerFaceColor','r')
grid on
hold on
plot3(total_pasto(1,1),total_pasto(1,2),total_pasto(1,3), 'bo', 'MarkerSize', 10, 'MarkerFaceColor','b')
plot3(total_cielo(1,1),total_cielo(1,2),total_cielo(1,3), 'yo', 'MarkerSize', 10, 'MarkerFaceColor','y')
plot3(desconocido(1,1),desconocido(1,2),desconocido(1,3), 'go', 'MarkerSize', 10, 'MarkerFaceColor','g')


plot3(pixel_pasto(:,1),pixel_pasto(:,2),pixel_pasto(:,3), 'wo', 'MarkerSize', 5, 'MarkerFaceColor','k')
plot3(pixel_montania(:,1),pixel_montania(:,2),pixel_montania(:,3), 'wo', 'MarkerSize', 5, 'MarkerFaceColor','k')
plot3(pixel_cielo(:,1),pixel_cielo(:,2),pixel_cielo(:,3), 'wo', 'MarkerSize', 5, 'MarkerFaceColor','k')

legend('Montaña','Pasto','Cielo','Desconocido')

distancia_pasto = sqrt((total_pasto(1,1) - desconocido(1,1))^2 + (total_pasto(1,2) - desconocido(1,2))^2 + (total_pasto(1,3) - desconocido(1,3))^2);
distancia_cielo = sqrt((total_cielo(1,1) - desconocido(1,1))^2 + (total_cielo(1,2) - desconocido(1,2))^2 + (total_cielo(1,3) - desconocido(1,3))^2);
distancia_montania = sqrt((total_montania(1,1) - desconocido(1,1))^2 + (total_montania(1,2) - desconocido(1,2))^2 + (total_montania(1,3) - desconocido(1,3))^2);

arreglo_distancias = min([distancia_montania, distancia_cielo, distancia_pasto]);

if arreglo_distancias == distancia_pasto
    disp('Las cordenadas coinciden con pasto')

elseif arreglo_distancias == distancia_cielo
    disp('Las cordenadas coinciden con cielo')

else 
    disp('Las cordenadas coinciden con montaña')
end

