function score = KLD(P,Q)
    score = 0;
    for i = 1:length(P)
        score = score + P(i)*log2(P(i)/Q(i));
    end
end