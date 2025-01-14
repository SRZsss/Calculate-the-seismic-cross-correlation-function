function [Dbpf,sp_bpf,f]=bpf(data,dt,N,cutoff)
% band-pass frequency filter 9BPF)
% data = n x r input (e.g. shot gathers, time series signal). n = number of samples. r = number of recivers.
% N = the BPF fir filter length
% cut_off = vector contains cut-off frequency values. For instance; '[5,37]' corresponds to low cut and high cut of 5 and 37 Hz.
% Dbpf = BP filtered data
% sp_bpf = BP filtered data frequency spectra
% f = vector containing the frequency values

[nt,nx] = size(data);
nt_fft = 2*nt;
data_f = fx(data,dt,nt_fft);
B = fir1(N,cutoff*2*dt);
HH = fft(B,nt_fft);
HH = conj(HH)';

sp_bpf = zeros(size(data_f));
for i = 1:nx
    sp_bpf(:,i) = data_f(:,i).*HH;
end
Dbpf = real(ifft(sp_bpf,[],1));
Dbpf = Dbpf(1+(length(B)-1)/2:nt+(length(B)-1)/2,:);

