function DATA = Gaussianfilter(data,dt,varargin)
%%
% One-dimensional Gaussian filter function
% Input:
% data: Data to be filtered;
% dt: sample interval
% Three filtering modes: Lowpass Bandpass Highpass;
% 
% Ouput: 
% DATA: Filtered data
% 
%    Copyright 2022- Ruizhe Sun,Department of geophysics,Jilin university of China
%    Licensed under the Apache License, Version 2.0 (the "License");
%    you may not use this file except in compliance with the License.
%    You may obtain a copy of the License at
%        http://www.apache.org/licenses/LICENSE-2.0

    if length(varargin)>2
        error('Too many input parameters')
    end
    a = 0;
    input = reshape(varargin,2,[]);
    if length(input{1}) == 7;
        if input{1} == 'Lowpass'
            DATA = Lowpass(data,dt,input{2});
            a = 1;
        end
    else
        if input{1} == 'Bandpass'
            DATA = Bandpass(data,dt,input{2});
            a = 1;
        end
        if input{1} == 'Highpass'
            DATA = Highpass(data,dt,input{2});
            a = 1;
        end
    end
    if a ~= 1
        error('Wrong filtering mode,correct input: Lowpass, Bandpass, Highpass');
    end
end
%% Subfunction
function DATA = Lowpass(data,dt,Fw)
    M = length(data);
    if length(Fw) ~= 1
        error('Filter parameter input error')
    end
    dataf = fftshift(fft(data));
    fsl = length(dataf)
    fs = linspace(0+1/dt/2/fsl,1/dt/2,fsl/2)';
    D = -abs(fs);
    Dp = [flip(D); D];
    H = exp(Dp/Fw);
    DATA = real(ifft(ifftshift(dataf.*H)));
end
function DATA = Bandpass(data,dt,Fw)
    M = length(data);
    if length(Fw) ~= 2
        error('Filter parameter input error')
    end
    dataf = fftshift(fft(data));
    fsl = length(dataf)
    fs = linspace(0+1/dt/2/fsl,1/dt/2,fsl/2)';
    D = -abs(fs-mean(Fw));
    Dp = [flip(D); D];
    H = exp(-20*(Dp/mean(Fw(2)-Fw(1))).^2);
    DATA = real(ifft(ifftshift(dataf.*H)));
end
function DATA = Highpass(data,dt,Fw)
    M = length(data);
    if length(Fw) ~= 1
        error('Filter parameter input error')
    end
    dataf = fftshift(fft(data));
    fsl = length(dataf)
    fs = linspace(0+1/dt/2/fsl,1/dt/2,fsl/2)';
    D = -abs(fs);
    Dp = [flip(D); D];
    H = 1 - exp(Dp/Fw);
    DATA = real(ifft(ifftshift(dataf.*H)));
end

