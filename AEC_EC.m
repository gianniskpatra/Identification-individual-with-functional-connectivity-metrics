function [AEC] = AEC_EC(pre_data, channels)

    AEC_2 = zeros(109,channels);
    AEC_3 = zeros(6,109,channels);
    AEC   = zeros(5,6,109,channels);
                        
    for e=1:5             % for 5 epochs
        for f=1:6         % for 6 frequency bands
            for s=1:109	  % for 109 subjects
            
                AEC_1(1:channels,1:channels)=0;
                Signal = squeeze(pre_data(e,f,s,:,:));
                Signal = Signal.';
                hilb_Signal=hilbert(Signal);

                for i=1:channels
                    for j=1:channels
                        if i<j

                            AEC1=abs(corrcoef(abs(hilb_Signal(:,j)),abs(hilb_Signal(:,i))));        
                            AEC_mean=AEC1(1,2);        
                            AEC_1(i,j)=AEC_mean;       
                            AEC_1(j,i)=AEC_1(i,j);
                        
                        end
                    end
                end
            
                AEC_EC = eig(AEC_1(:,:));
                AEC_EC = AEC_EC.';
                AEC_2(s,:) = squeeze(AEC_EC);
            
            end
        clear AEC_1;
        clear AEC_EC;
        AEC_3(f,:,:) = AEC_2 (:,:);
            
        end 
    clear AEC_2;
    AEC(e,:,:,:) = AEC_3 (:,:,:) ;
    end

end

