function R = block_inter_difference(block1,block2,T)
    if nargin < 2
        T = inf;
    end
    R = block1-block2;
    % Truncate
    R(R>T) = T;
    R(R<-T) = -T;
end