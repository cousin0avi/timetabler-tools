clear all; close all
addpath('lib')

name_year = 'Y8';
in_sheet  = '2017/8g.xls';
out_sheet = '2017/8g.xls';
hw_alloc_xls = '2017/hw_alloc.xls';
hw_alloc_range = 'A1:B11';

nf1 = '8e';
nf2 = '8F';
nf3 = '8G';
nf4 = '8H';

t_small = 5;
t_big = 90;

vec_share = [8,9,10];
%% Create subjects structures
form_1 = make_subjects_struct(in_sheet,nf1,hw_alloc_xls,name_year,hw_alloc_range);
form_2 = make_subjects_struct(in_sheet,nf2,hw_alloc_xls,name_year,hw_alloc_range);
form_3 = make_subjects_struct(in_sheet,nf3,hw_alloc_xls,name_year,hw_alloc_range);
form_4 = make_subjects_struct(in_sheet,nf4,hw_alloc_xls,name_year,hw_alloc_range);

%% Run solver
soln_1 = find_many_sol(form_1.subjects,form_1.hw_vec,form_1.ii_vec,form_1.period_vec,form_1.ic,4e4,t_small);
soln_2 = find_many_sol(form_2.subjects,form_2.hw_vec,form_2.ii_vec,form_2.period_vec,form_2.ic,4e4,t_small);
soln_3 = find_many_sol(form_3.subjects,form_3.hw_vec,form_3.ii_vec,form_3.period_vec,form_3.ic,4e4,t_small);
soln_4 = find_many_sol(form_4.subjects,form_4.hw_vec,form_4.ii_vec,form_4.period_vec,form_4.ic,4e4,t_small);

%% Find MAT occurences
count_mat_1 = find_sub_occurr(soln_1,form_1,8)
count_mat_2 = find_sub_occurr(soln_2,form_2,8)
count_mat_3 = find_sub_occurr(soln_3,form_3,8)
count_mat_4 = find_sub_occurr(soln_4,form_4,8)

%% Find MFL1 occurences
count_mfl1_1 = find_sub_occurr(soln_1,form_1,9)
count_mfl1_2 = find_sub_occurr(soln_2,form_2,9)
count_mfl1_3 = find_sub_occurr(soln_3,form_3,9)
count_mfl1_4 = find_sub_occurr(soln_4,form_4,9)

%% Find MFL2 occurences
count_mfl2_1 = find_sub_occurr(soln_1,form_1,10)
count_mfl2_2 = find_sub_occurr(soln_2,form_2,10)
count_mfl2_3 = find_sub_occurr(soln_3,form_3,10)
count_mfl2_4 = find_sub_occurr(soln_4,form_4,10)

%% Choose constraints
n_mat = sum(form_1.hw_vec==8);
force_mat = zeros(1,n_mat);
for ii=1:n_mat
    force_mat(ii) = input('Force a MAT hw to period: ');
end

n_ml1 = sum(form_1.hw_vec==9);
force_ml1 = zeros(1,n_ml1);
for ii=1:n_ml1
    force_ml1(ii) = input('Force a MFL1 hw to period: ');
end

n_ml2 = sum(form_1.hw_vec==10);
force_ml2 = zeros(1,n_ml2);
for ii=1:n_ml2
    force_ml2(ii) = input('Force a MFL2 hw to period: ');
end

%% Push constraints onto system
force_hw_vec = [force_mat force_ml1 force_ml2];

[form_1.subjects,form_1.period_vec ] = force_hw(form_1.subjects,form_1.period_vec,form_1.ic,force_hw_vec);
[form_2.subjects,form_2.period_vec ] = force_hw(form_2.subjects,form_2.period_vec,form_2.ic,force_hw_vec);
[form_3.subjects,form_3.period_vec ] = force_hw(form_3.subjects,form_3.period_vec,form_3.ic,force_hw_vec);
[form_4.subjects,form_4.period_vec ] = force_hw(form_4.subjects,form_4.period_vec,form_4.ic,force_hw_vec);

%% Run solver
soln_1 = find_many_sol(form_1.subjects,form_1.hw_vec,form_1.ii_vec,form_1.period_vec,form_1.ic,4e4,t_big);
soln_2 = find_many_sol(form_2.subjects,form_2.hw_vec,form_2.ii_vec,form_2.period_vec,form_2.ic,4e4,t_big);
soln_3 = find_many_sol(form_3.subjects,form_3.hw_vec,form_3.ii_vec,form_3.period_vec,form_3.ic,4e4,t_big);
soln_4 = find_many_sol(form_4.subjects,form_4.hw_vec,form_4.ii_vec,form_4.period_vec,form_4.ic,4e4,t_big);

%% Find the best and write solution
soln = soln_1;
ii_vec = form_1.ii_vec;
name_form = nf1;
write_best

soln = soln_2;
ii_vec = form_2.ii_vec;
name_form = nf2;
write_best

soln = soln_3;
ii_vec = form_3.ii_vec;
name_form = nf3;
write_best

soln = soln_4;
ii_vec = form_4.ii_vec;
name_form = nf4;
write_best