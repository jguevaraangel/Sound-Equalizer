%% Proyecto I: Equalizador básico de audio
% 
% Curso de Procesamiento de Señales
% Programa de Matemáticas Aplicadas y Ciencias de la Computación
% Universidad del Rosario, Agosto 2021
% 
% Profesor: ALexander Caicedo Dorado
%
% En esta función pueden encontrar las funciones básicas para adquirir una
% señal de audio utiliznado MATLAB, y calcular su transformada de Fourier.
% La salida de la transformada de Fourier deben utilizarla para realizar
% las tareas indicadas en el enundciado del Proyecto

%% Aquirir señal de audio

% recObj = audiorecorder; % Creando el objeto de audio
% 
% fs = recObj.SampleRate; % Extrayendo la frecuencia de muestreo del objeto de grabación.
% t_grab = 2; % Especificando el tiempo de grabación en segundos. Tenga en cuenta qu ese generará
%             % una grabación que se almacenara en un vector de 2*fs muestras.
% 
% disp('Comienza la grabación.')
% recordblocking(recObj, t_grab);
% disp('Termina la grabación.');

% x= getaudiodata(recObj); % Extrayendo los datos grabados del elemento de grabación
% Sonido 1
fs = 44100;
sample = [1, 2*fs];
[xn, fs] = audioread("nice.mp3",sample);
x = xn(:,1);
x = x./max(x); % Normalización de la señal

% Graficando la señal obtenida
n = length(x);
t = (0:n-1)/fs; % Creando un vector de tiempo
figure,
plot(t,x);
grid on
xlabel('tiempo [s]')
ylabel('Amplitud [u.a.]')
title('Señal de sonido grabada')

% Escuchando la señal grabada
sound(x,fs)

%% Calculo de la transformada de Fourier de la señal

Fx = fft(x); % Algoritmo para calcular los valores de la Transformada de Fourier
Fxs = fftshift(Fx); % Corrimiento de la transformada para obtener valores negativos y positivos. 
f = (-n/2:n/2-1)*fs/n; % Creación del vector de Frecuencias

% Grafica de la magnitud de la transformada de Fourier
figure, subplot(211)
plot(f,abs(Fxs))
xlabel('Frecuencia [Hz]')
ylabel('Amplitud [u.a.]')
title ('Magnitud de la Transformada de Fourier de la Señal')
grid on

% Grafica de la magnitud de la transformada de Fourier
subplot(212)
plot(f,angle(Fxs))
xlabel('Frecuencia [Hz]')
ylabel('Fase [radianes]')
title ('Fase de la Transformada de Fourier de la Señal')
grid on

%% Bandas de frecuencias (12) y Ventanas

% Ventanas rectangulares
% Primer ventana (alrededor de 0)
windows = zeros(12,n);
windows(1, ((fs/2 - 20)*n/fs):((fs/2 + 0)*n/fs)) = 1;    
windows(1, ((fs/2 - 0)*n/fs):((fs/2 + 20)*n/fs)) = 1;    

% Resto de las ventanas
width = 20;
i = 20;
counter = 2;
while i ~= 20480
    lower = (fs/2 - i - width)*n/fs;
    upper = (fs/2 - i - 1)*n/fs;
    windows(counter, lower:upper+1) = 1;  
    
    lower = (fs/2 + i + 1)*n/fs;
    upper = (fs/2 + i + width)*n/fs;
    windows(counter, lower-1:upper) = 1; 

    counter = counter + 1;
    i = i + width;
    width = width*2;
end

% Ultima ventana
upper = (fs/2 - i - 1)*n/fs;
windows(12, 1:upper+1) = 1;
lower = (fs/2 + i + 1)*n/fs;
windows(12, lower-1:n) = 1;

figure
hold on
for j=1:12   
    plot(f,windows(j,:))
end
xlabel('Frecuencia [Hz]')
ylabel('Amplitud [u.a.]')
grid on

%% Ecualizador  

% Union de las ventanas
height = abs(Fxs);
modified = zeros(1,n);
for j=1:12
    temp = height'.*windows(j,:);
    modified = modified + temp;
end

figure
plot(f,modified);
xlabel('Frecuencia [Hz]')
ylabel('Amplitud [u.a.]')
grid on

% Verificamos que los vectores coincidan
isequal(modified, height')

%% Obteniendo la Transformada inversa de Fourier

Fx2 = ifftshift(Fxs); % Devolviendo el corrimiento realizado con fftshift
y = real(ifft(Fx2)); % Calculando la transformada inversa (Se toma la parte real, porque debido 
                     % a errores numericos se obtiene una transformada compleja, pero los valores 
                     % complejos son muy pequeños.
y = y./max(y); % Se normaliza la señal de salida

% Graficando la señal en el tiempo
figure,
plot(t,y);
grid on
xlabel('tiempo [s]')
ylabel('Amplitud [u.a.]')
title('Señal de sonido recuperada')