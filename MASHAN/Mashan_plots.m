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
figset_linefont = @(ax) set(ax, 'fontsize', 15, 'linewidth', 1.5, "TickLength", [0.005 0.02], 'TickDir', 'out'); % setting of font size, frame line size, tick length and size
figset_date = @(ax, wave_day) set(ax, 'XTick', floor(wave_day(1)):10:ceil(wave_day(end)), ...
    'Xticklabel', datestr(floor(wave_day(1)):10:ceil(wave_day(end)), 'mm/dd')); % Major ticks which means 4 days
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
Layers = {"Bottom", "Middle", "Surface"};

% =========================== filter flags ================================
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

    % ig = find(C_QC_2022(ii).SL_flag(:, 12) > 3);
    ig = find(C_QC_2022(ii).Pre < 9);
    C_QC_2022(ii).Pre(ig) = NaN;

    ig = find(W_QC_2022(ii).Hs_flag(:, 12) > flag_threshold);
    W_QC_2022(ii).Hs(ig) = NaN;
    ig = find(W_QC_2022(ii).Dir_flag(:, 12) > flag_threshold);
    W_QC_2022(ii).Dir(ig) = NaN;
    ig = find(W_QC_2022(ii).Tp_flag(:, 12) > flag_threshold);
    W_QC_2022(ii).Tp(ig) = NaN;

    % if ii > 6 && ii < 11
    %     % C_QC_2022(ii).dday = NaN;
    %     C_QC_2022(ii).Cur = NaN(size(C_QC_2022(ii).Cur));
    %     C_QC_2022(ii).Dir = NaN(size(C_QC_2022(ii).Dir));
    %     C_QC_2022(ii).Pre = NaN(size(C_QC_2022(ii).Pre));
    %     W_QC_2022(ii).Dir  = NaN(size(W_QC_2022(ii).Dir));
    %     W_QC_2022(ii).Hs = NaN(size(W_QC_2022(ii).Dir));
    %     W_QC_2022(ii).Tp = NaN(size(W_QC_2022(ii).Dir));
    % end

    fprintf("2022 QC %.0f file success\n", ii);
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

    % ig = find(C_QC_2023(ii).SL_flag(:, 12) > 3);
    ig = find(C_QC_2023(ii).Pre < 9);
    C_QC_2023(ii).Pre(ig) = NaN;

    ig = find(W_QC_2023(ii).Hs_flag(:, 12) > flag_threshold);
    W_QC_2023(ii).Hs(ig) = NaN;
    ig = find(W_QC_2023(ii).Dir_flag(:, 12) > flag_threshold);
    W_QC_2023(ii).Dir(ig) = NaN;
    ig = find(W_QC_2023(ii).Tp_flag(:, 12) > flag_threshold);
    W_QC_2023(ii).Tp(ig) = NaN;

    if ii > 6 && ii < 11
        % C_QC_2023(ii).dday = NaN(size(C_QC_2023(ii).dday));
        C_QC_2023(ii).Cur = NaN(size(C_QC_2023(ii).Cur));
        C_QC_2023(ii).Dir = NaN(size(C_QC_2023(ii).Dir));
        C_QC_2023(ii).Pre = NaN(size(C_QC_2023(ii).Pre));
        W_QC_2023(ii).Dir  = NaN(size(W_QC_2023(ii).Dir));
        W_QC_2023(ii).Hs = NaN(size(W_QC_2023(ii).Dir));
        W_QC_2023(ii).Tp = NaN(size(W_QC_2023(ii).Dir));
    end

    fprintf("2023 QC %.0f file success\n", ii);
end



% ============================ All data ===================================
all_Hs_2022 = [];
all_Tp_2022 = [];
all_WDir_2022 = [];
all_waveday_2022 = [];
all_Cur_2022 = [];
all_Dir_2022 = [];
all_dday_2022 = [];

all_Hs_2023 = [];
all_Tp_2023 = [];
all_WDir_2023 = [];
all_waveday_2023 = [];
all_Cur_2023 = [];
all_Dir_2023 = [];
all_dday_2023 = [];

for ii = 1:length(W_QC_2022)
    all_waveday_2022 = [all_waveday_2022; W_QC_2022(ii).waveday];
    all_Hs_2022 = [all_Hs_2022; W_QC_2022(ii).Hs];
    all_Tp_2022 = [all_Tp_2022; W_QC_2022(ii).Tp];
    all_WDir_2022 = [all_WDir_2022; W_QC_2022(ii).Dir];
    all_dday_2022 = [all_dday_2022; C_QC_2022(ii).dday];
    all_Cur_2022 = [all_Cur_2022; C_QC_2022(ii).Cur];
    all_Dir_2022 = [all_Dir_2022; C_QC_2022(ii).Dir];

    all_waveday_2023 = [all_waveday_2023; W_QC_2023(ii).waveday];
    all_Hs_2023 = [all_Hs_2023; W_QC_2023(ii).Hs];
    all_Tp_2023 = [all_Tp_2023; W_QC_2023(ii).Tp];
    all_WDir_2023 = [all_WDir_2023; W_QC_2023(ii).Dir];
    all_dday_2023 = [all_dday_2023; C_QC_2023(ii).dday];
    all_Cur_2023 = [all_Cur_2023; C_QC_2023(ii).Cur];
    all_Dir_2023 = [all_Dir_2023; C_QC_2023(ii).Dir];
end

% ========================== seasonal data ================================
WW_202112 = readtable("C:\Users\adm\Desktop\Mashan\2022\QC\Mashan\202112\Mashan_WaveHs_202112.dat", "ReadVariableNames", false);
waveday_datetime_202112 = datetime(WW_202112.Var2, 'InputFormat', 'uuuuMMdd HH:mm:ss');
ig = find(waveday_datetime_202112 >= datetime(2021, 12, 25));
waveday_202112 = datenum(waveday_datetime_202112(ig));
Hs_202112 = WW_202112.Var3(ig);
Hs_flag_202112 = WW_202112.Var15(ig);
Hs_202112(Hs_flag_202112 > flag_threshold) = NaN;

WW_202112 = readtable("C:\Users\adm\Desktop\Mashan\2022\QC\Mashan\202112\Mashan_WaveDir_202112.dat", "ReadVariableNames", false);
WDir_202112 = WW_202112.Var3(ig);
WDir_flag_202112 = WW_202112.Var15(ig);
WDir_202112(WDir_flag_202112 > flag_threshold) = NaN;

WW_202112 = readtable("C:\Users\adm\Desktop\Mashan\2022\QC\Mashan\202112\Mashan_WaveTp_202112.dat", "ReadVariableNames", false);
Tp_202112 = WW_202112.Var3(ig);
Tp_flag_202112 = WW_202112.Var15(ig);
Tp_202112(Tp_flag_202112 > flag_threshold) = NaN;

