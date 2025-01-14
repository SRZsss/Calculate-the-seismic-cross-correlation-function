function dataout = mute2(data,dx,dt,hlimit,llimit,factor,headtrace)
%% mute1 function introdyuction
% 
%  Keep only the signals in the search window;
% 
%  Input:
%  data: The input shotgather,which represents time vertically and distance
%  horizontally;
%  dx: Track spacing;
%  dt: Sampling interval;
%  hlimit: Upper limit of speed window;
%  llimit: Lower limit of speed window;
% 
%  Output:
%  dataout: Reserved time window signal;
%  
% 
% 
%    Copyright 2022- Ruizhe Sun,Department of geophysics,Jilin university of China
%    Licensed under the Apache License, Version 2.0 (the "License");
%    you may not use this file except in compliance with the License.
%    You may obtain a copy of the License at
%        http://www.apache.org/licenses/LICENSE-2.0
%  
if nargin == 6
    headtrace = 1;
end
[nt,ntrace] = size(data);
X = (1:ntrace)*dx;
hT = fix(X/hlimit/dt);
lT = fix(X/llimit/dt);
indh = find(hT>1);
indl = find(lT>1);
dlayt = fix(headtrace/dt);
for i =indh(1):ntrace
    data(1:hT(i),i) = data(1:hT(i),i)*factor;
%     data(lT(i):end,i) = data(lT(i):end,i)*factor;
end
for i = indl(1):ntrace
%     data(1:hT(i),i) = data(1:hT(i),i)*factor;
    data(dlayt+lT(i):end,i) = data(dlayt+lT(i):end,i)*factor;
end
for i = 1:indl(1)
%     data(1:hT(i),i) = data(1:hT(i),i)*factor;
    data(dlayt+lT(indl(1)):end,i) = data(dlayt+lT(indl(1)):end,i)*factor;
end
dataout = data;


end


