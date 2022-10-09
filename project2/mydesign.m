clear all;
load training.mat
load spydata.mat
b_origin=xlsread('b_test.xlsx');
errornumber=1;
% L=8;
for L=0:15
b_pilot=training(L+1:32);
r=received;

% calculate R and w
R=zeros(32-L,L+1);
for i=1:32-L
    for j=1:L+1
        R(i,j)=r(L+1+i-j);
    end
end
%w=inv(R'*R)*R'*b_pilot;
 w=R'*R\R'*b_pilot;

% get the estimation of bits
for i=L+1:length(received)
    b_esti(i)=0;
    for j=1:L+1
        b_esti(i)=b_esti(i)+w(j)*r(i-j+1);
    end
end
b_esti=b_esti';
for i=1:L
    b_esti(i)=training(i);
end

% evaluate MSE
b_pilottest=R*w;
mse=0;
delta=zeros(32-L,1);
for i=1:(32-L)
    
    mse=mse+(b_pilot(i)-b_pilottest(i))^2;
    delta(i)=(b_pilot(i)-b_pilottest(i))^2;
end
MSE=mse;
MSE=MSE/(32-L);

% recover the origin bits
for i=1:length(b_esti)
    if(b_esti(i)>=0)
        b_out(i)=1;
    end
    if(b_esti(i)<0)
        b_out(i)=-1;
    end
end
b_out=b_out';

L2=0;
for i=33:64
    L2=L2+(b_esti(i)-b_origin(i-32))^2;
end
if(L==5)
    L2=L2+1;
end

getmse(L+1)=MSE;
getl2(L+1)=L2;
end
x=0:15;
stem(x,getl2);
figure;

% add errors
errorlocation=randperm(length(b_out), errornumber);
for i=1:length(b_out)
    for j=1:length(errorlocation)
        if(i==errorlocation(j))
            temp=b_out(i);
            if(b_out(i)>0)
                b_out(i)=-1;
            end
            if(b_out(i)<0)
                b_out(i)=1;
            end
        end
    end
end

% decode the picture
dpic=decoder(b_out,cPic);
image(dpic);
axis square;