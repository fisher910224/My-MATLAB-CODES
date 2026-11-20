%% 20260803~0820 Stastics
% 20260827 editted
clear; close all; clc;

% For detailed annotations, please see ...Current.m
% if there's no annotations, connect Ting-Yu Dai (fisher910224@gmail.com)

%% path
aim_folder = 'C:\Users\adm\Desktop\INTERTIDAL\代婷與的PDF們\NMMBA\20260803_0820';
func = 'C:\Users\adm\Desktop\INTERTIDAL\代婷與的PDF們\NMMBA\Functions';
wind = [aim_folder, '\wind'];
f_data = [aim_folder, '\finished_data'];
pic_w = [aim_folder, '\pictures\wave'];
pic_c = [aim_folder, '\pictures\current'];
pic_t = [aim_folder, '\pictures\tide'];

if ~isfolder(f_data)
    mkdir(f_data)
end
if ~isfolder(pic_w)
    mkdir(pic_w)
end
if ~isfolder(pic_c)
    mkdir(pic_c)
end
if ~isfolder(pic_t)
    mkdir(pic_t)
end

%% load data
cd(aim_folder)
load("DATA_CUR.mat");
WIND = load("DATA_WIND.mat");
W = load("DATA_W.mat");
dates = ['_', aim_folder(end-12:end-5)];

% ============== N station =================
waveday_N = N.(['waveday', dates]);
wavedaylength_N = N.(['wavedaylength', dates]);
dday_N = N.(['dday', dates]);
plotdate_all = N.(['plotdate_all', dates]);
filedate = N.(['filedate', dates]);
datelabel = N.(['datelabel', dates]);
daym_N = waveday_N;
Cur_N = N.(['Cur', dates]);
Dir_N = N.(['Dir', dates]);
u_N = N.(['u', dates]);
v_N = N.(['v', dates]);
tur_N = N.(['tur', dates]);
Pre_N = N.(['Pre', dates]);

% ============== S station =================
waveday_S = S.(['waveday', dates]);
wavedaylength_S = S.(['wavedaylength', dates]);
dday_S = S.(['dday', dates]);
daym_S = waveday_S;
Cur_S = S.(['Cur', dates]);
Dir_S = S.(['Dir', dates]);
u_S = S.(['u', dates]);
v_S = S.(['v', dates]);
tur_S = S.(['tur', dates]);
Pre_S = S.(['Pre', dates]);

cd(func)
% useful = find(wave_20250424(:,3)>0);
[Tp_N, T_N, Hs_N] = huang_waveheightTp(W.(['wave', dates]), 1, 1200);
Hs_N = Hs_N(~isnan(Hs_N));
T_N = T_N(~isnan(T_N));
Tp_N(Tp_N > 15) = NaN;
Tp_N = Tp_N(~isnan(Hs_N));

% useful = find(wave_20250424_S(:,3)>0);
[Tp_S, T_S, Hs_S] = huang_waveheightTp(W.(['wave', dates, '_S']),1,1200);
% Tp_S = Tp_N.*W.XX(1:length(Hs_N));
% T_S = T_N.*W.XX(1:length(Hs_N));
% Hs_S = Hs_N.*W.XX(1:length(Hs_N));
Tp_S(Tp_S > 15) = NaN;

low = 1;
mid = 5;
upp = 11;

%% fopen
ig = find(Dir_N >= (360-11.25));
Dir_N(ig) = Dir_N(ig)-360;

ig = find(Dir_S >= (360-11.25));
Dir_S(ig) = Dir_S(ig)-360;


[N.Cur.upp_max, idx] = max(Cur_N(:, upp));
N.Dir.upp_max = Dir_N(idx, upp);
N.Cur.upp_mean = mean(Cur_N(:, upp));
N.Dir.upp_mean = mean(Dir_N(:, upp));

[N.Cur.mid_max, idx] = max(Cur_N(:, mid));
N.Dir.mid_max = Dir_N(idx, mid);
N.Cur.mid_mean = mean(Cur_N(:, mid));
N.Dir.mid_mean = mean(Dir_N(:, mid));

[N.Cur.low_max, idx] = max(Cur_N(:, low));
N.Dir.low_max = Dir_N(idx, low);
N.Cur.low_mean = mean(Cur_N(:, low));
N.Dir.low_mean = mean(Dir_N(:, low));

[S.Cur.upp_max, idx] = max(Cur_S(:, upp));
S.Dir.upp_max = Dir_S(idx, upp);
S.Cur.upp_mean = mean(Cur_S(:, upp));
S.Dir.upp_mean = mean(Dir_S(:, upp));

[S.Cur.mid_max, idx] = max(Cur_S(:, mid));
S.Dir.mid_max = Dir_S(idx, mid);
S.Cur.mid_mean = mean(Cur_S(:, mid));
S.Dir.mid_mean = mean(Dir_S(:, mid));

