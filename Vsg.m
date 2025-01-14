function Sgather = Vsg(datainput,dt,wt,varargin)
%% Vsg function introduction
% Calculate ambient noise virtual shot gather(VSG);
% Preprocessing and then the VSG can be obtained by phase weighted stacking.
% 
% Input :
% datainput : Ambient noise data of cross correlation function to be caculated
% dt : Sample interval
% wt : Split time window;
% varargin : 
% 'IT':Interfere source trace;
% 'Rt':Interfere receive trace;
% 'Overlapt':Window overlay duration;
% 'Detrend':De-average and de-trend each data after windowing;
% 'Onebit':Onebit normalization of data after windowing;
% 'Bpfilter':Bandpass filtering of data after windowing;
% 'Gbpfilter':Gaussian bandpass filtering of data after windowing;
% 'Glpfilter':Gaussian lowpass filtering of data after windowing;
% 'Ghpfilter':Gaussian highpass filtering of data after windowing;
% 'Whitening':Spectral whitening of data after windowing;
% 'Detrendall':De-average and de-trend each data before windowing;
% 'Onebitall':Onebit normalization of data before windowing;
% 'Bpfilterall':Bandpass filtering of data before windowing;
% 'Gbpfilterall':Gaussian bandpass filtering of data before windowing;
% 'Glpfilterall':Gaussian lowpass filtering of data before windowing;
% 'Ghpfilterall':Gaussian highpass filtering of data before windowing;
% 'Whiteningall':Spectral whitening of data before windowing;
% 'Calculatemode':Calculation method,['corr']:cross-correlation;['dc']:Deconvolution;['coh']:cross-Coherent;
% 
% Output:
% Sgather:Output virtual shot gather;
% 
% example:Sgather = Vsg(datainput,0.01,10,10,'Overlapt',8,'Detrend',1,'Onebit',1,'Bpfilter',[1 2 25 26],'Whitening',[2 25],'Calculatemode','corr')
% 
%    Copyright 2022- Ruizhe Sun,Department of geophysics,Jilin university of China
%    Licensed under the Apache License, Version 2.0 (the "License");
%    you may not use this file except in compliance with the License.
%    You may obtain a copy of the License at
%        http://www.apache.org/licenses/LICENSE-2.0
% 
addpath('Vsgfunction')
pde = 1;
pon = 1;
lfi = 0;
fa = 0;
wa = 0;
pfilter = [];
whf = [];
lineup = 1;
cmode = 1;
window_PWS_T = 0.1;
v=0.8;%Weighting coefficent
overlapt = wt*0.8;
It = 1;
[nt,ntrace] = size(datainput);
Rt = 1:ntrace;
mbinput = {'It' 'Rt' 'Overlapt' 'Detrend' 'Detrendall' 'Onebit' 'Onebitall' 'Bpfilter' 'Bpfilterall' 'Gbpfilter' 'Gbpfilterall' 'Glpfilter' 'Glpfilterall' 'Ghpfilter' 'Ghpfilterall' 'Whitening' 'Whiteningall' 'Calculatemode'};
input = reshape(varargin,2,[]);
[~,pin] = size(input);
for i = 1:pin
    pm = 0;
    for j = 1:18
        if strcmp(cell2mat(input(1,i)),cell2mat(mbinput(j)))
            pm = j;
        end
    end
    if pm == 0
        error('Wrong input parameters')
    end
    if pm == 1
        It = cell2mat(input(2,i));
    end
    if pm == 2
        Rt = cell2mat(input(2,i));
    end
    if pm == 3
        overlapt = cell2mat(input(2,i));
    end
    if pm == 4
        pde = cell2mat(input(2,i));
    end
    if pm == 5
        if cell2mat(input(2,i)) == 1
            datainput = detrenddata(datainput);
        end
    end
    if pm == 6
        pon = cell2mat(input(2,i));
    end
    if pm == 7
        if cell2mat(input(2,i)) == 1
            datainput = Onebit(datainput);
        end
    end
    if pm == 8
        fa = lineup;
        lineup = lineup+1;
        pfilter = cell2mat(input(2,i));
        lfi = 1;
    end
    if pm == 9
        datainput = bpf(datainput,dt,cell2mat(input(2,i)));
    end
    if pm == 10
        fa = lineup;
        lineup = lineup+1;
        pfilter = cell2mat(input(2,i));
        lfi = 2;
    end
    if pm == 11
         datainput = Gaussianfilter(datainput,dt,'Bandpass',cell2mat(input(2,i)));
    end
    if pm == 12
        fa = lineup;
        lineup = lineup+1;
        pfilter = cell2mat(input(2,i));
        lfi = 3;
    end
    if pm == 13
         datainput = Gaussianfilter(datainput,dt,'Lowpass',cell2mat(input(2,i)));
    end
    if pm == 14
        fa = lineup;
        lineup = lineup+1;
        pfilter = cell2mat(input(2,i));
        lfi = 4;
    end
    if pm == 15
         datainput = Gaussianfilter(datainput,dt,'Highpass',cell2mat(input(2,i)));
    end
    if pm == 16
        wa = lineup;
        lineup = lineup+1;
        whf = cell2mat(input(2,i));
    end
    if pm == 17
        datainput = Vwhitening(datainput,dt,cell2mat(input(2,i)));
    end
    if pm == 18
        ifmode = [strcmp(cell2mat(input(2,i)),'xcorr') strcmp(cell2mat(input(2,i)),'dc') strcmp(cell2mat(input(2,i)),'xcoh') strcmp(cell2mat(input(2,i)),'xcoh1')];
        cmode = find(ifmode == 1);
    end
