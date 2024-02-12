clc
clear all
close all   
warning off all


imagen=imread("e.jpg");
imagen = im2gray(imagen);

tamy = size(imagen, 1);
tamx = size(imagen, 2);

[veces, pixeles] = imhist(imagen);

figure(1)
subplot(1,1,1), bar(pixeles,veces), title("IMAGEN");

cantidadNumeros = tamx * tamy;

probabilidades = veces/cantidadNumeros;

pixeles = string(char(pixeles + 1));

tempProb = [];
tempPix = [];
for i = 1:256
    if(probabilidades(i) ~= 0)
        tempProb = [tempProb probabilidades(i)];
        tempPix = [tempPix pixeles(i)];
    end
end

probabilidades = tempProb';
pixeles = tempPix';

faltan = size(probabilidades);
faltan = faltan(1);

pasosProbabilidades = string(zeros(faltan));
pasosArbol = string(zeros(faltan));

j = 1;

while(faltan > 1)
    [probabilidades, indicesOrdenados] = sort(probabilidades);
    pixeles = pixeles(indicesOrdenados);
    
    pasosProbabilidades(1:faltan, j) = probabilidades;
    pasosArbol(1:faltan, j) = pixeles;

    newProbabilidad = probabilidades(1) + probabilidades(2);
    newString = strcat(char(257), pixeles(1), pixeles(2));
    
    probabilidades = [probabilidades(3:end); newProbabilidad];
    pixeles = [pixeles(3:end); newString];
%     fprintf("Paso %d:\n", j);
%     fprintf(" %s ",probabilidades);
%     fprintf("\n");

    faltan = faltan - 1;
    
    j = j + 1;
    
end

arbol = char(pixeles);
longitudArbol = strlength(arbol);

codificacion = string(1:256);
codificacionActual = '';
k = 0;


for i = 1 : longitudArbol
    charActual = arbol(i);
    if charActual == char(257)
        k = k + 1;
        codificacionActual(k) = '0';
%         fprintf(" %s ",codificacionActual);
%         fprintf("\n\n");
    else 
        codificacion(uint16(charActual)) = string(codificacionActual);
        while(k > 0 && codificacionActual(k) == '1')
            k = k - 1;
            codificacionActual = codificacionActual(1 : k);
%             fprintf(" %s ",codificacionActual);
%             fprintf("");
        end

        if k > 0
            codificacionActual(k) = '1';
%             fprintf(" %s ",codificacionActual);
%             fprintf("\n\n");
        end
    end
end

cantidad = size(tempPix);
cantidad = cantidad(2);

indices = find(veces ~= 0);
codificacionTemp = codificacion(indices);
valores = 0 : 255;
valores = valores(indices);

entropia = 0;
sumLongitudes = 0;
tempProb = tempProb';

for i = 1 : cantidad
    bits_signo = log2(1./tempProb(i));
    bits_signo = int8(bits_signo);

    fprintf("\tPixel: %d \tProbabilidad: %f \tBits/Simbolo: %d \tHufmann: %s\n", valores(i), tempProb(i),bits_signo, codificacionTemp(i));

    entropia = entropia + tempProb(i) * log2(1/tempProb(i));
    sumLongitudes = sumLongitudes + tempProb(i) * strlength(codificacionTemp(i));
end

format("long");
fprintf("\n\tLa entropia es %f\n", entropia);
fprintf("\tLa eficiencia es %f porciento\n", 100*entropia/sumLongitudes)

