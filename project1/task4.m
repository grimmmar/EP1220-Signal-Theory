n=100;
x=(0:n-1)/n;
y=fft(y2,n);
p=y.*conj(y)/n;
plot(x,p);