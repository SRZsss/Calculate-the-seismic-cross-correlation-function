function [deconf] = decon(s,r,ep)
% water-level deconvolution interferometry in frequency domain
% Muhammad F. Akbar @ 2018
%
% s = n x 1 vector/trace/signal at virtual source location (n = number of samples)
% r = n x r receivers traces (r = number of receiver)
% deconf = n x r virtual shot gather from vortual source at s position
% ep = stabilization parameter
% physical interpretation of 'deconf': Virtual/pseudoshot gather recorded at each of r locations as if there is a physical source at s location.

[~,nx] = size(r);
[nt,~] = size(r);

npad = round(nt);
rp = padarray(r,npad);
sp = padarray(s,npad);
rp = rp(1:2*nt,:);
sp = sp(1:2*nt,:);

wr = fft(rp);
ws = fft(sp);

deconff = zeros(nt*2,nx);
OP = conj(ws)./(abs(ws).^2+(ep^2)*max(abs(ws).^2)); % deconvolution operator

for i = 1:nx % apply the deconvolution operator
    deconff(:,i) = wr(:,i).*OP;
end

decon = real(ifft(deconff,[],1));

deconf = decon(1:nt,:); % causal part of deconvolution result