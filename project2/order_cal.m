clear all;
pic = imread('kth.jpg');
[key, cPic] = encoder(pic);

h = [1 0.7 0.7];
dkey = conv(key, h);

L = 13;
b = key(L+1:32);
r = dkey(1:length(key)-2);

R = zeros(32-L,L+1);
for i = 1:32-L
    for j = 1:L+1
        R(i,j) = r(L+1+i-j);
    end
end
w = R'*R\R'*b;
b_caret = R*w;
mse = 0;
for i = 1:(32-L)
    mse = mse + (b(i)-b_caret(i))^2;
end
MSE = mse/(32-L);

%zkey = conv(dkey,coeff);

% bkey = sign(zkey);
% dPic = decoder(bkey, cPic);
% image(dPic);
% axis square;