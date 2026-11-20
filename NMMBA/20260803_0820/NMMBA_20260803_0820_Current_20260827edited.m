%% 20260803~0820 Current
% 20260827 editted
clear; close all; clc;

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
cd(aim_folder) % changing folder (pwd) to main folder
load("DATA_CUR.mat"); % read current data
WIND = load("DATA_WIND.mat"); % read wind data AS A STRUCT DATA TYPE
% % =================== date ====================
dates = ['_', aim_folder(end-12:end-5)];
% if you naming the main folder completly (e.g. "...\20260406_0427"), 
% then this variable will be a string of "_YOUR DATA DATE (yyyymmdd, e.g. "_20260406")"

% ============== N station =================
% naming the variables to makes easier to plot pictures
% don't need to change anything below except "low", "mid" and "upp", 
% which is layers of current
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

%% Tseng pro's
% making a stastic table saving as .txt
cd(func)
filename = sprintf('%s\\%s%sLowerlayer_Cur_Dir.txt', f_data, filedate, station_N);
Vanalyis(u_N(:,low)*100, v_N(:,low)*100, Cur_N(:,low)*100, Dir_N(:,low), filename, f_data);   %輸出流速流向聯合機率分布統計表

filename = sprintf('%s\\%s%sMiddlelayer_Cur_Dir.txt', f_data, filedate, station_N);
Vanalyis(u_N(:,mid)*100, v_N(:,mid)*100, Cur_N(:,mid)*100, Dir_N(:,mid), filename, f_data);   %輸出流速流向聯合機率分布統計表

filename = sprintf('%s\\%s%sUpperlayer_Cur_Dir.txt', f_data, filedate, station_N);
Vanalyis(u_N(:,upp)*100, v_N(:,upp)*100, Cur_N(:,upp)*100, Dir_N(:,upp), filename, f_data);   %輸出流速流向聯合機率分布統計表

filename = sprintf('%s\\%s%sLowerlayer_Cur_Dir.txt', f_data, filedate, station_S);
Vanalyis(u_S(:,low)*100, v_S(:,low)*100, Cur_S(:,low)*100, Dir_S(:,low), filename, f_data);   %輸出流速流向聯合機率分布統計表

filename = sprintf('%s\\%s%sMiddlelayer_Cur_Dir.txt', f_data, filedate, station_S);
Vanalyis(u_S(:,mid)*100, v_S(:,mid)*100, Cur_S(:,mid)*100, Dir_S(:,mid), filename, f_data);   %輸出流速流向聯合機率分布統計表

filename = sprintf('%s\\%s%sUpperlayer_Cur_Dir.txt', f_data, filedate, station_S);
Vanalyis(u_S(:,upp)*100, v_S(:,upp)*100, Cur_S(:,upp)*100, Dir_S(:,upp), filename, f_data);   %輸出流速流向聯合機率分布統計表

%% layer mean vel., max vel. and dir. stastic table
Cur_max = [];
Cur_max_loc = [];
Dir_Prob = [];
Dir_number = [];
for ii = 1:width(Cur_N)
    [N.Cur_max(ii), N.Cur_max_loc(ii)] = max(Cur_N(:,ii));
    N.Cur_mean = mean(Cur_N);
    [S.Cur_max(ii), S.Cur_max_loc(ii)] = max(Cur_S(:,ii));
    S.Cur_mean = mean(Cur_S);
end

for ii = 1:width(Dir_N)
    [N.Dir_Prob(:,ii), N.Dir_number(:,ii)] = find_16Dir(Dir_N(:,ii));
    [S.Dir_Prob(:,ii), S.Dir_number(:,ii)] = find_16Dir(Dir_S(:,ii));
end

layers = [low mid upp];
position = [
    'N  ';
    'NNE';
    'NE ';
    'ENE';
    'E  ';
    'ESE';
    'SE ';
    'SSE';
    'S  ';
    'SSW';
    'SW ';
    'WSW';
    'W  ';
    'WNW';
    'NW ';
    'NWW'
    ];

% cd(f_data)
% filename = [filedate, station, 'everylayer_cur_max.txt'];
filename = sprintf("%s\\%severylayer_cur_max.txt", f_data, filedate); % combine strings
fid = fopen(filename, "w");
fprintf(fid, "Maximum flow rate in each layer - data and flow rate average\n");
fprintf(fid, "%s\n", filedate);
fprintf(fid, "\n");
fprintf(fid, 'Layers   Cur_mean  Cur_max   Cur_max_Dir\n');
for ii = length(layers):-1:1
    % current_tidal_status = tidal_status{Cur_max_loc(ii)};
    fprintf(fid, '%-5.2f m  %-9.2f %-9.2f %-12.1f %-9.2f %-9.2f %-12.1f\n', ...
            layers(ii) + 1.4, ...
            N.Cur_mean(layers(ii)), ...
            N.Cur_max(layers(ii)), ...
            Dir_N(N.Cur_max_loc(layers(ii)), layers(ii)), ...
            S.Cur_mean(layers(ii)), ...
            S.Cur_max(layers(ii)), ...
            Dir_S(S.Cur_max_loc(layers(ii)), layers(ii)));
