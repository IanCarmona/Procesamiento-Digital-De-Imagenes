clc;

usuario = 0;
while usuario == 0
% Leemos las dos imagenes
imagenx = imread("img.jpg");
imageny = imread("mar.jpg");

figure(1);
subplot(2,2,1); 
imshow(imagenx);
title('Imagen 1');
subplot(2,2,2); 
imhist(imagenx); 
title('Histograma de imagen 1');
subplot(2,2,3); 
imshow(imageny);
title('Imagen 2');
subplot(2,2,4); 
imhist(imageny); 
title('Histograma de imagen 2');
%Solicitamos la imagen que desea usar de referencia
Sel = input('Ingrese el número de la imagen que quiere usar de base: ');
if Sel == 1
    imagen1 = imagenx;
    imagen2 = imageny;
elseif Sel == 2
    imagen1 = imageny;
    imagen2 = imagenx;
end

% Obtener los histogramas de ambas imágenes
[h1, x1] = imhist(imagen1);
[h2, x2] = imhist(imagen2);

% Ecualizar el histograma de la imagen 1 para que sea similar al histograma de la imagen 2

imagen1_ecualizada = imhistmatch(imagen2, imagen1);

% Mostrar las imágenes y sus histogramas
figure(2);
subplot(2,2,1); 
imshow(imagen1); 
title('Imagen de Referencia');
subplot(2,2,3); 
imhist(imagen1); 
title('Histograma base');

subplot(2,2,2); 
imshow(imagen1_ecualizada); 
title('Imagen ecualizada');
subplot(2,2,4); 
imhist(imagen1_ecualizada); 
title('Histograma ecualizado');
usuario = input('Introduzca 0 si quiere verificar otros datos o 1 si quiere salir:');
end
disp('Fin del programa, gracias por usarlo :)')


%f(g) = [gmax - gmin] P(g)ACUM + gmin  ECUALIZACION 