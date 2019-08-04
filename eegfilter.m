function [pre_data] = eegfilter(data, channels)

    SR = 160; % Sample Rate
    xfilter = zeros(6,109,channels,9600);
    pre_data = zeros(5,6,109,channels,1920);

    for s=1:109
    
        person=squeeze(data(s,1:channels,:));
    
        % bandpass filter 1-4Hz
        xfilter(1,s,:,:) = eegfilt(person(1:channels,:),SR,1,4,0,[],0);

        % bandpass filter 4-8Hz                   
        xfilter(2,s,:,:) = eegfilt(person(1:channels,:),SR,4,8,0,[],0);
    
        % bandpass filter 8-13Hz
        xfilter(3,s,:,:) = eegfilt(person(1:channels,:),SR,8,13,0,[],0);
    
        % bandpass filter 13-20Hz
        xfilter(4,s,:,:) = eegfilt(person(1:channels,:),SR,13,20,0,[],0);
    
        % bandpass filter 20-30Hz
        xfilter(5,s,:,:) = eegfilt(person(1:channels,:),SR,20,30,0,[],0);
    
        % bandpass filter 30-45Hz
        xfilter(6,s,:,:) = eegfilt(person(1:channels,:),SR,30,45,0,[],0);

    end

    % xfilter(f,s,c,v) f=frequency band,s=subject ,c=channel, v=value of data

    % 5 epochs 
    b=1;
    for e=1:5
        pre_data(e,:,:,:,:) = xfilter(:,:,:,b:1920*e);
        b=e*1920+1;
    end
    
end
