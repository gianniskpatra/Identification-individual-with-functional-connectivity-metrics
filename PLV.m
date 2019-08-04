function [PLV] = PLV(pre_data, channels)

    PLV_2 = zeros(109,channels,channels);
    PLV_3 = zeros(6,109,channels,channels);
    PLV   = zeros(5,6,109,channels,channels);
                            
    for e=1:5             % for 5 epochs
        for f=1:6         % for 6 frequency bands
            for s=1:109	  % for 109 subjects
                
                PLV_1(1:channels,1:channels)=0;
                Signal = squeeze(pre_data(e,f,s,:,:));
                Signal = Signal.';
                phaseSignal=angle(hilbert(Signal));

                for i=1:channels
                    for j=1:channels
                        if i<j

                            PLV_1(i,j)=abs(mean(exp(1i*(phaseSignal(:,i))-(phaseSignal(:,j))),1));
                            PLV_1(j,i)=PLV_1(i,j);
                            
                        end
                    end
                end
                
                PLV_2(s,:,:) = PLV_1(:,:);
                
            end
        clear PLV_1;
        PLV_3(f,:,:,:) = PLV_2 (:,:,:);
                
        end 
    clear PLV_2;
    PLV(e,:,:,:,:) = PLV_3 (:,:,:,:) ;
    end

end

