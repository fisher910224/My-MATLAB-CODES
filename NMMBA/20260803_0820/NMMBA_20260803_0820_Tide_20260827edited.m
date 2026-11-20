%% 20260803~0820 Tide
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
% % =================== date ====================
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
Prem_N = houravg(Pre_N, length(Pre_N), 6);

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
Prem_S = houravg(Pre_S, length(Pre_S), 6);

% =================== wind ====================
wi = WIND.(['wi', dates]);
wu = WIND.(['wu', dates])(1:length(daym_N)); % U分量 風為來向加負號變去向
wv = WIND.(['wv', dates])(1:length(daym_N)); % V分量 風為來向加負號變去向

% ==================== OOhOOOO =================
station_N = 'N_';
station_S = 'S_';

low = 1;
mid = 5;
upp = 11;

% ================= find spring tide & neap tide ===================
windowsize = 6*36;

leveldiff = [];
for ii = 1:(length(Pre_N)-windowsize+1)
    leveldiff(ii,1) = max(Pre_N(ii:ii+windowsize-1)) - min(Pre_N(ii:ii+windowsize-1));
end
[springtide, springtide_time] = max(leveldiff);
[neaptide, neaptide_time] = min(leveldiff);

%% FIXSETTING
figset_linefont = @(ax) set(ax, 'fontsize', 24, 'linewidth', 1.5, "TickLength", [0.005 0.02], 'TickDir', 'out');
figset_date = @(ax, wave_day) set(ax, 'XTick', floor(wave_day(1)):4:ceil(wave_day(end)), ...
    'Xticklabel', datestr(floor(wave_day(1)):4:ceil(wave_day(end)), 'mm/dd'));
figset_date_minorticks = @(ax, wave_day) set(ax.XAxis, 'Minortick', 'on', 'MinorTickValues', floor(wave_day(1)):1:ceil(wave_day(end)));


