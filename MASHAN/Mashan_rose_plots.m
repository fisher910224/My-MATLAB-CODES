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

    ig = find(C_QC_2023(ii).SL_flag(:, 12) > flag_threshold);
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
all_WDir_2022 = [];
all_waveday_2022 = [];
all_Cur_2022 = [];
all_Dir_2022 = [];
all_dday_2022 = [];

all_Hs_2023 = [];
all_WDir_2023 = [];
all_waveday_2023 = [];
all_Cur_2023 = [];
all_Dir_2023 = [];
all_dday_2023 = [];

for ii = 1:length(W_QC_2022)
    all_waveday_2022 = [all_waveday_2022; W_QC_2022(ii).waveday];
    all_Hs_2022 = [all_Hs_2022; W_QC_2022(ii).Hs];
    all_WDir_2022 = [all_WDir_2022; W_QC_2022(ii).Dir];
    all_dday_2022 = [all_dday_2022; C_QC_2022(ii).dday];
    all_Cur_2022 = [all_Cur_2022; C_QC_2022(ii).Cur];
    all_Dir_2022 = [all_Dir_2022; C_QC_2022(ii).Dir];

    all_waveday_2023 = [all_waveday_2023; W_QC_2023(ii).waveday];
    all_Hs_2023 = [all_Hs_2023; W_QC_2023(ii).Hs];
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


