function data=xcor(data1,data2)
%% xcor Function Introduction
% Calculate two vectors cross-correlation 
% 
% Input :
% data1 : Data of cross correlation function to caculated
% data2 : Cross correlation reference vector
% Output : 
% data : Cross-correlation function by caculate
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
    data=fftshift(ifftshift(conj(data2).*data1));
    data = norm1(data);
end