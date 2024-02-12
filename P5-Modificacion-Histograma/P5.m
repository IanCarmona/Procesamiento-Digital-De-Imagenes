clc;

x = imread("img.jpg");
a = double(x);
usuario = 0;
while usuario == 0
% obtiene el tamaño de la imagen
[filas,columnas,colores] = size(a);
disp('Ingrese los limites que desea ajustar');
mi = input('Ingrese el limite inferior:');
ma= input('Ingrese el limite superior:');
% Reshape la imagen en una matriz de 2D para poder obtener los valores mínimos de cada componente
componentes = reshape(a, filas * columnas, colores);
% Obtiene los valores mínimos y maximos de cada componente RGB
min_RGB = min(componentes);
max_RGB = max(componentes);
    New(:,:,1) = (((a(:,:,1)-min_RGB(1)) / (max_RGB(1)-min_RGB(1))) * (ma-mi)) + mi;
    New(:,:,2) = (((a(:,:,2)-min_RGB(2)) / (max_RGB(2)-min_RGB(2))) * (ma-mi)) + mi;
    New(:,:,3) = (((a(:,:,3)-min_RGB(3)) / (max_RGB(3)-min_RGB(3))) * (ma-mi)) + mi;
    z = round(New);
    valores_pixeles = uint8(z); % obtiene los valores de los píxeles en la ubicación (i,j)
figure(1);
subplot(2,2,1);
imshow(x);
title('Figura Original');
subplot(2,2,2);
histogram(x);
title('Histograma original');

subplot(2,2,3);
imshow(valores_pixeles);
title('Figura Resultante');
subplot(2,2,4);
histogram(valores_pixeles);
title('Histograma Procesado');

figure(2);
subplot(2,5,1);
imshow(x);
title('Original');

subplot(2,5,2);
imshow(valores_pixeles);
title('Resultante');

subplot(2,5,3);
imshow(valores_pixeles(:,:,1));
title('Gris R');

subplot(2,5,4);
imshow(valores_pixeles(:,:,2));
title('Gris G');

subplot(2,5,5);
imshow(valores_pixeles(:,:,3));
title('Gris B');

subplot(2,5,6);
bar(imhist(x));
title('original');

bw = rgb2gray(valores_pixeles); % convierte la imagen en escala de grises
bw_r = valores_pixeles(:,:,1); % convierte la imagen en escala de grises
bw_g = valores_pixeles(:,:,2); % convierte la imagen en escala de grises
bw_b = valores_pixeles(:,:,3); % convierte la imagen en escala de grises

subplot(2,5,7);

bar(imhist(bw)); % muestra el histograma
title('Procesado');

subplot(2,5,8);
bar(imhist(bw_r)); % muestra el histograma
title('GrayR Procesado');

subplot(2,5,9);
bar(imhist(bw_g)); % muestra el histograma
title('GrayG Procesado');

subplot(2,5,10);
bar(imhist(bw_b)); % muestra el histograma
title('GrayB Procesado');
 usuario = input('Introduzca 0 si quiere verificar otros datos o 1 si quiere salir:');
end
disp('Fin del programa, gracias por usarlo :)')