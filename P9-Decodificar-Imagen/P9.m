clc;
clear all
close all
warning of all

%leemos la imagen
x = imread("e.jpg");
a = rgb2gray(x);
usuario = 0;
cuantificador = [16 11 10 16 24 40 51 61;
         12 12 14 19 26 58 60 55;
         14 13 16 24 40 57 69 56;
         14 17 22 29 51 87 80 62;
         18 22 37 56 68 109 103 77;
         24 35 55 64 81 104 113 92;
         49 64 78 87 103 121 120 101;
         72 92 95 98 112 100 103 99];
while usuario == 0
    clear cadena;
    run = 0;
    % obtiene el tamaño de la imagen
    [filas,columnas, ~] = size(a);
    
    % Dividir la imagen en n partes iguales
    FC = 8;
    n = columnas/FC;
    % Calcular el tamaño de cada parte
    P = floor(filas/n);
    Q = floor(columnas/n);
    
    % Inicializar la matriz de celdas para almacenar cada parte
    partes = cell(1,n*n);
    
    % Dividir la imagen en n x n partes iguales usando un ciclo for
    k = 1;
    for i = 1:n
        for j = 1:n
            parte = a( (i-1)*P+1:i*P, (j-1)*Q+1:j*Q, : );
            partes{k} = parte;
            k = k+1;
        end
    end
    %pedimos al usuario que introduzca el recuadro que desea decodificar
    cuadro = input('Introduzca el cuadro que desea decodificar:');
    x1 = double(partes{cuadro});
    x2 = x1 - 128;
    x3 = dct2(x2);
    x4 = x3 ./cuantificador;
    x5 = round(x4);
    
    if(x5(1,1) == 0)%0
        cadena = '010';
        lenght = 3;
    elseif(x5(1,1) == -1 || x5(1,1) == 1)%1
        cadena = '011';
        lenght = 4;
    elseif(x5(1,1)<= -2 && x5(1,1)>= -3 || x5(1,1)<= 3 && x5(1,1)>= 2)%2
        cadena = '100';
        lenght = 5;
    elseif(x5(1,1)<= -4 && x5(1,1)>= -7 || x5(1,1)<= 7 && x5(1,1)>= 4)%3
        cadena = '00';
        lenght = 5;
    elseif(x5(1,1)<= -8 && x5(1,1)>= -15 || x5(1,1)<= 15 && x5(1,1)>= 8)%4
        cadena = '101';
        lenght = 7;
    elseif(x5(1,1)<= -16 && x5(1,1)>= -31 || x5(1,1)<= 31 && x5(1,1)>= 16)%5
        cadena = '110';
        lenght = 8;
    elseif(x5(1,1)<= -32 && x5(1,1)>= -63 || x5(1,1)<= 63 && x5(1,1)>= 32)%6
        cadena = '1110';
        lenght = 10;
    elseif(x5(1,1)<= -64 && x5(1,1)>= -127 || x5(1,1)<= 127 && x5(1,1)>= 64)%7
        cadena = '11110';
        lenght = 12;
    elseif(x5(1,1)<= -128 && x5(1,1)>= -255 || x5(1,1)<= 255 && x5(1,1)>= 128)%8
        cadena = '111110';
        lenght = 14;
    elseif(x5(1,1)<= -256 && x5(1,1)>= -511 || x5(1,1)<= 511 && x5(1,1)>= 256)%9
        cadena = '1111110';
        lenght = 16;
    elseif(x5(1,1)<= -512 && x5(1,1)>= -1023 || x5(1,1)<= 1023 && x5(1,1)>= 512)%A
        cadena = '11111110';
        lenght = 18;
    elseif(x5(1,1)<= -1024 && x5(1,1)>= -2047 || x5(1,1)<= 2047 && x5(1,1)>= 1024)%B
        cadena = '111111110';
        lenght = 20;
    else
    disp('Error al categorizar el primer bit')
    
    end 
    if(cuadro == 1)
        posant = zeros(8,8);
    else
        posant = double(partes{cuadro-1});
    end
     x6 = x5(1,1)- posant(1,1);
     tam = length(cadena);
     bits = lenght-tam;
     %convertimos el valor a binario
     if (x6<0)
        y = abs(x6);
        y0 = dec2bin(y, bits);
        y1 = ['0' y0];
        % Invertir todos los bits
        y2 = double(y1) - '0';
        % Invertir bits
        y3 = ~y2;
        
        % Convertir de vuelta a cadena de caracteres
        y4 = char(y3 + '0');
        z1 = y4;
        z2 = '1';
        %sumarle 1
        z11 = bin2dec(z1);
        z22 = bin2dec(z2);
        num_neg = z11 + z22;

        num_neg_bin = dec2bin(num_neg);
        cadena = [cadena num_neg_bin];
    
    
     else
          num_bin = dec2bin(x6, bits);
          cadena = [cadena '0'];
          cadena = [cadena num_bin];
     end
    recorridoX = [2,1,1,2,3,4,3,2,1,1,2,3,4,5,6,5,4,3,2,1,1,2,3,4,5,6,7,8,7,6,5,4,3,2,1,2,3,4,5,6,7,8,8,7,6,5,4,3,4,5,6,7,8,8,7,6,5,6,7,8,8,7,8];
    recorridoY = [1,2,3,2,1,1,2,3,4,5,4,3,2,1,1,2,3,4,5,6,7,6,5,4,3,2,1,1,2,3,4,5,6,7,8,8,7,6,5,4,3,2,3,4,5,6,7,8,8,7,6,5,4,5,6,7,8,8,7,6,7,8,8];
    for i = 1:63
        c1 = recorridoX(1,i);
        f1 = recorridoY(1,i);
        if((x5(f1,c1) == 0))
            run = run + 1;
        else
            %comparar con la tabla run/category
            % 0
            if(x5(f1,c1) == 0 && run == 0) %0
                base = '1010';
                lenght1 = 4;
                run = 0;
        
            elseif((x5(f1,c1) == -1 || x5(f1,c1) == 1) && run == 0) %1
                base = '00';
                lenght1 = 3;
                run = 0;
        
            elseif((x5(f1,c1)<= -2 && x5(f1,c1)>= -3 || x5(f1,c1)<= 3 && x5(f1,c1)>= 2) && run == 0) %2
               base = '01';
               lenght1 = 4;
               run = 0;
        
            elseif((x5(f1,c1)<= -4 && x5(f1,c1)>= -7 || x5(f1,c1)<= 7 && x5(f1,c1)>= 4) && run == 0) %3
                base = '100';
                lenght1 = 6;
                run = 0;
        
            elseif((x5(f1,c1)<= -8 && x5(f1,c1)>= -15 || x5(f1,c1)<= 15 && x5(f1,c1)>= 8) && run == 0) %4
                base = '1011';
                lenght1 = 8;
                run = 0;
        
            elseif((x5(f1,c1)<= -16 && x5(f1,c1)>= -31 || x5(f1,c1)<= 31 && x5(f1,c1)>= 16) && run == 0) %5
                base = '11010';
                lenght1 = 10;
                run = 0;
        
            elseif((x5(f1,c1)<= -32 && x5(f1,c1)>= -63 || x5(f1,c1)<= 63 && x5(f1,c1)>= 32) && run == 0) %6
                base = '111000';
                lenght1 = 12;
                run = 0;
        
            elseif((x5(f1,c1)<= -64 && x5(f1,c1)>= -127 || x5(f1,c1)<= 127 && x5(f1,c1)>= 64) && run == 0) %7
                base = '1111000';
                lenght1 = 14;
                run = 0;
        
            elseif((x5(f1,c1)<= -128 && x5(f1,c1)>= -255 || x5(f1,c1)<= 255 && x5(f1,c1)>= 128) && run == 0) %8
                base = '1111110110';
                lenght1 = 18;
                run = 0;
        
            elseif((x5(f1,c1)<= -256 && x5(f1,c1)>= -511 || x5(f1,c1)<= 511 && x5(f1,c1)>= 256) && run == 0) %9
                base = '1111111110000010';
                lenght1 = 25;
                run = 0;
        
            elseif((x5(f1,c1)<= -512 && x5(f1,c1)>= -1023 || x5(f1,c1)<= 1023 && x5(f1,c1)>= 512) && run == 0) %A
                base = '1111111110000011';
                lenght1 = 26;
                run = 0;
        
            % 1
            elseif((x5(f1,c1) == -1 || x5(f1,c1) == 1) && run == 1) %1
                base = '1100';
                lenght1 = 5;
                run = 0; 
        
            elseif((x5(f1,c1)<= -2 && x5(f1,c1)>= -3 || x5(f1,c1)<= 3 && x5(f1,c1)>= 2) && run == 1) %2
               base = '111001';
               lenght1 = 8;
               run = 0;
        
            elseif((x5(f1,c1)<= -4 && x5(f1,c1)>= -7 || x5(f1,c1)<= 7 && x5(f1,c1)>= 4) && run == 1) %3
                base = '1111001';
                lenght1 = 10;
                run = 0;
        
            elseif((x5(f1,c1)<= -8 && x5(f1,c1)>= -15 || x5(f1,c1)<= 15 && x5(f1,c1)>= 8) && run == 1) %4
                base = '111110110';
                lenght1 = 13;
                run = 0;
        
            elseif((x5(f1,c1)<= -16 && x5(f1,c1)>= -31 || x5(f1,c1)<= 31 && x5(f1,c1)>= 16) && run == 1) %5
                base = '11111110110';
                lenght1 = 16;
                run = 0;
        
            elseif((x5(f1,c1)<= -32 && x5(f1,c1)>= -63 || x5(f1,c1)<= 63 && x5(f1,c1)>= 32) && run == 1) %6
                base = '1111111110000100';
                lenght1 = 22;
                run = 0;
        
            elseif((x5(f1,c1)<= -64 && x5(f1,c1)>= -127 || x5(f1,c1)<= 127 && x5(f1,c1)>= 64) && run == 1) %7
                base = '1111111110000101';
                lenght1 = 23;
                run = 0;
        
            elseif((x5(f1,c1)<= -128 && x5(f1,c1)>= -255 || x5(f1,c1)<= 255 && x5(f1,c1)>= 128) && run == 1) %8
                base = '1111111110000110';
                lenght1 = 24;
                run = 0;
        
            elseif((x5(f1,c1)<= -256 && x5(f1,c1)>= -511 || x5(f1,c1)<= 511 && x5(f1,c1)>= 256) && run == 1) %9
                base = '1111111110000111';
                lenght1 = 25;
                run = 0;
        
            elseif((x5(f1,c1)<= -512 && x5(f1,c1)>= -1023 || x5(f1,c1)<= 1023 && x5(f1,c1)>= 512) && run == 1) %A
                base = '1111111110001000';
                lenght1 = 26;
                run = 0;
            % 2
            elseif((x5(f1,c1) == -1 || x5(f1,c1) == 1) && run == 2) %1
                base = '11011';
                lenght1 = 6;
                run = 0; 
        
            elseif((x5(f1,c1)<= -2 && x5(f1,c1)>= -3 || x5(f1,c1)<= 3 && x5(f1,c1)>= 2) && run == 2) %2
               base = '11111000';
               lenght1 = 10;
               run = 0;
        
            elseif((x5(f1,c1)<= -4 && x5(f1,c1)>= -7 || x5(f1,c1)<= 7 && x5(f1,c1)>= 4) && run == 2) %3
                base = '1111110111';
                lenght1 = 13;
                run = 0;
        
            elseif((x5(f1,c1)<= -8 && x5(f1,c1)>= -15 || x5(f1,c1)<= 15 && x5(f1,c1)>= 8) && run == 2) %4
                base = '1111111110001001';
                lenght1 = 20;
                run = 0;
        
            elseif((x5(f1,c1)<= -16 && x5(f1,c1)>= -31 || x5(f1,c1)<= 31 && x5(f1,c1)>= 16) && run == 2) %5
                base = '1111111110001010';
                lenght1 = 21;
                run = 0;
        
            elseif((x5(f1,c1)<= -32 && x5(f1,c1)>= -63 || x5(f1,c1)<= 63 && x5(f1,c1)>= 32) && run == 2) %6
                base = '1111111110001011';
                lenght1 = 22;
                run = 0;
        
            elseif((x5(f1,c1)<= -64 && x5(f1,c1)>= -127 || x5(f1,c1)<= 127 && x5(f1,c1)>= 64) && run == 2) %7
                base = '1111111110001100';
                lenght1 = 23;
                run = 0;
        
            elseif((x5(f1,c1)<= -128 && x5(f1,c1)>= -255 || x5(f1,c1)<= 255 && x5(f1,c1)>= 128) && run == 2) %8
                base = '1111111110001101';
                lenght1 = 24;
                run = 0;
        
            elseif((x5(f1,c1)<= -256 && x5(f1,c1)>= -511 || x5(f1,c1)<= 511 && x5(f1,c1)>= 256) && run == 2) %9
                base = '1111111110001110';
                lenght1 = 25;
                run = 0;
        
            elseif((x5(f1,c1)<= -512 && x5(f1,c1)>= -1023 || x5(f1,c1)<= 1023 && x5(f1,c1)>= 512) && run == 2) %A
                base = '1111111110001111';
                lenght1 = 26;
                run = 0;
        
            %3
            elseif((x5(f1,c1) == -1 || x5(f1,c1) == 1) && run == 3) %1
                base = '111010';
                lenght1 = 7;
                run = 0; 
        
            elseif((x5(f1,c1)<= -2 && x5(f1,c1)>= -3 || x5(f1,c1)<= 3 && x5(f1,c1)>= 2) && run == 3) %2
               base = '111110111';
               lenght1 = 11;
               run = 0;
        
            elseif((x5(f1,c1)<= -4 && x5(f1,c1)>= -7 || x5(f1,c1)<= 7 && x5(f1,c1)>= 4) && run == 3) %3
                base = '11111110111';
                lenght1 = 14;
                run = 0;
        
            elseif((x5(f1,c1)<= -8 && x5(f1,c1)>= -15 || x5(f1,c1)<= 15 && x5(f1,c1)>= 8) && run == 3) %4
                base = '1111111110010000';
                lenght1 = 20;
                run = 0;
        
            elseif((x5(f1,c1)<= -16 && x5(f1,c1)>= -31 || x5(f1,c1)<= 31 && x5(f1,c1)>= 16) && run == 3) %5
                base = '1111111110010001';
                lenght1 = 21;
                run = 0;
        
            elseif((x5(f1,c1)<= -32 && x5(f1,c1)>= -63 || x5(f1,c1)<= 63 && x5(f1,c1)>= 32) && run == 3) %6
                base = '1111111110010010';
                lenght1 = 22;
                run = 0;
        
            elseif((x5(f1,c1)<= -64 && x5(f1,c1)>= -127 || x5(f1,c1)<= 127 && x5(f1,c1)>= 64) && run == 3) %7
                base = '1111111110010011';
                lenght1 = 23;
                run = 0;
        
            elseif((x5(f1,c1)<= -128 && x5(f1,c1)>= -255 || x5(f1,c1)<= 255 && x5(f1,c1)>= 128) && run == 3) %8
                base = '1111111110010100';
                lenght1 = 24;
                run = 0;
        
            elseif((x5(f1,c1)<= -256 && x5(f1,c1)>= -511 || x5(f1,c1)<= 511 && x5(f1,c1)>= 256) && run == 3) %9
                base = '1111111110010101';
                lenght1 = 25;
                run = 0;
        
            elseif((x5(f1,c1)<= -512 && x5(f1,c1)>= -1023 || x5(f1,c1)<= 1023 && x5(f1,c1)>= 512) && run == 3) %A
                base = '1111111110010110';
                lenght1 = 26;
                run = 0;
            %4
           elseif((x5(f1,c1) == -1 || x5(f1,c1) == 1) && run == 4) %1
                base = '111011';
                lenght1 = 7;
                run = 0; 
        
            elseif((x5(f1,c1)<= -2 && x5(f1,c1)>= -3 || x5(f1,c1)<= 3 && x5(f1,c1)>= 2) && run == 4) %2
               base = '1111111000';
               lenght1 = 12;
               run = 0;
        
            elseif((x5(f1,c1)<= -4 && x5(f1,c1)>= -7 || x5(f1,c1)<= 7 && x5(f1,c1)>= 4) && run == 4) %3
                base = '1111111110010111';
                lenght1 = 19;
                run = 0;
        
            elseif((x5(f1,c1)<= -8 && x5(f1,c1)>= -15 || x5(f1,c1)<= 15 && x5(f1,c1)>= 8) && run == 4) %4
                base = '1111111110011000';
                lenght1 = 20;
                run = 0;
        
            elseif((x5(f1,c1)<= -16 && x5(f1,c1)>= -31 || x5(f1,c1)<= 31 && x5(f1,c1)>= 16) && run == 4) %5
                base = '1111111110011001';
                lenght1 = 21;
                run = 0;
        
            elseif((x5(f1,c1)<= -32 && x5(f1,c1)>= -63 || x5(f1,c1)<= 63 && x5(f1,c1)>= 32) && run == 4) %6
                base = '1111111110011010';
                lenght1 = 22;
                run = 0;
        
            elseif((x5(f1,c1)<= -64 && x5(f1,c1)>= -127 || x5(f1,c1)<= 127 && x5(f1,c1)>= 64) && run == 4) %7
                base = '1111111110011011';
                lenght1 = 23;
                run = 0;
        
            elseif((x5(f1,c1)<= -128 && x5(f1,c1)>= -255 || x5(f1,c1)<= 255 && x5(f1,c1)>= 128) && run == 4) %8
                base = '1111111110011100';
                lenght1 = 24;
                run = 0;
        
            elseif((x5(f1,c1)<= -256 && x5(f1,c1)>= -511 || x5(f1,c1)<= 511 && x5(f1,c1)>= 256) && run == 4) %9
                base = '1111111110011101';
                lenght1 = 25;
                run = 0;
        
            elseif((x5(f1,c1)<= -512 && x5(f1,c1)>= -1023 || x5(f1,c1)<= 1023 && x5(f1,c1)>= 512) && run == 4) %A
                base = '1111111110011110';
                lenght1 = 26;
                run = 0;
            %5
        
           elseif((x5(f1,c1) == -1 || x5(f1,c1) == 1) && run == 5) %1
                base = '1111010';
                lenght1 = 8;
                run = 0; 
        
            elseif((x5(f1,c1)<= -2 && x5(f1,c1)>= -3 || x5(f1,c1)<= 3 && x5(f1,c1)>= 2) && run == 5) %2
               base = '1111111001';
               lenght1 = 12;
               run = 0;
        
            elseif((x5(f1,c1)<= -4 && x5(f1,c1)>= -7 || x5(f1,c1)<= 7 && x5(f1,c1)>= 4) && run == 5) %3
                base = '1111111110011111';
                lenght1 = 19;
                run = 0;
        
            elseif((x5(f1,c1)<= -8 && x5(f1,c1)>= -15 || x5(f1,c1)<= 15 && x5(f1,c1)>= 8) && run == 5) %4
                base = '1111111110100000';
                lenght1 = 20;
                run = 0;
        
            elseif((x5(f1,c1)<= -16 && x5(f1,c1)>= -31 || x5(f1,c1)<= 31 && x5(f1,c1)>= 16) && run == 5) %5
                base = '1111111110100001';
                lenght1 = 21;
                run = 0;
        
            elseif((x5(f1,c1)<= -32 && x5(f1,c1)>= -63 || x5(f1,c1)<= 63 && x5(f1,c1)>= 32) && run == 5) %6
                base = '1111111110100010';
                lenght1 = 22;
                run = 0;
        
            elseif((x5(f1,c1)<= -64 && x5(f1,c1)>= -127 || x5(f1,c1)<= 127 && x5(f1,c1)>= 64) && run == 5) %7
                base = '1111111110100011';
                lenght1 = 23;
                run = 0;
        
            elseif((x5(f1,c1)<= -128 && x5(f1,c1)>= -255 || x5(f1,c1)<= 255 && x5(f1,c1)>= 128) && run == 5) %8
                base = '1111111110100100';
                lenght1 = 24;
                run = 0;
        
            elseif((x5(f1,c1)<= -256 && x5(f1,c1)>= -511 || x5(f1,c1)<= 511 && x5(f1,c1)>= 256) && run == 5) %9
                base = '1111111110100101';
                lenght1 = 25;
                run = 0;
        
            elseif((x5(f1,c1)<= -512 && x5(f1,c1)>= -1023 || x5(f1,c1)<= 1023 && x5(f1,c1)>= 512) && run == 5) %A
                base = '1111111110100110';
                lenght1 = 26;
                run = 0;
            %6
        
            elseif((x5(f1,c1) == -1 || x5(f1,c1) == 1) && run == 6) %1
                base = '1111011';
                lenght1 = 8;
                run = 0; 
        
            elseif((x5(f1,c1)<= -2 && x5(f1,c1)>= -3 || x5(f1,c1)<= 3 && x5(f1,c1)>= 2) && run == 6) %2
               base = '11111111000';
               lenght1 = 13;
               run = 0;
        
            elseif((x5(f1,c1)<= -4 && x5(f1,c1)>= -7 || x5(f1,c1)<= 7 && x5(f1,c1)>= 4) && run == 6) %3
                base = '1111111110100111';
                lenght1 = 19;
                run = 0;
        
            elseif((x5(f1,c1)<= -8 && x5(f1,c1)>= -15 || x5(f1,c1)<= 15 && x5(f1,c1)>= 8) && run == 6) %4
                base = '1111111110101000';
                lenght1 = 20;
                run = 0;
        
            elseif((x5(f1,c1)<= -16 && x5(f1,c1)>= -31 || x5(f1,c1)<= 31 && x5(f1,c1)>= 16) && run == 6) %5
                base = '1111111110101001';
                lenght1 = 21;
                run = 0;
        
            elseif((x5(f1,c1)<= -32 && x5(f1,c1)>= -63 || x5(f1,c1)<= 63 && x5(f1,c1)>= 32) && run == 6) %6
                base = '1111111110101010';
                lenght1 = 22;
                run = 0;
        
            elseif((x5(f1,c1)<= -64 && x5(f1,c1)>= -127 || x5(f1,c1)<= 127 && x5(f1,c1)>= 64) && run == 6) %7
                base = '1111111110101011';
                lenght1 = 23;
                run = 0;
        
            elseif((x5(f1,c1)<= -128 && x5(f1,c1)>= -255 || x5(f1,c1)<= 255 && x5(f1,c1)>= 128) && run == 6) %8
                base = '1111111110101100';
                lenght1 = 24;
                run = 0;
        
            elseif((x5(f1,c1)<= -256 && x5(f1,c1)>= -511 || x5(f1,c1)<= 511 && x5(f1,c1)>= 256) && run == 6) %9
                base = '1111111110101101';
                lenght1 = 25;
                run = 0;
        
            elseif((x5(f1,c1)<= -512 && x5(f1,c1)>= -1023 || x5(f1,c1)<= 1023 && x5(f1,c1)>= 512) && run == 6) %A
                base = '1111111110101110';
                lenght1 = 26;
                run = 0;
            %7
        
           elseif((x5(f1,c1) == -1 || x5(f1,c1) == 1) && run == 7) %1
                base = '11111001';
                lenght1 = 9;
                run = 0; 
        
            elseif((x5(f1,c1)<= -2 && x5(f1,c1)>= -3 || x5(f1,c1)<= 3 && x5(f1,c1)>= 2) && run == 7) %2
               base = '11111111001';
               lenght1 = 13;
               run = 0;
        
            elseif((x5(f1,c1)<= -4 && x5(f1,c1)>= -7 || x5(f1,c1)<= 7 && x5(f1,c1)>= 4) && run == 7) %3
                base = '1111111110101111';
                lenght1 = 19;
                run = 0;
        
            elseif((x5(f1,c1)<= -8 && x5(f1,c1)>= -15 || x5(f1,c1)<= 15 && x5(f1,c1)>= 8) && run == 7) %4
                base = '1111111110110000';
                lenght1 = 20;
                run = 0;
        
            elseif((x5(f1,c1)<= -16 && x5(f1,c1)>= -31 || x5(f1,c1)<= 31 && x5(f1,c1)>= 16) && run == 7) %5
                base = '1111111110110001';
                lenght1 = 21;
                run = 0;
        
            elseif((x5(f1,c1)<= -32 && x5(f1,c1)>= -63 || x5(f1,c1)<= 63 && x5(f1,c1)>= 32) && run == 7) %6
                base = '1111111110110010';
                lenght1 = 22;
                run = 0;
        
            elseif((x5(f1,c1)<= -64 && x5(f1,c1)>= -127 || x5(f1,c1)<= 127 && x5(f1,c1)>= 64) && run == 7) %7
                base = '1111111110110011';
                lenght1 = 23;
                run = 0;
        
            elseif((x5(f1,c1)<= -128 && x5(f1,c1)>= -255 || x5(f1,c1)<= 255 && x5(f1,c1)>= 128) && run == 7) %8
                base = '1111111110110100';
                lenght1 = 24;
                run = 0;
        
            elseif((x5(f1,c1)<= -256 && x5(f1,c1)>= -511 || x5(f1,c1)<= 511 && x5(f1,c1)>= 256) && run == 7) %9
                base = '1111111110110101';
                lenght1 = 25;
                run = 0;
        
            elseif((x5(f1,c1)<= -512 && x5(f1,c1)>= -1023 || x5(f1,c1)<= 1023 && x5(f1,c1)>= 512) && run == 7) %A
                base = '1111111110110110';
                lenght1 = 26;
                run = 0;
        
            %8
        
           elseif((x5(f1,c1) == -1 || x5(f1,c1) == 1) && run == 8) %1
                base = '11111010';
                lenght1 = 9;
                run = 0; 
        
            elseif((x5(f1,c1)<= -2 && x5(f1,c1)>= -3 || x5(f1,c1)<= 3 && x5(f1,c1)>= 2) && run == 8) %2
                base = '111111111000000';
                lenght1 = 17;
                run = 0; 
        
            elseif((x5(f1,c1)<= -4 && x5(f1,c1)>= -7 || x5(f1,c1)<= 7 && x5(f1,c1)>= 4) && run == 8) %3
                base = '1111111110110111';
                lenght1 = 19;
                run = 0; 
        
            elseif((x5(f1,c1)<= -8 && x5(f1,c1)>= -15 || x5(f1,c1)<= 15 && x5(f1,c1)>= 8) && run == 8) %4
                base = '1111111110111000';
                lenght1 = 20;
                run = 0; 
        
            elseif((x5(f1,c1)<= -16 && x5(f1,c1)>= -31 || x5(f1,c1)<= 31 && x5(f1,c1)>= 16) && run == 8) %5
                base = '1111111110111001';
                lenght1 = 21;
                run = 0; 
            elseif((x5(f1,c1)<= -32 && x5(f1,c1)>= -63 || x5(f1,c1)<= 63 && x5(f1,c1)>= 32) && run == 8) %6
                base = '1111111110111010';
                lenght1 = 22;
                run = 0; 
        
            elseif((x5(f1,c1)<= -64 && x5(f1,c1)>= -127 || x5(f1,c1)<= 127 && x5(f1,c1)>= 64) && run == 8) %7
                base = '1111111110111011';
                lenght1 = 23;
                run = 0; 
        
            elseif((x5(f1,c1)<= -128 && x5(f1,c1)>= -255 || x5(f1,c1)<= 255 && x5(f1,c1)>= 128) && run == 8) %8
                base = '1111111110111100';
                lenght1 = 24;
                run = 0; 
        
            elseif((x5(f1,c1)<= -256 && x5(f1,c1)>= -511 || x5(f1,c1)<= 511 && x5(f1,c1)>= 256) && run == 8) %9
                base = '1111111110111101';
                lenght1 = 25;
                run = 0; 
        
            elseif((x5(f1,c1)<= -512 && x5(f1,c1)>= -1023 || x5(f1,c1)<= 1023 && x5(f1,c1)>= 512) && run == 8) %A
                base = '1111111110111110';
                lenght1 = 26;
                run = 0; 
            
            %9
        
           elseif((x5(f1,c1) == -1 || x5(f1,c1) == 1) && run == 9) %1
                base = '111111000';
                lenght1 = 10;
                run = 0; 
        
            elseif((x5(f1,c1)<= -2 && x5(f1,c1)>= -3 || x5(f1,c1)<= 3 && x5(f1,c1)>= 2) && run == 9) %2
                base = '1111111110111111';
                lenght1 = 18;
                run = 0; 
        
            elseif((x5(f1,c1)<= -4 && x5(f1,c1)>= -7 || x5(f1,c1)<= 7 && x5(f1,c1)>= 4) && run == 9) %3
                base = '1111111111000000';
                lenght1 = 19;
                run = 0; 
        
            elseif((x5(f1,c1)<= -8 && x5(f1,c1)>= -15 || x5(f1,c1)<= 15 && x5(f1,c1)>= 8) && run == 9) %4
                base = '1111111111000001';
                lenght1 = 20;
                run = 0; 
        
            elseif((x5(f1,c1)<= -16 && x5(f1,c1)>= -31 || x5(f1,c1)<= 31 && x5(f1,c1)>= 16) && run == 9) %5
                base = '1111111111000010';
                lenght1 = 21;
                run = 0; 
        
            elseif((x5(f1,c1)<= -32 && x5(f1,c1)>= -63 || x5(f1,c1)<= 63 && x5(f1,c1)>= 32) && run == 9) %6
                base = '1111111111000011';
                lenght1 = 22;
                run = 0; 
        
            elseif((x5(f1,c1)<= -64 && x5(f1,c1)>= -127 || x5(f1,c1)<= 127 && x5(f1,c1)>= 64) && run == 9) %7
                base = '1111111111000100';
                lenght1 = 23;
                run = 0; 
        
            elseif((x5(f1,c1)<= -128 && x5(f1,c1)>= -255 || x5(f1,c1)<= 255 && x5(f1,c1)>= 128) && run == 9) %8
                base = '1111111111000101';
                lenght1 = 24;
                run = 0; 
        
            elseif((x5(f1,c1)<= -256 && x5(f1,c1)>= -511 || x5(f1,c1)<= 511 && x5(f1,c1)>= 256) && run == 9) %9
                base = '1111111111000110';
                lenght1 = 25;
                run = 0; 
        
            elseif((x5(f1,c1)<= -512 && x5(f1,c1)>= -1023 || x5(f1,c1)<= 1023 && x5(f1,c1)>= 512) && run == 9) %A
                base = '1111111111000111';
                lenght1 = 26;
                run = 0; 
            %A
        
           elseif((x5(f1,c1) == -1 || x5(f1,c1) == 1) && run == 10) %1
                base = '111111001';
                lenght1 = 10;
                run = 0; 
        
            elseif((x5(f1,c1)<= -2 && x5(f1,c1)>= -3 || x5(f1,c1)<= 3 && x5(f1,c1)>= 2) && run == 10) %2
                base = '1111111111001000';
                lenght1 = 18;
                run = 0; 
        
            elseif((x5(f1,c1)<= -4 && x5(f1,c1)>= -7 || x5(f1,c1)<= 7 && x5(f1,c1)>= 4) && run == 10) %3
                base = '1111111111001001';
                lenght1 = 19;
                run = 0; 
        
            elseif((x5(f1,c1)<= -8 && x5(f1,c1)>= -15 || x5(f1,c1)<= 15 && x5(f1,c1)>= 8) && run == 10) %4
                base = '1111111111001010';
                lenght1 = 20;
                run = 0; 
        
            elseif((x5(f1,c1)<= -16 && x5(f1,c1)>= -31 || x5(f1,c1)<= 31 && x5(f1,c1)>= 16) && run == 10) %5
                base = '1111111111001011';
                lenght1 = 21;
                run = 0; 
        
            elseif((x5(f1,c1)<= -32 && x5(f1,c1)>= -63 || x5(f1,c1)<= 63 && x5(f1,c1)>= 32) && run == 10) %6
                base = '1111111111001100';
                lenght1 = 22;
                run = 0; 
        
            elseif((x5(f1,c1)<= -64 && x5(f1,c1)>= -127 || x5(f1,c1)<= 127 && x5(f1,c1)>= 64) && run == 10) %7
                base = '1111111111001101';
                lenght1 = 23;
                run = 0; 
        
            elseif((x5(f1,c1)<= -128 && x5(f1,c1)>= -255 || x5(f1,c1)<= 255 && x5(f1,c1)>= 128) && run == 10) %8
                base = '1111111111001110';
                lenght1 = 24;
                run = 0; 
        
            elseif((x5(f1,c1)<= -256 && x5(f1,c1)>= -511 || x5(f1,c1)<= 511 && x5(f1,c1)>= 256) && run == 10) %9
                base = '1111111111001111';
                lenght1 = 25;
                run = 0; 
        
            elseif((x5(f1,c1)<= -512 && x5(f1,c1)>= -1023 || x5(f1,c1)<= 1023 && x5(f1,c1)>= 512) && run == 10) %A
                base = '1111111111010000';
                lenght1 = 26;
                run = 0; 
        
        
            %B
        
           elseif((x5(f1,c1) == -1 || x5(f1,c1) == 1) && run == 11) %1
                base = '111111010';
                lenght1 = 10;
                run = 0; 
        
            elseif((x5(f1,c1)<= -2 && x5(f1,c1)>= -3 || x5(f1,c1)<= 3 && x5(f1,c1)>= 2) && run == 11) %2
                base = '1111111111010001';
                lenght1 = 18;
                run = 0; 
        
            elseif((x5(f1,c1)<= -4 && x5(f1,c1)>= -7 || x5(f1,c1)<= 7 && x5(f1,c1)>= 4) && run == 11) %3
                base = '1111111111010010';
                lenght1 = 19;
                run = 0; 
        
            elseif((x5(f1,c1)<= -8 && x5(f1,c1)>= -15 || x5(f1,c1)<= 15 && x5(f1,c1)>= 8) && run == 11) %4
                base = '1111111111010011';
                lenght1 = 20;
                run = 0; 
        
            elseif((x5(f1,c1)<= -16 && x5(f1,c1)>= -31 || x5(f1,c1)<= 31 && x5(f1,c1)>= 16) && run == 11) %5
                base = '1111111111010100';
                lenght1 = 21;
                run = 0; 
        
            elseif((x5(f1,c1)<= -32 && x5(f1,c1)>= -63 || x5(f1,c1)<= 63 && x5(f1,c1)>= 32) && run == 11) %6
                base = '1111111111010101';
                lenght1 = 22;
                run = 0; 
        
            elseif((x5(f1,c1)<= -64 && x5(f1,c1)>= -127 || x5(f1,c1)<= 127 && x5(f1,c1)>= 64) && run == 11) %7
                base = '1111111111010110';
                lenght1 = 23;
                run = 0; 
        
            elseif((x5(f1,c1)<= -128 && x5(f1,c1)>= -255 || x5(f1,c1)<= 255 && x5(f1,c1)>= 128) && run == 11) %8
                base = '1111111111010111';
                lenght1 = 24;
                run = 0; 
        
            elseif((x5(f1,c1)<= -256 && x5(f1,c1)>= -511 || x5(f1,c1)<= 511 && x5(f1,c1)>= 256) && run == 11) %9
                base = '1111111111011000';
                lenght1 = 25;
                run = 0; 
        
            elseif((x5(f1,c1)<= -512 && x5(f1,c1)>= -1023 || x5(f1,c1)<= 1023 && x5(f1,c1)>= 512) && run == 11) %A
                base = '1111111111011001';
                lenght1 = 26;
                run = 0; 
            %C
        
           elseif((x5(f1,c1) == -1 || x5(f1,c1) == 1) && run == 12) %1
                base = '1111111010';
                lenght1 = 11;
                run = 0; 
        
            elseif((x5(f1,c1)<= -2 && x5(f1,c1)>= -3 || x5(f1,c1)<= 3 && x5(f1,c1)>= 2) && run == 12) %2
                base = '1111111111011010';
                lenght1 = 18;
                run = 0; 
        
            elseif((x5(f1,c1)<= -4 && x5(f1,c1)>= -7 || x5(f1,c1)<= 7 && x5(f1,c1)>= 4) && run == 12) %3
                base = '1111111111011011';
                lenght1 = 19;
                run = 0; 
        
            elseif((x5(f1,c1)<= -8 && x5(f1,c1)>= -15 || x5(f1,c1)<= 15 && x5(f1,c1)>= 8) && run == 12) %4
                base = '1111111111011100';
                lenght1 = 20;
                run = 0; 
        
            elseif((x5(f1,c1)<= -16 && x5(f1,c1)>= -31 || x5(f1,c1)<= 31 && x5(f1,c1)>= 16) && run == 12) %5
                base = '1111111111011101';
                lenght1 = 21;
                run = 0; 
        
            elseif((x5(f1,c1)<= -32 && x5(f1,c1)>= -63 || x5(f1,c1)<= 63 && x5(f1,c1)>= 32) && run == 12) %6
                base = '1111111111011110';
                lenght1 = 22;
                run = 0; 
        
            elseif((x5(f1,c1)<= -64 && x5(f1,c1)>= -127 || x5(f1,c1)<= 127 && x5(f1,c1)>= 64) && run == 12) %7
                base = '1111111111011111';
                lenght1 = 23;
                run = 0; 
        
            elseif((x5(f1,c1)<= -128 && x5(f1,c1)>= -255 || x5(f1,c1)<= 255 && x5(f1,c1)>= 128) && run == 12) %8
                base = '1111111111100000';
                lenght1 = 24;
                run = 0; 
        
            elseif((x5(f1,c1)<= -256 && x5(f1,c1)>= -511 || x5(f1,c1)<= 511 && x5(f1,c1)>= 256) && run == 12) %9
                base = '1111111111100001';
                lenght1 = 25;
                run = 0; 
        
            elseif((x5(f1,c1)<= -512 && x5(f1,c1)>= -1023 || x5(f1,c1)<= 1023 && x5(f1,c1)>= 512) && run == 12) %A
                base = '1111111111100010';
                lenght1 = 26;
                run = 0; 
        
            %D
        
           elseif((x5(f1,c1) == -1 || x5(f1,c1) == 1) && run == 13) %1
                base = '11111111010';
                lenght1 = 12;
                run = 0; 
        
            elseif((x5(f1,c1)<= -2 && x5(f1,c1)>= -3 || x5(f1,c1)<= 3 && x5(f1,c1)>= 2) && run == 13) %2
                base = '1111111111100011';
                lenght1 = 18;
                run = 0; 
        
            elseif((x5(f1,c1)<= -4 && x5(f1,c1)>= -7 || x5(f1,c1)<= 7 && x5(f1,c1)>= 4) && run == 13) %3
                base = '1111111111100100';
                lenght1 = 19;
                run = 0; 
        
            elseif((x5(f1,c1)<= -8 && x5(f1,c1)>= -15 || x5(f1,c1)<= 15 && x5(f1,c1)>= 8) && run == 13) %4
                base = '1111111111100101';
                lenght1 = 20;
                run = 0; 
        
            elseif((x5(f1,c1)<= -16 && x5(f1,c1)>= -31 || x5(f1,c1)<= 31 && x5(f1,c1)>= 16) && run == 13) %5
                base = '1111111111100110';
                lenght1 = 21;
                run = 0; 
        
            elseif((x5(f1,c1)<= -32 && x5(f1,c1)>= -63 || x5(f1,c1)<= 63 && x5(f1,c1)>= 32) && run == 13) %6
                base = '1111111111100111';
                lenght1 = 22;
                run = 0; 
        
            elseif((x5(f1,c1)<= -64 && x5(f1,c1)>= -127 || x5(f1,c1)<= 127 && x5(f1,c1)>= 64) && run == 13) %7
                base = '1111111111101000';
                lenght1 = 23;
                run = 0; 
        
            elseif((x5(f1,c1)<= -128 && x5(f1,c1)>= -255 || x5(f1,c1)<= 255 && x5(f1,c1)>= 128) && run == 13) %8
                base = '1111111111101001';
                lenght1 = 24;
                run = 0; 
        
            elseif((x5(f1,c1)<= -256 && x5(f1,c1)>= -511 || x5(f1,c1)<= 511 && x5(f1,c1)>= 256) && run == 13) %9
                base = '1111111111101010';
                lenght1 = 25;
                run = 0; 
        
            elseif((x5(f1,c1)<= -512 && x5(f1,c1)>= -1023 || x5(f1,c1)<= 1023 && x5(f1,c1)>= 512) && run == 13) %A
                base = '1111111111101011';
                lenght1 = 26;
                run = 0; 
        
        
            %E
        
           elseif((x5(f1,c1) == -1 || x5(f1,c1) == 1) && run == 14) %1
                base = '111111110110';
                lenght1 = 13;
                run = 0; 
        
            elseif((x5(f1,c1)<= -2 && x5(f1,c1)>= -3 || x5(f1,c1)<= 3 && x5(f1,c1)>= 2) && run == 14) %2
                base = '1111111111101100';
                lenght1 = 18;
                run = 0; 
        
            elseif((x5(f1,c1)<= -4 && x5(f1,c1)>= -7 || x5(f1,c1)<= 7 && x5(f1,c1)>= 4) && run == 14) %3
                base = '1111111111101101';
                lenght1 = 19;
                run = 0; 
        
            elseif((x5(f1,c1)<= -8 && x5(f1,c1)>= -15 || x5(f1,c1)<= 15 && x5(f1,c1)>= 8) && run == 14) %4
                base = '1111111111101110';
                lenght1 = 20;
                run = 0; 
        
            elseif((x5(f1,c1)<= -16 && x5(f1,c1)>= -31 || x5(f1,c1)<= 31 && x5(f1,c1)>= 16) && run == 14) %5
                base = '1111111111101111';
                lenght1 = 21;
                run = 0; 
        
            elseif((x5(f1,c1)<= -32 && x5(f1,c1)>= -63 || x5(f1,c1)<= 63 && x5(f1,c1)>= 32) && run == 14) %6
                base = '1111111111110000';
                lenght1 = 22;
                run = 0; 
        
            elseif((x5(f1,c1)<= -64 && x5(f1,c1)>= -127 || x5(f1,c1)<= 127 && x5(f1,c1)>= 64) && run == 14) %7
                base = '1111111111110001';
                lenght1 = 23;
                run = 0; 
        
            elseif((x5(f1,c1)<= -128 && x5(f1,c1)>= -255 || x5(f1,c1)<= 255 && x5(f1,c1)>= 128) && run == 14) %8
                base = '1111111111110010';
                lenght1 = 24;
                run = 0; 
        
            elseif((x5(f1,c1)<= -256 && x5(f1,c1)>= -511 || x5(f1,c1)<= 511 && x5(f1,c1)>= 256) && run == 14) %9
                base = '1111111111110011';
                lenght1 = 25;
                run = 0; 
        
            elseif((x5(f1,c1)<= -512 && x5(f1,c1)>= -1023 || x5(f1,c1)<= 1023 && x5(f1,c1)>= 512) && run == 14) %A
                base = '1111111111110100';
                lenght1 = 26;
                run = 0; 
        
            %F
            elseif(x5(f1,c1) == 0 && run == 15)  %0
                base = '111111110111';
                lenght1 = 13;
                run = 0;
        
            elseif((x5(f1,c1) == -1 || x5(f1,c1) == 1) && run == 15) %1
                base = '1111111111110101';
                lenght1 = 18;
                run = 0; 
        
            elseif((x5(f1,c1)<= -2 && x5(f1,c1)>= -3 || x5(f1,c1)<= 3 && x5(f1,c1)>= 2) && run == 15) %2
                base = '1111111111110110';
                lenght1 = 19;
                run = 0; 
        
            elseif((x5(f1,c1)<= -4 && x5(f1,c1)>= -7 || x5(f1,c1)<= 7 && x5(f1,c1)>= 4) && run == 15) %3
                base = '1111111111110111';
                lenght1 = 20;
                run = 0; 
        
            elseif((x5(f1,c1)<= -8 && x5(f1,c1)>= -15 || x5(f1,c1)<= 15 && x5(f1,c1)>= 8) && run == 15) %4
                base = '1111111111111000';
                lenght1 = 21;
                run = 0; 
        
            elseif((x5(f1,c1)<= -16 && x5(f1,c1)>= -31 || x5(f1,c1)<= 31 && x5(f1,c1)>= 16) && run == 15) %5
                base = '1111111111111001';
                lenght1 = 22;
                run = 0; 
        
            elseif((x5(f1,c1)<= -32 && x5(f1,c1)>= -63 || x5(f1,c1)<= 63 && x5(f1,c1)>= 32) && run == 15) %6
                base = '1111111111111010';
                lenght1 = 23;
                run = 0; 
        
            elseif((x5(f1,c1)<= -64 && x5(f1,c1)>= -127 || x5(f1,c1)<= 127 && x5(f1,c1)>= 64) && run == 15) %7
                base = '1111111111111011';
                lenght1 = 24;
                run = 0; 
        
            elseif((x5(f1,c1)<= -128 && x5(f1,c1)>= -255 || x5(f1,c1)<= 255 && x5(f1,c1)>= 128) && run == 15) %8
                base = '1111111111111100';
                lenght1 = 25;
                run = 0; 
        
            elseif((x5(f1,c1)<= -256 && x5(f1,c1)>= -511 || x5(f1,c1)<= 511 && x5(f1,c1)>= 256) && run == 15) %9
                base = '1111111111111101';
                lenght1 = 26;
                run = 0; 
        
            elseif((x5(f1,c1)<= -512 && x5(f1,c1)>= -1023 || x5(f1,c1)<= 1023 && x5(f1,c1)>= 512) && run == 15) %A
                base = '1111111111111110';
                lenght1 = 27;
                run = 0; 
            else
            disp('Error al catalogar los demas elementos');
            end
            %concatenar la cadena con el codigo base
            cadena = [cadena base];
            x7 = x5(f1,c1);
            tam = length(base);
            bits = lenght1- tam;
            %convertimos el valor a binario
            if (x7<0)
               y = abs(x7);
               y0 = dec2bin(y, bits);
               y1 = ['0' y0];
               % Invertir todos los bits
               y2 = double(y1) - '0';
               % Invertir bits
               y3 = ~y2;
               
               % Convertir de vuelta a cadena de caracteres
               y4 = char(y3 + '0');
               z1 = y4;
               z2 = '1';
               %sumarle 1
               z11 = bin2dec(z1);
               z22 = bin2dec(z2);
               num_neg = z11 + z22;
       
               num_neg_bin = dec2bin(num_neg);
               cadena = [cadena num_neg_bin];
            
            else
                num_bin = dec2bin(x6, bits);
                cadena = [cadena '0'];
                cadena = [cadena num_bin];
            end
    
        end
            
    end

    disp(cadena);
    usuario = input('Introduzca 0 si quiere verificar otros datos o 1 si quiere salir:');
end
disp('Fin del programa, gracias por usarlo :)')

