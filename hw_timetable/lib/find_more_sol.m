function [soln] = find_more_sol(soln_old,subs,hw_vec,ii_vec,period_vec,ic,n,toc_time) %# codegen

subjects.n_hw = subs.n_hw;
subjects.n_avail = subs.n_avail;
subjects.flag_done = subs.flag_done;
subjects.n_less = subs.n_less;

idx_less = subs.idx_less;
flag_avail = subs.flag_avail;
flag_hw = subs.flag_hw;
id_text = subs.id;
flag_check = subs.flag_check;

%% Remove poor solutions
[n_old,~] = size(soln_old.id);
if n_old>500
    [idx_bad,thresh_touch_mean,thresh_day_var] = identify_worest(soln_old);
    soln_old = remove_soln(soln_old,idx_bad);
    [n_old,~] = size(soln_old.id);
else
    thresh_touch_mean = max(soln_old.touch_mean);
    thresh_day_var = max(soln_old.day_var);
end

%% Allocate more memmory
soln = struct('id',zeros(1,1,'uint64'),'cell_hw',{{cell(6,10)}},'day_hw',{{zeros(1,10)}},'touch_hw',{{zeros(numel(ii_vec),1)}});
soln.id(1:n,1) = zeros(1,1,'uint64');
[soln.cell_hw{1:n,1}] = deal(cell(6,10));
[soln.day_hw{1:n,1}] = deal(zeros(1,10));
[soln.touch_hw{1:n,1}] = deal(zeros(numel(ii_vec),1));
soln.day_var = zeros(n,1);
soln.touch_mean = zeros(n,1);

%% Assign existing solutions to new memory
soln.id(1:n_old) = soln_old.id;
soln.day_var(1:n_old) = soln_old.day_var;
soln.touch_mean(1:n_old) = soln_old.touch_mean;
for ii=1:n_old
    soln.cell_hw{ii}  = soln_old.cell_hw{ii};
    soln.day_hw{ii}   = soln_old.day_hw{ii};
    soln.touch_hw{ii} = soln_old.touch_hw{ii};
end

%% Find more solutions
ii = n_old + 1;

tic
while toc<toc_time
    
    [temp_id, temp_cell_hw,temp_day_hw,temp_touch_hw,temp_day_var,temp_touch_mean] = find_sol_fast_mex(subjects,idx_less,flag_avail,flag_hw,flag_check,id_text,hw_vec,ii_vec,period_vec,ic);
    
    if temp_touch_mean>=thresh_touch_mean || temp_day_var>=thresh_day_var
        continue
    end
    
    if ~any(ismember(soln.id(1:ii),temp_id))
        soln.id(ii) = temp_id;
        soln.cell_hw{ii} = temp_cell_hw;
        soln.day_hw{ii} = temp_day_hw;
        soln.touch_hw{ii} = temp_touch_hw;
        soln.day_var(ii) = temp_day_var;
        soln.touch_mean(ii) = temp_touch_mean;
        
        ii = ii + 1;
        
        if ii==(n+1)
            break
        end
    end
end

toc

%% Remove empty solutions
idx = find(soln.id~=0,1,'last');
if idx~=n
    idx = idx+1:n;
    soln = remove_soln(soln,idx);
end

%% Remove solutions that have poor metrics - May not need this
if idx>9.99e2
    idx_bad = identify_worest(soln);
    soln = remove_soln(soln,idx_bad);
end

end