end

fprintf(fid, "\n\nMain flow data of each layer\n");
fprintf(fid, "%s\n", filedate);
fprintf(fid, "\n");
fprintf(fid, 'Layers   Major_Dir  Prob.   Minor_Dir  Prob.   Third_Dir  Prob.\n');
for ii = length(layers):-1:1
    fprintf(fid, '%-5.2f m  %-10s %-7.2f %-10s %-7.2f %-10s %-7.2f\n', ...
            layers(ii) + 1.4, ...
            position(N.Dir_number(1,ii),:), ...
            N.Dir_Prob(1,ii), ...
            position(N.Dir_number(2,ii),:), ...
            N.Dir_Prob(2,ii), ...
            position(N.Dir_number(3,ii),:), ...
            N.Dir_Prob(3,ii));
    fprintf(fid, '         %-10s %-7.2f %-10s %-7.2f %-10s %-7.2f\n', ...
            position(S.Dir_number(1,ii),:), ...
            S.Dir_Prob(1,ii), ...
            position(S.Dir_number(2,ii),:), ...
            S.Dir_Prob(2,ii), ...
            position(S.Dir_number(3,ii),:), ...
            S.Dir_Prob(3,ii));
end

fclose(fid);


%% figsetting
% "function_handle" is a setting function that you can change settings as you want
figset_linefont = @(ax) set(ax, 'fontsize', 10, 'linewidth', 1.5, "TickLength", [0.005 0.02], 'TickDir', 'out'); % setting of font size, frame line size, tick length and size
figset_date = @(ax, wave_day) set(ax, 'XTick', floor(wave_day(1)):4:ceil(wave_day(end)), ...
    'Xticklabel', datestr(floor(wave_day(1)):4:ceil(wave_day(end)), 'mm/dd')); % Major ticks which means 4 days
figset_date_minorticks = @(ax, wave_day) set(ax.XAxis, 'Minortick', 'on', 'MinorTickValues', floor(wave_day(1)):1:ceil(wave_day(end))); % Minor ticks which means one day


%% fiiiiiiiiiiiiiiiiiiiiiiiiiiigure Upper Layer
cd(func)
% figure('OuterPosition', get(0,'ScreenSize'))
figure('OuterPosition', [1 1 1920/2 1080]) % figure which size is half of my computer screen size, change it if you want
t = tiledlayout(8, 1, "TileSpacing", "compact", "Padding", "compact"); % plot output position
ax = nexttile; % the tile you plot
plot(dday_N, Pre_N, 'k', 'LineWidth', 2) % plot water level data
ylim([floor(min(Pre_N)*2)/2 ceil(max(Pre_N)*2)/2]); % upper and lower limit of Y axis
xlim([floor(daym_N(1)) ceil(daym_N(end))]) % upper and lower limit of X axis ("floor" means round down (complete discarding), "ceil" means round up (complete Carry))
ylabel('Depth (m)') % label of Y axis
figset_linefont(ax) % function handle "figsetting"
figset_date(ax, daym_N)
figset_date_minorticks(ax, daym_N)
set(ax, 'xticklabels', []) % discarding the X axis label preventing plot too small
title_str = sprintf('\\bf%s station Tide level, Wind speed & direction and Current speed & direction\n\\rm%s', ...
    station_N, plotdate_all); % title string
title(t, title_str, 'fontsize', 15) % print title string of the FIGURE (the whole picture)
title(ax, "Tide level", FontSize=12) % print title string of the TILE (your plotting)
grid on

ax = nexttile;
quiver_f(daym_N, wu, wv) % stick figure of wind
axis([floor(daym_N(1)) ceil(daym_N(end)) -15 15]) % setting X & Y axis at the same time
set(gca,'ytick',-15:5:15);
ylabel('Speed (m/s)');
figset_linefont(ax)
figset_date(ax, daym_N)
figset_date_minorticks(ax, daym_N)
grid on
title(ax, 'Wind', 'FontSize', 12)
set(ax, 'xticklabels', [])


ax = nexttile;
plot(dday_N, Cur_N(:,upp)*100, 'k','LineWidth',2) % line chart of the upper layer
axis([floor(daym_N(1)) ceil(daym_N(end)) 0 80])
ylabel('Speed (cm/s)')
figset_linefont(ax)
figset_date(ax, daym_N)
figset_date_minorticks(ax, daym_N)
grid on
title_str = sprintf('Upper layer %.1f mab', upp+1.4);
title(ax, title_str, 'fontsize', 12)
set(ax, 'xticklabels', [])

