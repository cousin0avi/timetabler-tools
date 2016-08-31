function [ subjects,period_vec ] = force_hw(subjects,period_vec,ic,force_sub )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

n_alloc = numel(force_sub); 

for ii=1:n_alloc
    period = force_sub(ii);
    idx = ic(period);
    
    subjects.flag_avail{idx}(subjects.idx_less{idx}==period) = false;
    subjects.flag_hw{idx}(subjects.idx_less{idx}==period) = true;
    period_vec(period) = false;

    subjects.n_hw(idx) = subjects.n_hw(idx) - 1;
    subjects.n_avail(idx) = subjects.n_avail(idx) - 1;

    if subjects.n_hw(idx)==0
        subjects.flag_done(idx)=true;
    end

end

