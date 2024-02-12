
clc
clear 
close all
warning off all

%Lectura de una imagen
A = imread('descarga.jpg');
B = rgb2gray(A);
C = rgb2gray(A);
Z = rgb2gray(A);

%creacion de la matriz de predicción
[m,n] = size(B);

P = (zeros(m,n));

x = round((m-1) / 2);
y = round((n-1) / 2);

%obtención de la primera fila y primera columna
for j=1:m
    P(j,1) = B(j,1,1);
end
for k=1:n
    P(1,k) = B(1,k,1);
end

j=2;
i=2;

while(i <= m)
    while(j <= n)

    
    
    if(j == n && i == m)

        P(i,j) = round((B(i,j-1)+B(i-1,j-1)+B(i-1,j))/3);

        C(i,j) = P(i,j);

    elseif(j == n)

        P(i,j) = round((B(i+1,j-1)+B(i,j-1)+B(i-1,j-1)+B(i-1,j))/4);

        P(i+1,j) = round((B(i,j)+B(i,j-1)+B(i+1,j-1))/3);

        C(i,j) = P(i,j);

        C(i+1,j) = P(i+1,j);

    elseif(i == m)

        P(i,j) = round((B(i-1,j-1)+B(i,j-1)+B(i-1,j)+B(i-1,j+1))/4);
    
        P(i,j+1) = round((B(i,j)+B(i-1,j)+B(i-1,j+1))/3);

        C(i,j) = P(i,j);

        C(i,j+1) = P(i,j+1);

    else

        P(i,j) = round((B(i-1,j-1)+B(i,j-1)+B(i+1,j-1)+B(i-1,j)+B(i-1,j+1))/5);
    
        P(i,j+1) = round((B(i,j)+B(i-1,j)+B(i-1,j+1))/3);

        P(i+1,j) = round((B(i+1,j-1)+B(i,j-1)+B(i,j)+B(i,j+1))/4);

        P(i+1,j+1) = round((B(i,j)+B(i,j+1)+B(i+1,j))/3);

        C(i,j) = P(i,j);

        C(i,j+1) = P(i,j+1);

        C(i+1,j) = P(i+1,j);

        C(i+1,j+1) = P(i+1,j+1);

    end
    j=j+2;

    
    end
    
    i=i+2;

    j= 2;
end




%Creacion la matriz de Error
E = zeros(m,n);
Eshow = zeros(m,n);
Eshow = double(Eshow);

%Error
%Error

    for i=1:m
        for j=1:n
            Error = ( double(B(i,j)) - double(P(i,j)));
            E(i,j) = Error;
            Eshow(i,j) = Error + 128;
        end
    end

Eshow = uint8(Eshow);



Nbit = input('A cuantos bits decea comprimir (1-8): ');
sizet = pow2(Nbit);
Tbit = (zeros(1,sizet));

figure(1)
subplot(2,2,1)
imshow(B)
title('Original')
subplot(2,2,2)
imshow(C)
title('Prediccion')

subplot(2,2,3)
imshow(Eshow)
title('Error')

%Creación de la matriz Error Quantificada
EQ = zeros(m,n);

%Estimar los valores de las muestras
min = (double(min(min(E))));
max = (double(max(max(E))));

delta = (max-min)/(sizet);
suma = min;

for rec = 1:sizet
        Tbit(1,rec,1) = suma(1,1);
        suma(1,1) = suma(1,1) + delta(1,1);
        Tbit(2,rec,1) = suma(1,1);
end


    for i=1:m
        for j=1:n
            muestraerror = double(E(i,j));
            %sizet es igual al numero de intervalos
            for l=1:sizet
                nmin = Tbit(1,l);
                nmax = Tbit(2,l);
                if muestraerror < nmax && muestraerror > nmin
                    EQ(i,j) = l - 1;
                end
            end
        end
    end

%Sacar la matriz quantificada -1
EQ1 = zeros(m,n);
EQ1 = double(EQ1);

%Proceso de [MEQ]^-1

    for i=1:m
        for j=1:n
            valormuestra = double(EQ(i,j)) + 1;
            nmin = double(Tbit(1,valormuestra));
            nmax = double(Tbit(2,valormuestra));
            nuevovalor = round((nmin + nmax) / 2);
            EQ1(i,j) = nuevovalor;
        end
    end

    EQ2 = uint8(EQ1);

%Recuperada
R = double(EQ2) + double(P);
R = uint8(R);

subplot(2,2,4)
imshow(R)
title('Recuperada')

Arriba = double(Z);
Arriba = Arriba^2;

Abajo = (double(Z)-double(R));
Abajo = Abajo^2;

Arall = sum(Arriba,'all');

Aball = sum(Abajo,'all');

Dentro=(Arall/Aball);

casiF = log10(Dentro);

final = 10*casiF;

disp(final-25);







