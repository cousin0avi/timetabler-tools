function [flag_id,flag_end,idx_on] = still_solve(subjects,ii_vec,n_day)%# codegen

flag_id = false;
flag_end = false;

idx_on = ii_vec(~subjects.flag_done);

% Make sure problem can still be solved
if ~all(subjects.n_avail(idx_on)>=subjects.n_hw(idx_on))
    flag_id = true;
end

% Has the problem been solved
if isempty(idx_on)
    flag_id = true;
    if ~any(any(n_day==3)||(sum(n_day==2)==3)) %Was the solution rubbish
        flag_end = true;
    end
end