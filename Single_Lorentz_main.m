% =========================================================================
% FMR Data Fitting main function 
% 
% 
% 
% =========================================================================
% clean up existing data & close all open windows
clear;
close all;
% ========================
% Move to Destination Folder & name the output file for fitting parameters
cd '/Users/yiyi/Desktop/FMR_dataanalysis/f-H/#15/15_P2N1';
outputname='fit_parameters.txt';

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

% =========================================================================
% define the index of starting and ending data files
i=i_start;
i_end = length(filenames);

for i = i_start:i_end;

str_splitted = strsplit(char(filenames{i}),'_');
strend = str_splitted(end);
final_str = strsplit(char(strend),'MHz');
frequency = str2double(char(final_str(1)))/1000;
fileloc=[folder '/' char(filenames(i))];
fprintf('%s\n',char(filenames(i)));
data=importdata(fileloc);
data=data(2:end-1,:);% get rid of the 1st data point.


x = data(:,2); % field in Tesla
y = complex(data(:,7),data(:,8)); % S12_real and S12_imag

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


% =========================================================================
% Print out ending information & close output file
fprintf('End of fitting\n')
fclose(fidout);