%% Figure-tide level
cd(func)
figure('OuterPosition', get(0,'ScreenSize'))
tt = tiledlayout(1, 1, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
plot(dday_N, Pre_N, 'LineWidth', 2, 'Color', 'k', 'DisplayName', 'N station'); hold on
plot(dday_S, Pre_S, 'LineWidth', 2, 'Color', 'b', 'DisplayName', 'S station'); hold on
legend
ylabel('Depth (m)')
ylim([floor(min([Pre_N;Pre_S])*2)/2 ceil(max([Pre_N; Pre_S])*2)/2]);
xlim([floor(daym_N(1))-1 ceil(daym_N(end))+1])
figset_linefont(ax)
figset_date(ax, waveday_N)
figset_date_minorticks(ax, waveday_N)
grid on
xlabel(['month/day of ', datestr(dday_N(1),'yyyy')])
title_str = sprintf("\\bfWater level change diagram\n\\rm%s", plotdate_all);
title(tt, title_str, 'FontSize',30)

cd(pic_t)
exportgraphics(gcf, [filedate, 'level.png'])

%% Spring tide
cd(func)
figure('OuterPosition', get(0,'ScreenSize'))
t = tiledlayout(2,1,"TileSpacing","compact","Padding","tight");
ax = nexttile;
plot(dday_N, Pre_N, 'k','LineWidth', 3)
axis([floor(dday_N(springtide_time)) floor(dday_N(springtide_time))+1.5 floor(min(Pre_N)) ceil(max(Pre_N))])
set(gca, 'xtick', floor(dday_N(springtide_time)):0.25:floor(dday_N(springtide_time))+1.5, ...
    'xticklabel',{[datestr(floor(dday_N(springtide_time)),'mm/dd'),  ' 00:00'],'06:00','12:00','18:00',[datestr(floor(dday_N(springtide_time))+1,'mm/dd'),  ' 00:00'],'06:00','12:00'})
ylabel('Depth (m)')
grid on
% set(ax, 'fontsize', 18,'FontWeight', 'bold','linewidth', 3)
figset_linefont(ax)
title(t, {['\bf',station_N,' Station 36 hours spring tide level'],['\rm',[datestr(floor(dday_N(springtide_time)),'mm/dd'),  ' 00:00'],'~', [datestr(floor(dday_N(springtide_time))+1,'mm/dd'),  ' 12:00']]},'FontSize',24)
hold on

dday_st = find(dday_N == floor(dday_N(springtide_time)));
dday_end = find(dday_N == floor(dday_N(springtide_time))+1.5);
ax = nexttile;
quiver_f(dday_N(dday_st:dday_end), u_N(dday_st:dday_end,3)*100, v_N(dday_st:dday_end,3)*100)
axis([floor(dday_N(springtide_time)) floor(dday_N(springtide_time))+1.5 -60 60])
set(gca, 'xtick', floor(dday_N(springtide_time)):0.25:floor(dday_N(springtide_time))+1.5, ...
    'xticklabel',{[datestr(floor(dday_N(springtide_time)),'mm/dd'),  ' 00:00'],'06:00','12:00','18:00',[datestr(floor(dday_N(springtide_time))+1,'mm/dd'),  ' 00:00'],'06:00','12:00'})
set(gca, 'ytick', -60:30:60)
% set(gca, 'LineWidth',3, 'fontsize', 18,'FontWeight','bold')
figset_linefont(ax)
ylabel('Speed (cm/s)')
xlabel(['month/day hour:minute of ', datestr(dday_N(1), 'yyyy')])
cd(pic_t)
exportgraphics(gcf, [datestr(floor(dday_N(springtide_time)),'yyyymmdd'),'_' ,station_N,'spring_tide_level.png'])

%% pressure t-tide
cd(func)
[NAME,~, amppha_N ,~] = t_tide(Prem_N);
O1raw_N = find(strcmp(strtrim(cellstr(NAME)), 'O1'));
K1raw_N = find(strcmp(strtrim(cellstr(NAME)), 'K1'));
M2raw_N = find(strcmp(strtrim(cellstr(NAME)), 'M2'));
S2raw_N = find(strcmp(strtrim(cellstr(NAME)), 'S2'));

[NAME,~, amppha_S ,~] = t_tide(Prem_S);
O1raw_S = find(strcmp(strtrim(cellstr(NAME)), 'O1'));
K1raw_S = find(strcmp(strtrim(cellstr(NAME)), 'K1'));
M2raw_S = find(strcmp(strtrim(cellstr(NAME)), 'M2'));
S2raw_S = find(strcmp(strtrim(cellstr(NAME)), 'S2'));

cd(f_data)
fidd = fopen([filedate, 'Tidedata-amplitude.txt'],'w');
fprintf(fidd, 'Amplitude (m)：    Phase (deg)：\n');
fprintf(fidd, 'K1, O1, M2, S2\n');
fprintf(fidd, '%6.4f %6.2f  %6.4f %6.2f\n', amppha_N(K1raw_N, 1), amppha_N(K1raw_N,3), amppha_S(K1raw_S, 1), amppha_S(K1raw_S,3));
fprintf(fidd, '%6.4f %6.2f  %6.4f %6.2f\n', amppha_N(O1raw_N, 1), amppha_N(O1raw_N,3), amppha_S(O1raw_S, 1), amppha_S(O1raw_S,3));
fprintf(fidd, '%6.4f %6.2f  %6.4f %6.2f\n', amppha_N(M2raw_N, 1), amppha_N(M2raw_N,3), amppha_S(M2raw_S, 1), amppha_S(M2raw_S,3));
fprintf(fidd, '%6.4f %6.2f  %6.4f %6.2f\n', amppha_N(S2raw_N, 1), amppha_N(S2raw_N,3), amppha_S(S2raw_S, 1), amppha_S(S2raw_S,3));
fclose(fidd);

