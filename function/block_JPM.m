function [JPM_h,JPM_v,JPM_d,JPM_m] = block_JPM(matrix,T)
    JPM_h = zeros(2*T+1);
    for i = 1:size(matrix,1)
        for j = 1:size(matrix,2)-1
            row = matrix(i,j)+T+1;
            col = matrix(i,j+1)+T+1;
            JPM_h(row,col) = JPM_h(row,col)+1;
        end
    end
    JPM_h = JPM_h/sum(JPM_h(:));

    JPM_v = zeros(2*T+1);
    for i = 1:size(matrix,1)-1
        for j = 1:size(matrix,2)
            row = matrix(i,j)+T+1;
            col = matrix(i+1,j)+T+1;
            JPM_v(row,col) = JPM_v(row,col)+1;
        end
    end
    JPM_v = JPM_v/sum(JPM_v(:));

    JPM_d = zeros(2*T+1);
    for i = 1:size(matrix,1)-1
        for j = 1:size(matrix,2)-1
            row = matrix(i,j)+T+1;
            col = matrix(i+1,j+1)+T+1;
            JPM_d(row,col) = JPM_d(row,col)+1;
        end
    end
    JPM_d = JPM_d/sum(JPM_d(:));

    JPM_m = zeros(2*T+1);
    for i = 1:size(matrix,1)-1
        for j = 2:size(matrix,2)-1
            row = matrix(i,j+1)+T+1;
            col = matrix(i+1,j)+T+1;
            JPM_m(row,col) = JPM_m(row,col)+1;
        end
    end
    JPM_m = JPM_m/sum(JPM_m(:));
end