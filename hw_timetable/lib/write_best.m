%% Find the best solutions
find_best_hw

%% Request user to specify a index
[~,set_codes_orig] = xlsread(in_sheet,name_form,'A12:J17');
while_switch = true;

while while_switch
    set_codes = set_codes_orig;
    x = input('Please select a value from idx to be the homework timetable. \n');
    
    idx = cellfun(@isempty,soln.cell_hw{x});
    
    for ii=1:60
        if idx(ii)
            set_codes{ii} = '';
        end
    end
    
    set_codes
    set_codes_orig
    
    str_switch = input('Is this solution acceptable? \n','s');
    while_switch = ~isempty(str_switch);
end

%% Output the solution to the spreadsheet
header = {'Mon A','Tue A','Wed A','Thur A','Fri A','Mon B','Tue B','Wed B','Thur B','Fri B'};
xlswrite(out_sheet,header,name_form,'A21:J21')
xlswrite(out_sheet,set_codes,name_form,'A22:J27')