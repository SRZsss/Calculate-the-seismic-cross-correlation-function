function data=xdvo(data1,data2)
%% xcoh Function Introduction
% Calculate two vectors  deconvolution
% 
% Input :
% data1 : Data of  deconvolution function to caculated
% data2 :  Deconvolution reference vector
% Output : 
% data :  Deconvolution function by caculate
% 
% Author(s) : CSIM
% Copyright : Open source
% Revison : 1.0  Date : 16/11/2022
% 
% CSIM,Key Laboratory of Applied Geophysics, Ministry of Natural Resources
% College of geoexploration science and technology,Jilin university of China
% 
    [nt,nx]=size(data1);
    N=2*nt-1;
    data1=fft(data1,N);
    data2=fft(data2,N);
    data=real(fftshift(ifft((abs(conj(data2))./abs(data1)+1e-3).*exp(sqrt(-1)*angle((conj(data2).*data1))))));
    data = norm1(data);
end