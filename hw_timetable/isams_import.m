clear all;close all
%% Params
name_form = '9G';
in_sheet = '2017/Y9G/9g.xls';
out_sheet = '2017/9g.xls';
look_up_script = 'look_up/y9_lt.m';

%% Read in iSAMS output
[~,sw1] = xlsread(in_sheet,'SW1','B4:F9');
[~,sw2] = xlsread(in_sheet,'SW2','B4:F9');

%% Put set codes into timetable
nl = char(10); %new line character

% Identify postions of newline characters
k1 = strfind(sw1,nl);
k2 = strfind(sw2,nl);

%Extract set codes
for ii=1:30
   idx = k1{ii}(1)+1:k1{ii}(2)-1;
   sw1{ii} = sw1{ii}(idx);
   
   idx = k2{ii}(1)+1:k2{ii}(2)-1;
   sw2{ii} = sw2{ii}(idx);
end

set_codes = [sw1,sw2];
clear sw1 sw2 nl k1 k2 idx
%% Map set codes onto 3 letter codes
input = set_codes;
run(look_up_script);
[n_rows,~] = size(y7_look);

for ii=1:n_rows
   idx = strfind(set_codes,y7_look{ii,1});
   idx = ~cellfun(@isempty,idx);
   [input{idx}] = deal(y7_look{ii,2});
end

%% Write out to file
warning('off','MATLAB:xlswrite:AddSheet')

header = {'Mon A','Tue A','Wed A','Thur A','Fri A','Mon B','Tue B','Wed B','Thur B','Fri B'};
xlswrite(out_sheet,header,name_form,'A1:J1')
xlswrite(out_sheet,input,name_form,'A2:J7')

xlswrite(out_sheet,header,name_form,'A11:J11')
xlswrite(out_sheet,set_codes,name_form,'A12:J17')
