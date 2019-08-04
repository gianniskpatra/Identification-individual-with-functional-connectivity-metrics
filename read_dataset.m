function [dataset] = read_dataset()

    dataset = zeros(109,64,9600);
    
    for i=1:109
        
        % Reading dataset
         if i < 10
             file_name = "dataset_EC/S00" + int2str(i) + "R02_edfm.mat";
         elseif i < 100
             file_name = "dataset_EC/S0" + int2str(i) + "R02_edfm.mat";
         else
             file_name = "dataset_EC/S" + int2str(i) + "R02_edfm.mat";
         end  
         
         % Read subject EEG data
         eeg_subject = load(file_name);
       
         % Load dataset to the file 
         dataset(i,:,:) = eeg_subject.val(1:64,1:9600);
         
    end
    
end