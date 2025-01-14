function [ white_dom_time ] = cns_sw( data,sbin,dt,flow,fhigh )
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here
% data_sw : spectural whiting
warning off
nt = size(data,1);
df = 1/(nt*dt);

fl = fix(flow/df);
fh = fix(fhigh/df);

for k = 1:nt/2
    if k < fl
        taper0(k) = exp(-((k-fl)^2/(0.1*(1*fh)^2)));
    elseif k>=fl&&k<=fh
        taper0(k)=1;
    else
        taper0(k) = exp(-((k-fh)^2/(0.1*(1*fh)^2)));
    end  
        
end
taper = zeros(nt,1);
taper(1:nt/2) =taper0';
taper(1+nt/2:nt) = flipud(taper0');
% 
% figure;
% plot((1:nt)*df,taper)

dim = length(size(data));

if dim==1   
    D = fft(data);
    D_phase = angle(D);
%     D_mag = sqrt(abs(D));
    D_mag = (abs(D));
    As = smooth(D_mag,sbin); 
    
    %D_mag = D_mag./max(D_mag);
    %As = As./max(As);
    white_mag  = D_mag./(As+1e-9);
    white_dom_freq = taper.*white_mag.*exp(-1i*D_phase);
    white_dom_time = real(ifft(white_dom_freq)); 

end

if dim==2 
    [~,ng] = size(data);
    for k = 1:ng
        D = fft(data(:,k));
        D_phase = angle(D);
%         D_mag = sqrt(abs(D));
        D_mag = (abs(D));
        As = smooth(D_mag,sbin);
        %D_mag = D_mag./max(D_mag);
        %As = As./max(As);
        white_mag  = D_mag./(As+1e-9);
        white_dom_freq = taper.*white_mag.*exp(-1i*D_phase);
        white_dom_time(:,k) = real(ifft(white_dom_freq)); 
    end
end


end