end
if cmode == 1
    xcc = @(data1,data2)xcorr(data1,data2);
elseif cmode == 2
    xcc = @(data1,data2)xdc(data1,data2);
elseif cmode == 3
    xcc = @(data1,data2)xcoh(data1,data2);
elseif cmode == 4
    xcc = @(data1,data2)xcoh1(data1,data2);
end
wdata = @(datainput)windowdata(datainput,dt,pde,pon,lfi,wa,pfilter,whf,fa);
nw = fix((nt*dt-wt)/(wt-overlapt))+1;%The number of windows
dmi = fix(wt/dt);%The number of sample in one window
wmi = fix((wt-overlapt)/dt);
data_NCF = zeros(2*dmi-1,nw);
Sgather = zeros(dmi,Rt(end));
for i = It
    for j = Rt
        for k = 1:nw
            data1_mi = wdata(datainput((k-1)*wmi+1:(k-1)*wmi+dmi,i));
            data2_mi = wdata(datainput((k-1)*wmi+1:(k-1)*wmi+dmi,j));
            data_NCF(:,k) = xcc(data2_mi,data1_mi);
        end
        if cmode ==2
            data_NCF(isnan(data_NCF)) =0;
        end
        c = CalcPWSCoefficient(data_NCF,window_PWS_T, dt);
        c = c.^(v);%相位叠加参数
        data_NCF_all(:) = mean(data_NCF,2).*c;%相位叠加
        data_NCF_all(:) = data_NCF_all(:)/max(abs(data_NCF_all(:)));%归一化得到了叠加后的互相关函数
        if length(It) == 1  
            Sgather(:,j) = (flip(data_NCF_all(1:dmi)') + data_NCF_all(dmi:end)'); 
%               Sgather(:,j) = data_NCF_all(:)';
        else
            Sgather(:,j,i) = (flip(data_NCF_all(1:dmi)') + data_NCF_all(dmi:end)'); 
        end
    end
end


end
function dataoutput = detrenddata(datainput)
    [~,ntr] = size(datainput);
    for ii = 1:ntr
        datainput(:,ii) = detrend(datainput(:,ii));
    end
    dataoutput = datainput;
end
function dataoutput = Onebit(datainput)
    datainput(datainput>0) = 1;
    datainput(datainput<0) = -1;
    dataoutput = datainput;
end
function dataoutput = bpf(datainput,dt,pfilter);
    [~,ntr] = size(datainput);
    for ii = 1:ntr
        datainput(:,ii) = bp_filter(datainput(:,ii),dt,pfilter(1),pfilter(2),pfilter(3),pfilter(4));
    end
    dataoutput = datainput;
end
function dataoutput = Vwhitening(datainput,dt,Fr)
    [~,ntr] = size(datainput);
    for ii = 1:ntr
        datainput(:,ii) = cns_sw(datainput(:,ii),5,dt,Fr(1),Fr(2));
    end
%     datainput = cns_sw(datainput,5,dt,Fr(1),Fr(2));
    dataoutput = datainput;
end
function dataoutput = windowdata(datainput,dt,pde,pon,lfi,wa,pfilter,whf,fa)
    if pde == 1
        datainput = detrend(datainput);
    end
    if pon == 1
        datainput = Onebit(datainput);
    end
    if pde == 2
        datainput = detrend(datainput);
    end
    if pon == 2
        datainput = Onebit(datainput);
    end
    if wa == 1
        datainput = Vwhitening(datainput,dt,whf(1),whf(2));
    end
    if fa == 1
        if lfi == 1
            datainput = bp_filter(datainput,dt,pfilter(1),pfilter(2),pfilter(3),pfilter(4));
        end
        if lfi == 2
            datainput = Gaussianfilter(datainput,dt,'Bandpass',pfilter);
        end
        if lfi == 3
            datainput = Gaussianfilter(datainput,dt,'Lowpass',pfilter);
        end
        if lfi == 4
            datainput = Gaussianfilter(datainput,dt,'Highpass',pfilter);
        end
    end
    if wa == 2
        datainput = Vwhitening(datainput,dt,whf);
    end
    if fa == 2
        if lfi == 1
            datainput = bp_filter(datainput,dt,pfilter(1),pfilter(2),pfilter(3),pfilter(4));
        end
        if lfi == 2
            datainput = Gaussianfilter(datainput,dt,'Bandpass',pfilter);
        end
        if lfi == 3
            datainput = Gaussianfilter(datainput,dt,'Lowpass',pfilter);
        end
        if lfi == 4
            datainput = Gaussianfilter(datainput,dt,'Highpass',pfilter);
        end
    end
    dataoutput = datainput;
end
