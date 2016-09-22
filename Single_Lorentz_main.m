%% ========================================================================
% FMR Data Fitting main function 
% Author: Yizhang Chen, NYU
% Contact: yc1224@nyu.edu
% Fit FMR data with Single Lorentzian Model
% Thanks to Yuming Hung with the original version for the fitting

%% ========================================================================
% clean up existing data & close all open windows
clear;
close all;

%% ========================================================================
% Give destination folder, outputfile
cd '/Users/yiyi/Desktop/FMR_2TMagnet re-analysize/W6PN21_P18N1';
degree = 0;
angle = degree*3.14159265/180;
outputname='W6PN21-P18N1.txt';
% Give indices of field(T), S12_real, S12_imag
indexH = 2;
indexS12real = 7;
indexS12imag = 8;

%% ========================================================================

%%% read files in the current folder
folder = pwd;
% read all data file ended with *MHz.dat in the current folder
files=dir('*MHz.dat');
% sort out the files in natural order
[filenames, index] = sort_nat({files.name});
% open and creat the file for output
outputloc=[folder '/' outputname];
% Open or create new file for writing. Append data to the end of the file.
fidout=fopen(outputloc,'a+');


%% ========================================================================
% starting and ending indices of data files
i=3;
i_end = numel(filenames);
while i<=i_end;
%% ========================================================================

% Get frequency(GHz) from file names (read out number between _ and MHz)
str_splitted = strsplit(char(filenames{i}),'degree_');
strend = str_splitted(end);% Take '*MHz.dat' from data files 'XXX_*MHz.dat'
final_str = strsplit(char(strend),'MHz'); % Get '*' by splitting '*MHz.dat'
frequency = str2double(char(final_str(1)))/1000;% convert MHz to GHz

%% ========================================================================
% load data
fileloc = [folder '/' char(filenames(i))];
fprintf('%s\n',char(filenames(i)));
rawdata = importdata(fileloc);
data = rawdata(2:end-1,:);% get rid of the 1st data point.

%% ========================================================================
% field in Oe
x = data(:,indexH); %in Oe
x = x*cos(angle); % adjust effective field in plane of the sample
% Construct complex data y with S12_real and S12_imag
y = complex(data(:,indexS12real),data(:,indexS12imag)); 

% Call Fitting function to fit x-y with specific frequency
[fitpara, fitconfint, fig] = Single_Lorentz(x,y,frequency);

%% ========================================================================     
% Ask user to move on or re-fit current data.
replyw = input('Want to fit next one?(y/n)', 's');

% if input character is 'y', save fitting parameters & figure
if strcmpi(replyw,'y')    
% Save Hres, linewidth, lower and upper bounds of linewidth 
    scalefactor = 10000;
    Hres=abs(fitpara(4)*scalefactor);%%% Change to Oe 
    w=abs(fitpara(2))*scalefactor; % in Oe
    w_lb=min(abs(fitconfint(2,:)))*scalefactor; % in Oe
    w_ub=max(abs(fitconfint(2,:)))*scalefactor; % in Oe
    fprintf(fidout,'%10.0f %10.2f %10.3f %10.3f %10.3f\r\n',frequency,Hres,w,w_lb, w_ub);

% Save figure
    fig.PaperPositionMode = 'auto';% set image size as auto
    saveas(fig,strtok(char(filenames{i}),'.'),'png');
    
% Move on to the next data file
    i = i+1; 
    
end
%% =========================================================================

close(fig);

end

%% ========================================================================

% Print out ending information & close output file
fprintf('End of fitting\n')
fclose(fidout);


