clc
clear all
close all all
warning off all

% Lectura de la imagen
Imagen = imread("e.jpg");

% Convertir la imagen a escala de grises
ImagenBW = rgb2gray(Imagen);

% Obtener dimensiones de la imagen
[filas, columnas] = size(ImagenBW);

% Calcular la moda de cada fila
modas = mode(ImagenBW, 2);

% Calcular el punto medio de cada fila
puntosMedios = sum(ImagenBW, 2) ./ columnas;

% Reemplazar la moda por el punto medio en cada fila
for i = 1:filas
    moda = modas(i);
    puntoMedio = puntosMedios(i);
    ImagenBW(i, ImagenBW(i,:) == moda) = puntoMedio;
end

% Mostrar ambas imágenes en una figura
figure;

subplot(1,2,1);
imshow(Imagen);
title('Imagen original');

subplot(1,2,2);
imshow(ImagenBW);
title('Imagen procesada');