[S.Cur.low_max, idx] = max(Cur_S(:, low));
S.Dir.low_max = Dir_S(idx, low);
S.Cur.low_mean = mean(Cur_S(:, low));
S.Dir.low_mean = mean(Dir_S(:, low));


cd(f_data)
fid = fopen("Stastics_Cur.txt", 'w');
fprintf(fid, "北站流速流向統計表 (%s)\n", plotdate_all);
fprintf(fid, "Layers   Vel.max(m/s)  Dir.max(degree)  Vel.mean(m/s)  Dir.mean(degree)\n");
fprintf(fid, "Upper    %-13.3f  %-16.1f  %-14.3f  %-17.1f\n", ...
    N.Cur.upp_max, N.Dir.upp_max, N.Cur.upp_mean, N.Dir.upp_mean);
fprintf(fid, "Middle   %-13.3f  %-16.1f  %-14.3f  %-17.1f\n", ...
    N.Cur.mid_max, N.Dir.mid_max, N.Cur.mid_mean, N.Dir.mid_mean);
fprintf(fid, "Lower    %-13.3f  %-16.1f  %-14.3f  %-17.1f\n\n", ...
    N.Cur.low_max, N.Dir.low_max, N.Cur.low_mean, N.Dir.low_mean);

fprintf(fid, "南站流速流向統計表 (%s)\n", plotdate_all);
fprintf(fid, "Layers   Vel.max(m/s)  Dir.max(degree)  Vel.mean(m/s)  Dir.mean(degree)\n");
fprintf(fid, "Upper    %-13.3f  %-16.1f  %-14.3f  %-17.1f\n", ...
    S.Cur.upp_max, S.Dir.upp_max, S.Cur.upp_mean, S.Dir.upp_mean);
fprintf(fid, "Middle   %-13.3f  %-16.1f  %-14.3f  %-17.1f\n", ...
    S.Cur.mid_max, S.Dir.mid_max, S.Cur.mid_mean, S.Dir.mid_mean);
fprintf(fid, "Lower    %-13.3f  %-16.1f  %-14.3f  %-17.1f\n", ...
    S.Cur.low_max, S.Dir.low_max, S.Cur.low_mean, S.Dir.low_mean);
fclose(fid);

%% Wave stastics
% Hs.mean, T.mean, Hs.max, T.max, Tur.max, Tur.Hs.max
N.Hs.mean_value = nanmean(Hs_N);
N.T.mean_value = nanmean(T_N);
[N.Hs.max_value, idx] = max(Hs_N);
N.T.max_value = max(T_N);
N.Tur.max_value = max(tur_N);
turm = houravg(tur_N, length(tur_N), 6)';
N.Tur.Hs_max_value = max(turm(idx));

S.Hs.mean_value = nanmean(Hs_S);
S.T.mean_value = nanmean(T_S);
[S.Hs.max_value, idx] = max(Hs_S);
S.T.max_value = max(T_S);
S.Tur.max_value = max(tur_S);
turm = houravg(tur_S, length(tur_S), 6)';
S.Tur.Hs_max_value = max(turm(idx));


cd(f_data)
fid = fopen("Stastics_Waveheight.txt", 'w');
fprintf(fid, "北站波高週期濁度統計表 (%s)\n", plotdate_all);
fprintf(fid, "Hs.mean(cm)  T.mean(s)  Hs.max(cm)  T.max(s)  Tur.max(NTU)  Tur.Hs_max(NTU)\n");
fprintf(fid, "%-11.1f  %-9.1f  %-10.1f  %-8.1f  %-12.1f  %-15.1f\n", ...
    N.Hs.mean_value, N.T.mean_value, N.Hs.max_value, N.T.max_value, N.Tur.max_value, N.Tur.Hs_max_value);

fprintf(fid, "南站波高週期濁度統計表 (%s)\n", plotdate_all);
fprintf(fid, "Hs.mean(cm)  T.mean(s)  Hs.max(cm)  T.max(s)  Tur.max(NTU)  Tur.Hs_max(NTU)\n");
fprintf(fid, "%-11.1f  %-9.1f  %-10.1f  %-8.1f  %-12.1f  %-15.1f\n", ...
    S.Hs.mean_value, S.T.mean_value, S.Hs.max_value, S.T.max_value, S.Tur.max_value, S.Tur.Hs_max_value);
% fprintf(fid, "%-11.1f  %-9.1f  %-10.1f  %-8.1f  %-12.1f  %-15.1f\n", ...
%     14.96, 5.70, 54.98, 6.74, S.Tur.max_value, S.Tur.Hs_max_value);

fclose(fid);


