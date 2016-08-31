clear all; close all
addpath('lib')

name_year = 'Y7';
name_form = '7H';
in_sheet  = '2017/7g.xls';
out_sheet = '2017/7g.xls';
hw_alloc_xls = '2017/hw_alloc.xls';
hw_alloc_range = 'A1:B10';

%% Identify all subjects in timetable
[~,timetable] = xlsread(in_sheet,name_form,'A2:J7');
[~,~,hw_alloc] = xlsread(hw_alloc_xls,name_year,hw_alloc_range);

[hw_alloc(:,1),idx]=sort(hw_alloc(:,1));
hw_alloc(:,2) = hw_alloc(idx,2);

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
%% Add any a priori information here

%% Create vector which will randomise the subjects
temp = cell([n_sub 1]);
for ii=ii_vec
    temp{ii} = repmat(ii,[subjects.n_hw(ii) 1]);
end
hw_vec = vertcat(temp{:});
%% Remove variables
clear('temp','subs','hw_alloc')

%% Run solver
soln = find_many_sol(subjects,hw_vec,ii_vec,period_vec,ic,4e4,300);

%% Find the best and write solution
write_best