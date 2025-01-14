function [green] = green_Master(ibas,x,lengthwindow,slidinterval,method_cor)  

[~, nch] = size(x);
bas = x(:,ibas);  
green = zeros(2*lengthwindow-1,nch);

for ich = 1:nch   
    %str = sprintf('------------- Current Slave Channel: %d -------------', ich);
%     disp(str);
    
    [total_tim1, tmp] = size(x(:, ich));
    [total_tim2, tmp] = size(bas);
    total_time=min(total_tim1,total_tim2);

    range=1:lengthwindow;
    num = round((total_time - length(range)) / slidinterval + 1);
    trac = zeros(2 * length(range) - 1, 1);

    for i = 1:num-1
         if strcmp(method_cor,'xcorr') ;               
            trac = trac + xcorr(x(range, ich), bas(range)); 
         else strcmp(method_cor,'xcov')  ;
            trac = trac + xcov(x(range, ich), bas(range));
%          else strcmp(method_cor,'decon')  ;
%             trac = trac + xcov(x(range, ich), bas(range));
         %else                    
            %trac = trac + corr_decon(x(range, ich), bas(range));                  
         end 

        range = range + slidinterval;
    end
    trac = trac / num;

    green(:,ich)= trac/(max(trac)+1e-9);
end
