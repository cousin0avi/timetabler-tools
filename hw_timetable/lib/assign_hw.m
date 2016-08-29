function [subjects,idx_less,flag_avail,flag_hw,n_day,period_vec] = assign_hw(idx,subjects,idx_less,flag_avail,flag_hw,n_day,period_vec,ic) %#codegen

if ~all(subjects.n_hw(idx)<=subjects.n_avail(idx))
    return
end

if all(~flag_avail{idx})
    return
end


temp = idx_less{idx}(flag_avail{idx}==true);
period = temp(randperm(numel(temp), 1));

if ~period_vec(period)
    error('Trying to allocate to a period which has been deselected')
end

flag_avail{idx}(idx_less{idx}==period)=false;
flag_hw{idx}(idx_less{idx}==period)=true;
period_vec(period)=false;

subjects.n_hw(idx) = subjects.n_hw(idx) - 1;
subjects.n_avail(idx) = subjects.n_avail(idx) - 1;

if subjects.n_hw(idx)==0
    subjects.flag_done(idx)=true;
end

% Track HW per day
a = ceil(cast(period,'double')/6);
n_day(a) = n_day(a) - 1;


% If day becomes full then remove accessibility from other subjects
if n_day(a) == 0
    day_vec = (a-1)*6+1:(a-1)*6+6;
    day_vec = day_vec(period_vec(day_vec));
    period_vec(day_vec) = false;
    
    for kk=1:numel(day_vec)
        idx2 = ic(day_vec(kk));
        flag_avail{idx2}(idx_less{idx2}==day_vec(kk)) = false;
        subjects.n_avail(idx2) = subjects.n_avail(idx2) - 1;
    end
end
end