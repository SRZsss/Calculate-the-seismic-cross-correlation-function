%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%谱白化%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%谱白化
%%
%datapart:谱白化的数据
%dt:数据采样时间间隔
%LowFMin:最小的频率
%HighFMax:最大的频率
%LowFMin和HighFMax决定谱白化的范围

function data=whitening(datapart,dt,LowFMin,HighFMax)
[fftlength,~]=size(datapart);
delta_f = 1/fftlength/dt;
fftdata=fft(datapart,fftlength);
MinFPoint = max(2, ceil(LowFMin/delta_f));
MaxFPoint = min(fftlength/2, floor(HighFMax/delta_f));
nn =  MinFPoint:MaxFPoint;
datafamp = abs(fftdata(nn))';
winsize = max(round(0.02/delta_f), 11);
if mod(winsize,2) == 0
    winsize = winsize + 1;
end
shiftpt = round((winsize+1)/2);
datafampnew = [ones(1,winsize)*datafamp(1) datafamp ones(1,winsize)*datafamp(end)];
datafampsmooth = filter(ones(1,winsize)/winsize,1,datafampnew);
datafampsmooth2 = datafampsmooth((winsize+shiftpt):(winsize+shiftpt+length(nn)-1));
KK = find(datafampsmooth2 > 0);
JJ = isnan(datafampsmooth2);
fftdata(nn(JJ)) = 0;
fftdata(nn(KK)) = fftdata(nn(KK))./datafampsmooth2(KK)' ;
data=real(ifft(fftdata));    
     
   