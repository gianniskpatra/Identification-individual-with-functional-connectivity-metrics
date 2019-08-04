function [data_5chan] = chan5(data)

    data_5chan = zeros(109,5,9600);

    for s=1:109
    
        chan_val=squeeze(data(s,:,:));
    
        ind_logical = true(64,1);

        ind_logical([26,28,41,42,51])=false;
        data_5chan(s,:,:) = chan_val(~ind_logical,:);

    end

end

