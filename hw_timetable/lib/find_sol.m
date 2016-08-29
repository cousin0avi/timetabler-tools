function [soln] = find_sol(subs,hw_vec,ii_vec,period_vec,ic) %#codegen

flag_end = false;

subjects.n_hw = subs.n_hw;
subjects.n_avail = subs.n_avail;
subjects.flag_done = subs.flag_done;
subjects.n_less = subs.n_less;

idx_less = subs.idx_less;
flag_avail = subs.flag_avail;
flag_hw = subs.flag_hw;

subjects_orig = subjects;
idx_less_orig = idx_less;
flag_avail_orig = flag_avail;
flag_hw_orig = flag_hw;

while ~flag_end
    % initialise the problem
    n_day = 3*ones([10,1],'uint8');
    subjects = subjects_orig;
    rand_vec = hw_vec(randperm(numel(hw_vec)));
    
    idx_less = idx_less_orig;
    flag_avail = flag_avail_orig;
    flag_hw = flag_hw_orig;
    
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

idx = cumsum(subjects.n_less);
id_bin(1:idx(1)) = flag_hw{1}(1:subjects.n_less(1));

for ii=ii_vec
    if ii~=1
        id_bin(idx(ii-1)+1:idx(ii)) = flag_hw{ii}(1:subjects.n_less(ii));
    end
    [cell_hw{idx_less{ii}(flag_hw{ii})}] = deal(subs.id{ii});
end

soln.id = cast(bi2de(id_bin),'uint64');
soln.cell_hw = cell_hw;
end