function [id,cell_hw,day_hw,touch_hw,day_var,touch_mean] = find_sol_fast(subjects,idx_less,flag_avail,flag_hw,flag_check,id_text,hw_vec,ii_vec,period_vec,ic) %#codegen

flag_end = false;
n_day = 3*ones([10,1],'uint8');
 
subjects_orig = subjects;
idx_less_orig = idx_less;
flag_avail_orig = flag_avail;
flag_hw_orig = flag_hw;
period_vec_orig = period_vec;

while ~flag_end
    % initialise the problem
    n_day = 3*ones([10,1],'uint8');
    subjects = subjects_orig;
    rand_vec = hw_vec(randperm(numel(hw_vec)));
    
    idx_less = idx_less_orig;
    flag_avail = flag_avail_orig;
    flag_hw = flag_hw_orig;
    period_vec = period_vec_orig;
    
    [~,~,idx_on] = still_solve(subjects,ii_vec,n_day);
    
    % Start assigning HW
    for jj=1:numel(rand_vec);
        if subjects.flag_done(rand_vec(jj)) %Check if subject needs to be allocated
            continue
        end
        
        while any( subjects.n_avail(idx_on)==subjects.n_hw(idx_on) )
            idx = ii_vec(subjects.n_avail==subjects.n_hw);
            idx = idx(randperm(numel(idx), 1));
            
            [subjects,idx_less,flag_avail,flag_hw,n_day,period_vec] = assign_hw(idx,subjects,idx_less,flag_avail,flag_hw,n_day,period_vec,ic);
            
            [flag_id,flag_end,idx_on] = still_solve(subjects,ii_vec,n_day);
            if flag_id
                break
            end
        end
        
        if subjects.flag_done(rand_vec(jj)) %Check if subject needs to be allocated
            continue
        end
        
        % Assign next subject
        idx = rand_vec(jj);
        [subjects,idx_less,flag_avail,flag_hw,n_day,period_vec] = assign_hw(idx,subjects,idx_less,flag_avail,flag_hw,n_day,period_vec,ic);
        
        [flag_id,flag_end,idx_on] = still_solve(subjects,ii_vec,n_day);
        if flag_id
            break
        end
    end
end

%% Construct solution output
id_bin = false(1,60);
cell_hw = cell(6,10);
day_hw = zeros(1,10);
touch_hw = zeros(numel(ii_vec),1);

for ii=1:6 %cell definition for codegen
    for jj=1:10
        cell_hw{ii,jj}='';
    end
end

idx = cumsum(subjects.n_less);
id_bin(1:idx(1)) = flag_hw{1}(1:subjects.n_less(1));

for ii=1:numel(ii_vec)
    idx2=1:subjects.n_less(ii);
    if ii~=1
        id_bin(idx(ii-1)+1:idx(ii)) = flag_hw{ii}(idx2);
    end
    
    %Create human readable HW TT
    for jj=1:numel(idx2)
        if(flag_hw{ii}(jj))
            cell_hw{idx_less{ii}(jj)} = id_text{ii};
        end
    end
    
    % find touching HW
    b = flag_hw{ii}(flag_check{ii});
    if b(1) && b(end)
        c = 0;
    else
        c = 1;
    end
    
    d = [c;diff(b)];
    touch_hw(ii) = sum(b(d==0));
end

id = cast(bi2de(id_bin),'uint64');

day_hw = cast(3-n_day.','double');
day_var = var(day_hw);
touch_mean = mean(touch_hw);

end