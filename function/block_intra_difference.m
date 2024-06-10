% Difference-arrays
function [A_h,A_v,A_d,A_m] = block_intra_difference(block,T)
    if nargin < 2
        T = inf;
    end
    A_h = block(1:end,1:end-1)-block(1:end,2:end);
    A_v = block(1:end-1,1:end)-block(2:end,1:end);
    A_d = block(1:end-1,1:end-1)-block(2:end,2:end);
    A_m = block(1:end-1,2:end)-block(2:end,1:end-1);
    % Truncate
    A_h(A_h>T) = T;
    A_h(A_h<-T) = -T;
    
    A_v(A_v>T) = T;
    A_v(A_v<-T) = -T;
    
    A_d(A_d>T) = T;
    A_d(A_d<-T) = -T;
    
    A_m(A_m>T) = T;
    A_m(A_m<-T) = -T;
end