function w = windows(n, fs)
    
    % Ventanas rectangulares
    % Primer ventana (alrededor de 0)
    w = zeros(12,n);
    w(1, ((fs/2 - 20)*n/fs):((fs/2 + 0)*n/fs)) = 1;    
    w(1, ((fs/2 - 0)*n/fs):((fs/2 + 20)*n/fs)) = 1;    
    
    % Resto de las ventanas
    width = 20;
    i = 20;
    counter = 2;
    while i ~= 20480
        lower = (fs/2 - i - width)*n/fs;
        upper = (fs/2 - i - 1)*n/fs;
        w(counter, lower:upper+1) = 1;  
        
        lower = (fs/2 + i + 1)*n/fs;
        upper = (fs/2 + i + width)*n/fs;
        w(counter, lower-1:upper) = 1; 
    
        counter = counter + 1;
        i = i + width;
        width = width*2;
    end

    % Ultima ventana
    upper = (fs/2 - i - 1)*n/fs;
    w(12, 1:upper+1) = 1;
    lower = (fs/2 + i + 1)*n/fs;
    w(12, lower-1:n) = 1;
    
end