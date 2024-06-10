function [result,JSD1,JSD2] = region_distinguishment(img,siz1,T,img_gt)
    [h,w] = size(img);
    %% Step1
    func = @(block_struct) round(abs(dct2(block_struct.data)));
    dct_matrix = blockproc(img,[siz1,siz1],func);

    row = siz1*ones(floor(h/siz1),1);
    col = siz1*ones(floor(w/siz1),1);
    if floor(h/siz1)*siz1<h
        row(end+1) = h-floor(h/siz1)*siz1;
    end
    if floor(w/siz1)*siz1<w
        col(end+1) = w-floor(w/siz1)*siz1;
    end
    dct_blocks = mat2cell(dct_matrix,row,col);
    
    %% Step2
    Feature = cell(size(dct_blocks));

    for i = 3:size(dct_blocks,1)-2
        for j = 3:size(dct_blocks,2)-2
            block1 = dct_blocks{i,j};
            % Intra
            [A_h,A_v,A_d,A_m] = block_intra_difference(block1,T);
            [jpm_A_hh,jpm_A_hv,jpm_A_hd,jpm_A_hm] = block_JPM(A_h,T);
            [jpm_A_vh,jpm_A_vv,jpm_A_vd,jpm_A_vm] = block_JPM(A_v,T);
            [jpm_A_dh,jpm_A_dv,jpm_A_dd,jpm_A_dm] = block_JPM(A_d,T);
            [jpm_A_mh,jpm_A_mv,jpm_A_md,jpm_A_mm] = block_JPM(A_m,T);
            intra_jpm = (jpm_A_hh+jpm_A_hv+jpm_A_hd+jpm_A_hm+jpm_A_vh+jpm_A_vv+jpm_A_vd+jpm_A_vm+...
                jpm_A_dh+jpm_A_dv+jpm_A_dd+jpm_A_dm+jpm_A_mh+jpm_A_mv+jpm_A_md+jpm_A_mm)/16;


            % Inter
            block2 = dct_blocks{i,j+1};
            R_h = block_inter_difference(block1,block2,T);
            [jpm_R_hh,jpm_R_hv,jpm_R_hd,jpm_R_hm] = block_JPM(R_h,T);
            block2 = dct_blocks{i+1,j};
            R_v = block_inter_difference(block1,block2,T);
            [jpm_R_vh,jpm_R_vv,jpm_R_vd,jpm_R_vm] = block_JPM(R_v,T);
            block2 = dct_blocks{i+1,j+1};
            R_d = block_inter_difference(block1,block2,T);
            [jpm_R_dh,jpm_R_dv,jpm_R_dd,jpm_R_dm] = block_JPM(R_d,T);
            block2 = dct_blocks{i+1,j-1};
            R_m = block_inter_difference(block1,block2,T);
            [jpm_R_mh,jpm_R_mv,jpm_R_md,jpm_R_mm] = block_JPM(R_m,T);
            inter_jpm = (jpm_R_hh+jpm_R_hv+jpm_R_hd+jpm_R_hm+jpm_R_vh+jpm_R_vv+jpm_R_vd+jpm_R_vm+...
                jpm_R_dh+jpm_R_dv+jpm_R_dd+jpm_R_dm+jpm_R_mh+jpm_R_mv+jpm_R_md+jpm_R_mm)/16;
            feature = [intra_jpm(:);inter_jpm(:)];
            Feature{i,j} = feature;
        end
    end
    %% Step3
    [~,~,c] = size(img_gt);
    if c>1
        img_gt = rgb2gray(img_gt);
    end
    img_gt = imbinarize(img_gt);
    [L, ~] = bwlabel(img_gt);

    func = @(block_struct) max(block_struct.data(:));
    L_ = blockproc(L,[siz1,siz1],func);


    [Out_Region_X,Out_Region_Y] = find(L_ == 0);
    [R1_X,R1_Y] = find(L_ == 1);
    [R2_X,R2_Y] = find(L_ == 2);


    Out_Region_f = zeros(2*(2*T+1)*(2*T+1),1);
    count = 0;
    for i = 1:length(Out_Region_X)
        feature = Feature{Out_Region_X(i),Out_Region_Y(i)};
        if ~isempty(feature)
            count = count+1;
        else
            continue;
        end
        Out_Region_f = Out_Region_f+feature;
    end
    Out_Region_f = Out_Region_f/count;
    Out_Region_f = Out_Region_f/sum(Out_Region_f);


    R1_f = zeros(2*(2*T+1)*(2*T+1),1);
    count = 0;
    for i = 1:length(R1_X)
        feature = Feature{R1_X(i),R1_Y(i)};
        if ~isempty(feature)
            count = count+1;
        else
            continue;
        end
        R1_f = R1_f+feature;
    end
    R1_f = R1_f/count;
    R1_f = R1_f/sum(R1_f);


    R2_f = zeros(2*(2*T+1)*(2*T+1),1);
    count = 0;
    for i = 1:length(R2_X)
        feature = Feature{R2_X(i),R2_Y(i)};
        if ~isempty(feature)
            count = count+1;
        else
            continue;
        end
        R2_f = R2_f+feature;
    end
    R2_f = R2_f/count;
    R2_f = R2_f/sum(R2_f);

    P = Out_Region_f;
    Q1 = R1_f;
    M1 =(P+Q1)/2;

    JSD1 = 0.5*KLD(P,M1)+0.5*KLD(Q1,M1);

    Q2 = R2_f;
    M2 =(P+Q2)/2;

    JSD2 = 0.5*KLD(P,M2)+0.5*KLD(Q2,M2);

    Forged1 = L == 1;
    Forged2 = L == 2;
    result = zeros(h,w,3);
    if JSD1 >JSD2
        result(:,:,1) = 255*Forged1+255*Forged2;
        result(:,:,2) = 255*Forged2;
        result(:,:,3) =255* Forged2;
    else
        result(:,:,1) = 255*Forged1+255*Forged2;
        result(:,:,2) = 255*Forged1;
        result(:,:,3) = 255*Forged1;
    end
    result = uint8(result);
end