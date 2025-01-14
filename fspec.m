function fspec(v,dt)
[nt,ng]=size(v);

f=fft(v);

ff=1/dt/nt*(0:floor(nt/2)-1);


% if (ng>1)
%    figure;plot(ff,sum(abs(f(1:floor(nt/2),:)),2));xlabel('frequency','fontsize',14);   ylabel('Amplitude','fontsize',14);
%    figure;imagesc((1:ng),ff,(abs(hilbert(f(1:floor(nt/2),:)))));
%    xlabel('trace No.','fontsize',14);
%    ylabel('frequency','fontsize',14);
% else
   fsp = abs(f(1:floor(nt/2)));
   figure;plot(ff,fsp,'k-','LineWidth',1);
   set(gca,'FontWeight','bold')
   xlabel('frequency','fontsize',14,'FontWeight','bold');
   ylabel('Amplitude','fontsize',14,'FontWeight','bold');
% end


end