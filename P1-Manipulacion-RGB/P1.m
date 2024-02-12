% LIMPIAR

clc
close all
warning off all

% ARCHIVOS

MONEDA = imread('moneda.jpg');
LETRA_A= imread('A.jpg');

% TAMAÑO

[m_a,n_a] = size(LETRA_A);
[m_m,n_m] = size(MONEDA);

% VISUALIZAR

figure(1);

% CASO 1

subplot(2,2,1);

r = MONEDA;
r(:,:,1);
r(:,:,2) = 0;
r(:,:,3) = 0;

g = MONEDA;
g(:,:,1) = 0;
g(:,:,2);
g(:,:,3) = 0;

b = MONEDA;
b(:,:,1) = 0;
b(:,:,2) = 0;
b(:,:,3);

out = imtile({MONEDA,r,g,b});

imshow(out);
title("Todos los formatos");

% CASO 2

RGB_V = MONEDA;
RGB_V(:,1:200,1);
RGB_V(:,1:200,2) = 0;
RGB_V(:,1:200,3) = 0;
RGB_V(:,201:400,1) = 0;
RGB_V(:,201:400,2);
RGB_V(:,201:400,3) = 0;
RGB_V(:,401:600,1) = 0;
RGB_V(:,401:600,2) = 0;
RGB_V(:,401:600,3);
subplot(2,2,2);
imshow(RGB_V);
title("RGB Vertical");

% CASO 3

RGB_H = MONEDA;
RGB_H(1:200,:,1);
RGB_H(1:200,:,2) = 0;
RGB_H(1:200,:,3) = 0;
RGB_H(201:400,:,1) = 0;
RGB_H(201:400,:,2);
RGB_H(201:400,:,3) = 0;
RGB_H(401:600,:,1) = 0;
RGB_H(401:600,:,2) = 0;
RGB_H(401:600,:,3);
subplot(2,2,3);
imshow(RGB_H);
title("RGB Horizontal");

% CASO 4

% Componente 4
% RGB Letra
letra = imread("A2.jpg");
A2 = letra;
Elemento3 = letra;
subplot(2,2,4);

%R
Elemento3(:,1:283,1) = -255;
Elemento3(:,1:283,2);
Elemento3(:,1:283,3);

%G
A2(:,:,1);
A2(:,:,2)=255;
A2(:,:,3);

%B
Elemento3(:,284:567,1);
Elemento3(:,284:567,2);
Elemento3(:,284:567,3) = -255;

final = A2 - Elemento3;

imshow(final);
title('Letra RGB');


