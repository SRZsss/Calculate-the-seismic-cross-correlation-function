function data = norm1(data)
%% Normalized function
% Calculate the result of vector normalization for each column
% 
% Input :
% data : Input vector
% 
% Output : 
% data : Vector after normalization
% 
% 
%    Copyright 2022 Ruizhe Sun,Department of geophysics,Jilin university of China
%    Licensed under the Apache License, Version 2.0 (the "License");
%    you may not use this file except in compliance with the License.
%    You may obtain a copy of the License at
%        http://www.apache.org/licenses/LICENSE-2.0
% 
for i = 1:length(data(1,:))
    if max(data(:,i))==0
        data(:,i) = data(:,i)/1;
    else
        data(:,i) = data(:,i)/(max(abs(data(:,i)))+1e-9);
    end
end
end