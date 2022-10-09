clear;

% DECODING AND ENCODING, PRESENTATION OF THE TWO FUNCTIONS
% RECIPROCAL.

load("spydata.mat");
load("training.mat");
rKey = received;
key = training;

% SIGNAL RECONSTRUCTION: EQUALIZE.
% PARAMETERS
L = 8; % there will be L+1 parameters w. And we lose L values among the N
N = 32;
% CONSTRUCTION OF THE MATRIX R
R = zeros(N-L, L+1);
for ligne = 1:N-L
    for colonne = 1:L+1
        R(ligne, colonne) = rKey(L+ligne-colonne+1);
    end
end
%[RB,p] = rref(R);
% CONSTRUCTION OF THE TRAINING VECTOR (THE KNOWN ONE))
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

mse=0;
for i = L+1:N
   mse = mse + (eKey(i)-key(i))^2;
end
%mse

for k = 1:length(eKey)
     eKey(k) = sign(eKey(k));
     if eKey(k) == 0
         eKey(k) = -1;
     end
end

% errCheck = (eKey-key)/2;
% MSE = 0;
% for i = 1:N %length(errCheck)        % we only know key from 1 to N !!!!
%    MSE = MSE + errCheck(i)^2;
% end
% MSE;


% return


% ALLOWS ERRORS TO BE ADDED TO key FOR TESTING
nombre_d_erreurs_a_inserer = 1500;
j = randperm(length(eKey), nombre_d_erreurs_a_inserer); 
for i = 1:length(j)
    eKey(j(i)) = eKey(j(i)) * (-1);
end

% IMAGE DECODING AND DISPLAY
dPic = decoder(eKey, cPic);
image(dPic);
%xlabel(['Deciphered image for L=',num2str(L),' and ',num2str(nombre_d_erreurs_a_inserer),' bit error insertions']);
set(gca,'XTickLabel', [], 'YTickLabel', []);
axis square;