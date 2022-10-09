n=100;
r=xcorr(y)/n;
pxx=fft(r);
f=(0:length(pxx)-1)/length(pxx);
plot(f,abs(pxx));
title('Power Spectrum Density Estimate');
xlabel('Normalized Frequency');
ylabel('Power');