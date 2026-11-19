%% Mashan Harbor, Kinmen
% 20260817 edited
clear; close all; clc; 

%% Path
main_folder = 'C:\Users\adm\Desktop\Mashan';
cd(main_folder)
pic_c = [main_folder, '\picture\current'];
pic_w = [main_folder, '\picture\wave'];
p_data = [main_folder, '\processed_data'];
if ~isfolder(pic_c)
    mkdir(pic_c)
end
if ~isfolder(pic_w)
    mkdir(pic_w)
end
if ~isfolder(p_data)
    mkdir(p_data)
end

%% Figure setting
figset_linefont = @(ax) set(ax, 'fontsize', 12, 'linewidth', 1.5, "TickLength", [0.005 0.02], 'TickDir', 'out'); % setting of font size, frame line size, tick length and size
figset_date = @(ax, wave_day) set(ax, 'XTick', floor(wave_day(1)):4:ceil(wave_day(end)), ...
    'Xticklabel', datestr(floor(wave_day(1)):4:ceil(wave_day(end)), 'mm/dd')); % Major ticks which means 4 days
figset_date_minorticks = @(ax, wave_day) set(ax.XAxis, 'Minortick', 'on', 'MinorTickValues', floor(wave_day(1)):1:ceil(wave_day(end))); % Minor ticks which means one day

%% Load data
station = 'Mashan';
data_path = sprintf('%s\\2022\\QC\\%s\\QC_data.mat', main_folder, station);
QC_2022 = load(data_path);
data_path = "C:\Users\adm\Desktop\Mashan\2023\QC\Mashan\QC_data.mat";
QC_2023 = load(data_path);
C_QC_2022 = QC_2022.C;
W_QC_2022 = QC_2022.W;
C_QC_2023 = QC_2023.C;
W_QC_2023 = QC_2023.W;
flag_threshold = 1;

for ii = 1:length(C_QC_2022)
    ig = find(C_QC_2022(ii).Bot_Vel_flag(:, 12) > flag_threshold);
    C_QC_2022(ii).Cur(ig, 1) = NaN;
    ig = find(C_QC_2022(ii).Mid_Vel_flag(:, 12) > flag_threshold);
    C_QC_2022(ii).Cur(ig, 2) = NaN;
    ig = find(C_QC_2022(ii).Top_Vel_flag(:, 12) > flag_threshold);
    C_QC_2022(ii).Cur(ig, 3) = NaN;

    ig = find(C_QC_2022(ii).Bot_Dir_flag(:, 12) > flag_threshold);
    C_QC_2022(ii).Dir(ig, 1) = NaN;
    ig = find(C_QC_2022(ii).Mid_Dir_flag(:, 12) > flag_threshold);
    C_QC_2022(ii).Dir(ig, 2) = NaN;
    ig = find(C_QC_2022(ii).Top_Dir_flag(:, 12) > flag_threshold);
    C_QC_2022(ii).Dir(ig, 3) = NaN;

    ig = find(C_QC_2022(ii).SL_flag(:, 12) > flag_threshold);
    C_QC_2022(ii).Pre(ig) = NaN;

    ig = find(W_QC_2022(ii).Hs_flag(:, 12) > flag_threshold);
    W_QC_2022(ii).Hs(ig) = NaN;
    ig = find(W_QC_2022(ii).Dir_flag(:, 12) > flag_threshold);
    W_QC_2022(ii).Dir(ig) = NaN;
    ig = find(W_QC_2022(ii).Tp_flag(:, 12) > flag_threshold);
    W_QC_2022(ii).Tp(ig) = NaN;
    fprintf("2022 QC file success\n");
end

for ii = 1:length(C_QC_2023)
    ig = find(C_QC_2023(ii).Bot_Vel_flag(:, 12) > flag_threshold);
    C_QC_2023(ii).Cur(ig, 1) = NaN;
    ig = find(C_QC_2023(ii).Mid_Vel_flag(:, 12) > flag_threshold);
    C_QC_2023(ii).Cur(ig, 2) = NaN;
    ig = find(C_QC_2023(ii).Top_Vel_flag(:, 12) > flag_threshold);
    C_QC_2023(ii).Cur(ig, 3) = NaN;

    ig = find(C_QC_2023(ii).Bot_Dir_flag(:, 12) > flag_threshold);
    C_QC_2023(ii).Dir(ig, 1) = NaN;
    ig = find(C_QC_2023(ii).Mid_Dir_flag(:, 12) > flag_threshold);
    C_QC_2023(ii).Dir(ig, 2) = NaN;
    ig = find(C_QC_2023(ii).Top_Dir_flag(:, 12) > flag_threshold);
    C_QC_2023(ii).Dir(ig, 3) = NaN;

    ig = find(C_QC_2023(ii).SL_flag(:, 12) > flag_threshold);
    C_QC_2023(ii).Pre(ig) = NaN;

    ig = find(W_QC_2023(ii).Hs_flag(:, 12) > flag_threshold);
    W_QC_2023(ii).Hs(ig) = NaN;
    ig = find(W_QC_2023(ii).Dir_flag(:, 12) > flag_threshold);
    W_QC_2023(ii).Dir(ig) = NaN;
    ig = find(W_QC_2023(ii).Tp_flag(:, 12) > flag_threshold);
    W_QC_2023(ii).Tp(ig) = NaN;
    fprintf("2023 QC file success\n");
end


%% stastics data
days_total_length = 365*24;
Hs_flags_all = [];
obs_days_total = [];
for ii = 1:length(W_QC_2022)
    flag_total = W_QC_2022(ii).Hs_flag(:, end);
    days_everymonth = W_QC_2022(ii).waveday;
    Hs_flags_all = [Hs_flags_all; flag_total];
    obs_days_total = [obs_days_total; days_everymonth];
end

%% 
figure("OuterPosition", [1 1 1920 1080])
tt = tiledlayout("flow");
for ii = 1:length(C_QC_2022)
    ax = nexttile;
    % ii = 6;
    plot(QC_2022.C(ii).dday, QC_2022.C(ii).Pre, 'r'); hold on
    plot(C_QC_2022(ii).dday, C_QC_2022(ii).Pre, 'b')
    figset_date(ax, C_QC_2022(ii).dday)
    figset_linefont(ax)
    xlim([floor(C_QC_2022(ii).dday(1)) ceil(C_QC_2022(ii).dday(end))])
    % ylim([10 18])
end
title_str = sprintf('Sealevel Raw vs QC data %s', datestr(C_QC_2022(1).dday(1), 'yyyy'));
title(tt, title_str, 'fontsize', 24, 'fontweight', 'bold')


figure("OuterPosition", [1 1 1920 1080])
tt = tiledlayout("flow");
for ii = 1:length(C_QC_2022)
    ax = nexttile;
    % ii = 6;
    plot(QC_2022.C(ii).dday, QC_2022.C(ii).Pre, 'r'); hold on
    plot(C_QC_2022(ii).dday, C_QC_2022(ii).Pre, 'b')
    figset_date(ax, C_QC_2022(ii).dday)
    figset_linefont(ax)
    xlim([floor(C_QC_2022(ii).dday(1)) ceil(C_QC_2022(ii).dday(end))])
    % ylim([10 18])
end
title_str = sprintf('Sealevel Raw vs QC data %s', datestr(C_QC_2022(1).dday(1), 'yyyy'));
title(tt, title_str, 'fontsize', 24, 'fontweight', 'bold')

%% 
figure
plot(C(4).dday, C(4).Cur(:, 1))
ig = find(isnan(C(4).Cur(:, 3)));


