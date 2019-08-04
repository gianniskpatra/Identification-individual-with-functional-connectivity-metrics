function [data_14chan] = chan14(data)

    data_14chan = zeros(109,14,9600);

    for s=1:109
    
        chan_val=squeeze(data(s,:,:));
    
        ind_logical = true(64,1);

        ind_logical([1,7,26,28,30,32,36,38,41,42,47,55,61,63])=false;
        data_14chan(s,:,:) = chan_val(~ind_logical,:);

    end

end