%% Rose Hs Dir
figure("OuterPosition", [1 1 1920/2 1080])
tt = tiledlayout(3, 1, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
title_str = sprintf("Hs, %s~%s", datestr(all_waveday_2022(1), 'yyyy/mm'), datestr(all_waveday_2022(end), 'mm'));
clear Options % 清除舊變數確保乾淨
Options.nDirections     = 16;
Options.AngleNorth      = 0;
Options.AngleEast       = 90;
Options.labels          = {'N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE', 'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW'};
Options.gridstyle       = ':';
Options.radialgridstyle = ':';
Options.gridcolor       = 'k';
Options.gridwidth       = 1.2;
Options.gridalpha       = 0.5;
Options.MaxFrequency    = 40;
Options.nfreq           = 4;
Options.FreqLabelAngle  = 270;
Options.zeroAndNegative = true;
Options.cMap            = 'invgray';
Options.vWinds          = [0, 25, 50, 75, 100];
Options.LabLegend       = '(cm)';
Options.LegendVariable  = 'Hs';
Options.scalefactor     = 0.9;
Options.TitleString     = title_str;
Options.axes            = ax;

Rose_dir = all_WDir_2022(~isnan(all_WDir_2022));
Rose_Hs = all_Hs_2022(~isnan(all_Hs_2022))*100;
% Rose_dir = [WDir_202112(~isnan(WDir_202112)); all_WDir_2022(~isnan(all_WDir_2022))];
% Rose_Hs = [Hs_202112(~isnan(Hs_202112)); all_Hs_2022(~isnan(all_Hs_2022))]*100;
% Rose_dir = [WDir_202112; all_WDir_2022(~isnan(all_WDir_2022))];
% Rose_Hs = [Hs_202112; all_Hs_2022(~isnan(all_Hs_2022))]*100;
WindRose(Rose_dir, Rose_Hs, Options);
figset_linefont(ax)
set(ax.Legend, 'Location', 'southeastoutside', 'Box', 'off')
set(ax, 'TitleHorizontalAlignment', 'left')
all_text = findall(ax, 'Type', 'text');
for ii = 1:length(all_text)
    txt_str = all_text(ii).String;
    
    % 如果文字中包含 '%'，代表它是頻率標籤
    if contains(txt_str, '%')
        set(all_text(ii), ...
            'HorizontalAlignment', 'center', ...   % 水平對齊：left, center, right
            'VerticalAlignment', 'bottom', ...   % 垂直對齊：top, middle, bottom
            'FontSize', 10, ...                  % 字體大小
            'FontWeight', 'bold', ...            % 加粗
            'Color', [0.2 0.2 0.2], ...          % 深灰色
            'FontName', 'Helvetica');            % 字體名稱
            
        % 如果你想讓文字稍微「位移」一點點，不要貼在線上面：
        % pos = all_text(i).Position;
        % all_text(i).Position = pos + [0.5 0 0]; % 往右位移 0.5 單位
    end
end


ax = nexttile;
title_str = sprintf("Hs, %s~%s", datestr(all_waveday_2023(1), 'yyyy/mm'), datestr(all_waveday_2023(end), 'mm'));
Options.TitleString     = title_str;
Options.axes            = ax;
Options.MaxFrequency    = 25;
Options.nfreq           = 5;
Rose_dir = all_WDir_2023(~isnan(all_WDir_2023));
Rose_Hs = all_Hs_2023(~isnan(all_Hs_2023))*100;
WindRose(Rose_dir, Rose_Hs, Options);
figset_linefont(ax)
set(ax.Legend, 'Location', 'southeastoutside', 'Box', 'off')
set(ax, 'TitleHorizontalAlignment', 'left')
all_text = findall(ax, 'Type', 'text');
for ii = 1:length(all_text)
    txt_str = all_text(ii).String;
    
    % 如果文字中包含 '%'，代表它是頻率標籤
    if contains(txt_str, '%')
        set(all_text(ii), ...
            'HorizontalAlignment', 'center', ...   % 水平對齊：left, center, right
            'VerticalAlignment', 'bottom', ...   % 垂直對齊：top, middle, bottom
            'FontSize', 10, ...                  % 字體大小
            'FontWeight', 'bold', ...            % 加粗
            'Color', [0.2 0.2 0.2], ...          % 深灰色
            'FontName', 'Helvetica');            % 字體名稱
            
        % 如果你想讓文字稍微「位移」一點點，不要貼在線上面：
        % pos = all_text(i).Position;
        % all_text(i).Position = pos + [0.5 0 0]; % 往右位移 0.5 單位
    end
end


ax = nexttile;
title_str = sprintf("Hs, %s~%s", datestr(all_waveday_2022(1), 'yyyy'), datestr(all_waveday_2023(end), 'yyyy'));
Options.TitleString     = title_str;
Options.axes            = ax;
Options.MaxFrequency    = 30;
Options.nfreq           = 3;
Rose_dir = [all_WDir_2022(~isnan(all_WDir_2022)); all_WDir_2023(~isnan(all_WDir_2023))];
Rose_Hs = [all_Hs_2022(~isnan(all_Hs_2022)); all_Hs_2022(~isnan(all_Hs_2023))]*100;
WindRose(Rose_dir, Rose_Hs, Options);
% WindRose([all_WDir_2022; all_WDir_2023], [all_Hs_2022; all_Hs_2023]*100, Options);
figset_linefont(ax)
set(ax.Legend, 'Location', 'southeastoutside', 'Box', 'off')
set(ax, 'TitleHorizontalAlignment', 'left')
all_text = findall(ax, 'Type', 'text');
for ii = 1:length(all_text)
    txt_str = all_text(ii).String;
    
    % 如果文字中包含 '%'，代表它是頻率標籤
    if contains(txt_str, '%')
        set(all_text(ii), ...
            'HorizontalAlignment', 'center', ...   % 水平對齊：left, center, right
            'VerticalAlignment', 'bottom', ...   % 垂直對齊：top, middle, bottom
            'FontSize', 10, ...                  % 字體大小
            'FontWeight', 'bold', ...            % 加粗
            'Color', [0.2 0.2 0.2], ...          % 深灰色
            'FontName', 'Helvetica');            % 字體名稱
            
        % 如果你想讓文字稍微「位移」一點點，不要貼在線上面：
        % pos = all_text(i).Position;
        % all_text(i).Position = pos + [0.5 0 0]; % 往右位移 0.5 單位
    end
end
save_str = sprintf("%s\\Rose_Hs.png", pic_w);
exportgraphics(gcf, save_str)


%% Seasonal Rose
figure("OuterPosition", [1 1 1920/2 1080])
tt = tiledlayout(3, 2, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
title_str = sprintf("Hs, Winter(%s~%s)", datestr(winter.waveday_2022(1), 'yyyy/mm'), datestr(winter.waveday_2022(end), 'yyyy/mm'));
clear Options % 清除舊變數確保乾淨
Options.nDirections     = 16;
Options.AngleNorth      = 0;
Options.AngleEast       = 90;
Options.labels          = {'N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE', 'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW'};
Options.gridstyle       = ':';
Options.radialgridstyle = ':';
Options.gridcolor       = 'k';
Options.gridwidth       = 1.2;
Options.gridalpha       = 0.5;
Options.MaxFrequency    = 40;
Options.nfreq           = 4;
Options.FreqLabelAngle  = 270;
Options.zeroAndNegative = true;
Options.cMap            = 'invgray';
Options.vWinds          = [0, 25, 50, 75, 100];
Options.LabLegend       = '(cm)';
Options.LegendVariable  = 'Hs';
Options.scalefactor     = 0.9;
Options.TitleString     = title_str;
Options.axes            = ax;

Rose_dir = winter.WDir_2022(~isnan(winter.WDir_2022));
Rose_Hs = winter.Hs_2022(~isnan(winter.Hs_2022))*100;
less_length = min([length(Rose_Hs) length(Rose_dir)]);
WindRose(Rose_dir(1:less_length), Rose_Hs(1:less_length), Options);
figset_linefont(ax)
set(ax.Legend, 'Location', 'southeastoutside', 'Box', 'off')
set(ax, 'TitleHorizontalAlignment', 'left')
all_text = findall(ax, 'Type', 'text');
for ii = 1:length(all_text)
    txt_str = all_text(ii).String;
    
    % 如果文字中包含 '%'，代表它是頻率標籤
    if contains(txt_str, '%')
        set(all_text(ii), ...
            'HorizontalAlignment', 'center', ...   % 水平對齊：left, center, right
            'VerticalAlignment', 'bottom', ...   % 垂直對齊：top, middle, bottom
            'FontSize', 10, ...                  % 字體大小
            'FontWeight', 'bold', ...            % 加粗
            'Color', [0.2 0.2 0.2], ...          % 深灰色
            'FontName', 'Helvetica');            % 字體名稱
            
        % 如果你想讓文字稍微「位移」一點點，不要貼在線上面：
        % pos = all_text(i).Position;
        % all_text(i).Position = pos + [0.5 0 0]; % 往右位移 0.5 單位
    end
end

ax = nexttile;
title_str = sprintf("Hs, Spring(%s~%s)", datestr(spring.waveday_2022(1), 'yyyy/mm'), datestr(spring.waveday_2022(end), 'mm'));
Options.TitleString     = title_str;
Options.axes            = ax;
Rose_dir = spring.WDir_2022(~isnan(spring.WDir_2022));
Rose_Hs = spring.Hs_2022(~isnan(spring.Hs_2022))*100;
less_length = min([length(Rose_Hs) length(Rose_dir)]);
WindRose(Rose_dir(1:less_length), Rose_Hs(1:less_length), Options);
figset_linefont(ax)
set(ax.Legend, 'Location', 'southeastoutside', 'Box', 'off')
set(ax, 'TitleHorizontalAlignment', 'left')
all_text = findall(ax, 'Type', 'text');
for ii = 1:length(all_text)
    txt_str = all_text(ii).String;
    
    % 如果文字中包含 '%'，代表它是頻率標籤
    if contains(txt_str, '%')
        set(all_text(ii), ...
            'HorizontalAlignment', 'center', ...   % 水平對齊：left, center, right
            'VerticalAlignment', 'bottom', ...   % 垂直對齊：top, middle, bottom
            'FontSize', 10, ...                  % 字體大小
            'FontWeight', 'bold', ...            % 加粗
            'Color', [0.2 0.2 0.2], ...          % 深灰色
            'FontName', 'Helvetica');            % 字體名稱
            
        % 如果你想讓文字稍微「位移」一點點，不要貼在線上面：
        % pos = all_text(i).Position;
        % all_text(i).Position = pos + [0.5 0 0]; % 往右位移 0.5 單位
    end
end


ax = nexttile;
title_str = sprintf("Hs, Summer(%s~%s)", datestr(summer.waveday_2022(1), 'yyyy/mm'), datestr(summer.waveday_2022(end), 'mm'));
Options.TitleString     = title_str;
Options.axes            = ax;
Rose_dir = summer.WDir_2022(~isnan(summer.WDir_2022));
Rose_Hs = summer.Hs_2022(~isnan(summer.Hs_2022))*100;
less_length = min([length(Rose_Hs) length(Rose_dir)]);
WindRose(Rose_dir(1:less_length), Rose_Hs(1:less_length), Options);
figset_linefont(ax)
set(ax.Legend, 'Location', 'southeastoutside', 'Box', 'off')
set(ax, 'TitleHorizontalAlignment', 'left')
all_text = findall(ax, 'Type', 'text');
for ii = 1:length(all_text)
    txt_str = all_text(ii).String;
    
    % 如果文字中包含 '%'，代表它是頻率標籤
    if contains(txt_str, '%')
        set(all_text(ii), ...
            'HorizontalAlignment', 'center', ...   % 水平對齊：left, center, right
            'VerticalAlignment', 'bottom', ...   % 垂直對齊：top, middle, bottom
            'FontSize', 10, ...                  % 字體大小
            'FontWeight', 'bold', ...            % 加粗
            'Color', [0.2 0.2 0.2], ...          % 深灰色
            'FontName', 'Helvetica');            % 字體名稱
            
        % 如果你想讓文字稍微「位移」一點點，不要貼在線上面：
        % pos = all_text(i).Position;
        % all_text(i).Position = pos + [0.5 0 0]; % 往右位移 0.5 單位
    end
end



ax = nexttile;
title_str = sprintf("Hs, Fall(%s~%s)", datestr(fall.waveday_2022(1), 'yyyy/mm'), datestr(fall.waveday_2022(end), 'mm'));
Options.TitleString     = title_str;
Options.axes            = ax;
Rose_dir = fall.WDir_2022(~isnan(fall.WDir_2022));
Rose_Hs = fall.Hs_2022(~isnan(fall.Hs_2022))*100;
less_length = min([length(Rose_Hs) length(Rose_dir)]);
WindRose(Rose_dir(1:less_length), Rose_Hs(1:less_length), Options);
figset_linefont(ax)
set(ax.Legend, 'Location', 'southeastoutside', 'Box', 'off')
set(ax, 'TitleHorizontalAlignment', 'left')
all_text = findall(ax, 'Type', 'text');
for ii = 1:length(all_text)
    txt_str = all_text(ii).String;
    
    % 如果文字中包含 '%'，代表它是頻率標籤
    if contains(txt_str, '%')
        set(all_text(ii), ...
            'HorizontalAlignment', 'center', ...   % 水平對齊：left, center, right
            'VerticalAlignment', 'bottom', ...   % 垂直對齊：top, middle, bottom
            'FontSize', 10, ...                  % 字體大小
            'FontWeight', 'bold', ...            % 加粗
            'Color', [0.2 0.2 0.2], ...          % 深灰色
            'FontName', 'Helvetica');            % 字體名稱
            
        % 如果你想讓文字稍微「位移」一點點，不要貼在線上面：
        % pos = all_text(i).Position;
        % all_text(i).Position = pos + [0.5 0 0]; % 往右位移 0.5 單位
    end
end


ax = nexttile;
title_str = sprintf("Hs, Winter(%s~%s)", datestr(winter.waveday_2023(1), 'yyyy/mm'), datestr(winter.waveday_2023(end), 'yyyy/mm'));
Options.TitleString     = title_str;
Options.axes            = ax;

Rose_dir = winter.WDir_2023(~isnan(winter.WDir_2023));
Rose_Hs = winter.Hs_2023(~isnan(winter.Hs_2023))*100;
less_length = min([length(Rose_Hs) length(Rose_dir)]);
WindRose(Rose_dir(1:less_length), Rose_Hs(1:less_length), Options);
figset_linefont(ax)
set(ax.Legend, 'Location', 'southeastoutside', 'Box', 'off')
set(ax, 'TitleHorizontalAlignment', 'left')
all_text = findall(ax, 'Type', 'text');
for ii = 1:length(all_text)
    txt_str = all_text(ii).String;
    
    % 如果文字中包含 '%'，代表它是頻率標籤
    if contains(txt_str, '%')
        set(all_text(ii), ...
            'HorizontalAlignment', 'center', ...   % 水平對齊：left, center, right
            'VerticalAlignment', 'bottom', ...   % 垂直對齊：top, middle, bottom
            'FontSize', 10, ...                  % 字體大小
            'FontWeight', 'bold', ...            % 加粗
            'Color', [0.2 0.2 0.2], ...          % 深灰色
            'FontName', 'Helvetica');            % 字體名稱
            
        % 如果你想讓文字稍微「位移」一點點，不要貼在線上面：
        % pos = all_text(i).Position;
        % all_text(i).Position = pos + [0.5 0 0]; % 往右位移 0.5 單位
    end
end


ax = nexttile;
title_str = sprintf("Hs, Spring(%s~%s)", datestr(spring.waveday_2023(1), 'yyyy/mm'), datestr(spring.waveday_2023(end), 'mm'));
Options.TitleString     = title_str;
Options.axes            = ax;
Rose_dir = spring.WDir_2023(~isnan(spring.WDir_2023));
Rose_Hs = spring.Hs_2023(~isnan(spring.Hs_2023))*100;
less_length = min([length(Rose_Hs) length(Rose_dir)]);
WindRose(Rose_dir(1:less_length), Rose_Hs(1:less_length), Options);
figset_linefont(ax)
set(ax.Legend, 'Location', 'southeastoutside', 'Box', 'off')
set(ax, 'TitleHorizontalAlignment', 'left')
all_text = findall(ax, 'Type', 'text');
for ii = 1:length(all_text)
    txt_str = all_text(ii).String;
    
    % 如果文字中包含 '%'，代表它是頻率標籤
    if contains(txt_str, '%')
        set(all_text(ii), ...
            'HorizontalAlignment', 'center', ...   % 水平對齊：left, center, right
            'VerticalAlignment', 'bottom', ...   % 垂直對齊：top, middle, bottom
            'FontSize', 10, ...                  % 字體大小
            'FontWeight', 'bold', ...            % 加粗
            'Color', [0.2 0.2 0.2], ...          % 深灰色
            'FontName', 'Helvetica');            % 字體名稱
            
        % 如果你想讓文字稍微「位移」一點點，不要貼在線上面：
        % pos = all_text(i).Position;
        % all_text(i).Position = pos + [0.5 0 0]; % 往右位移 0.5 單位
    end
end


save_str = sprintf("%s\\Rose_seasonal_Hs.png", pic_w);
exportgraphics(gcf, save_str)


%% Rose Monthly
figure("OuterPosition", [1 1 1920/2 1080])
tt = tiledlayout(4, 3, "TileSpacing", "compact", "Padding", "tight");
clear Options % 清除舊變數確保乾淨
Options.nDirections     = 16;
Options.AngleNorth      = 0;
Options.AngleEast       = 90;
Options.labels          = {'N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE', 'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW'};
Options.gridstyle       = ':';
Options.radialgridstyle = ':';
Options.gridcolor       = 'k';
Options.gridwidth       = 1;
Options.gridalpha       = 0.5;
Options.MaxFrequency    = 40;
Options.nfreq           = 4;
Options.FreqLabelAngle  = 270;
Options.zeroAndNegative = true;
Options.cMap            = 'invgray';
Options.vWinds          = [0, 25, 50, 75, 100];
Options.LabLegend       = '(cm)';
Options.LegendVariable  = 'Hs';
Options.scalefactor     = 0.9;
Options.CirFontsize     = 8;

for ii = 1:length(W_QC_2022)
    ax = nexttile;
    title_str = sprintf("Hs, %s", datestr(W_QC_2022(ii).waveday(1), 'yyyy/mm'));
    Options.axes            = ax;
    Options.TitleString     = title_str;
    Rose_dir = W_QC_2022(ii).Dir(~isnan(W_QC_2022(ii).Dir));
    Rose_Hs = W_QC_2022(ii).Hs(~isnan(W_QC_2022(ii).Hs))*100;
    less_length = min([length(Rose_Hs) length(Rose_dir)]);
    WindRose(Rose_dir(1:less_length), Rose_Hs(1:less_length), Options);
    % WindRose(W_QC_2022(ii).Dir, W_QC_2022(ii).Hs*100, Options);
    figset_linefont(ax)
    set(ax.Legend, 'Location', 'southeastoutside', 'Box', 'off', 'fontsize', 5)
    set(ax, 'TitleHorizontalAlignment', 'left', 'fontsize', 8)
    % if ii ~= 3; set(ax.Legend, 'visible', 'off'); end
    all_text = findall(ax, 'Type', 'text');
    for jj = 1:length(all_text)
        txt_str = all_text(jj).String;
        
        % 如果文字中包含 '%'，代表它是頻率標籤
        if contains(txt_str, '%')
            set(all_text(jj), ...
                'HorizontalAlignment', 'center', ...   % 水平對齊：left, center, right
                'VerticalAlignment', 'bottom', ...   % 垂直對齊：top, middle, bottom
                'FontSize', 8, ...                  % 字體大小
                'FontWeight', 'bold', ...            % 加粗
                'Color', [0.2 0.2 0.2], ...          % 深灰色
                'FontName', 'Helvetica');            % 字體名稱
                
            % 如果你想讓文字稍微「位移」一點點，不要貼在線上面：
            % pos = all_text(i).Position;
            % all_text(i).Position = pos + [0.5 0 0]; % 往右位移 0.5 單位
        end
    end
end


save_str = sprintf("%s\\Rose_monthly_2022_Hs.png", pic_w);
exportgraphics(gcf, save_str)



figure("OuterPosition", [1 1 1920/2 1080])
tt = tiledlayout(4, 3, "TileSpacing", "compact", "Padding", "tight");
% clear Options % 清除舊變數確保乾淨
for ii = 1:length(W_QC_2023)
    if ii > 6 && ii < 11
        ax = nexttile;
        ax.Visible = 'off';
    else
        ax = nexttile;
        title_str = sprintf("Hs, %s", datestr(W_QC_2023(ii).waveday(1), 'yyyy/mm'));
        Options.MaxFrequency    = 30;
        Options.nfreq           = 3;
        Options.axes            = ax;
        Options.TitleString     = title_str;
        Rose_dir = W_QC_2023(ii).Dir(~isnan(W_QC_2023(ii).Dir));
        Rose_Hs = W_QC_2023(ii).Hs(~isnan(W_QC_2023(ii).Hs))*100;
        less_length = min([length(Rose_Hs) length(Rose_dir)]);
        WindRose(Rose_dir(1:less_length), Rose_Hs(1:less_length), Options);
        % WindRose(W_QC_2023(ii).Dir, W_QC_2023(ii).Hs*100, Options);
        figset_linefont(ax)
        set(ax.Legend, 'Location', 'southeastoutside', 'Box', 'off', 'fontsize', 5)
        set(ax, 'TitleHorizontalAlignment', 'left', 'fontsize', 8)
        % if ii ~= 3; set(ax.Legend, 'visible', 'off'); end
        all_text = findall(ax, 'Type', 'text');
        for jj = 1:length(all_text)
            txt_str = all_text(jj).String;
            
            % 如果文字中包含 '%'，代表它是頻率標籤
            if contains(txt_str, '%')
                set(all_text(jj), ...
                    'HorizontalAlignment', 'center', ...   % 水平對齊：left, center, right
                    'VerticalAlignment', 'bottom', ...   % 垂直對齊：top, middle, bottom
                    'FontSize', 8, ...                  % 字體大小
                    'FontWeight', 'bold', ...            % 加粗
                    'Color', [0.2 0.2 0.2], ...          % 深灰色
                    'FontName', 'Helvetica');            % 字體名稱
                    
                % 如果你想讓文字稍微「位移」一點點，不要貼在線上面：
                % pos = all_text(i).Position;
                % all_text(i).Position = pos + [0.5 0 0]; % 往右位移 0.5 單位
            end
        end
    end
end


save_str = sprintf("%s\\Rose_monthly_2023_Hs.png", pic_w);
exportgraphics(gcf, save_str)


%% Current Rose
figure("OuterPosition", [1 1 1920/2 1080*3/4])
tt = tiledlayout(3, 3, "TileSpacing", "compact", "Padding", "tight");
% clear Options % 清除舊變數確保乾淨
Options.nDirections     = 16;
Options.AngleNorth      = 0;
Options.AngleEast       = 90;
Options.labels          = {'N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE', 'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW'};
Options.gridstyle       = ':';
Options.radialgridstyle = ':';
Options.gridcolor       = 'k';
Options.gridwidth       = 1;
Options.gridalpha       = 0.5;
Options.MaxFrequency    = 50;
Options.nfreq           = 5;
Options.FreqLabelAngle  = 270;
Options.zeroAndNegative = true;
Options.cMap            = 'invgray';
Options.vWinds          = [0, 20, 40, 60, 80];
Options.LabLegend       = '(cm/sec)';
Options.LegendVariable  = 'Vel.';
Options.scalefactor     = 0.9;
Options.CirFontsize     = 8;
Layers = {"Bottom", "Middle", "Surface"};

for ii = 1:3
    ax = nexttile;
    title_str = sprintf("%s, %s~%s", Layers{ii}, datestr(all_dday_2022(1), 'yyyy/mm'), datestr(all_dday_2022(end), 'mm'));
    Options.axes            = ax;
    Options.TitleString     = title_str;
    Rose_dir = all_Dir_2022(~isnan(all_Dir_2022(:, ii)), ii);
    Rose_Cur = all_Cur_2022(~isnan(all_Cur_2022(:, ii)), ii)*100;
    less_length = min([length(Rose_Cur) length(Rose_dir)]);
    WindRose(Rose_dir(1:less_length), Rose_Cur(1:less_length), Options);
    % WindRose(all_Dir_2022(:, ii), all_Cur_2022(:, ii)*100, Options);
    figset_linefont(ax)
    set(ax.Legend, 'Location', 'southeastoutside', 'Box', 'off', 'fontsize', 5)
    set(ax, 'TitleHorizontalAlignment', 'left', 'fontsize', 8)
    all_text = findall(ax, 'Type', 'text');
    for jj = 1:length(all_text)
        txt_str = all_text(jj).String;
        
        % 如果文字中包含 '%'，代表它是頻率標籤
        if contains(txt_str, '%')
            set(all_text(jj), ...
                'HorizontalAlignment', 'center', ...   % 水平對齊：left, center, right
                'VerticalAlignment', 'bottom', ...   % 垂直對齊：top, middle, bottom
                'FontSize', 7, ...                  % 字體大小
                'FontWeight', 'bold', ...            % 加粗
                'Color', [0.2 0.2 0.2], ...          % 深灰色
                'FontName', 'Helvetica');            % 字體名稱
                
            % 如果你想讓文字稍微「位移」一點點，不要貼在線上面：
            % pos = all_text(i).Position;
            % all_text(i).Position = pos + [0.5 0 0]; % 往右位移 0.5 單位
        end
    end
end


for ii = 1:3
    ax = nexttile;
    title_str = sprintf("%s, %s~%s", Layers{ii}, datestr(all_dday_2023(1), 'yyyy/mm'), datestr(all_dday_2023(end), 'mm'));
    Options.axes            = ax;
    Options.TitleString     = title_str;
    Rose_dir = all_Dir_2023(~isnan(all_Dir_2023(:, ii)), ii);
    Rose_Cur = all_Cur_2023(~isnan(all_Cur_2023(:, ii)), ii)*100;
    less_length = min([length(Rose_Cur) length(Rose_dir)]);
    WindRose(Rose_dir(1:less_length), Rose_Cur(1:less_length), Options);
    % WindRose(all_Dir_2023(:, ii), all_Cur_2023(:, ii)*100, Options);
    figset_linefont(ax)
    set(ax.Legend, 'Location', 'southeastoutside', 'Box', 'off', 'fontsize', 5)
    set(ax, 'TitleHorizontalAlignment', 'left', 'fontsize', 8)
    all_text = findall(ax, 'Type', 'text');
    for jj = 1:length(all_text)
        txt_str = all_text(jj).String;
        
        % 如果文字中包含 '%'，代表它是頻率標籤
        if contains(txt_str, '%')
            set(all_text(jj), ...
                'HorizontalAlignment', 'center', ...   % 水平對齊：left, center, right
                'VerticalAlignment', 'bottom', ...   % 垂直對齊：top, middle, bottom
                'FontSize', 7, ...                  % 字體大小
                'FontWeight', 'bold', ...            % 加粗
                'Color', [0.2 0.2 0.2], ...          % 深灰色
                'FontName', 'Helvetica');            % 字體名稱
                
            % 如果你想讓文字稍微「位移」一點點，不要貼在線上面：
            % pos = all_text(i).Position;
            % all_text(i).Position = pos + [0.5 0 0]; % 往右位移 0.5 單位
        end
    end
end

for ii = 1:3
    ax = nexttile;
    title_str = sprintf("%s, %s~%s", Layers{ii}, datestr(all_dday_2022(1), 'yyyy'), datestr(all_dday_2023(end), 'yyyy'));
    Options.axes            = ax;
    Options.TitleString     = title_str;
    Rose_dir = [all_Dir_2022(~isnan(all_Dir_2022(:, ii)), ii); all_Dir_2023(~isnan(all_Dir_2023(:, ii)), ii)];
    Rose_Cur = [all_Cur_2022(~isnan(all_Cur_2022(:, ii)), ii); all_Cur_2023(~isnan(all_Cur_2023(:, ii)), ii)]*100;
    less_length = min([length(Rose_Cur) length(Rose_dir)]);
    WindRose(Rose_dir(1:less_length), Rose_Cur(1:less_length), Options);
    % WindRose([all_Dir_2022(:, ii); all_Dir_2023(:, ii)], [all_Cur_2022(:, ii); all_Cur_2023(:, ii)]*100, Options);
    figset_linefont(ax)
    set(ax.Legend, 'Location', 'southeastoutside', 'Box', 'off', 'fontsize', 5)
    set(ax, 'TitleHorizontalAlignment', 'left', 'fontsize', 8)
    all_text = findall(ax, 'Type', 'text');
    for jj = 1:length(all_text)
        txt_str = all_text(jj).String;
        
        % 如果文字中包含 '%'，代表它是頻率標籤
        if contains(txt_str, '%')
            set(all_text(jj), ...
                'HorizontalAlignment', 'center', ...   % 水平對齊：left, center, right
                'VerticalAlignment', 'bottom', ...   % 垂直對齊：top, middle, bottom
                'FontSize', 7, ...                  % 字體大小
                'FontWeight', 'bold', ...            % 加粗
                'Color', [0.2 0.2 0.2], ...          % 深灰色
                'FontName', 'Helvetica');            % 字體名稱
                
            % 如果你想讓文字稍微「位移」一點點，不要貼在線上面：
            % pos = all_text(i).Position;
            % all_text(i).Position = pos + [0.5 0 0]; % 往右位移 0.5 單位
        end
    end
end

save_str = sprintf("%s\\Rose_Cur.png", pic_c);
exportgraphics(gcf, save_str)


%% Current seasonal Rose
figure("OuterPosition", [1 1 1920/2 1080])
tt = tiledlayout(4, 3, "TileSpacing", "compact", "Padding", "tight");
% clear Options % 清除舊變數確保乾淨
Options.nDirections     = 16;
Options.AngleNorth      = 0;
Options.AngleEast       = 90;
Options.labels          = {'N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE', 'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW'};
Options.gridstyle       = ':';
Options.radialgridstyle = ':';
Options.gridcolor       = 'k';
Options.gridwidth       = 1;
Options.gridalpha       = 0.5;
Options.MaxFrequency    = 50;
Options.nfreq           = 5;
Options.FreqLabelAngle  = 270;
Options.zeroAndNegative = true;
Options.cMap            = 'invgray';
Options.vWinds          = [0, 20, 40, 60, 80];
Options.LabLegend       = '(cm/sec)';
Options.LegendVariable  = 'Vel.';
Options.scalefactor     = 0.9;
Options.CirFontsize     = 8;
Layers = {"Bottom", "Middle", "Surface"};

for ii = 1:3
    ax = nexttile;
    title_str = sprintf("%s, Winter(%s~%s)", Layers{ii}, datestr(winter.dday_2022(1), 'yyyy/mm'), datestr(winter.dday_2022(end), 'yyyy/mm'));
    Options.axes            = ax;
    Options.TitleString     = title_str;
    Rose_dir = winter.Dir_2022(~isnan(winter.Dir_2022(:, ii)), ii);
    Rose_Cur = winter.Cur_2022(~isnan(winter.Cur_2022(:, ii)), ii)*100;
    less_length = min([length(Rose_Cur) length(Rose_dir)]);
    WindRose(Rose_dir(1:less_length), Rose_Cur(1:less_length), Options);
    % WindRose(all_Dir_2022(:, ii), all_Cur_2022(:, ii)*100, Options);
    figset_linefont(ax)
    set(ax.Legend, 'Location', 'southeastoutside', 'Box', 'off', 'fontsize', 5)
    set(ax, 'TitleHorizontalAlignment', 'left', 'fontsize', 8)
    all_text = findall(ax, 'Type', 'text');
    for jj = 1:length(all_text)
        txt_str = all_text(jj).String;
        
        % 如果文字中包含 '%'，代表它是頻率標籤
        if contains(txt_str, '%')
            set(all_text(jj), ...
                'HorizontalAlignment', 'center', ...   % 水平對齊：left, center, right
                'VerticalAlignment', 'bottom', ...   % 垂直對齊：top, middle, bottom
                'FontSize', 7, ...                  % 字體大小
                'FontWeight', 'bold', ...            % 加粗
                'Color', [0.2 0.2 0.2], ...          % 深灰色
                'FontName', 'Helvetica');            % 字體名稱
                
            % 如果你想讓文字稍微「位移」一點點，不要貼在線上面：
            % pos = all_text(i).Position;
            % all_text(i).Position = pos + [0.5 0 0]; % 往右位移 0.5 單位
        end
    end
end

save_str = sprintf("%s\\Rose_Cur_2021.png", pic_c);
exportgraphics(gcf, save_str)


figure("OuterPosition", [1 1 1920/2 1080])
tt = tiledlayout(4, 3, "TileSpacing", "compact", "Padding", "tight");
for ii = 1:3
    ax = nexttile;
    title_str = sprintf("%s, Spring(%s~%s)", Layers{ii}, datestr(spring.dday_2022(1), 'yyyy/mm'), datestr(spring.dday_2022(end), 'mm'));
    Options.axes            = ax;
    Options.TitleString     = title_str;
    Rose_dir = spring.Dir_2022(~isnan(spring.Dir_2022(:, ii)), ii);
    Rose_Cur = spring.Cur_2022(~isnan(spring.Cur_2022(:, ii)), ii)*100;
    less_length = min([length(Rose_Cur) length(Rose_dir)]);
    WindRose(Rose_dir(1:less_length), Rose_Cur(1:less_length), Options);
    % WindRose(all_Dir_2022(:, ii), all_Cur_2022(:, ii)*100, Options);
    figset_linefont(ax)
    set(ax.Legend, 'Location', 'southeastoutside', 'Box', 'off', 'fontsize', 5)
    set(ax, 'TitleHorizontalAlignment', 'left', 'fontsize', 8)
    all_text = findall(ax, 'Type', 'text');
    for jj = 1:length(all_text)
        txt_str = all_text(jj).String;
        
        % 如果文字中包含 '%'，代表它是頻率標籤
        if contains(txt_str, '%')
            set(all_text(jj), ...
                'HorizontalAlignment', 'center', ...   % 水平對齊：left, center, right
                'VerticalAlignment', 'bottom', ...   % 垂直對齊：top, middle, bottom
                'FontSize', 7, ...                  % 字體大小
                'FontWeight', 'bold', ...            % 加粗
                'Color', [0.2 0.2 0.2], ...          % 深灰色
                'FontName', 'Helvetica');            % 字體名稱
                
            % 如果你想讓文字稍微「位移」一點點，不要貼在線上面：
            % pos = all_text(i).Position;
            % all_text(i).Position = pos + [0.5 0 0]; % 往右位移 0.5 單位
        end
    end
end

for ii = 1:3
    ax = nexttile;
    title_str = sprintf("%s, Summer(%s~%s)", Layers{ii}, datestr(summer.dday_2022(1), 'yyyy/mm'), datestr(summer.dday_2022(end), 'mm'));
    Options.axes            = ax;
    Options.TitleString     = title_str;
    Rose_dir = summer.Dir_2022(~isnan(summer.Dir_2022(:, ii)), ii);
    Rose_Cur = summer.Cur_2022(~isnan(summer.Cur_2022(:, ii)), ii)*100;
    less_length = min([length(Rose_Cur) length(Rose_dir)]);
    WindRose(Rose_dir(1:less_length), Rose_Cur(1:less_length), Options);
    % WindRose(all_Dir_2022(:, ii), all_Cur_2022(:, ii)*100, Options);
    figset_linefont(ax)
    set(ax.Legend, 'Location', 'southeastoutside', 'Box', 'off', 'fontsize', 5)
    set(ax, 'TitleHorizontalAlignment', 'left', 'fontsize', 8)
    all_text = findall(ax, 'Type', 'text');
    for jj = 1:length(all_text)
        txt_str = all_text(jj).String;
        
        % 如果文字中包含 '%'，代表它是頻率標籤
        if contains(txt_str, '%')
            set(all_text(jj), ...
                'HorizontalAlignment', 'center', ...   % 水平對齊：left, center, right
                'VerticalAlignment', 'bottom', ...   % 垂直對齊：top, middle, bottom
                'FontSize', 7, ...                  % 字體大小
                'FontWeight', 'bold', ...            % 加粗
                'Color', [0.2 0.2 0.2], ...          % 深灰色
                'FontName', 'Helvetica');            % 字體名稱
                
            % 如果你想讓文字稍微「位移」一點點，不要貼在線上面：
            % pos = all_text(i).Position;
            % all_text(i).Position = pos + [0.5 0 0]; % 往右位移 0.5 單位
        end
    end
end

for ii = 1:3
    ax = nexttile;
    title_str = sprintf("%s, Fall(%s~%s)", Layers{ii}, datestr(fall.dday_2022(1), 'yyyy/mm'), datestr(fall.dday_2022(end), 'mm'));
    Options.axes            = ax;
    Options.TitleString     = title_str;
    Rose_dir = fall.Dir_2022(~isnan(fall.Dir_2022(:, ii)), ii);
    Rose_Cur = fall.Cur_2022(~isnan(fall.Cur_2022(:, ii)), ii)*100;
    less_length = min([length(Rose_Cur) length(Rose_dir)]);
    WindRose(Rose_dir(1:less_length), Rose_Cur(1:less_length), Options);
    % WindRose(all_Dir_2022(:, ii), all_Cur_2022(:, ii)*100, Options);
    figset_linefont(ax)
    set(ax.Legend, 'Location', 'southeastoutside', 'Box', 'off', 'fontsize', 5)
    set(ax, 'TitleHorizontalAlignment', 'left', 'fontsize', 8)
    all_text = findall(ax, 'Type', 'text');
    for jj = 1:length(all_text)
        txt_str = all_text(jj).String;
        
        % 如果文字中包含 '%'，代表它是頻率標籤
        if contains(txt_str, '%')
            set(all_text(jj), ...
                'HorizontalAlignment', 'center', ...   % 水平對齊：left, center, right
                'VerticalAlignment', 'bottom', ...   % 垂直對齊：top, middle, bottom
                'FontSize', 7, ...                  % 字體大小
                'FontWeight', 'bold', ...            % 加粗
                'Color', [0.2 0.2 0.2], ...          % 深灰色
                'FontName', 'Helvetica');            % 字體名稱
                
            % 如果你想讓文字稍微「位移」一點點，不要貼在線上面：
            % pos = all_text(i).Position;
            % all_text(i).Position = pos + [0.5 0 0]; % 往右位移 0.5 單位
        end
    end
end

for ii = 1:3
    ax = nexttile;
    title_str = sprintf("%s, Winter(%s~%s)", Layers{ii}, datestr(winter.dday_2023(1), 'yyyy/mm'), datestr(winter.dday_2023(end), 'yyyy/mm'));
    Options.axes            = ax;
    Options.TitleString     = title_str;
    Rose_dir = winter.Dir_2023(~isnan(winter.Dir_2023(:, ii)), ii);
    Rose_Cur = winter.Cur_2023(~isnan(winter.Cur_2023(:, ii)), ii)*100;
    less_length = min([length(Rose_Cur) length(Rose_dir)]);
    WindRose(Rose_dir(1:less_length), Rose_Cur(1:less_length), Options);
    % WindRose(all_Dir_2023(:, ii), all_Cur_2023(:, ii)*100, Options);
    figset_linefont(ax)
    set(ax.Legend, 'Location', 'southeastoutside', 'Box', 'off', 'fontsize', 5)
    set(ax, 'TitleHorizontalAlignment', 'left', 'fontsize', 8)
    all_text = findall(ax, 'Type', 'text');
    for jj = 1:length(all_text)
        txt_str = all_text(jj).String;
        
        % 如果文字中包含 '%'，代表它是頻率標籤
        if contains(txt_str, '%')
            set(all_text(jj), ...
                'HorizontalAlignment', 'center', ...   % 水平對齊：left, center, right
                'VerticalAlignment', 'bottom', ...   % 垂直對齊：top, middle, bottom
                'FontSize', 7, ...                  % 字體大小
                'FontWeight', 'bold', ...            % 加粗
                'Color', [0.2 0.2 0.2], ...          % 深灰色
                'FontName', 'Helvetica');            % 字體名稱
                
            % 如果你想讓文字稍微「位移」一點點，不要貼在線上面：
            % pos = all_text(i).Position;
            % all_text(i).Position = pos + [0.5 0 0]; % 往右位移 0.5 單位
        end
    end
end

save_str = sprintf("%s\\Rose_Cur_2022.png", pic_c);
exportgraphics(gcf, save_str)


figure("OuterPosition", [1 1 1920/2 1080])
tt = tiledlayout(4, 3, "TileSpacing", "compact", "Padding", "tight");
for ii = 1:3
    ax = nexttile;
    title_str = sprintf("%s, Spring(%s~%s)", Layers{ii}, datestr(spring.dday_2023(1), 'yyyy/mm'), datestr(spring.dday_2023(end), 'mm'));
    Options.axes            = ax;
    Options.TitleString     = title_str;
    Rose_dir = spring.Dir_2023(~isnan(spring.Dir_2023(:, ii)), ii);
    Rose_Cur = spring.Cur_2023(~isnan(spring.Cur_2023(:, ii)), ii)*100;
    less_length = min([length(Rose_Cur) length(Rose_dir)]);
    WindRose(Rose_dir(1:less_length), Rose_Cur(1:less_length), Options);
    % WindRose(all_Dir_2023(:, ii), all_Cur_2023(:, ii)*100, Options);
    figset_linefont(ax)
    set(ax.Legend, 'Location', 'southeastoutside', 'Box', 'off', 'fontsize', 5)
    set(ax, 'TitleHorizontalAlignment', 'left', 'fontsize', 8)
    all_text = findall(ax, 'Type', 'text');
    for jj = 1:length(all_text)
        txt_str = all_text(jj).String;
        
        % 如果文字中包含 '%'，代表它是頻率標籤
        if contains(txt_str, '%')
            set(all_text(jj), ...
                'HorizontalAlignment', 'center', ...   % 水平對齊：left, center, right
                'VerticalAlignment', 'bottom', ...   % 垂直對齊：top, middle, bottom
                'FontSize', 7, ...                  % 字體大小
                'FontWeight', 'bold', ...            % 加粗
                'Color', [0.2 0.2 0.2], ...          % 深灰色
                'FontName', 'Helvetica');            % 字體名稱
                
            % 如果你想讓文字稍微「位移」一點點，不要貼在線上面：
            % pos = all_text(i).Position;
            % all_text(i).Position = pos + [0.5 0 0]; % 往右位移 0.5 單位
        end
    end
end

save_str = sprintf("%s\\Rose_Cur_2023.png", pic_c);
exportgraphics(gcf, save_str)


%% rose 2022 monthly current

for kk = 1:3
figure("OuterPosition", [1 1 1920/2 1080])
tt = tiledlayout(4, 3, "TileSpacing", "compact", "Padding", "tight");
clear Options % 清除舊變數確保乾淨
Options.nDirections     = 16;
Options.AngleNorth      = 0;
Options.AngleEast       = 90;
Options.labels          = {'N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE', 'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW'};
Options.gridstyle       = ':';
Options.radialgridstyle = ':';
Options.gridcolor       = 'k';
Options.gridwidth       = 1;
Options.gridalpha       = 0.5;
Options.MaxFrequency    = 50;
Options.nfreq           = 5;
Options.FreqLabelAngle  = 270;
Options.zeroAndNegative = true;
Options.cMap            = 'invgray';
Options.vWinds          = [0, 25, 50, 75, 100];
Options.LabLegend       = '(cm/sec)';
Options.LegendVariable  = 'Vel.';
Options.scalefactor     = 0.9;
Options.CirFontsize     = 8;

for ii = 1:length(C_QC_2022)
    % jj = 3;
    ax = nexttile;
    title_str = sprintf("%s, %s", Layers{kk}, datestr(C_QC_2022(ii).dday(1), 'yyyy/mm'));
    % title_str = sprintf("Hs, %s", datestr(C_QC_2022(ii).dday(1), 'yyyy/mm'));
    Options.axes            = ax;
    Options.TitleString     = title_str;
    Rose_dir = C_QC_2022(ii).Dir(~isnan(C_QC_2022(ii).Dir(:, kk)), kk);
    Rose_Cur = C_QC_2022(ii).Cur(~isnan(C_QC_2022(ii).Cur(:, kk)), kk)*100;
    less_length = min([length(Rose_Cur) length(Rose_dir)]);
    WindRose(Rose_dir(1:less_length), Rose_Cur(1:less_length), Options);
    % WindRose(W_QC_2022(ii).Dir, W_QC_2022(ii).Hs*100, Options);
    figset_linefont(ax)
    set(ax.Legend, 'Location', 'southeastoutside', 'Box', 'off', 'fontsize', 5)
    set(ax, 'TitleHorizontalAlignment', 'left', 'fontsize', 8)
    % if ii ~= 3; set(ax.Legend, 'visible', 'off'); end
    all_text = findall(ax, 'Type', 'text');
    for jj = 1:length(all_text)
        txt_str = all_text(jj).String;
        
        % 如果文字中包含 '%'，代表它是頻率標籤
        if contains(txt_str, '%')
            set(all_text(jj), ...
                'HorizontalAlignment', 'center', ...   % 水平對齊：left, center, right
                'VerticalAlignment', 'bottom', ...   % 垂直對齊：top, middle, bottom
                'FontSize', 8, ...                  % 字體大小
                'FontWeight', 'bold', ...            % 加粗
                'Color', [0.2 0.2 0.2], ...          % 深灰色
                'FontName', 'Helvetica');            % 字體名稱
                
            % 如果你想讓文字稍微「位移」一點點，不要貼在線上面：
            % pos = all_text(i).Position;
            % all_text(i).Position = pos + [0.5 0 0]; % 往右位移 0.5 單位
        end
    end
end
save_str = sprintf("%s\\Rose_%s_Cur_2022.png", pic_c, Layers{kk});
exportgraphics(gcf, save_str)
end


for kk = 1:3
figure("OuterPosition", [1 1 1920/2 1080])
tt = tiledlayout(4, 3, "TileSpacing", "compact", "Padding", "tight");
for ii = 1:length(C_QC_2023)
    % kk = 3;
    if ii > 6 && ii < 11
        ax = nexttile;
        ax.Visible = 'off';
    else
    ax = nexttile;
    title_str = sprintf("%s, %s", Layers{kk}, datestr(C_QC_2023(ii).dday(1), 'yyyy/mm'));
    Options.axes            = ax;
    Options.TitleString     = title_str;
    Rose_dir = C_QC_2023(ii).Dir(~isnan(C_QC_2023(ii).Dir(:, kk)), kk);
    Rose_Cur = C_QC_2023(ii).Cur(~isnan(C_QC_2023(ii).Cur(:, kk)), kk)*100;
    less_length = min([length(Rose_Cur) length(Rose_dir)]);
    WindRose(Rose_dir(1:less_length), Rose_Cur(1:less_length), Options);
    % WindRose(W_QC_2023(ii).Dir, W_QC_2023(ii).Hs*100, Options);
    figset_linefont(ax)
    set(ax.Legend, 'Location', 'southeastoutside', 'Box', 'off', 'fontsize', 5)
    set(ax, 'TitleHorizontalAlignment', 'left', 'fontsize', 8)
    % if ii ~= 3; set(ax.Legend, 'visible', 'off'); end
    all_text = findall(ax, 'Type', 'text');
    for jj = 1:length(all_text)
        txt_str = all_text(jj).String;
        
        % 如果文字中包含 '%'，代表它是頻率標籤
        if contains(txt_str, '%')
            set(all_text(jj), ...
                'HorizontalAlignment', 'center', ...   % 水平對齊：left, center, right
                'VerticalAlignment', 'bottom', ...   % 垂直對齊：top, middle, bottom
                'FontSize', 8, ...                  % 字體大小
                'FontWeight', 'bold', ...            % 加粗
                'Color', [0.2 0.2 0.2], ...          % 深灰色
                'FontName', 'Helvetica');            % 字體名稱
                
            % 如果你想讓文字稍微「位移」一點點，不要貼在線上面：
            % pos = all_text(i).Position;
            % all_text(i).Position = pos + [0.5 0 0]; % 往右位移 0.5 單位
        end
    end
    end
end
save_str = sprintf("%s\\Rose_%s_Cur_2023.png", pic_c, Layers{kk});
exportgraphics(gcf, save_str)
end




