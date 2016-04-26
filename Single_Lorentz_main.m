% =========================================================================
% FMR Data Fitting main function 
% Author: Eason Chen, NYU
% Contact: yc1224@nyu.edu
% 
%%
% =========================================================================
% clean up existing data & close all open windows
clear;
close all;
%%
% ========================
% Move to Destination Folder & name the output file for fitting parameters
cd '/Users/yiyi/Desktop/FMR_dataanalysis/f-H/#15/15_P2N1';
outputname='fit_parameters.txt';
% inex of field(T), S12_real, S12_imag
indexH = 2;
indexS12real = 7;
indexS12imag = 8;

%%
%========================
%%% read files in the current folder
folder = pwd;
% read all data file ended with MHz*.dat in the current folder
files=dir('*MHz*.dat');
% sort out the files in natural order
[filenames, index] = sort_nat({files.name});

%%% open and creat the file for output
outputloc=[folder '/' outputname];
fidout=fopen(outputloc,'a+');% define the output file format as addiable
%%
% =========================================================================
% define the index of starting and ending data files
i_start=5;
% i_end = length(filenames);
i_end = 5;
% =========================================================================
% Load invidual data files for analysis
for i = i_start:i_end;

% =========================================================================
% Grab frequency(GHz) from file names (read out number between _ and MHz)
str_splitted = strsplit(char(filenames{i}),'_');
strend = str_splitted(end);% Take '?MHz.dat' from data files 'XXX_?MHz.dat'
final_str = strsplit(char(strend),'MHz'); % Get '?' by splitting '?MHz.dat'
frequency = str2double(char(final_str(1)))/1000;% convert MHz to GHz
% =========================================================================
% load data into variable data
fileloc = [folder '/' char(filenames(i))];
fprintf('%s\n',char(filenames(i)));
rawdata = importdata(fileloc);
data = rawdata(2:end-1,:);% get rid of the 1st data point.

% =========================================================================

x = data(:,indexH); % field in Tesla
% S12_real and S12_imag. size(y)= nx2
y = complex(data(:,indexS12real),data(:,indexS12imag)); 

[fitpara, fitconfint, S12_plot] = Single_Lorentz(x,y,frequency);

replyw='hahaha';
while ~strcmpi(replyw,'y') && ~strcmpi(replyw,'n')
          replyw = input('Want to fit next one?(y/n)', 's');
end
    if strcmpi(replyw,'y');
        
    Hres=abs(fitpara(4))*1e4;%%% Change to Oe 
    w=abs(fitpara(2))*1e4; % in Oe
    w_lb=min(abs(fitconfint(2,:)))*1e4; % in Oe
    w_ub=max(abs(fitconfint(2,:)))*1e4; % in Oe
    fig = gcf; % set fig as the current figure
    fig.PaperPositionMode = 'auto';% set image size as auto
    saveas(S12_plot,strtok(char(filenames{i}),'.'),'png');
    close(S12_plot);
    
% =========================================================================     
% Save the fitting result 
fprintf(fidout,'%10.0f %10.2f %10.3f %10.3f %10.3f\r\n',frequency,Hres,w,w_lb, w_ub);

    elseif strcmpi(replyw,'n');
        saveas(S12_plot,strtok(char(filenames{i}),'.'),'png')
        saveas(S12_plot,strtok(char(filenames{i}),'.'),'png')
        close(S12_plot);
    end
end
%%

% =========================================================================
% Print out ending information & close output file
fprintf('End of fitting\n')
fclose(fidout);


