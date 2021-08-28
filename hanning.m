function h = hanning(n, fs)
    
    % Ventanas de hanning
    % Primer ventana (alrededor de 0)
    h = zeros(12,n);
    h(1, ((fs/2 - 20)*n/fs):((fs/2 + 0)*n/fs)) = hann(((fs/2 + 0)*n/fs) - ((fs/2 - 20)*n/fs) + 1);    
    h(1, ((fs/2 - 0)*n/fs):((fs/2 + 20)*n/fs)) = hann(((fs/2 + 20)*n/fs) - ((fs/2 - 0)*n/fs) + 1);    
    
    % Resto de las ventanas
    width = 20;
    i = 20;
    counter = 2;
    while i ~= 20480
        lower = (fs/2 - i - width)*n/fs;
        upper = (fs/2 - i - 1)*n/fs;
        h(counter, lower:upper+1) = hann(upper+1 - lower + 1);  
        
        lower = (fs/2 + i + 1)*n/fs;
        upper = (fs/2 + i + width)*n/fs;
        h(counter, lower-1:upper) = hann(upper - lower + 1 + 1); 
    
        counter = counter + 1;
        i = i + width;
        width = width*2;
    end

    % Ultima ventana
    upper = (fs/2 - i - 1)*n/fs;
    h(12, 1:upper+1) = hann(upper+1-1+1);
    lower = (fs/2 + i + 1)*n/fs;
    h(12, lower-1:n) = hann(n - lower+1 + 1);
    
end