ax = nexttile;
quiver_f(dday_N, u_N(:,upp)*100, v_N(:,upp)*100)
axis([floor(daym_N(1)) ceil(daym_N(end)) -80 80])
set(ax, 'ytick', -80:40:80)
ylabel('Speed (cm/s)')
figset_linefont(ax)
figset_date(ax, daym_N)
figset_date_minorticks(ax, daym_N)
set(ax, 'xticklabels', [])
grid on

% Middle layer
ax = nexttile;
plot(dday_N, Cur_N(:,mid)*100,'k','LineWidth',2)
axis([floor(daym_N(1)) ceil(daym_N(end)) 0 80])
ylabel('Speed (cm/s)')
set(ax,'ytick',0:20:80)
figset_linefont(ax)
figset_date(ax, daym_N)
figset_date_minorticks(ax, daym_N)
title_str = sprintf('Middle layer %.1f mab', mid+1.4);
title(ax, title_str, 'fontsize', 12)
set(ax, 'xticklabels', [])
grid on

ax = nexttile;
quiver_f(dday_N, u_N(:,mid)*100, v_N(:,mid)*100)
axis([floor(daym_N(1)) ceil(daym_N(end)) -80 80])
set(ax, 'ytick', -80:40:80)
ylabel('Speed (cm/s)')
figset_linefont(ax)
figset_date(ax, daym_N)
figset_date_minorticks(ax, daym_N)
set(ax, 'xticklabels', [])
grid on

% bottom layer
ax = nexttile;
plot(dday_N, Cur_N(:,low)*100, 'k', 'LineWidth', 2)
axis([floor(daym_N(1)) ceil(daym_N(end)) 0 80])
ylabel('Speed (cm/s)')
set(gca, 'ytick', 0:20:80)
figset_linefont(ax)
figset_date(ax, daym_N)
figset_date_minorticks(ax, daym_N)
title_str = sprintf('Lower layer %.1f mab', low+1.4);
title(ax, title_str, 'fontsize', 12)
set(ax, 'xticklabels', [])
grid on

ax = nexttile;
quiver_f(dday_N, u_N(:,low)*100, v_N(:,low)*100)
axis([floor(daym_N(1)) ceil(daym_N(end)) -80 80])
set(ax, 'ytick', -80:40:80)
ylabel('Speed (cm/s)')
xlabel('Date (month/day)')
figset_linefont(ax)
figset_date(ax, daym_N)
figset_date_minorticks(ax, daym_N)
grid on

cd(pic_c)
exportgraphics(gcf,[filedate, station_N, 'threelayers_Current_speed_flow_vector_depth_wind.png'])


%====================== S station ============================
figure('OuterPosition', [1 1 1920/2 1080])
t = tiledlayout(8, 1, "TileSpacing", "compact", "Padding", "compact");
ax = nexttile;
plot(dday_S, Pre_S, 'k', 'LineWidth', 2)
ylim([floor(min(Pre_S)*2)/2 ceil(max(Pre_S)*2)/2]);
xlim([floor(daym_S(1)) ceil(daym_S(end))])
ylabel('Depth (m)')
figset_linefont(ax)
figset_date(ax, daym_S)
figset_date_minorticks(ax, daym_S)
set(ax, 'xticklabels', [])
title_str = sprintf('\\bf%s station Tide level, Wind speed & direction and Current speed & direction\n\\rm%s', ...
    station_S, plotdate_all);
title(t, title_str, 'fontsize', 15)
title(ax, "Tide level", FontSize=12)
grid on

cd(func)
ax = nexttile;
quiver_f(daym_N, wu, wv)
axis([floor(daym_N(1)) ceil(daym_N(end)) -15 15])
set(gca,'ytick',-15:5:15);
ylabel('Speed (m/s)');
figset_linefont(ax)
figset_date(ax, daym_N)
figset_date_minorticks(ax, daym_N)
grid on
title(ax, 'Wind', 'FontSize', 12)
set(ax, 'xticklabels', [])


ax = nexttile;
plot(dday_S, Cur_S(:,upp)*100, 'k','LineWidth',2)
axis([floor(daym_S(1)) ceil(daym_S(end)) 0 80])
ylabel('Speed (cm/s)')
figset_linefont(ax)
figset_date(ax, daym_S)
figset_date_minorticks(ax, daym_S)
grid on
title_str = sprintf('Upper layer %.1f mab', upp+1.4);
title(ax, title_str, 'fontsize', 12)
set(ax, 'xticklabels', [])

ax = nexttile;
quiver_f(dday_S, u_S(:,upp)*100, v_S(:,upp)*100)
axis([floor(daym_S(1)) ceil(daym_S(end)) -80 80])
set(ax, 'ytick', -80:40:80)
ylabel('Speed (cm/s)')
figset_linefont(ax)
figset_date(ax, daym_S)
figset_date_minorticks(ax, daym_S)
set(ax, 'xticklabels', [])
grid on

