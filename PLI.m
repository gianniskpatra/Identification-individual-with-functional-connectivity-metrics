function [PLI] = PLI(pre_data, channels)

    PLI_2 = zeros(109,channels,channels);
    PLI_3 = zeros(6,109,channels,channels);
    PLI   = zeros(5,6,109,channels,channels);
                        
    for e=1:5             % for 5 epochs
        for f=1:6         % for 6 frequency bands
            for s=1:109	  % for 109 subjects
            
                PLI_1(1:channels,1:channels)=0;
                Signal = squeeze(pre_data(e,f,s,:,:));
                Signal = Signal.';
                phaseSignal=angle(hilbert(Signal));

                for i=1:channels
                    for j=1:channels
                        if i<j
                            PLI_1(i,j)=abs(mean(sign(sin(phaseSignal(:,i)-phaseSignal(:,j)))));
                            PLI_1(j,i)=PLI_1(i,j);     
                        end
                    end
                end
            
                PLI_2(s,:,:) = PLI_1(:,:);
            
            end
        clear PLI_1;
        PLI_3(f,:,:,:) = PLI_2 (:,:,:);
            
        end 
    clear PLI_2;
    PLI(e,:,:,:,:) = PLI_3 (:,:,:,:) ;
    end
    
end

