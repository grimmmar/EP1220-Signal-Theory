clear all;
pic = imread('kth.jpg');
dPic = decoder(key, cPic);
image(dPic);
axis square;