dd = dir("C:\Users\adm\Desktop\Mashan\2022\QC\Mashan\202112\*CurVel*");
cd("C:\Users\adm\Desktop\Mashan\2022\QC\Mashan\202112\")
for ii = 1:length(dd)
    CC_202112 = readtable(dd(ii).name, 'ReadVariableNames', false);
    dday_datetime_202112 = datetime(CC_202112.Var2, 'InputFormat', 'uuuuMMdd HH:mm:ss');
    ig = dday_datetime_202112 >= datetime(2021, 12, 25);
    dday_202112 = datenum(dday_datetime_202112(ig));
    Cur_202112(:, ii) = CC_202112.Var3(ig);
    Cur_flag_202112 = CC_202112.Var15(ig);
    Cur_202112(Cur_flag_202112 > flag_threshold, ii) = NaN;
end

dd = dir("C:\Users\adm\Desktop\Mashan\2022\QC\Mashan\202112\*CurDir*");
for ii = 1:length(dd)
    CC_202112 = readtable(dd(ii).name, 'ReadVariableNames', false);
    dday_datetime_202112 = datetime(CC_202112.Var2, 'InputFormat', 'uuuuMMdd HH:mm:ss');
    ig = dday_datetime_202112 >= datetime(2021, 12, 25);
    Dir_202112(:, ii) = CC_202112.Var3(ig);
    Dir_flag_202112 = CC_202112.Var15(ig);
    Dir_202112(Dir_flag_202112 > flag_threshold, ii) = NaN;
end

SL_202112 = readtable("C:\Users\adm\Desktop\Mashan\2022\QC\Mashan\202112\Mashan_Sealevel_202112.dat", "ReadVariableNames", false);
Pre_202112 = SL_202112.Var3(ig);
Pre_flag_202112 = SL_202112.Var15(ig);
Pre_202112(Pre_flag_202112 > flag_threshold) = NaN;

winter.waveday_2022 = [waveday_202112; W_QC_2022(1).waveday; W_QC_2022(2).waveday];
winter.Hs_2022 = [Hs_202112; W_QC_2022(1).Hs; W_QC_2022(2).Hs];
winter.WDir_2022 = [WDir_202112; W_QC_2022(1).Dir; W_QC_2022(2).Dir];
winter.Tp_2022 = [Tp_202112; W_QC_2022(1).Tp; W_QC_2022(2).Tp];
winter.dday_2022 = [dday_202112; C_QC_2022(1).dday; C_QC_2022(2).dday];
winter.Cur_2022 = [Cur_202112; C_QC_2022(1).Cur; C_QC_2022(2).Cur];
winter.Dir_2022 = [Dir_202112; C_QC_2022(1).Dir; C_QC_2022(2).Dir];
winter.Pre_2022 = [Pre_202112; C_QC_2022(1).Pre; C_QC_2022(2).Pre];

spring.waveday_2022 = [W_QC_2022(3).waveday; W_QC_2022(4).waveday; W_QC_2022(5).waveday];
spring.Hs_2022 = [W_QC_2022(3).Hs; W_QC_2022(4).Hs; W_QC_2022(5).Hs];
spring.WDir_2022 = [W_QC_2022(3).Dir; W_QC_2022(4).Dir; W_QC_2022(5).Dir];
spring.Tp_2022 = [W_QC_2022(3).Tp; W_QC_2022(4).Tp; W_QC_2022(5).Tp];
spring.dday_2022 = [C_QC_2022(3).dday; C_QC_2022(4).dday; C_QC_2022(5).dday];
spring.Cur_2022 = [C_QC_2022(3).Cur; C_QC_2022(4).Cur; C_QC_2022(5).Cur];
spring.Dir_2022 = [C_QC_2022(3).Dir; C_QC_2022(4).Dir; C_QC_2022(5).Dir];
spring.Pre_2022 = [C_QC_2022(3).Pre; C_QC_2022(4).Pre; C_QC_2022(5).Pre];

summer.waveday_2022 = [W_QC_2022(6).waveday; W_QC_2022(7).waveday; W_QC_2022(8).waveday];
summer.Hs_2022 = [W_QC_2022(6).Hs; W_QC_2022(7).Hs; W_QC_2022(8).Hs];
summer.WDir_2022 = [W_QC_2022(6).Dir; W_QC_2022(7).Dir; W_QC_2022(8).Dir];
summer.Tp_2022 = [W_QC_2022(6).Tp; W_QC_2022(7).Tp; W_QC_2022(8).Tp];
summer.dday_2022 = [C_QC_2022(6).dday; C_QC_2022(7).dday; C_QC_2022(8).dday];
summer.Cur_2022 = [C_QC_2022(6).Cur; C_QC_2022(7).Cur; C_QC_2022(8).Cur];
summer.Dir_2022 = [C_QC_2022(6).Dir; C_QC_2022(7).Dir; C_QC_2022(8).Dir];
summer.Pre_2022 = [C_QC_2022(6).Pre; C_QC_2022(7).Pre; C_QC_2022(8).Pre];

fall.waveday_2022 = [W_QC_2022(9).waveday; W_QC_2022(10).waveday; W_QC_2022(11).waveday];
fall.Hs_2022 = [W_QC_2022(9).Hs; W_QC_2022(10).Hs; W_QC_2022(11).Hs];
fall.WDir_2022 = [W_QC_2022(9).Dir; W_QC_2022(10).Dir; W_QC_2022(11).Dir];
fall.Tp_2022 = [W_QC_2022(9).Tp; W_QC_2022(10).Tp; W_QC_2022(11).Tp];
fall.dday_2022 = [C_QC_2022(9).dday; C_QC_2022(10).dday; C_QC_2022(11).dday];
fall.Cur_2022 = [C_QC_2022(9).Cur; C_QC_2022(10).Cur; C_QC_2022(11).Cur];
fall.Dir_2022 = [C_QC_2022(9).Dir; C_QC_2022(10).Dir; C_QC_2022(11).Dir];
fall.Pre_2022 = [C_QC_2022(9).Pre; C_QC_2022(10).Pre; C_QC_2022(11).Pre];

winter.waveday_2023 = [W_QC_2022(12).waveday; W_QC_2023(1).waveday; W_QC_2023(2).waveday];
winter.Hs_2023 = [W_QC_2022(12).Hs; W_QC_2023(1).Hs; W_QC_2023(2).Hs];
winter.WDir_2023 = [W_QC_2022(12).Dir; W_QC_2023(1).Dir; W_QC_2023(2).Dir];
winter.Tp_2023 = [W_QC_2022(12).Tp; W_QC_2023(1).Tp; W_QC_2023(2).Tp];
winter.dday_2023 = [C_QC_2022(12).dday; C_QC_2023(1).dday; C_QC_2023(2).dday];
winter.Cur_2023 = [C_QC_2022(12).Cur; C_QC_2023(1).Cur; C_QC_2023(2).Cur];
winter.Dir_2023 = [C_QC_2022(12).Dir; C_QC_2023(1).Dir; C_QC_2023(2).Dir];
winter.Pre_2023 = [C_QC_2022(12).Pre; C_QC_2023(1).Pre; C_QC_2023(2).Pre];

spring.waveday_2023 = [W_QC_2023(3).waveday; W_QC_2023(4).waveday; W_QC_2023(5).waveday];
spring.Hs_2023 = [W_QC_2023(3).Hs; W_QC_2023(4).Hs; W_QC_2023(5).Hs];
spring.WDir_2023 = [W_QC_2023(3).Dir; W_QC_2023(4).Dir; W_QC_2023(5).Dir];
spring.Tp_2023 = [W_QC_2023(3).Tp; W_QC_2023(4).Tp; W_QC_2023(5).Tp];
spring.dday_2023 = [C_QC_2023(3).dday; C_QC_2023(4).dday; C_QC_2023(5).dday];
spring.Cur_2023 = [C_QC_2023(3).Cur; C_QC_2023(4).Cur; C_QC_2023(5).Cur];
spring.Dir_2023 = [C_QC_2023(3).Dir; C_QC_2023(4).Dir; C_QC_2023(5).Dir];
spring.Pre_2023 = [C_QC_2023(3).Pre; C_QC_2023(4).Pre; C_QC_2023(5).Pre];

summer.waveday_2023 = [W_QC_2023(6).waveday; W_QC_2023(7).waveday; W_QC_2023(8).waveday];
summer.Hs_2023 = [W_QC_2023(6).Hs; W_QC_2023(7).Hs; W_QC_2023(8).Hs];
summer.WDir_2023 = [W_QC_2023(6).Dir; W_QC_2023(7).Dir; W_QC_2023(8).Dir];
summer.Tp_2023 = [W_QC_2023(6).Tp; W_QC_2023(7).Tp; W_QC_2023(8).Tp];
summer.dday_2023 = [C_QC_2023(6).dday; C_QC_2023(7).dday; C_QC_2023(8).dday];
summer.Cur_2023 = [C_QC_2023(6).Cur; C_QC_2023(7).Cur; C_QC_2023(8).Cur];
summer.Dir_2023 = [C_QC_2023(6).Dir; C_QC_2023(7).Dir; C_QC_2023(8).Dir];
summer.Pre_2023 = [C_QC_2023(6).Pre; C_QC_2023(7).Pre; C_QC_2023(8).Pre];

fall.waveday_2023 = [W_QC_2023(9).waveday; W_QC_2023(10).waveday; W_QC_2023(11).waveday];
fall.Hs_2023 = [W_QC_2023(9).Hs; W_QC_2023(10).Hs; W_QC_2023(11).Hs];
fall.WDir_2023 = [W_QC_2023(9).Dir; W_QC_2023(10).Dir; W_QC_2023(11).Dir];
fall.Tp_2023 = [W_QC_2023(9).Tp; W_QC_2023(10).Tp; W_QC_2023(11).Tp];
fall.dday_2023 = [C_QC_2023(9).dday; C_QC_2023(10).dday; C_QC_2023(11).dday];
fall.Cur_2023 = [C_QC_2023(9).Cur; C_QC_2023(10).Cur; C_QC_2023(11).Cur];
fall.Dir_2023 = [C_QC_2023(9).Dir; C_QC_2023(10).Dir; C_QC_2023(11).Dir];
fall.Pre_2023 = [C_QC_2023(9).Pre; C_QC_2023(10).Pre; C_QC_2023(11).Pre];


%% QC_PLOT
figure("OuterPosition", [1 1 1920 1080])
tiledlayout("flow")
for ii = 1:12
    ax = nexttile;
    ig = find(C_QC_2022(ii).SL_flag(:, 12) > 3);
    PP = C_QC_2022(ii).Pre;
    PP(ig) = NaN;
    plot(QC_2022.C(ii).dday, QC_2022.C(ii).Pre, 'r', 'DisplayName', 'Raw'); hold on
    plot(C_QC_2022(ii).dday, PP, 'b', 'DisplayName', 'QC (flag > 3)')
    legend
    figset_linefont(ax)
    figset_date(ax, QC_2022.C(ii).dday)
end
file_name = sprintf("%s\\%s_SL_QC_3.png", pic_c, station);
exportgraphics(gcf, file_name)


%% Wave Stastics
Hs_range = 0:0.2:3;
T_range = [0, 3:15];

% ============================= YEARLY HS =================================
Vanalyis_Hsdir(all_Hs_2022, all_WDir_2022, Hs_range, p_data, '2022_Year_HsDir.txt')
Vanalyis_HsT(all_Hs_2022, all_Tp_2022, Hs_range, T_range, p_data, '2022_Year_HsT.txt')

Vanalyis_Hsdir(all_Hs_2023, all_WDir_2023, Hs_range, p_data, '2023_Year_HsDir.txt')
Vanalyis_HsT(all_Hs_2023, all_Tp_2023, Hs_range, T_range, p_data, '2023_Year_HsT.txt')

Vanalyis_Hsdir([all_Hs_2022; all_Hs_2023], [all_WDir_2022; all_WDir_2023], Hs_range, p_data, '2022_2023_Year_HsDir.txt')
Vanalyis_HsT([all_Hs_2022; all_Hs_2023], [all_Tp_2022; all_Tp_2023], Hs_range, T_range, p_data, '2022_2023_Year_HsT.txt')

% =========================== SEASONAL 2022 ===============================
Vanalyis_Hsdir(winter.Hs_2022, winter.WDir_2022, Hs_range, p_data, '2022_winter_HsDir.txt')
Vanalyis_HsT(winter.Hs_2022, winter.Tp_2022, Hs_range, T_range, p_data, '2022_winter_HsT.txt')

Vanalyis_Hsdir(spring.Hs_2022, spring.WDir_2022, Hs_range, p_data, '2022_spring_HsDir.txt')
Vanalyis_HsT(spring.Hs_2022, spring.Tp_2022, Hs_range, T_range, p_data, '2022_spring_HsT.txt')

Vanalyis_Hsdir(summer.Hs_2022, summer.WDir_2022, Hs_range, p_data, '2022_summer_HsDir.txt')
Vanalyis_HsT(summer.Hs_2022, summer.Tp_2022, Hs_range, T_range, p_data, '2022_summer_HsT.txt')

Vanalyis_Hsdir(fall.Hs_2022, fall.WDir_2022, Hs_range, p_data, '2022_fall_HsDir.txt')
Vanalyis_HsT(fall.Hs_2022, fall.Tp_2022, Hs_range, T_range, p_data, '2022_fall_HsT.txt')

% =========================== SEASONAL 2023 ===============================
Vanalyis_Hsdir(winter.Hs_2023, winter.WDir_2023, Hs_range, p_data, '2023_winter_HsDir.txt')
Vanalyis_HsT(winter.Hs_2023, winter.Tp_2023, Hs_range, T_range, p_data, '2023_winter_HsT.txt')

Vanalyis_Hsdir(spring.Hs_2023, spring.WDir_2023, Hs_range, p_data, '2023_spring_HsDir.txt')
Vanalyis_HsT(spring.Hs_2023, spring.Tp_2023, Hs_range, T_range, p_data, '2023_spring_HsT.txt')

Vanalyis_Hsdir(summer.Hs_2023, summer.WDir_2023, Hs_range, p_data, '2023_summer_HsDir.txt')
Vanalyis_HsT(summer.Hs_2023, summer.Tp_2023, Hs_range, T_range, p_data, '2023_summer_HsT.txt')

Vanalyis_Hsdir(fall.Hs_2023, fall.WDir_2023, Hs_range, p_data, '2023_fall_HsDir.txt')
Vanalyis_HsT(fall.Hs_2023, fall.Tp_2023, Hs_range, T_range, p_data, '2023_fall_HsT.txt')

% ============================ MONTHLY 2022 ===============================
for ii = 1:12
    Hsdir_str = sprintf('%s_HsDir.txt', datestr(W_QC_2022(ii).waveday(1), 'yyyy_mm'));
    HsT_str = sprintf('%s_HsT.txt', datestr(W_QC_2022(ii).waveday(1), 'yyyy_mm'));
    Vanalyis_Hsdir(W_QC_2022(ii).Hs, W_QC_2022(ii).Dir, Hs_range, p_data, Hsdir_str)
    Vanalyis_HsT(W_QC_2022(ii).Hs, W_QC_2022(ii).Tp, Hs_range, T_range, p_data, HsT_str)
end

% ============================ MONTHLY 2023 ===============================
for ii = [1:6, 11:12]
    Hsdir_str = sprintf('%s_HsDir.txt', datestr(W_QC_2023(ii).waveday(1), 'yyyy_mm'));
    HsT_str = sprintf('%s_HsT.txt', datestr(W_QC_2023(ii).waveday(1), 'yyyy_mm'));
    Vanalyis_Hsdir(W_QC_2023(ii).Hs, W_QC_2023(ii).Dir, Hs_range, p_data, Hsdir_str)
    Vanalyis_HsT(W_QC_2023(ii).Hs, W_QC_2023(ii).Tp, Hs_range, T_range, p_data, HsT_str)
end

%% Current Stastics
Cur_range = (0:10:150)/100;

% =============================== YEARLY ==================================
for ii = 1:3
    Cur_str = sprintf('2022_Year_Cur_%sLayer_CurDir.txt', Layers{ii});
    Vanalyis_Curdir(all_Cur_2022(:, ii), all_Dir_2022(:, ii), Cur_range, p_data, Cur_str)

    Cur_str = sprintf('2023_Year_Cur_%sLayer_CurDir.txt', Layers{ii});
    Vanalyis_Curdir(all_Cur_2023(:, ii), all_Dir_2023(:, ii), Cur_range, p_data, Cur_str)


    Cur_str = sprintf('2022_2023_Year_Cur_%sLayer_CurDir.txt', Layers{ii});
    Vanalyis_Curdir([all_Cur_2022(:, ii); all_Cur_2023(:, ii)], [all_Dir_2022(:, ii); all_Dir_2023(:, ii)], Cur_range, p_data, Cur_str)
end

% ============================== Seasonal =================================
for ii = 1:3
    Cur_str = sprintf('2022_winter_%sLayer_CurDir.txt', Layers{ii});
    Vanalyis_Curdir(winter.Cur_2022(:, ii), winter.Dir_2022(:, ii), Cur_range, p_data, Cur_str)

    Cur_str = sprintf('2022_spring_%sLayer_CurDir.txt', Layers{ii});
    Vanalyis_Curdir(spring.Cur_2022(:, ii), spring.Dir_2022(:, ii), Cur_range, p_data, Cur_str)

    Cur_str = sprintf('2022_summer_%sLayer_CurDir.txt', Layers{ii});
    Vanalyis_Curdir(summer.Cur_2022(:, ii), summer.Dir_2022(:, ii), Cur_range, p_data, Cur_str)

    Cur_str = sprintf('2022_fall_%sLayer_CurDir.txt', Layers{ii});
    Vanalyis_Curdir(fall.Cur_2022(:, ii), fall.Dir_2022(:, ii), Cur_range, p_data, Cur_str)


    Cur_str = sprintf('2023_winter_%sLayer_CurDir.txt', Layers{ii});
    Vanalyis_Curdir(winter.Cur_2023(:, ii), winter.Dir_2023(:, ii), Cur_range, p_data, Cur_str)

    Cur_str = sprintf('2023_spring_%sLayer_CurDir.txt', Layers{ii});
    Vanalyis_Curdir(spring.Cur_2023(:, ii), spring.Dir_2023(:, ii), Cur_range, p_data, Cur_str)

    Cur_str = sprintf('2023_summer_%sLayer_CurDir.txt', Layers{ii});
    Vanalyis_Curdir(summer.Cur_2023(:, ii), summer.Dir_2023(:, ii), Cur_range, p_data, Cur_str)

    Cur_str = sprintf('2023_fall_%sLayer_CurDir.txt', Layers{ii});
    Vanalyis_Curdir(fall.Cur_2023(:, ii), fall.Dir_2023(:, ii), Cur_range, p_data, Cur_str)
end

% ============================== MONTHLY ==================================
for jj = 1:12
for ii = 1:3
    
    Cur_str = sprintf('%s_%sLayer_CurDir.txt', datestr(C_QC_2022(jj).dday(1), 'yyyy_mm'), Layers{ii});
    Vanalyis_Curdir(C_QC_2022(jj).Cur(:, ii), C_QC_2022(jj).Dir(:, ii), Cur_range, p_data, Cur_str);
    
end
end


for jj = [1:6, 11:12]
for ii = 1:3
    
    Cur_str = sprintf('%s_%sLayer_CurDir.txt', datestr(C_QC_2023(jj).dday(1), 'yyyy_mm'), Layers{ii});
    Vanalyis_Curdir(C_QC_2023(jj).Cur(:, ii), C_QC_2023(jj).Dir(:, ii), Cur_range, p_data, Cur_str);
    
end
end

%% seasonal plot 2022
% ================================ winter =================================
figure("OuterPosition", [1 1 1920*2/3, 1080])
tt = tiledlayout(4, 1, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
plot(winter.dday_2022, winter.Pre_2022, 'LineWidth', 1, 'Color', 'k');
figset_date_minorticks(ax, winter.dday_2022)
grid on
ylabel('sea level (m)')
xlim([floor(winter.dday_2022(1)) ceil(winter.dday_2022(end))])
figset_date(ax, winter.dday_2022)
figset_linefont(ax)


ax = nexttile;
scatter(winter.waveday_2022, winter.Hs_2022, 8, 'k', 'filled');
figset_date_minorticks(ax, winter.waveday_2022)
grid on
ylabel('Hs (m)')
xlim([floor(winter.dday_2022(1)) ceil(winter.dday_2022(end))])
figset_date(ax, winter.dday_2022)
figset_linefont(ax)

ax = nexttile;
scatter(winter.waveday_2022, winter.Tp_2022, 8, 'k', 'filled');
figset_date_minorticks(ax, winter.waveday_2022)
ylim([0 10])
grid on
ylabel('T (sec.)')
xlim([floor(winter.dday_2022(1)) ceil(winter.dday_2022(end))])
figset_date(ax, winter.dday_2022)
figset_linefont(ax)

ax = nexttile;
scatter(winter.waveday_2022, winter.WDir_2022, 8, 'k', 'filled');
figset_date_minorticks(ax, winter.waveday_2022)
grid on
ylim([0 360])
ylabel('Wave Dir. (^{\circ})')
xlim([floor(winter.dday_2022(1)) ceil(winter.dday_2022(end))])
figset_date(ax, winter.dday_2022)
figset_linefont(ax)
set(ax, 'ytick', 0:90:360)

title_str = sprintf("\\bf%s Winter, %s", datestr(winter.dday_2022(end), 'yyyy'), station);
title(tt, title_str, 'fontsize', 20)

saving_str = sprintf("%s\\wave_diagram_winter.png", pic_w);
exportgraphics(gcf, saving_str)


% ================================ spring =================================
figure("OuterPosition", [1 1 1920*2/3, 1080])
tt = tiledlayout(4, 1, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
% ig = find(spring.Pre_2022 > 10);
plot(spring.dday_2022, spring.Pre_2022, 'LineWidth', 1, 'Color', 'k');
figset_date_minorticks(ax, spring.dday_2022)
grid on
ylabel('sea level (m)')
xlim([floor(spring.dday_2022(1)) ceil(spring.dday_2022(end))])
figset_date(ax, spring.dday_2022)
figset_linefont(ax)


ax = nexttile;
scatter(spring.waveday_2022, spring.Hs_2022, 8, 'k', 'filled');
figset_date_minorticks(ax, spring.waveday_2022)
grid on
ylabel('Hs (m)')
xlim([floor(spring.dday_2022(1)) ceil(spring.dday_2022(end))])
figset_date(ax, spring.dday_2022)
figset_linefont(ax)

ax = nexttile;
scatter(spring.waveday_2022, spring.Tp_2022, 8, 'k', 'filled');
figset_date_minorticks(ax, spring.waveday_2022)
ylim([0 10])
grid on
ylabel('T (sec.)')
xlim([floor(spring.dday_2022(1)) ceil(spring.dday_2022(end))])
figset_date(ax, spring.dday_2022)
figset_linefont(ax)

ax = nexttile;
scatter(spring.waveday_2022, spring.WDir_2022, 8, 'k', 'filled');
figset_date_minorticks(ax, spring.waveday_2022)
grid on
ylim([0 360])
ylabel('Wave Dir. (^{\circ})')
xlim([floor(spring.dday_2022(1)) ceil(spring.dday_2022(end))])
figset_date(ax, spring.dday_2022)
figset_linefont(ax)
set(ax, 'ytick', 0:90:360)

title_str = sprintf("\\bf%s Spring, %s", datestr(spring.dday_2022(end), 'yyyy'), station);
title(tt, title_str, 'fontsize', 20)

saving_str = sprintf("%s\\wave_diagram_spring.png", pic_w);
exportgraphics(gcf, saving_str)


% ================================ summer =================================
figure("OuterPosition", [1 1 1920*2/3, 1080])
tt = tiledlayout(4, 1, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
% ig = find(summer.Pre_2022 > 10);
plot(summer.dday_2022, summer.Pre_2022, 'LineWidth', 1, 'Color', 'k');
figset_date_minorticks(ax, summer.dday_2022)
grid on
ylabel('sea level (m)')
xlim([floor(summer.dday_2022(1)) ceil(summer.dday_2022(end))])
figset_date(ax, summer.dday_2022)
figset_linefont(ax)


ax = nexttile;
scatter(summer.waveday_2022, summer.Hs_2022, 8, 'k', 'filled');
figset_date_minorticks(ax, summer.waveday_2022)
grid on
ylabel('Hs (m)')
xlim([floor(summer.dday_2022(1)) ceil(summer.dday_2022(end))])
figset_date(ax, summer.dday_2022)
figset_linefont(ax)

ax = nexttile;
scatter(summer.waveday_2022, summer.Tp_2022, 8, 'k', 'filled');
figset_date_minorticks(ax, summer.waveday_2022)
ylim([0 10])
grid on
ylabel('T (sec.)')
xlim([floor(summer.dday_2022(1)) ceil(summer.dday_2022(end))])
figset_date(ax, summer.dday_2022)
figset_linefont(ax)

ax = nexttile;
scatter(summer.waveday_2022, summer.WDir_2022, 8, 'k', 'filled');
figset_date_minorticks(ax, summer.waveday_2022)
grid on
ylim([0 360])
ylabel('Wave Dir. (^{\circ})')
xlim([floor(summer.dday_2022(1)) ceil(summer.dday_2022(end))])
figset_date(ax, summer.dday_2022)
figset_linefont(ax)
set(ax, 'ytick', 0:90:360)

title_str = sprintf("\\bf%s Summer, %s", datestr(summer.dday_2022(end), 'yyyy'), station);
title(tt, title_str, 'fontsize', 20)

saving_str = sprintf("%s\\wave_diagram_summer.png", pic_w);
exportgraphics(gcf, saving_str)


% ================================= fall ==================================
figure("OuterPosition", [1 1 1920*2/3, 1080])
tt = tiledlayout(4, 1, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
% ig = find(fall.Pre_2022 > 10);
plot(fall.dday_2022, fall.Pre_2022, 'LineWidth', 1, 'Color', 'k');
figset_date_minorticks(ax, fall.dday_2022)
grid on
ylabel('sea level (m)')
xlim([floor(fall.dday_2022(1)) ceil(fall.dday_2022(end))])
figset_date(ax, fall.dday_2022)
figset_linefont(ax)


ax = nexttile;
scatter(fall.waveday_2022, fall.Hs_2022, 8, 'k', 'filled');
figset_date_minorticks(ax, fall.waveday_2022)
grid on
ylabel('Hs (m)')
xlim([floor(fall.dday_2022(1)) ceil(fall.dday_2022(end))])
figset_date(ax, fall.dday_2022)
figset_linefont(ax)

ax = nexttile;
scatter(fall.waveday_2022, fall.Tp_2022, 8, 'k', 'filled');
figset_date_minorticks(ax, fall.waveday_2022)
ylim([0 10])
grid on
ylabel('T (sec.)')
xlim([floor(fall.dday_2022(1)) ceil(fall.dday_2022(end))])
figset_date(ax, fall.dday_2022)
figset_linefont(ax)

ax = nexttile;
scatter(fall.waveday_2022, fall.WDir_2022, 8, 'k', 'filled');
figset_date_minorticks(ax, fall.waveday_2022)
grid on
ylim([0 360])
ylabel('Wave Dir. (^{\circ})')
xlim([floor(fall.dday_2022(1)) ceil(fall.dday_2022(end))])
figset_date(ax, fall.dday_2022)
figset_linefont(ax)
set(ax, 'ytick', 0:90:360)

title_str = sprintf("\\bf%s Fall, %s", datestr(fall.dday_2022(end), 'yyyy'), station);
title(tt, title_str, 'fontsize', 20)

saving_str = sprintf("%s\\wave_diagram_fall.png", pic_w);
exportgraphics(gcf, saving_str)


%% seasonal plot 2023
% ================================ winter =================================
figure("OuterPosition", [1 1 1920*2/3, 1080])
tt = tiledlayout(4, 1, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
plot(winter.dday_2023, winter.Pre_2023, 'LineWidth', 1, 'Color', 'k');
figset_date_minorticks(ax, winter.dday_2023)
grid on
ylabel('sea level (m)')
xlim([floor(winter.dday_2023(1)) ceil(winter.dday_2023(end))])
figset_date(ax, winter.dday_2023)
figset_linefont(ax)


ax = nexttile;
scatter(winter.waveday_2023, winter.Hs_2023, 8, 'k', 'filled');
figset_date_minorticks(ax, winter.waveday_2023)
grid on
ylabel('Hs (m)')
xlim([floor(winter.dday_2023(1)) ceil(winter.dday_2023(end))])
figset_date(ax, winter.dday_2023)
figset_linefont(ax)

ax = nexttile;
scatter(winter.waveday_2023, winter.Tp_2023, 8, 'k', 'filled');
figset_date_minorticks(ax, winter.waveday_2023)
ylim([0 10])
grid on
ylabel('T (sec.)')
xlim([floor(winter.dday_2023(1)) ceil(winter.dday_2023(end))])
figset_date(ax, winter.dday_2023)
figset_linefont(ax)

ax = nexttile;
scatter(winter.waveday_2023, winter.WDir_2023, 8, 'k', 'filled');
figset_date_minorticks(ax, winter.waveday_2023)
grid on
ylim([0 360])
ylabel('Wave Dir. (^{\circ})')
xlim([floor(winter.dday_2023(1)) ceil(winter.dday_2023(end))])
figset_date(ax, winter.dday_2023)
figset_linefont(ax)
set(ax, 'ytick', 0:90:360)

title_str = sprintf("\\bf%s Winter, %s", datestr(winter.dday_2023(end), 'yyyy'), station);
title(tt, title_str, 'fontsize', 20)

saving_str = sprintf("%s\\wave_diagram_winter.png", pic_w);
exportgraphics(gcf, saving_str)


% ================================ spring =================================
figure("OuterPosition", [1 1 1920*2/3, 1080])
tt = tiledlayout(4, 1, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
% ig = find(spring.Pre_2023 > 10);
plot(spring.dday_2023, spring.Pre_2023, 'LineWidth', 1, 'Color', 'k');
figset_date_minorticks(ax, spring.dday_2023)
grid on
ylabel('sea level (m)')
xlim([floor(spring.dday_2023(1)) ceil(spring.dday_2023(end))])
figset_date(ax, spring.dday_2023)
figset_linefont(ax)


ax = nexttile;
scatter(spring.waveday_2023, spring.Hs_2023, 8, 'k', 'filled');
figset_date_minorticks(ax, spring.waveday_2023)
grid on
ylabel('Hs (m)')
xlim([floor(spring.dday_2023(1)) ceil(spring.dday_2023(end))])
figset_date(ax, spring.dday_2023)
figset_linefont(ax)

ax = nexttile;
scatter(spring.waveday_2023, spring.Tp_2023, 8, 'k', 'filled');
figset_date_minorticks(ax, spring.waveday_2023)
ylim([0 10])
grid on
ylabel('T (sec.)')
xlim([floor(spring.dday_2023(1)) ceil(spring.dday_2023(end))])
figset_date(ax, spring.dday_2023)
figset_linefont(ax)

ax = nexttile;
scatter(spring.waveday_2023, spring.WDir_2023, 8, 'k', 'filled');
figset_date_minorticks(ax, spring.waveday_2023)
grid on
ylim([0 360])
ylabel('Wave Dir. (^{\circ})')
xlim([floor(spring.dday_2023(1)) ceil(spring.dday_2023(end))])
figset_date(ax, spring.dday_2023)
figset_linefont(ax)
set(ax, 'ytick', 0:90:360)

title_str = sprintf("\\bf%s Spring, %s", datestr(spring.dday_2023(end), 'yyyy'), station);
title(tt, title_str, 'fontsize', 20)

saving_str = sprintf("%s\\wave_diagram_spring.png", pic_w);
exportgraphics(gcf, saving_str)


% ================================ summer =================================
figure("OuterPosition", [1 1 1920*2/3, 1080])
tt = tiledlayout(4, 1, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
% ig = find(summer.Pre_2023 > 10);
plot(summer.dday_2023, summer.Pre_2023, 'LineWidth', 1, 'Color', 'k');
figset_date_minorticks(ax, summer.dday_2023)
grid on
ylabel('sea level (m)')
xlim([floor(summer.dday_2023(1)) ceil(summer.dday_2023(end))])
figset_date(ax, summer.dday_2023)
figset_linefont(ax)


ax = nexttile;
scatter(summer.waveday_2023, summer.Hs_2023, 8, 'k', 'filled');
figset_date_minorticks(ax, summer.waveday_2023)
grid on
ylabel('Hs (m)')
xlim([floor(summer.dday_2023(1)) ceil(summer.dday_2023(end))])
figset_date(ax, summer.dday_2023)
figset_linefont(ax)

ax = nexttile;
scatter(summer.waveday_2023, summer.Tp_2023, 8, 'k', 'filled');
figset_date_minorticks(ax, summer.waveday_2023)
ylim([0 10])
grid on
ylabel('T (sec.)')
xlim([floor(summer.dday_2023(1)) ceil(summer.dday_2023(end))])
figset_date(ax, summer.dday_2023)
figset_linefont(ax)

ax = nexttile;
scatter(summer.waveday_2023, summer.WDir_2023, 8, 'k', 'filled');
figset_date_minorticks(ax, summer.waveday_2023)
grid on
ylim([0 360])
ylabel('Wave Dir. (^{\circ})')
xlim([floor(summer.dday_2023(1)) ceil(summer.dday_2023(end))])
figset_date(ax, summer.dday_2023)
figset_linefont(ax)
set(ax, 'ytick', 0:90:360)

title_str = sprintf("\\bf%s Summer, %s", datestr(summer.dday_2023(end), 'yyyy'), station);
title(tt, title_str, 'fontsize', 20)

saving_str = sprintf("%s\\wave_diagram_summer.png", pic_w);
exportgraphics(gcf, saving_str)


% ================================= fall ==================================
figure("OuterPosition", [1 1 1920*2/3, 1080])
tt = tiledlayout(4, 1, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
% ig = find(fall.Pre_2023 > 10);
plot(fall.dday_2023, fall.Pre_2023, 'LineWidth', 1, 'Color', 'k');
figset_date_minorticks(ax, fall.dday_2023)
grid on
ylabel('sea level (m)')
xlim([floor(fall.dday_2023(1)) ceil(fall.dday_2023(end))])
figset_date(ax, fall.dday_2023)
figset_linefont(ax)


ax = nexttile;
scatter(fall.waveday_2023, fall.Hs_2023, 8, 'k', 'filled');
figset_date_minorticks(ax, fall.waveday_2023)
grid on
ylabel('Hs (m)')
xlim([floor(fall.dday_2023(1)) ceil(fall.dday_2023(end))])
figset_date(ax, fall.dday_2023)
figset_linefont(ax)

ax = nexttile;
scatter(fall.waveday_2023, fall.Tp_2023, 8, 'k', 'filled');
figset_date_minorticks(ax, fall.waveday_2023)
ylim([0 10])
grid on
ylabel('T (sec.)')
xlim([floor(fall.dday_2023(1)) ceil(fall.dday_2023(end))])
figset_date(ax, fall.dday_2023)
figset_linefont(ax)

ax = nexttile;
scatter(fall.waveday_2023, fall.WDir_2023, 8, 'k', 'filled');
figset_date_minorticks(ax, fall.waveday_2023)
grid on
ylim([0 360])
ylabel('Wave Dir. (^{\circ})')
xlim([floor(fall.dday_2023(1)) ceil(fall.dday_2023(end))])
figset_date(ax, fall.dday_2023)
figset_linefont(ax)
set(ax, 'ytick', 0:90:360)

title_str = sprintf("\\bf%s Fall, %s", datestr(fall.dday_2023(end), 'yyyy'), station);
title(tt, title_str, 'fontsize', 20)

saving_str = sprintf("%s\\wave_diagram_fall.png", pic_w);
exportgraphics(gcf, saving_str)


%% monthly 2022
figset_date = @(ax, wave_day) set(ax, 'XTick', floor(wave_day(1)):3:ceil(wave_day(end)), ...
    'Xticklabel', datestr(floor(wave_day(1)):3:ceil(wave_day(end)), 'mm/dd')); % Major ticks which means 4 days

for ii = 1:length(W_QC_2022)
    figure("OuterPosition", [1 1 1920*2/3 1080])
    tt = tiledlayout(4, 1, "TileSpacing", "compact", "Padding", "tight");
    ax = nexttile;
    plot(C_QC_2022(ii).dday, C_QC_2022(ii).Pre, 'LineWidth', 1, 'Color', 'k')
    figset_date_minorticks(ax, C_QC_2022(ii).dday)
    grid on
    ylabel('sea level (m)')
    xlim([floor(C_QC_2022(ii).dday(1)) ceil(C_QC_2022(ii).dday(end))])
    figset_date(ax, C_QC_2022(ii).dday)
    figset_linefont(ax)

    ax = nexttile;
    scatter(W_QC_2022(ii).waveday, W_QC_2022(ii).Hs, 8, 'k', 'filled');
    figset_date_minorticks(ax, W_QC_2022(ii).waveday)
    grid on
    ylabel('Hs (m)')
    xlim([floor(W_QC_2022(ii).waveday(1)) ceil(W_QC_2022(ii).waveday(end))])
    figset_date(ax, W_QC_2022(ii).waveday)
    figset_linefont(ax)
    
    ax = nexttile;
    scatter(W_QC_2022(ii).waveday, W_QC_2022(ii).Tp, 8, 'k', 'filled');
    figset_date_minorticks(ax, W_QC_2022(ii).waveday)
    ylim([0 10])
    grid on
    ylabel('T (sec.)')
    xlim([floor(W_QC_2022(ii).waveday(1)) ceil(W_QC_2022(ii).waveday(end))])
    figset_date(ax, W_QC_2022(ii).waveday)
    figset_linefont(ax)
    
    ax = nexttile;
    scatter(W_QC_2022(ii).waveday, W_QC_2022(ii).Dir, 8, 'k', 'filled');
    figset_date_minorticks(ax, W_QC_2022(ii).waveday)
    grid on
    ylim([0 360])
    ylabel('Wave Dir. (^{\circ})')
    xlim([floor(W_QC_2022(ii).waveday(1)) ceil(W_QC_2022(ii).waveday(end))])
    figset_date(ax, W_QC_2022(ii).waveday)
    figset_linefont(ax)
    set(ax, 'ytick', 0:90:360)

    saving_str = sprintf("%s\\wave_diagram_%s.png", pic_w, datestr(C_QC_2022(ii).dday(1), 'yyyy_mm'));
    exportgraphics(gcf, saving_str)

end

%% monthly 2023
figset_date = @(ax, wave_day) set(ax, 'XTick', floor(wave_day(1)):3:ceil(wave_day(end)), ...
    'Xticklabel', datestr(floor(wave_day(1)):3:ceil(wave_day(end)), 'mm/dd')); % Major ticks which means 4 days

for ii = 1:length(W_QC_2023)
    if ii > 6 && ii < 11
        ii = ii;
    elseif ii == 11
        figure("OuterPosition", [1 1 1920*2/3 1080])
        tt = tiledlayout(4, 1, "TileSpacing", "compact", "Padding", "tight");
        ax = nexttile;
        plot(C_QC_2023(ii).dday, C_QC_2023(ii).Pre, 'LineWidth', 1, 'Color', 'k')
        figset_date_minorticks(ax, C_QC_2023(ii).dday)
        grid on
        ylabel('sea level (m)')
        xlim([datenum(2023, 11, 1) ceil(C_QC_2023(ii).dday(end))])
        figset_date(ax, C_QC_2023(ii).dday)
        figset_linefont(ax)
    
        ax = nexttile;
        scatter(W_QC_2023(ii).waveday, W_QC_2023(ii).Hs, 8, 'k', 'filled');
        figset_date_minorticks(ax, W_QC_2023(ii).waveday)
        grid on
        ylabel('Hs (m)')
        xlim([datenum(2023, 11, 1) ceil(W_QC_2023(ii).waveday(end))])
        figset_date(ax, W_QC_2023(ii).waveday)
        figset_linefont(ax)
        
        ax = nexttile;
        scatter(W_QC_2023(ii).waveday, W_QC_2023(ii).Tp, 8, 'k', 'filled');
        figset_date_minorticks(ax, W_QC_2023(ii).waveday)
        ylim([0 10])
        grid on
        ylabel('T (sec.)')
        xlim([datenum(2023, 11, 1) ceil(W_QC_2023(ii).waveday(end))])
        figset_date(ax, W_QC_2023(ii).waveday)
        figset_linefont(ax)
        
        ax = nexttile;
        scatter(W_QC_2023(ii).waveday, W_QC_2023(ii).Dir, 8, 'k', 'filled');
        figset_date_minorticks(ax, W_QC_2023(ii).waveday)
        grid on
        ylim([0 360])
        ylabel('Wave Dir. (^{\circ})')
        xlim([datenum(2023, 11, 1) ceil(W_QC_2023(ii).waveday(end))])
        figset_date(ax, W_QC_2023(ii).waveday)
        figset_linefont(ax)
        set(ax, 'ytick', 0:90:360)
    
        saving_str = sprintf("%s\\wave_diagram_%s.png", pic_w, datestr(C_QC_2023(ii).dday(1), 'yyyy_mm'));
        exportgraphics(gcf, saving_str)

    else
    figure("OuterPosition", [1 1 1920*2/3 1080])
    tt = tiledlayout(4, 1, "TileSpacing", "compact", "Padding", "tight");
    ax = nexttile;
    plot(C_QC_2023(ii).dday, C_QC_2023(ii).Pre, 'LineWidth', 1, 'Color', 'k')
    figset_date_minorticks(ax, C_QC_2023(ii).dday)
    grid on
    ylabel('sea level (m)')
    xlim([floor(C_QC_2023(ii).dday(1)) ceil(C_QC_2023(ii).dday(end))])
    figset_date(ax, C_QC_2023(ii).dday)
    figset_linefont(ax)

    ax = nexttile;
    scatter(W_QC_2023(ii).waveday, W_QC_2023(ii).Hs, 8, 'k', 'filled');
    figset_date_minorticks(ax, W_QC_2023(ii).waveday)
    grid on
    ylabel('Hs (m)')
    xlim([floor(W_QC_2023(ii).waveday(1)) ceil(W_QC_2023(ii).waveday(end))])
    figset_date(ax, W_QC_2023(ii).waveday)
    figset_linefont(ax)
    
    ax = nexttile;
    scatter(W_QC_2023(ii).waveday, W_QC_2023(ii).Tp, 8, 'k', 'filled');
    figset_date_minorticks(ax, W_QC_2023(ii).waveday)
    ylim([0 10])
    grid on
    ylabel('T (sec.)')
    xlim([floor(W_QC_2023(ii).waveday(1)) ceil(W_QC_2023(ii).waveday(end))])
    figset_date(ax, W_QC_2023(ii).waveday)
    figset_linefont(ax)
    
    ax = nexttile;
    scatter(W_QC_2023(ii).waveday, W_QC_2023(ii).Dir, 8, 'k', 'filled');
    figset_date_minorticks(ax, W_QC_2023(ii).waveday)
    grid on
    ylim([0 360])
    ylabel('Wave Dir. (^{\circ})')
    xlim([floor(W_QC_2023(ii).waveday(1)) ceil(W_QC_2023(ii).waveday(end))])
    figset_date(ax, W_QC_2023(ii).waveday)
    figset_linefont(ax)
    set(ax, 'ytick', 0:90:360)

    saving_str = sprintf("%s\\wave_diagram_%s.png", pic_w, datestr(C_QC_2023(ii).dday(1), 'yyyy_mm'));
    exportgraphics(gcf, saving_str)
    end
end

%% u & v
figset_date = @(ax, wave_day) set(ax, 'XTick', floor(wave_day(1)):10:ceil(wave_day(end)), ...
    'Xticklabel', datestr(floor(wave_day(1)):10:ceil(wave_day(end)), 'mm/dd')); % Major ticks which means 4 days
season = {"winter"};
u = winter.Cur_2022.*sind(winter.Dir_2022);
v = winter.Cur_2022.*cosd(winter.Dir_2022);

for ii = 1:3
    figure("OuterPosition", [1 1 1920*2/3 1080*2/3])
    tt = tiledlayout(3, 1, "TileSpacing", "compact", "Padding", "tight");
    ax = nexttile;
    plot(winter.dday_2022, u(:, ii), 'LineWidth', 1, 'Color', 'k')
    grid on
    ylim([-1 1])
    xlim([floor(winter.dday_2022(1)) ceil(winter.dday_2022(end))])
    ylabel('(m/s)')
    figset_linefont(ax)
    figset_date(ax, winter.dday_2022)
    figset_date_minorticks(ax, winter.dday_2022)
    title_str = sprintf("\\bfU, %s layer", Layers{ii});
    title(ax, title_str, 'FontSize', 18)
    title_str = sprintf("\\bf%s Winter, %s", datestr(winter.dday_2022(end), 'yyyy'), station);
    title(tt, title_str, 'FontSize', 18)
    
    ax = nexttile;
    plot(winter.dday_2022, v(:, ii), 'LineWidth', 1, 'Color', 'k')
    grid on
    ylabel('(m/s)')
    ylim([-1 1])
    xlim([floor(winter.dday_2022(1)) ceil(winter.dday_2022(end))])
    figset_linefont(ax)
    figset_date(ax, winter.dday_2022)
    figset_date_minorticks(ax, winter.dday_2022)
    title_str = sprintf("\\bfV, %s layer", Layers{ii});
    title(ax, title_str, 'FontSize', 18)
    
    ax = nexttile;
    quiver_f(winter.dday_2022, u(:, ii), v(:, ii))
    grid on
    ylabel('(m/s)')
    ylim([-1 1])
    xlim([floor(winter.dday_2022(1)) ceil(winter.dday_2022(end))])
    figset_linefont(ax)
    figset_date(ax, winter.dday_2022)
    figset_date_minorticks(ax, winter.dday_2022)
    title_str = sprintf("\\bfUV vector, %s layer", Layers{ii});
    title(ax, title_str, 'FontSize', 18)
    
    saving_str = sprintf("%s\\uv_%s_diagram_winter.png", pic_c, Layers{ii});
    exportgraphics(gcf, saving_str)

end


u = spring.Cur_2022.*sind(spring.Dir_2022);
v = spring.Cur_2022.*cosd(spring.Dir_2022);

for ii = 1:3
    figure("OuterPosition", [1 1 1920*2/3 1080*2/3])
    tt = tiledlayout(3, 1, "TileSpacing", "compact", "Padding", "tight");
    ax = nexttile;
    plot(spring.dday_2022, u(:, ii), 'LineWidth', 1, 'Color', 'k')
    grid on
    ylim([-1 1])
    xlim([floor(spring.dday_2022(1)) ceil(spring.dday_2022(end))])
    ylabel('(m/s)')
    figset_linefont(ax)
    figset_date(ax, spring.dday_2022)
    figset_date_minorticks(ax, spring.dday_2022)
    title_str = sprintf("\\bfU, %s layer", Layers{ii});
    title(ax, title_str, 'FontSize', 18)
    title_str = sprintf("\\bf%s Spring, %s", datestr(spring.dday_2022(end), 'yyyy'), station);
    title(tt, title_str, 'FontSize', 18)
    
    ax = nexttile;
    plot(spring.dday_2022, v(:, ii), 'LineWidth', 1, 'Color', 'k')
    grid on
    ylabel('(m/s)')
    ylim([-1 1])
    xlim([floor(spring.dday_2022(1)) ceil(spring.dday_2022(end))])
    figset_linefont(ax)
    figset_date(ax, spring.dday_2022)
    figset_date_minorticks(ax, spring.dday_2022)
    title_str = sprintf("\\bfV, %s layer", Layers{ii});
    title(ax, title_str, 'FontSize', 18)
    
    ax = nexttile;
    quiver_f(spring.dday_2022, u(:, ii), v(:, ii))
    grid on
    ylabel('(m/s)')
    ylim([-1 1])
    xlim([floor(spring.dday_2022(1)) ceil(spring.dday_2022(end))])
    figset_linefont(ax)
    figset_date(ax, spring.dday_2022)
    figset_date_minorticks(ax, spring.dday_2022)
    title_str = sprintf("\\bfUV vector, %s layer", Layers{ii});
    title(ax, title_str, 'FontSize', 18)
    
    saving_str = sprintf("%s\\uv_%s_diagram_spring.png", pic_c, Layers{ii});
    exportgraphics(gcf, saving_str)

end


u = summer.Cur_2022.*sind(summer.Dir_2022);
v = summer.Cur_2022.*cosd(summer.Dir_2022);

for ii = 1:3
    figure("OuterPosition", [1 1 1920*2/3 1080*2/3])
    tt = tiledlayout(3, 1, "TileSpacing", "compact", "Padding", "tight");
    ax = nexttile;
    plot(summer.dday_2022, u(:, ii), 'LineWidth', 1, 'Color', 'k')
    grid on
    ylim([-1 1])
    xlim([floor(summer.dday_2022(1)) ceil(summer.dday_2022(end))])
    ylabel('(m/s)')
    figset_linefont(ax)
    figset_date(ax, summer.dday_2022)
    figset_date_minorticks(ax, summer.dday_2022)
    title_str = sprintf("\\bfU, %s layer", Layers{ii});
    title(ax, title_str, 'FontSize', 18)
    title_str = sprintf("\\bf%s Summer, %s", datestr(summer.dday_2022(end), 'yyyy'), station);
    title(tt, title_str, 'FontSize', 18)
    
    ax = nexttile;
    plot(summer.dday_2022, v(:, ii), 'LineWidth', 1, 'Color', 'k')
    grid on
    ylabel('(m/s)')
    ylim([-1 1])
    xlim([floor(summer.dday_2022(1)) ceil(summer.dday_2022(end))])
    figset_linefont(ax)
    figset_date(ax, summer.dday_2022)
    figset_date_minorticks(ax, summer.dday_2022)
    title_str = sprintf("\\bfV, %s layer", Layers{ii});
    title(ax, title_str, 'FontSize', 18)
    
    ax = nexttile;
    quiver_f(summer.dday_2022, u(:, ii), v(:, ii))
    grid on
    ylabel('(m/s)')
    ylim([-1 1])
    xlim([floor(summer.dday_2022(1)) ceil(summer.dday_2022(end))])
    figset_linefont(ax)
    figset_date(ax, summer.dday_2022)
    figset_date_minorticks(ax, summer.dday_2022)
    title_str = sprintf("\\bfUV vector, %s layer", Layers{ii});
    title(ax, title_str, 'FontSize', 18)
    
    saving_str = sprintf("%s\\uv_%s_diagram_summer.png", pic_c, Layers{ii});
    exportgraphics(gcf, saving_str)

end


u = fall.Cur_2022.*sind(fall.Dir_2022);
v = fall.Cur_2022.*cosd(fall.Dir_2022);

for ii = 1:3
    figure("OuterPosition", [1 1 1920*2/3 1080*2/3])
    tt = tiledlayout(3, 1, "TileSpacing", "compact", "Padding", "tight");
    ax = nexttile;
    plot(fall.dday_2022, u(:, ii), 'LineWidth', 1, 'Color', 'k')
    grid on
    ylim([-1 1])
    xlim([floor(fall.dday_2022(1)) ceil(fall.dday_2022(end))])
    ylabel('(m/s)')
    figset_linefont(ax)
    figset_date(ax, fall.dday_2022)
    figset_date_minorticks(ax, fall.dday_2022)
    title_str = sprintf("\\bfU, %s layer", Layers{ii});
    title(ax, title_str, 'FontSize', 18)
    title_str = sprintf("\\bf%s Fall, %s", datestr(fall.dday_2022(end), 'yyyy'), station);
    title(tt, title_str, 'FontSize', 18)
    
    ax = nexttile;
    plot(fall.dday_2022, v(:, ii), 'LineWidth', 1, 'Color', 'k')
    grid on
    ylabel('(m/s)')
    ylim([-1 1])
    xlim([floor(fall.dday_2022(1)) ceil(fall.dday_2022(end))])
    figset_linefont(ax)
    figset_date(ax, fall.dday_2022)
    figset_date_minorticks(ax, fall.dday_2022)
    title_str = sprintf("\\bfV, %s layer", Layers{ii});
    title(ax, title_str, 'FontSize', 18)
    
    ax = nexttile;
    quiver_f(fall.dday_2022, u(:, ii), v(:, ii))
    grid on
    ylabel('(m/s)')
    ylim([-1 1])
    xlim([floor(fall.dday_2022(1)) ceil(fall.dday_2022(end))])
    figset_linefont(ax)
    figset_date(ax, fall.dday_2022)
    figset_date_minorticks(ax, fall.dday_2022)
    title_str = sprintf("\\bfUV vector, %s layer", Layers{ii});
    title(ax, title_str, 'FontSize', 18)
    
    saving_str = sprintf("%s\\uv_%s_diagram_fall.png", pic_c, Layers{ii});
    exportgraphics(gcf, saving_str)

end


%% u & v
figset_date = @(ax, wave_day) set(ax, 'XTick', floor(wave_day(1)):10:ceil(wave_day(end)), ...
    'Xticklabel', datestr(floor(wave_day(1)):10:ceil(wave_day(end)), 'mm/dd')); % Major ticks which means 4 days
season = {"winter"};
u = winter.Cur_2023.*sind(winter.Dir_2023);
v = winter.Cur_2023.*cosd(winter.Dir_2023);

for ii = 1:3
    figure("OuterPosition", [1 1 1920*2/3 1080*2/3])
    tt = tiledlayout(3, 1, "TileSpacing", "compact", "Padding", "tight");
    ax = nexttile;
    plot(winter.dday_2023, u(:, ii), 'LineWidth', 1, 'Color', 'k')
    grid on
    ylim([-1 1])
    xlim([floor(winter.dday_2023(1)) ceil(winter.dday_2023(end))])
    ylabel('(m/s)')
    figset_linefont(ax)
    figset_date(ax, winter.dday_2023)
    figset_date_minorticks(ax, winter.dday_2023)
    title_str = sprintf("\\bfU, %s layer", Layers{ii});
    title(ax, title_str, 'FontSize', 18)
    title_str = sprintf("\\bf%s Winter, %s", datestr(winter.dday_2023(end), 'yyyy'), station);
    title(tt, title_str, 'FontSize', 18)
    
    ax = nexttile;
    plot(winter.dday_2023, v(:, ii), 'LineWidth', 1, 'Color', 'k')
    grid on
    ylabel('(m/s)')
    ylim([-1 1])
    xlim([floor(winter.dday_2023(1)) ceil(winter.dday_2023(end))])
    figset_linefont(ax)
    figset_date(ax, winter.dday_2023)
    figset_date_minorticks(ax, winter.dday_2023)
    title_str = sprintf("\\bfV, %s layer", Layers{ii});
    title(ax, title_str, 'FontSize', 18)
    
    ax = nexttile;
    quiver_f(winter.dday_2023, u(:, ii), v(:, ii))
    grid on
    ylabel('(m/s)')
    ylim([-1 1])
    xlim([floor(winter.dday_2023(1)) ceil(winter.dday_2023(end))])
    figset_linefont(ax)
    figset_date(ax, winter.dday_2023)
    figset_date_minorticks(ax, winter.dday_2023)
    title_str = sprintf("\\bfUV vector, %s layer", Layers{ii});
    title(ax, title_str, 'FontSize', 18)
    
    saving_str = sprintf("%s\\uv_%s_diagram_winter.png", pic_c, Layers{ii});
    exportgraphics(gcf, saving_str)

end


u = spring.Cur_2023.*sind(spring.Dir_2023);
v = spring.Cur_2023.*cosd(spring.Dir_2023);

for ii = 1:3
    figure("OuterPosition", [1 1 1920*2/3 1080*2/3])
    tt = tiledlayout(3, 1, "TileSpacing", "compact", "Padding", "tight");
    ax = nexttile;
    plot(spring.dday_2023, u(:, ii), 'LineWidth', 1, 'Color', 'k')
    grid on
    ylim([-1 1])
    xlim([floor(spring.dday_2023(1)) ceil(spring.dday_2023(end))])
    ylabel('(m/s)')
    figset_linefont(ax)
    figset_date(ax, spring.dday_2023)
    figset_date_minorticks(ax, spring.dday_2023)
    title_str = sprintf("\\bfU, %s layer", Layers{ii});
    title(ax, title_str, 'FontSize', 18)
    title_str = sprintf("\\bf%s Spring, %s", datestr(spring.dday_2023(end), 'yyyy'), station);
    title(tt, title_str, 'FontSize', 18)
    
    ax = nexttile;
    plot(spring.dday_2023, v(:, ii), 'LineWidth', 1, 'Color', 'k')
    grid on
    ylabel('(m/s)')
    ylim([-1 1])
    xlim([floor(spring.dday_2023(1)) ceil(spring.dday_2023(end))])
    figset_linefont(ax)
    figset_date(ax, spring.dday_2023)
    figset_date_minorticks(ax, spring.dday_2023)
    title_str = sprintf("\\bfV, %s layer", Layers{ii});
    title(ax, title_str, 'FontSize', 18)
    
    ax = nexttile;
    quiver_f(spring.dday_2023, u(:, ii), v(:, ii))
    grid on
    ylabel('(m/s)')
    ylim([-1 1])
    xlim([floor(spring.dday_2023(1)) ceil(spring.dday_2023(end))])
    figset_linefont(ax)
    figset_date(ax, spring.dday_2023)
    figset_date_minorticks(ax, spring.dday_2023)
    title_str = sprintf("\\bfUV vector, %s layer", Layers{ii});
    title(ax, title_str, 'FontSize', 18)
    
    saving_str = sprintf("%s\\uv_%s_diagram_spring.png", pic_c, Layers{ii});
    exportgraphics(gcf, saving_str)

end


u = summer.Cur_2023.*sind(summer.Dir_2023);
v = summer.Cur_2023.*cosd(summer.Dir_2023);

for ii = 1:3
    figure("OuterPosition", [1 1 1920*2/3 1080*2/3])
    tt = tiledlayout(3, 1, "TileSpacing", "compact", "Padding", "tight");
    ax = nexttile;
    plot(summer.dday_2023, u(:, ii), 'LineWidth', 1, 'Color', 'k')
    grid on
    ylim([-1 1])
    xlim([floor(summer.dday_2023(1)) ceil(summer.dday_2023(end))])
    ylabel('(m/s)')
    figset_linefont(ax)
    figset_date(ax, summer.dday_2023)
    figset_date_minorticks(ax, summer.dday_2023)
    title_str = sprintf("\\bfU, %s layer", Layers{ii});
    title(ax, title_str, 'FontSize', 18)
    title_str = sprintf("\\bf%s Summer, %s", datestr(summer.dday_2023(end), 'yyyy'), station);
    title(tt, title_str, 'FontSize', 18)
    
    ax = nexttile;
    plot(summer.dday_2023, v(:, ii), 'LineWidth', 1, 'Color', 'k')
    grid on
    ylabel('(m/s)')
    ylim([-1 1])
    xlim([floor(summer.dday_2023(1)) ceil(summer.dday_2023(end))])
    figset_linefont(ax)
    figset_date(ax, summer.dday_2023)
    figset_date_minorticks(ax, summer.dday_2023)
    title_str = sprintf("\\bfV, %s layer", Layers{ii});
    title(ax, title_str, 'FontSize', 18)
    
    ax = nexttile;
    quiver_f(summer.dday_2023, u(:, ii), v(:, ii))
    grid on
    ylabel('(m/s)')
    ylim([-1 1])
    xlim([floor(summer.dday_2023(1)) ceil(summer.dday_2023(end))])
    figset_linefont(ax)
    figset_date(ax, summer.dday_2023)
    figset_date_minorticks(ax, summer.dday_2023)
    title_str = sprintf("\\bfUV vector, %s layer", Layers{ii});
    title(ax, title_str, 'FontSize', 18)
    
    saving_str = sprintf("%s\\uv_%s_diagram_summer.png", pic_c, Layers{ii});
    exportgraphics(gcf, saving_str)

end


u = fall.Cur_2023.*sind(fall.Dir_2023);
v = fall.Cur_2023.*cosd(fall.Dir_2023);

for ii = 1:3
    figure("OuterPosition", [1 1 1920*2/3 1080*2/3])
    tt = tiledlayout(3, 1, "TileSpacing", "compact", "Padding", "tight");
    ax = nexttile;
    plot(fall.dday_2023, u(:, ii), 'LineWidth', 1, 'Color', 'k')
    grid on
    ylim([-1 1])
    xlim([floor(fall.dday_2023(1)) ceil(fall.dday_2023(end))])
    ylabel('(m/s)')
    figset_linefont(ax)
    figset_date(ax, fall.dday_2023)
    figset_date_minorticks(ax, fall.dday_2023)
    title_str = sprintf("\\bfU, %s layer", Layers{ii});
    title(ax, title_str, 'FontSize', 18)
    title_str = sprintf("\\bf%s Fall, %s", datestr(fall.dday_2023(end), 'yyyy'), station);
    title(tt, title_str, 'FontSize', 18)
    
    ax = nexttile;
    plot(fall.dday_2023, v(:, ii), 'LineWidth', 1, 'Color', 'k')
    grid on
    ylabel('(m/s)')
    ylim([-1 1])
    xlim([floor(fall.dday_2023(1)) ceil(fall.dday_2023(end))])
    figset_linefont(ax)
    figset_date(ax, fall.dday_2023)
    figset_date_minorticks(ax, fall.dday_2023)
    title_str = sprintf("\\bfV, %s layer", Layers{ii});
    title(ax, title_str, 'FontSize', 18)
    
    ax = nexttile;
    quiver_f(fall.dday_2023, u(:, ii), v(:, ii))
    grid on
    ylabel('(m/s)')
    ylim([-1 1])
    xlim([floor(fall.dday_2023(1)) ceil(fall.dday_2023(end))])
    figset_linefont(ax)
    figset_date(ax, fall.dday_2023)
    figset_date_minorticks(ax, fall.dday_2023)
    title_str = sprintf("\\bfUV vector, %s layer", Layers{ii});
    title(ax, title_str, 'FontSize', 18)
    
    saving_str = sprintf("%s\\uv_%s_diagram_fall.png", pic_c, Layers{ii});
    exportgraphics(gcf, saving_str)

end


%% monthly
figset_date = @(ax, wave_day) set(ax, 'XTick', floor(wave_day(1)):3:ceil(wave_day(end)), ...
    'Xticklabel', datestr(floor(wave_day(1)):3:ceil(wave_day(end)), 'mm/dd')); % Major ticks which means 4 days

for jj = 1:length(C_QC_2022)
u = C_QC_2022(jj).Cur.*sind(C_QC_2022(jj).Dir);
v = C_QC_2022(jj).Cur.*cosd(C_QC_2022(jj).Dir);

for ii = 1:3
    figure("OuterPosition", [1 1 1920*2/3 1080*2/3])
    tt = tiledlayout(3, 1, "TileSpacing", "compact", "Padding", "tight");
    ax = nexttile;
    plot(C_QC_2022(jj).dday, u(:, ii), 'LineWidth', 1, 'Color', 'k')
    grid on
    ylim([-1 1])
    xlim([floor(C_QC_2022(jj).dday(1)) ceil(C_QC_2022(jj).dday(end))])
    ylabel('(m/s)')
    figset_linefont(ax)
    figset_date(ax,C_QC_2022(jj).dday)
    figset_date_minorticks(ax, C_QC_2022(jj).dday)
    title_str = sprintf("\\bfU, %s layer", Layers{ii});
    title(ax, title_str, 'FontSize', 18)
    title_str = sprintf("\\bf%s %s, %s", datestr(C_QC_2022(jj).dday(end), 'yyyy'), datestr(C_QC_2022(jj).dday(end), 'mmm'), station);
    title(tt, title_str, 'FontSize', 18)
    
    ax = nexttile;
    plot(C_QC_2022(jj).dday, v(:, ii), 'LineWidth', 1, 'Color', 'k')
    grid on
    ylabel('(m/s)')
    ylim([-1 1])
    xlim([floor(C_QC_2022(jj).dday(1)) ceil(C_QC_2022(jj).dday(end))])
    figset_linefont(ax)
    figset_date(ax, C_QC_2022(jj).dday)
    figset_date_minorticks(ax, C_QC_2022(jj).dday)
    title_str = sprintf("\\bfV, %s layer", Layers{ii});
    title(ax, title_str, 'FontSize', 18)
    
    ax = nexttile;
    quiver_f(C_QC_2022(jj).dday, u(:, ii), v(:, ii))
    grid on
    ylabel('(m/s)')
    ylim([-1 1])
    xlim([floor(C_QC_2022(jj).dday(1)) ceil(C_QC_2022(jj).dday(end))])
    figset_linefont(ax)
    figset_date(ax, C_QC_2022(jj).dday)
    figset_date_minorticks(ax, C_QC_2022(jj).dday)
    title_str = sprintf("\\bfUV vector, %s layer", Layers{ii});
    title(ax, title_str, 'FontSize', 18)
    
    saving_str = sprintf("%s\\uv_%s_diagram_%s.png", pic_c, Layers{ii}, datestr(C_QC_2022(jj).dday(end), 'yyyy_mm'));
    exportgraphics(gcf, saving_str)
end
end
close all;

for jj = 1:length(C_QC_2023)
u = C_QC_2023(jj).Cur.*sind(C_QC_2023(jj).Dir);
v = C_QC_2023(jj).Cur.*cosd(C_QC_2023(jj).Dir);

for ii = 1:3
    if ii > 6 && ii < 11
        ii = ii;
    elseif ii == 11
        figure("OuterPosition", [1 1 1920*2/3 1080*2/3])
        tt = tiledlayout(3, 1, "TileSpacing", "compact", "Padding", "tight");
        ax = nexttile;
        plot(C_QC_2023(jj).dday, u(:, ii), 'LineWidth', 1, 'Color', 'k')
        grid on
        ylim([-1 1])
        xlim([datenum(2023, 11, 1) ceil(C_QC_2023(jj).dday(end))])
        ylabel('(m/s)')
        figset_linefont(ax)
        figset_date(ax,C_QC_2023(jj).dday)
        figset_date_minorticks(ax, C_QC_2023(jj).dday)
        title_str = sprintf("\\bfU, %s layer", Layers{ii});
        title(ax, title_str, 'FontSize', 18)
        title_str = sprintf("\\bf%s %s, %s", datestr(C_QC_2023(jj).dday(end), 'yyyy'), datestr(C_QC_2023(jj).dday(end), 'mmm'), station);
        title(tt, title_str, 'FontSize', 18)
        
        ax = nexttile;
        plot(C_QC_2023(jj).dday, v(:, ii), 'LineWidth', 1, 'Color', 'k')
        grid on
        ylabel('(m/s)')
        ylim([-1 1])
        xlim([datenum(2023, 11, 1) ceil(C_QC_2023(jj).dday(end))])
        figset_linefont(ax)
        figset_date(ax, C_QC_2023(jj).dday)
        figset_date_minorticks(ax, C_QC_2023(jj).dday)
        title_str = sprintf("\\bfV, %s layer", Layers{ii});
        title(ax, title_str, 'FontSize', 18)
        
        ax = nexttile;
        quiver_f(C_QC_2023(jj).dday, u(:, ii), v(:, ii))
        grid on
        ylabel('(m/s)')
        ylim([-1 1])
        xlim([datenum(2023, 11, 1) ceil(C_QC_2023(jj).dday(end))])
        figset_linefont(ax)
        figset_date(ax, C_QC_2023(jj).dday)
        figset_date_minorticks(ax, C_QC_2023(jj).dday)
        title_str = sprintf("\\bfUV vector, %s layer", Layers{ii});
        title(ax, title_str, 'FontSize', 18)
        
        saving_str = sprintf("%s\\uv_%s_diagram_%s.png", pic_c, Layers{ii}, datestr(C_QC_2023(jj).dday(end), 'yyyy_mm'));
        exportgraphics(gcf, saving_str)
    else
    figure("OuterPosition", [1 1 1920*2/3 1080*2/3])
    tt = tiledlayout(3, 1, "TileSpacing", "compact", "Padding", "tight");
    ax = nexttile;
    plot(C_QC_2023(jj).dday, u(:, ii), 'LineWidth', 1, 'Color', 'k')
    grid on
    ylim([-1 1])
    xlim([floor(C_QC_2023(jj).dday(1)) ceil(C_QC_2023(jj).dday(end))])
    ylabel('(m/s)')
    figset_linefont(ax)
    figset_date(ax,C_QC_2023(jj).dday)
    figset_date_minorticks(ax, C_QC_2023(jj).dday)
    title_str = sprintf("\\bfU, %s layer", Layers{ii});
    title(ax, title_str, 'FontSize', 18)
    title_str = sprintf("\\bf%s %s, %s", datestr(C_QC_2023(jj).dday(end), 'yyyy'), datestr(C_QC_2023(jj).dday(end), 'mmm'), station);
    title(tt, title_str, 'FontSize', 18)
    
    ax = nexttile;
    plot(C_QC_2023(jj).dday, v(:, ii), 'LineWidth', 1, 'Color', 'k')
    grid on
    ylabel('(m/s)')
    ylim([-1 1])
    xlim([floor(C_QC_2023(jj).dday(1)) ceil(C_QC_2023(jj).dday(end))])
    figset_linefont(ax)
    figset_date(ax, C_QC_2023(jj).dday)
    figset_date_minorticks(ax, C_QC_2023(jj).dday)
    title_str = sprintf("\\bfV, %s layer", Layers{ii});
    title(ax, title_str, 'FontSize', 18)
    
    ax = nexttile;
    quiver_f(C_QC_2023(jj).dday, u(:, ii), v(:, ii))
    grid on
    ylabel('(m/s)')
    ylim([-1 1])
    xlim([floor(C_QC_2023(jj).dday(1)) ceil(C_QC_2023(jj).dday(end))])
    figset_linefont(ax)
    figset_date(ax, C_QC_2023(jj).dday)
    figset_date_minorticks(ax, C_QC_2023(jj).dday)
    title_str = sprintf("\\bfUV vector, %s layer", Layers{ii});
    title(ax, title_str, 'FontSize', 18)
    
    saving_str = sprintf("%s\\uv_%s_diagram_%s.png", pic_c, Layers{ii}, datestr(C_QC_2023(jj).dday(end), 'yyyy_mm'));
    exportgraphics(gcf, saving_str)
    end
end
end

