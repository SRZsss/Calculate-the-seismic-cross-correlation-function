function x =  DC_smooth(x,nfilt)
[~,ng] = size(x);
for i=1: ng
        x(:,i) = x(:,i) - mean(x(:,i));
        x(:,i) = filter(ones(1,nfilt)/nfilt,1,x(:,i));
%         x(:,i) = sign(x(:,i));
end