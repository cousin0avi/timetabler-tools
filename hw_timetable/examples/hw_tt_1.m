% clear all; close all
%
% [~,timetable] = xlsread('student.xls','9CM','A2:J7');
% [~,~,hw_alloc] = xlsread('hw_alloc.xls','Y9','A1:B12');
%
% [hw_alloc(:,1),idx]=sort(hw_alloc(:,1));
% hw_alloc(:,2) = hw_alloc(idx,2);
% save('temp.mat')

%% Identify all subjects in timetable
clear all;
addpath('lib')
load('temp.mat')

[subs,~,ic] = unique(timetable);

ic=cast(ic,'uint8');

n_sub = size(subs);
n_sub = cast(n_sub(1),'uint8');
ii_vec= 1:n_sub;

%% Construct subjects struct
subjects = make_subjects(ic,subs,hw_alloc);

%% Create vector that will keep track of available periods
period_vec = true([60,1]);
for ii=ii_vec
    if subjects.flag_done(ii)
        period_vec(subjects.idx_less{ii}(1:subjects.n_less(ii)))=false;
    elseif any(~subjects.flag_avail{ii})
        period_vec(subjects.idx_less{ii}(~subjects.flag_avail{ii}(1:subjects.n_less(ii))))=false;
    end
end
%% Create vector which will randomise the subjects
temp = cell([n_sub 1]);
for ii=ii_vec
    temp{ii} = repmat(ii,[subjects.n_hw(ii) 1]);
end
hw_vec = vertcat(temp{:});
clear('temp','subs','hw_alloc')

%% Run the solver
soln = find_sol(subjects,hw_vec,ii_vec,period_vec,ic);
soln