% Middle layer
ax = nexttile;
plot(dday_S, Cur_S(:,mid)*100,'k','LineWidth',2)
axis([floor(daym_S(1)) ceil(daym_S(end)) 0 80])
ylabel('Speed (cm/s)')
set(ax,'ytick',0:20:80)
figset_linefont(ax)
figset_date(ax, daym_S)
figset_date_minorticks(ax, daym_S)
title_str = sprintf('Middle layer %.1f mab', mid+1.4);
title(ax, title_str, 'fontsize', 12)
set(ax, 'xticklabels', [])
grid on

ax = nexttile;
quiver_f(dday_S, u_S(:,mid)*100, v_S(:,mid)*100)
axis([floor(daym_S(1)) ceil(daym_S(end)) -80 80])
set(ax, 'ytick', -80:40:80)
ylabel('Speed (cm/s)')
figset_linefont(ax)
figset_date(ax, daym_S)
figset_date_minorticks(ax, daym_S)
set(ax, 'xticklabels', [])
grid on

% bottom layer
ax = nexttile;
plot(dday_S, Cur_S(:,low)*100, 'k', 'LineWidth', 2)
axis([floor(daym_S(1)) ceil(daym_S(end)) 0 80])
ylabel('Speed (cm/s)')
set(gca, 'ytick', 0:20:80)
figset_linefont(ax)
figset_date(ax, daym_S)
figset_date_minorticks(ax, daym_S)
title_str = sprintf('Lower layer %.1f mab', low+1.4);
title(ax, title_str, 'fontsize', 12)
set(ax, 'xticklabels', [])
grid on

ax = nexttile;
quiver_f(dday_S, u_S(:,low)*100, v_S(:,low)*100)
axis([floor(daym_S(1)) ceil(daym_S(end)) -80 80])
set(ax, 'ytick', -80:40:80)
ylabel('Speed (cm/s)')
xlabel('Date (month/day)')
figset_linefont(ax)
figset_date(ax, daym_S)
figset_date_minorticks(ax, daym_S)
grid on

cd(pic_c)
exportgraphics(gcf,[filedate, station_S, 'threelayers_Current_speed_flow_vector_depth_wind.png']) % saving picture and cutting the empty frame


%% Current Rose 
MaxProp = 50; % current direction probability

