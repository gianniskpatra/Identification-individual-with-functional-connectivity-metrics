﻿%% clear

clear all
clc
close all

%% Load all data 

% data(s,c,v) s=subject, c=channel, v=value of data in V 
% (109 subjects - 1 condition eyes-closed)

data = read_dataset;

%% Choose number of channels (64,32,14,5)

choose_channels = input('Choose number of channels:\n 64, 32, 14, 5 \n');

switch choose_channels
    case '64'
        channels=64;
        name="C64_";
    case '32'
        channels=32;
        name="C32_";
    case '14'
        channels=14;
        name="C14_";
    case '5'
        channels=5;
        name="C5_";
end

if (channels==64)
    ch_data = data;
    
elseif (channels==32)
    ch_data = chan32(data);
    
elseif (channels==14)
    ch_data = chan14(data);
    
elseif (channels==5)
    ch_data = chan5(data);
    
end

clear data;

%% Choose Filter and filtorder

choose_filter = input('Choose filter:\n butter, eegfilt\n');

switch choose_filter
    
    case 'butter'
        
        filt=1;
        name = name + "butter_";
        choose_filter2 = input('Choose filtorder:\n low, medium, high, ultra \n');
        
        switch choose_filter2
            
            case 'low'
                filtorder = 3;
                name = name + "L_";

            case 'medium'
                filtorder = 4;
                name = name + "M_";
                
            case 'high'
                filtorder = 5;
                name = name + "H_";
                
            case 'ultra'
                filtorder = 6;
                name = name + "U_";
                
        end               
                
        pre_data = butterfilter(ch_data, filtorder, channels);
        
    case 'eegfilt'
        filt=2;
        pre_data = eegfilter(ch_data, channels);
        name = name + "eegfilt_";
end

% clear data
vars = {'ch_data','filtorder'};
clear(vars{:});
clear vars;

%% Choose Metric

choose_metric = input('Choose metric:\n Phase Lag Index(PLI), Phase Locking Value(PLV), Ampitude Envelope Correlation(AEC)\n');

switch choose_metric
    case 'PLI'
        choose=1;
        name = name + "PLI_";
    case 'PLV'
        choose=2;
        name = name + "PLV_";
    case 'AEC'
        choose=3;
        name = name + "AEC_";
end


%% Choose Eigenvector Centrality (EC) or not

choose_EC = input('With or without Eigenvector Centrality(EC)?\n');

switch choose_EC
    case 'without'
        chooseEC=1;
        name = name + "notEC";
    case 'with'
        chooseEC=2;
        name = name + "EC";
end


%% Metrics

if (chooseEC==1)
    
    if (choose==1)     % Phase Lag Index (PLI)
    
        Metric = PLI(pre_data, channels);
        
    elseif (choose==2) % Phase Locking Value (PLV)
        
        Metric = PLV(pre_data, channels);
       
    elseif (choose==3) % Amplitude Envelope Correlation (AEC)
        
        Metric = AEC(pre_data, channels);
    end
    
    
 %% Upper triangular part of each feature vector
    
    values = channels*(channels-1)/2;
    vector = zeros(5,6,109,values);
    
    for e=1:5             % for each epoch
        for f=1:6         % for each band
            for s=1:109	  % for each subject
                   
                A = squeeze(Metric(e,f,s,:,:));

                % Mask of upper triangular elements
                mask = triu(true(size(A)),1);

                % Use mask to select upper triangular elements from input array
                vector(e,f,s,:) = A(mask);

            end
        end
    end

    % clear data
    vars = {'a','k','s','c1','c2','f','e','A','mask','Metric'};
    clear(vars{:});
    clear vars;

    
elseif (chooseEC==2)
    
    if (choose==1)     % Phase Lag Index (PLI)
    
        vector = PLI_EC(pre_data, channels);
        
    elseif (choose==2) % Phase Locking Value (PLV)
        
        vector = PLV_EC(pre_data, channels);
       
    elseif (choose==3) % Amplitude Envelope Correlation (AEC)
        
        vector = AEC_EC(pre_data, channels);
    end
    
end

% clear data
vars = {'clannels','values','pre_data','choose','choose_EC'};
clear(vars{:});
clear vars;

%% Frequency Bands

% Each band frequency is ( 5x109x(channels*(channels-1)/2) ) feature vector. 

Delta = squeeze(vector(:,1,:,:)); 
Theta = squeeze(vector(:,2,:,:));
Alpha = squeeze(vector(:,3,:,:));
Low_Beta = squeeze(vector(:,4,:,:));
High_Beta = squeeze(vector(:,5,:,:));
Gamma = squeeze(vector(:,6,:,:));

clear vector;

%% Plot all ROC curves for all Frequency Bands

color1 = 'Delta';
EER_D = Roc(Delta,color1);

color1 = 'Theta';
EER_T = Roc(Theta,color1);

color1 = 'Alpha';
EER_A = Roc(Alpha,color1);

color1 = 'Low Beta';
EER_LB = Roc(Low_Beta,color1);

color1 = 'High Beta';
EER_HB = Roc(High_Beta,color1);

color1 = 'Gamma';
EER_G = Roc(Gamma,color1);

hold off
lgd = legend;

EER = [EER_D;EER_T;EER_A;EER_LB;EER_HB;EER_G];

% clear data
vars = {'Delta','Theta','Alpha','Low_Beta','High_Beta','Gamma','lgd','color1','EER_D','EER_T','EER_A','EER_LB','EER_HB','EER_G'};
clear(vars{:});
clear vars;

name_fig = name + ".png";
name_fig = convertStringsToChars(name_fig);
saveas(gcf,name_fig); % here you save the figure

%% Message

a = '\n You have chosen ';
b = ' channels with ';
c = ' filter ';

if (filt == 1)
    d = 'and with ';
    e = ' filtorder. The metric used was ';
elseif (filt == 2)
    choose_filter2 = '';
    d = '';
    e = '. The metric used was ';
end

if chooseEC == 1
    f = ' without Eigenvector Centrality (EC).';
else
    f = ' with Eigenvector Centrality (EC).';
end

specific_parameters = [a choose_channels b choose_filter c d choose_filter2 e choose_metric f]

% clear data
vars = {'a','b','c','d','e','f','choose_channels','choose_filter','choose_filter2','choose_metric','filt','chooseEC','channels'};
clear(vars{:});
clear vars;


%% Save Results in .txt

name = name + ".txt";
name = convertStringsToChars(name);

Bands = {'Delta';'Theta';'Alpha';'Low Beta';'High Beta';'Gamma'};
T = table(EER,...
    'RowNames',Bands)

writetable(T,name);


%% Write Specific Parameters for this experiment

fid = fopen(name, 'a');
fprintf(fid, specific_parameters);
fclose(fid);

% clear data
vars = {'Bands','fid','ans','name','name_fig','T','specific_parameters'};
clear(vars{:});
clear vars;
