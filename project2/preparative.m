clear;

% DECODING AND ENCODING, PRESENTATION OF THE TWO FUNCTIONS
% RECIPROCAL.
% pic = imread('kth.jpg');
% [key, cPic] = encoder(pic);
% dPic = decoder(key, cPic);
% image(dPic);

% IMAGE ENCODING
pic = imread('kth.jpg');

iterMax=1;
maxL = 31;
MSEArray = zeros(maxL+1, iterMax);

for iter = 1:iterMax

    [key, cPic] = encoder(pic);
    
    % SIGNAL DISTORTION: CONVOLUTION
    h = [1, 0.7, 0.7 0.7];
    rKey = zeros(size(key));
    for k = 1:length(key)
        for l = 0:3
            if k-l >= 1
                rKey(k) = rKey(k) + h(l+1)*key(k-l) + normrnd(0, 0.2);
            end
        end
    end
    %rKey = filter(h, 1, key); % this line does the same as the comment before


    for L = 0:maxL
        % SIGNAL RECONSTRUCTION: EQUALIZE.
        % PARAMETERS
        %L = 15; % iThere will be L+1 parameters w. And we lose L values among the N
        N = 32;
        % CONSTRUCTION OF THE MATRIX R
        R = zeros(N-L, L+1);
        for ligne = 1:N-L
            for colonne = 1:L+1
                R(ligne, colonne) = rKey(L+ligne-colonne+1);
            end
        end
        [RB,p] = rref(R);
        % CONSTRUCTION OF THE TRAINING VECTOR (THE KNOWN ONE)
        b = zeros(N-L, 1);
        for colonne = 1:N-L
            b(colonne) = key(L+colonne);
        end
        % RESOLVING THE EQUATIONS TO OBTAIN THE COEFFICIENTS w
        w = R\b;
        % EXTRAPOLATION OF THE RESULTS OBTAINED ON THE FOLLOWING rKey VALUES
        eKey = zeros(size(rKey));
        for k = 1:N % we could also go to N, because we know them
           eKey(k) = key(k); 
        end
        for k = N+1:length(rKey)
            for i = 1:L+1
                eKey(k) = eKey(k) + w(i)*rKey(k-i+1);
            end


        end

        for k = N+1:length(rKey)
            eKey(k) = sign(eKey(k));
            if eKey(k) == 0
                eKey(k) = -1;
            end
        end

        errCheck = (eKey-key);
        SE = 0;
        for i = 1:length(errCheck)        % we only know key from 1 to N !!!!
           SE = SE + errCheck(i)^2;
        end
        MSEArray(L+1, iter) = SE / length(errCheck);

    end
    plot(0:maxL, MSEArray(:,iter));
    hold on;
end
hold off;

    %title('MSE between the recovered signal and the original key');
    xlabel('order L');
    ylabel('MSE');