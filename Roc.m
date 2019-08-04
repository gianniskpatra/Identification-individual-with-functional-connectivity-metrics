function [EER] = Roc(band,color1)

    matching_matrix = zeros(545,545);

    k=0;
    l=0;
    for s1=1:109
        for s2=1:109
            for e1=1:5
                for e2=1:5
                    vec1 = squeeze(band(e1,s1,:));
                    vec2 = squeeze(band(e2,s2,:));
                    matching_matrix((e1+l),(e2+k)) = norm(vec1 - vec2);
                end
            end
            k=k+5;
        end
        k=0;
        l=l+5;
    end


    %% Find all possible genuine and impostor matching scores

    a=1;
    b=5;
    k=1;
    l=10;

    for s=1:109
        
        A = matching_matrix(a:b,a:b);
    	mask = triu(true(size(A)),1);
    	B = A(mask);
        genuine_score(k:l) = B;    
           
        a=a+5;
        b=b+5;
        k=k+10;
        l=l+10;
        
    end

    a=1;
    b=5;
    c=6;
    d=10;
    k=1;
    l=25;
    f=11;
    e=15;
    pp=108;

    for s=1:108
        
        for s1=1:pp
            
            A = matching_matrix(a:b,c:d);
            reshape(A,1,[]);
            transpose(A);
            B = reshape(A.',1,[]);
            B = B.';        
            impostor_score(k:l) = B;
            
            k=k+25;
            l=l+25;
            c=c+5;
            d=d+5;

        end
        
        pp=pp-1;
        a=a+5;
        b=b+5;
        c=f;
        d=e;
        f=f+5;
        e=e+5;
    end

    %% From matching score to similarity score + flag

    genuine_score1 = 1./(1+genuine_score);  % similarity of genuine
    impostor_score1= 1./(1+impostor_score); % similarity of impostor
    similarity_vector = cat(2,impostor_score1,genuine_score1); % similarity = sim.genuine + sim.impostor
    flag = zeros(1,148240);     % impostor=0 
    flag(1,147151:148240) = 1;  % genuine=1

    %% FAR, FRR, Plot ROC

    nAcquisitions=length(similarity_vector); % length(score)
    assert (nAcquisitions==length(flag));    % Throw error if condition false

    nGen=sum(flag);
    nImp=sum(~flag);
    assert(nGen+nImp==nAcquisitions);  % Throw error if condition false

    % sort in ascending order
    [score_sort, i_sort]=sort(similarity_vector);
    flag_sort=flag(i_sort);

    % thresholds
    vett_threshold=movmean(score_sort,2);
    vett_threshold=vett_threshold(2:end);
    vett_threshold(end+1)=1;

    FRR=cumsum(flag_sort)/nGen;

    FAR=cumsum(~flag_sort(end:-1:1))/nImp;
    FAR=FAR(end-1:-1:1);
    FAR(end+1)=0;

    % ROC Curve (plot)

    plot(FAR,FRR,'DisplayName',color1);
    title ('ROC curve');
    xlabel('FAR');
    ylabel('FRR');
    hold on;

    %% EER + AUC

    AUC=abs(trapz(FAR,FRR));
    min_val=abs(FAR-FRR);
    EER_FAR=FAR(find(min_val==min(min_val)));
    EER_FRR=FRR(find(min_val==min(min_val)));

    EER=100*(EER_FAR+EER_FRR)/2;

end