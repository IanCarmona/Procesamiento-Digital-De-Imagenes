clc
clear all
close all all
warning off all

% Lectura de la imagen
Imagen = imread("peppers.png");
figure(1);
imshow(Imagen);

usuario = 0;
while usuario == 0
    ImagenBW = im2gray(Imagen);
    [filas,columnas]=size(ImagenBW);
    porcentajeRuido = input('Ingrese el porcentaje de ruido que desea en su imagen:');
    % Tamaño de la matriz y cantidad de puntos
    cantidadPuntos = round(porcentajeRuido*filas*columnas/100);
    
    % Calcular el número total de elementos en la matriz
    numElementos = filas * columnas;
    
    % Verificar si hay suficientes elementos para generar la cantidad de puntos deseados
    if cantidadPuntos > numElementos
        error('No hay suficientes elementos en la matriz para generar la cantidad de puntos especificada.');
    end
    % Generar una secuencia de índices aleatorios únicos
    indicesAleatorios = randperm(numElementos, cantidadPuntos);
    iterador = -1;
    % Asignar los puntos aleatorios en la matriz
    [filasIndices, columnasIndices] = ind2sub([filas, columnas], indicesAleatorios);
    for i = 1:cantidadPuntos
        if iterador > 0
            ImagenBW(filasIndices(i), columnasIndices(i)) = 0;
        else
            ImagenBW(filasIndices(i), columnasIndices(i)) = 255;
        end
        iterador = iterador*(-1);
    end
    figure(2);
    imshow(ImagenBW);
    
    ImagenSinRuido = quitarRuido(ImagenBW);
    figure(3);
    imshow(ImagenSinRuido);
    
    usuario = input('Introduzca 0 si quiere verificar otro valor o 1 si quiere salir:');
end

disp('Fin del programa, gracias por usarlo :)');

% Función para quitar el ruido de una imagen
function ImagenSinRuido = quitarRuido(ImagenRuidosa)
    ImagenSinRuido = ImagenRuidosa;
    [filas, columnas] = size(ImagenSinRuido);
    
    % Recorrer cada píxel de la imagen
    for i = 2:filas-1
        for j = 2:columnas-1
            % Obtener los valores de los píxeles vecinos
            vecinos = [ImagenSinRuido(i-1, j-1), ImagenSinRuido(i-1, j), ImagenSinRuido(i-1, j+1), ...
                       ImagenSinRuido(i, j-1), ImagenSinRuido(i, j), ImagenSinRuido(i, j+1), ...
                       ImagenSinRuido(i+1, j-1), ImagenSinRuido(i+1, j), ImagenSinRuido(i+1, j+1)];
            % Calcular la mediana de los valores vecinos
            mediana = median(vecinos);
            % Reemplazar el píxel con la mediana
            ImagenSinRuido(i, j) = mediana;
        end
    end
end