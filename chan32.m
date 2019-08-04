function [data_32chan] = chan32(data)

    data_32chan = zeros(109,32,9600);

    for s=1:109
    
        chan_val=squeeze(data(s,:,:));
    
        ind_logical = true(64,1);

        ind_logical
        ([1,3,4,5,7,9,11,13,15,17,19,21,22,24,27,30,32,...
        34,36,38,41,42,43,44,47,49,51,53,55,61,62,63])=false;
        data_32chan(s,:,:) = chan_val(~ind_logical,:);

    end

end

