% params eeg

%% time interpolation

params.tinterp            = [];
params.tinterp.methode    = 'linear';
params.tinterp.prewindow  = 0.002;
params.tinterp.postwindow = 0.002;

%% fft

params.fft         = [];
params.fft.method  = 'pmtm';
params.fft.events  = [1,1];
params.fft.toi     = {[-3,0],[0,3]}; % s
params.fft.freq    = 1:0.5:45; % Hz
params.fft.fcor    = false;
% params.fft.channels = 28;

%% wavelet analysis

params.wav         = [];
params.wav.wavelet     = 'cmor4-1';
params.wav.foi         = [1:10,12:2:24,28:4:44];
params.wav.dt          = 0.010;
params.wav.events      = [1,1];
params.wav.toi         = {[-3,0],[0,3]};

params.wav.zscore      = 0;
params.wav.FTstruct    = 1;