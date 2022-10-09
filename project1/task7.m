k=-10:10;
r=(16/15)^2*4.^(-abs(k)).*(abs(k)+17/15);
stem(k,r);
title('Autocorrelation function');
xlabel('k');
ylabel('rx2');