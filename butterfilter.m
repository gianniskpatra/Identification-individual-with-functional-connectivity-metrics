function [pre_data] = butterfilter(data, filtorder, channels)


    SR = 160; % Sample Rate
    xfilter = zeros(6,109,channels,9600);
    pre_data = zeros(5,6,109,channels,1920);

    for s=1:109
        
        % bandpass filter 1-4Hz
        [a,b] = butter (filtorder, [1*2/SR 4*2/SR],  'bandpass'); 
        % bandpass filter 4-8Hz
        [c,d] = butter (filtorder, [4*2/SR 8*2/SR],  'bandpass');
        % bandpass filter 8-13Hz
        [e,f] = butter (filtorder, [8*2/SR 13*2/SR], 'bandpass'); 
        % bandpass filter 13-20Hz
        [g,h] = butter (filtorder, [13*2/SR 20*2/SR], 'bandpass'); 
        % bandpass filter 20-30Hz
        [i,j] = butter (filtorder, [20*2/SR 30*2/SR], 'bandpass'); 
        % bandpass filter 30-45Hz
        [k,l] = butter (filtorder, [30*2/SR 45*2/SR], 'bandpass'); 

        for ch=1:channels

            xfilter(1,s,ch,:) = filtfilt(a,b,data(s,ch,:)); 

            xfilter(2,s,ch,:) = filtfilt(c,d,data(s,ch,:));

            xfilter(3,s,ch,:) = filtfilt(e,f,data(s,ch,:));

            xfilter(4,s,ch,:) = filtfilt(g,h,data(s,ch,:));

            xfilter(5,s,ch,:) = filtfilt(i,j,data(s,ch,:));

            xfilter(6,s,ch,:) = filtfilt(k,l,data(s,ch,:));
            
        end       
    end

    % xfilter(f,s,c,v) f=frequency band,s=subject ,c=channel, v=value of data

    % 5 epochs 
    b=1;
    for e=1:5
        pre_data(e,:,:,:,:) = xfilter(:,:,:,b:1920*e);
        b=e*1920+1;
    end

end