cd(func)
figure("OuterPosition", [1 1 1920/2 1080])
tt = tiledlayout(3, 2, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
WindRose(Dir_N(:,upp),Cur_N(:,upp)*100, ... % the function i don't where to download it, but in your functions folder
    'nDirections', 16, ...
    'gridstyle', ':', ...
    'gridcolor', 'k', ...
    'gridwidth', 2, ...
    'gridalpha', 0.5, ...
    'labels', {'N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'}, ...
    'cMap', 'invgray', ...
    'vWinds',[0 10 20 30 40 50 60], ...
    'TitleString', [station_N, ' Cur Upper Layer ', num2str(upp+1.4),' mab'], ...
    'LabLegend', 'Cur in cm', ...
    'LegendVariable', 'Cur' , ...
    'zeroAndNegative', true, ...
    'MaxFrequency', MaxProp, ...
    'FreqLabelAngle', 'auto', ...
    'AngleNorth', 0, ...
    'axes', gca, ...
    'AngleEast', 90);
figset_linefont(ax)
ax.Legend.Location = 'westoutside';

ax = nexttile;
WindRose(Dir_S(:,upp),Cur_S(:,upp)*100, ...
    'nDirections', 16, ...
    'gridstyle', ':', ...
    'gridcolor', 'k', ...
    'gridwidth', 2, ...
    'gridalpha', 0.5, ...
    'labels', {'N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'}, ...
    'cMap', 'invgray', ...
    'vWinds',[0 10 20 30 40 50 60], ...
    'TitleString', [station_S, ' Cur Upper Layer ', num2str(upp+1.4),' mab'], ...
    'LabLegend', 'Cur in cm', ...
    'LegendVariable', 'Cur' , ...
    'zeroAndNegative', true, ...
    'MaxFrequency', MaxProp, ...
    'FreqLabelAngle', 'auto', ...
    'AngleNorth', 0, ...
    'AngleEast', 90, ...
    'axes', gca);
figset_linefont(ax)
set(ax.Legend, 'visible', 'off')

ax = nexttile;
WindRose(Dir_N(:,mid),Cur_N(:,mid)*100,'nDirections', 16,'gridstyle', ':', 'gridcolor', 'k', 'gridwidth', 2, 'gridalpha', 0.5, 'labels', {'N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'}, 'cMap', 'invgray','vWinds',[0 10 20 30 40 50 60], ...
    'TitleString', [station_N, ' Cur Middle Layer ', num2str(mid+1.4),' mab'], 'LabLegend', 'Cur in cm', 'LegendVariable', 'Cur' ,'zeroAndNegative', true, ...
    'MaxFrequency', MaxProp, 'FreqLabelAngle', 'auto', 'AngleNorth', 0, 'AngleEast', 90, ...
    "axes", gca);
figset_linefont(ax)
% ax.Legend.Location = 'westoutside';
set(ax.Legend, 'visible', 'off')

ax = nexttile;
WindRose(Dir_S(:,mid),Cur_S(:,mid)*100,'nDirections', 16,'gridstyle', ':', 'gridcolor', 'k', 'gridwidth', 2, 'gridalpha', 0.5, 'labels', {'N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'}, 'cMap', 'invgray','vWinds',[0 10 20 30 40 50 60], ...
    'TitleString', [station_S, ' Cur Middle Layer ', num2str(mid+1.4),' mab'], 'LabLegend', 'Cur in cm', 'LegendVariable', 'Cur' ,'zeroAndNegative', true, ...
    'MaxFrequency', MaxProp, 'FreqLabelAngle', 'auto', 'AngleNorth', 0, 'AngleEast', 90, ...
    "axes", gca);
figset_linefont(ax)
set(ax.Legend, 'visible', 'off')

ax = nexttile;
WindRose(Dir_N(:,low),Cur_N(:,low)*100,'nDirections', 16,'gridstyle', ':', 'gridcolor', 'k', 'gridwidth', 2, 'gridalpha', 0.5, 'labels', {'N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'}, 'cMap', 'invgray','vWinds',[0 10 20 30 40 50 60], ...
    'TitleString', [station_N, ' Cur Lower Layer ', num2str(low+1.4),' mab'], 'LabLegend', 'Cur in cm', 'LegendVariable', 'Cur' ,'zeroAndNegative', true, ...
    'MaxFrequency', MaxProp, 'FreqLabelAngle', 'auto', 'AngleNorth', 0, 'AngleEast', 90, ...
    "axes", gca);
figset_linefont(ax)
% ax.Legend.Location = 'westoutside';
set(ax.Legend, 'visible', 'off')

ax = nexttile;
WindRose(Dir_S(:,low),Cur_S(:,low)*100,'nDirections', 16,'gridstyle', ':', 'gridcolor', 'k', 'gridwidth', 2, 'gridalpha', 0.5, 'labels', {'N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'}, 'cMap', 'invgray','vWinds',[0 10 20 30 40 50 60], ...
    'TitleString', [station_S, ' Cur Lower Layer ', num2str(low+1.4),' mab'], 'LabLegend', 'Cur in cm', 'LegendVariable', 'Cur' ,'zeroAndNegative', true, ...
    'MaxFrequency', MaxProp, 'FreqLabelAngle', 'auto', 'AngleNorth', 0, 'AngleEast', 90, ...
    "axes", gca);
figset_linefont(ax)
set(ax.Legend, 'visible', 'off')

file_str = sprintf("%s\\%s3layers_2sites_Windrose.png", pic_c, filedate);
exportgraphics(gcf, file_str)

%% PVD (Progressive Vector Diagram)
cd(func)
totalday = ceil(dday_N(end)-dday_N(1)); % days from the start to the end of the observation 
dayday = diff(floor(dday_N)); % round down the dday data, force it into the beginging of the day (e.g. floor(2026/04/30 11:30) -> 2026/04/30 00:00)
another_day = find(dayday == 1); % diff: difference value between values of the double data; if the day is changed, diff(dayday) = 1
PVD_time = [0;diff((dday_N-datenum(dday_N(1)))*86400)]; % turning day into second, then made it as a matrix (double)
PVD_time_S = [0;diff((dday_S-datenum(dday_S(1)))*86400)];
figure("OuterPosition", [1 1 1920/2 1080])
tt = tiledlayout(3,2,"TileSpacing","compact","Padding","tight");
%{
for ii = upp
    %=========================== N station ============================
    ax = nexttile;
    xlocal=cumsum(u_N(:,ii).*PVD_time/1000); % 10分鐘一筆資料 & 單位轉換成公里
    ylocal=cumsum(v_N(:,ii).*PVD_time/1000);
    x = cumsum(abs(u_N(:,ii)).*PVD_time/1000);
    y = cumsum(abs(v_N(:,ii)).*PVD_time/1000);
    distance = sqrt(x(end)^2+y(end)^2);
    vel = distance/totalday;

    plot(xlocal,ylocal,'k','linewidth',1.5);hold on;
    plot(xlocal(another_day),ylocal(another_day),'ob','markerSize',7,'MarkerFaceColor','none');hold on;
    plot(xlocal(1),ylocal(1),'ob','markerSize',5,'MarkerFaceColor','b');hold on;
    plot(xlocal(end),ylocal(end),'om','markerSize',10,'MarkerFaceColor','none');hold on;
    axis equal;
    grid on;
    axis_lim = [-150 50 -100 50];
    axis(axis_lim)
        
    text(xlocal(1),ylocal(1)+10,[datestr(dday_N(1), 'yyyy/mm/dd HH:MM')],'FontSize',12,'color','b', ...
        'HorizontalAlignment','center');
    text(xlocal(end)-40,ylocal(end)-10,[datestr(dday_N(end), 'yyyy/mm/dd HH:MM')],'fontsize',12,'color','m', ...
        'HorizontalAlignment','left');
    % text(48, -95, ['底床上', num2str(ii+1.4), 'm'],'FontName','標楷體','FontSize',12,'HorizontalAlignment','right')
    for jj = 2:2:length(another_day+1)
        text(xlocal(another_day(jj-1))+7, ylocal(another_day(jj-1))+5,[datestr((dday_N(another_day(jj))), 'dd')], ...
            'FontSize',12,'color','k');
    end
    text(-130, 40, ['Total path length: ', num2str(distance, '%.1f'), ' km'], 'fontsize', 16)
    text(-130, 25, ['Velocity: ', num2str(vel, '%.1f'), ' km/day'], 'fontsize', 16)
    text(axis_lim(1)+15, axis_lim(3)-10, '(km)', 'FontSize', 15)
    text(axis_lim(1)-5, axis_lim(3)+15, '(km)', 'FontSize', 15, 'HorizontalAlignment','right')
    set(gca,'FontWeight','bold','fontsize',15, 'tickdir', 'out','linewidth',1.5, ...
        'Ticklength', [.03 .03]);hold on
    ax.XAxis.MinorTick = 'on';
    ax.XAxis.MinorTickValues = axis_lim(1):10:axis_lim(2);
    ax.YAxis.MinorTick = 'on';
    ax.YAxis.MinorTickValues = axis_lim(3):10:axis_lim(4);

    title_str = sprintf("N PVD %.1f mab", ii+1.4);
    title(ax, title_str, 'FontSize', 18)

    %=========================== S station ============================
    ax = nexttile;
    xlocal=cumsum(u_S(:,ii).*PVD_time_S/1000); % 10分鐘一筆資料 & 單位轉換成公里
    ylocal=cumsum(v_S(:,ii).*PVD_time_S/1000);
    x = cumsum(abs(u_S(:,ii)).*PVD_time_S/1000);
    y = cumsum(abs(v_S(:,ii)).*PVD_time_S/1000);
    distance = sqrt(x(end)^2+y(end)^2);
    vel = distance/totalday;

    plot(xlocal,ylocal,'k','linewidth',1.5);hold on;
    plot(xlocal(another_day),ylocal(another_day),'ob','markerSize',7,'MarkerFaceColor','none');hold on;
    plot(xlocal(1),ylocal(1),'ob','markerSize',5,'MarkerFaceColor','b');hold on;
    plot(xlocal(end),ylocal(end),'om','markerSize',10,'MarkerFaceColor','none');hold on;
    axis equal;
    grid on;
    axis_lim = [-150 50 -100 50];
    axis(axis_lim)
        
    text(xlocal(1),ylocal(1)+10,[datestr(dday_S(1), 'yyyy/mm/dd HH:MM')],'FontSize',12,'color','b', ...
        'HorizontalAlignment','center');
    text(xlocal(end)-40,ylocal(end)-10,[datestr(dday_S(end), 'yyyy/mm/dd HH:MM')],'fontsize',12,'color','m', ...
        'HorizontalAlignment','left');
    % text(48, -95, ['底床上', num2str(ii+1.4), 'm'],'FontName','標楷體','FontSize',12,'HorizontalAlignment','right')
    for jj = 2:2:length(another_day+1)
        text(xlocal(another_day(jj-1))+7, ylocal(another_day(jj-1))+5,[datestr((dday_S(another_day(jj))), 'dd')], ...
            'FontSize',12,'color','k');
    end
    text(-130, 40, ['Total path length: ', num2str(distance, '%.1f'), ' km'], 'fontsize', 16)
    text(-130, 25, ['Velocity: ', num2str(vel, '%.1f'), ' km/day'], 'fontsize', 16)
    text(axis_lim(1)+15, axis_lim(3)-10, '(km)', 'FontSize', 15)
    text(axis_lim(1)-5, axis_lim(3)+15, '(km)', 'FontSize', 15, 'HorizontalAlignment','right')
    set(gca,'FontWeight','bold','fontsize',15, 'tickdir', 'out','linewidth',1.5, ...
        'Ticklength', [.03 .03]);hold on
    ax.XAxis.MinorTick = 'on';
    ax.XAxis.MinorTickValues = axis_lim(1):10:axis_lim(2);
    ax.YAxis.MinorTick = 'on';
    ax.YAxis.MinorTickValues = axis_lim(3):10:axis_lim(4);

    title_str = sprintf("S PVD %.1f mab", ii+1.4);
    title(ax, title_str, 'FontSize', 18)
end
%}


for ii = [upp mid low]
    %=========================== N station ============================
    ax = nexttile;
    xlocal=cumsum(u_N(:,ii).*PVD_time/1000); % 10分鐘一筆資料 & 單位轉換成公里
    ylocal=cumsum(v_N(:,ii).*PVD_time/1000);
    x = cumsum(abs(u_N(:,ii)).*PVD_time/1000); % calculate the distance of U component, then accumulate the data
    y = cumsum(abs(v_N(:,ii)).*PVD_time/1000); % calculate the distance of V component, then accumulate the data
    distance = sqrt(x(end)^2+y(end)^2); % Pythagorean theorem
    vel = distance/totalday; % total distance / total days

    plot(xlocal,ylocal,'k','linewidth',1.5);hold on;
    plot(xlocal(another_day),ylocal(another_day),'ob','markerSize',7,'MarkerFaceColor','none');hold on;
    plot(xlocal(1),ylocal(1),'ob','markerSize',5,'MarkerFaceColor','b');hold on;
    plot(xlocal(end),ylocal(end),'om','markerSize',10,'MarkerFaceColor','none');hold on;
    axis equal;
    grid on;
    axis_lim = [-150 250 -200 150];
    axis(axis_lim)
        
    text(xlocal(1),ylocal(1)+10,[datestr(dday_N(1), 'yyyy/mm/dd HH:MM')],'FontSize',12,'color','b', ...
        'HorizontalAlignment','center');
    text(xlocal(end)-40,ylocal(end)-10,[datestr(dday_N(end), 'yyyy/mm/dd HH:MM')],'fontsize',12,'color','m', ...
        'HorizontalAlignment','left');
    % text(48, -95, ['底床上', num2str(ii+1.4), 'm'],'FontName','標楷體','FontSize',12,'HorizontalAlignment','right')
    for jj = 2:2:length(another_day+1)
        text(xlocal(another_day(jj-1))+7, ylocal(another_day(jj-1))+5,[datestr((dday_N(another_day(jj))), 'dd')], ...
            'FontSize',12,'color','k');
    end
    y_axis_length = axis_lim(4)-axis_lim(3);
    x_axis_length = axis_lim(2)-axis_lim(1);
    text(0.01, 0.95, ['Total path length: ', num2str(distance, '%.1f'), ' km'], 'fontsize', 16, 'Units', 'normalized')
    text(0.01, 0.85, ['Velocity: ', num2str(vel, '%.1f'), ' km/day'], 'fontsize', 16, 'Units', 'normalized')
    text(0.12, -0.05, '(km)', 'FontSize', 15, 'Units', 'normalized')
    text(-0.02, 0.2, '(km)', 'FontSize', 15, 'HorizontalAlignment','right', 'Units', 'normalized')
    set(gca,'FontWeight','bold','fontsize',15, 'tickdir', 'out','linewidth',1.5, ...
        'Ticklength', [.03 .03]);hold on
    ax.XAxis.MinorTick = 'on';
    ax.XAxis.MinorTickValues = axis_lim(1):10:axis_lim(2);
    ax.YAxis.MinorTick = 'on';
    ax.YAxis.MinorTickValues = axis_lim(3):10:axis_lim(4);

    title_str = sprintf("N PVD %.1f mab", ii+1.4);
    title(ax, title_str, 'FontSize', 18)

    %=========================== S station ============================
    ax = nexttile;
    xlocal=cumsum(u_S(:,ii).*PVD_time_S/1000); % 10分鐘一筆資料 & 單位轉換成公里
    ylocal=cumsum(v_S(:,ii).*PVD_time_S/1000);
    x = cumsum(abs(u_S(:,ii)).*PVD_time_S/1000);
    y = cumsum(abs(v_S(:,ii)).*PVD_time_S/1000);
    distance = sqrt(x(end)^2+y(end)^2);
    vel = distance/totalday;

    plot(xlocal,ylocal,'k','linewidth',1.5);hold on;
    plot(xlocal(another_day),ylocal(another_day),'ob','markerSize',7,'MarkerFaceColor','none');hold on;
    plot(xlocal(1),ylocal(1),'ob','markerSize',5,'MarkerFaceColor','b');hold on;
    plot(xlocal(end),ylocal(end),'om','markerSize',10,'MarkerFaceColor','none');hold on;
    axis equal;
    grid on;
    axis_lim = [-150 250 -200 150];
    axis(axis_lim)
        
    text(xlocal(1),ylocal(1)+10,[datestr(dday_S(1), 'yyyy/mm/dd HH:MM')],'FontSize',12,'color','b', ...
        'HorizontalAlignment','center');
    text(xlocal(end)-40,ylocal(end)-10,[datestr(dday_S(end), 'yyyy/mm/dd HH:MM')],'fontsize',12,'color','m', ...
        'HorizontalAlignment','left');
    % text(48, -95, ['底床上', num2str(ii+1.4), 'm'],'FontName','標楷體','FontSize',12,'HorizontalAlignment','right')
    for jj = 2:2:length(another_day+1)
        text(xlocal(another_day(jj-1))+7, ylocal(another_day(jj-1))+5,[datestr((dday_S(another_day(jj))), 'dd')], ...
            'FontSize',12,'color','k');
    end
    y_axis_length = axis_lim(4)-axis_lim(3);
    x_axis_length = axis_lim(2)-axis_lim(1);
    text(0.01, 0.95, ['Total path length: ', num2str(distance, '%.1f'), ' km'], 'fontsize', 16, 'Units', 'normalized')
    text(0.01, 0.85, ['Velocity: ', num2str(vel, '%.1f'), ' km/day'], 'fontsize', 16, 'Units', 'normalized')
    text(0.12, -0.05, '(km)', 'FontSize', 15, 'Units', 'normalized')
    text(-0.02, 0.2, '(km)', 'FontSize', 15, 'HorizontalAlignment','right', 'Units', 'normalized')
    set(gca,'FontWeight','bold','fontsize',15, 'tickdir', 'out','linewidth',1.5, ...
        'Ticklength', [.03 .03]);hold on
    ax.XAxis.MinorTick = 'on';
    ax.XAxis.MinorTickValues = axis_lim(1):10:axis_lim(2);
    ax.YAxis.MinorTick = 'on';
    ax.YAxis.MinorTickValues = axis_lim(3):10:axis_lim(4);

    title_str = sprintf("S PVD %.1f mab", ii+1.4);
    title(ax, title_str, 'FontSize', 18)
end

file_str = sprintf("%s\\%sPVD_3layers_2sites.png", pic_c, filedate);
exportgraphics(gcf, file_str)

%% scatter UV
figure("OuterPosition", [1 1 1920/2-300 1080])
tt = tiledlayout(3, 2, "TileSpacing", "compact", "Padding", "tight");
for ii = [upp mid low]
    ax = nexttile;
    scatter(u_N(:, ii), v_N(:, ii), 8, "filled", "MarkerFaceColor", [.5 .5 1]); hold on % scatter chart of U & V component
    axis equal
    text(.1, -.7, '(m/sec)', 'FontSize',15)
    ax.XAxisLocation = 'origin'; % making X axis fixed at y = 0
    ax.YAxisLocation = 'origin'; % making Y axis fixed at x = 0
    ax.TickDir = 'both'; % having ticks both inside and outside axis
    axis([-.9 .9 -.9 .9])
    set(ax, 'Xtick', [-.8:.2:-.4, .2:.2:.8], 'Ytick', -.8:.2:.8, ...
        'fontsize',13,'linewidth',1.5, 'Ticklength', [.03 .03], ...
        'Clipping', 'off', 'fontweight', 'bold') % "Clipping": allow plots out of frame
    plot([-.2, -.2], [-.07, .07], 'LineWidth', 2, 'Color', [.2 .2 .2])
    text(-.2, -.08, '-0.2', 'FontSize', 13, 'FontWeight', 'bold', 'HorizontalAlignment', 'center')
    ax.XAxis.MinorTick = 'on';
    ax.XAxis.MinorTickValues = -.8:.1:.8;
    ax.YAxis.MinorTick = 'on';
    ax.YAxis.MinorTickValues = -.8:.1:.8;
    ax.Layer = 'top';
    title_str = sprintf("N %.1f mab", ii+1.4);
    title(ax, title_str, 'FontSize', 15)

    ax = nexttile;
    scatter(u_S(:, ii), v_S(:, ii), 8, "filled", "MarkerFaceColor", [.5 .5 1]); hold on
    axis equal
    text(.1, -.7, '(m/sec)', 'FontSize',15)
    ax.XAxisLocation = 'origin';
    ax.YAxisLocation = 'origin';
    ax.TickDir = 'both';
    axis([-.9 .9 -.9 .9])
    set(ax, 'Xtick', [-.8:.2:-.4, .2:.2:.8], 'Ytick', -.8:.2:.8, ...
        'fontsize',13,'linewidth',1.5, 'Ticklength', [.03 .03], ...
        'Clipping', 'off', 'fontweight', 'bold')
    plot([-.2, -.2], [-.07, .07], 'LineWidth', 2, 'Color', [.2 .2 .2])
    text(-.2, -.08, '-0.2', 'FontSize', 13, 'FontWeight', 'bold', 'HorizontalAlignment', 'center')
    ax.XAxis.MinorTick = 'on';
    ax.XAxis.MinorTickValues = -.8:.1:.8;
    ax.YAxis.MinorTick = 'on';
    ax.YAxis.MinorTickValues = -.8:.1:.8;
    ax.Layer = 'top';
    title_str = sprintf("S %.1f mab", ii+1.4);
    title(ax, title_str, 'FontSize', 15)
end
% title_str = sprintf("\\bfUV scatter diagram\n\\rm%s", plotdate_all);
% title(tt, title_str, 'fontsize', 18)

file_str = sprintf("%s\\%sUV_scatter_diagram_3layers_2sites.png", pic_c, filedate);
exportgraphics(gcf, file_str)
