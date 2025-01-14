function data = xcoh1(data1,data2)
%% xcoh Function Introduction
% Calculate two vectors cross-coherence
% 
% Input :
% data1 : Data of cross coherence function to caculated
% data2 : Cross coherence reference vector
% Output : 
% data : Cross-coherence function by caculate
% 
% Author(s) : CSIM
% Copyright : Open source
% Revison : 1.0  Date : 16/11/2022
% 
% CSIM,Key Laboratory of Applied Geophysics, Ministry of Natural Resources
% College of geoexploration science and technology,Jilin university of China
% 
    [nt,nx]=size(data1);
    data1=fft(data1,2*nt-1);
    data2=fft(data2,2*nt-1);
%     data = fftshift(ifft(exp(sqrt(-1)*angle((conj(data2).*data1)))));
    data=(fftshift(ifft((conj(data2).*data1)./abs(conj(data2))./abs(data1))));
    data = norm1(real(data));
end