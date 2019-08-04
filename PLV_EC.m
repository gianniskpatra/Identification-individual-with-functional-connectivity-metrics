function [PLV] = PLV_EC(pre_data, channels)

    PLV_2 = zeros(109,channels);
    PLV_3 = zeros(6,109,channels);
    PLV   = zeros(5,6,109,channels);
                            
    for e=1:5             % for 5 epochs
        for f=1:6         % for 6 frequency bands
            for s=1:109	  % for 109 subjects
                
                PLV_1 = zeros(channels,channels);
                Signal = squeeze(pre_data(e,f,s,:,:));
                Signal = Signal.';
                phaseSignal=angle(hilbert(Signal));

                for i=1:channels
                    for j=1:channels
                        if i<j

                            PLV_1(i,j)=abs(mean(exp(1i*(unwrap(phaseSignal(:,i))-unwrap(phaseSignal(:,j)))),1));
                            PLV_1(j,i)=PLV_1(i,j);
                            
                        end
                    end
                end
                
                PLV_EC = eig(PLV_1(:,:));
                PLV_EC = PLV_EC.';
                PLV_2(s,:) = squeeze(PLV_EC);
                
            end
        clear PLV_1;
        clear PLV_EC;
        PLV_3(f,:,:) = PLV_2 (:,:);

        end 
        
    clear PLV_2;
    PLV(e,:,:,:) = PLV_3 (:,:,:) ;
    end

end

