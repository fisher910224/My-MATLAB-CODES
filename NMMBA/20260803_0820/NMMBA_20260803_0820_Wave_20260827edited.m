%% 20260803~0820 Wave both station
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
WW = load("DATA_W.mat");
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

tur_N(tur_N>60) = NaN;

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

% ==================== Wave ====================
% 202508 special
% useful = WW.(['N_wave', dates])(:,3)>0;
useful = WW.(['wave', dates])(:,3)>0;
% [N.Tp, N.T, N.Hs] = huang_waveheightTp(WW.(['N_wave', dates])(useful,:),1,1200);
[N.Tp, N.T, N.Hs] = huang_waveheightTp(WW.(['wave', dates])(useful,:),1,1200);
N.Tp(N.Tp > 15) = NaN;
N.Hs = N.Hs(~isnan(N.Hs));
N.T = N.T(~isnan(N.Hs));
N.Tp = N.Tp(~isnan(N.Hs));

useful = WW.(['wave', dates, '_S'])(:,3)>0;
% [S.Tp, S.T, S.Hs] = huang_waveheightTp(WW.(['S_wave', dates])(useful,:),1,1200);
[S.Tp, S.T, S.Hs] = huang_waveheightTp(WW.(['wave', dates, '_S'])(useful,:),1,1200);
S.Tp(S.Tp > 15) = NaN;
S.Hs = S.Hs(~isnan(S.Hs));
S.T = S.T(~isnan(S.Hs));
S.Tp = S.Tp(~isnan(S.Hs));


less_length = min([length(waveday_N) length(N.Hs)]);
N.Hs = N.Hs(1:less_length);
N.T = N.T(1:less_length);
N.Tp = N.Tp(1:less_length);
waveday_N = waveday_N(1:less_length);



less_length = min([length(waveday_S) length(S.Hs)]);
S.Hs = S.Hs(1:less_length);
S.T = S.T(1:less_length);
S.Tp = S.Tp(1:less_length);
waveday_S = waveday_S(1:less_length);

% XX = WW.XX(1:less_length);
% S.Hs = S.Hs.*XX;
% S.T = S.T.*XX;
% S.Tp = S.Tp.*XX;

%% figsetting
figset_linefont = @(ax) set(ax, 'fontsize', 15, 'linewidth', 1.5, "TickLength", [0.005 0.02], 'TickDir', 'out');
figset_date = @(ax, wave_day) set(ax, 'XTick', floor(wave_day(1)):4:ceil(wave_day(end)), ...
    'Xticklabel', datestr(floor(wave_day(1)):4:ceil(wave_day(end)), 'mm/dd'));
figset_date_minorticks = @(ax, wave_day) set(ax.XAxis, 'Minortick', 'on', 'MinorTickValues', floor(wave_day(1)):1:ceil(wave_day(end)));

%% 
cd(func)
[N.percentHsT, N.percentHsTp] = Vanalyis_wave(N.Hs, N.T, N.Tp, ...
    [filedate, station_N, 'Wave_height_HsT.txt'], [filedate, station_N, 'Wave_height_HsTp.txt'],f_data);

[S.percentHsT, S.percentHsTp] = Vanalyis_wave(S.Hs, S.T, S.Tp, ...
    [filedate, station_S, 'Wave_height_HsT.txt'], [filedate, station_S, 'Wave_height_HsTp.txt'],f_data);

edges=0:10:160;
T_range=3:1:16;

%% 繪製長條圖 Histogram
% ====================== N station ======================
figure('outerposition',get(0,'screensize')); % 全螢幕 Full screen Picture
t = tiledlayout(3,1,"TileSpacing","compact","Padding","tight");
ax = nexttile;
histogram(N.Hs,edges,'Normalization','probability','FaceColor','k');
axis([00 140 0 0.6]);
set(gca,'xtick',0:10:140,'linewidth',3,'FontWeight','bold','fontsize',18, ...
    'ytick',0:0.2:0.6,'yticklabel',{'0','20','40','60'})
ylabel('percentage (%)');
title(ax,'Hs (cm)','fontsize',18)
title(t, {['\bf', station_N, '  station Wave Height probability distribution'], ['\rm',plotdate_all]},'fontsize',28);

ax = nexttile;
histogram(N.T,T_range,'Normalization','probability','FaceColor','k');
title(ax,'Tm02 (second)','fontsize',18);
axis([0 12 0 1]);
set(gca,'xtick',0:1:16,'ytick',(0:50:100)/100,'yticklabel',{'0','50','100'}, ...
    'linewidth',3,'FontWeight','bold','fontsize',18);
ylabel('percentage (%)');

ax = nexttile;
histogram(N.Tp, T_range,'Normalization','probability','FaceColor','k');
title(ax,'Tp (second)','fontsize',18);
axis([0 12 0 0.4]);
set(gca,'xtick',0:1:16,'ytick',(0:10:40)/100,'yticklabel',{'0','10','20','30','40'}, ...
    'linewidth',3,'FontWeight','bold','fontsize',18);
ylabel('percentage (%)');
cd(pic_w)
exportgraphics(gcf,[filedate,station_N, 'Hs_T_Tp_Histogram.png'])

% ====================== S station ======================
figure('outerposition',get(0,'screensize')); % 全螢幕 Full screen Picture
t = tiledlayout(3,1,"TileSpacing","compact","Padding","tight");
ax = nexttile;
histogram(S.Hs,edges,'Normalization','probability','FaceColor','k');
axis([00 140 0 0.6]);
set(gca,'xtick',0:10:140,'linewidth',3,'FontWeight','bold','fontsize',18, ...
    'ytick',0:0.2:0.6,'yticklabel',{'0','20','40','60'})
ylabel('percentage (%)');
title(ax,'Hs (cm)','fontsize',18)
title(t, {['\bf', station_S, '  station Wave Height probability distribution'], ['\rm',plotdate_all]},'fontsize',28);

ax = nexttile;
histogram(S.T,T_range,'Normalization','probability','FaceColor','k');
title(ax,'Tm02 (second)','fontsize',18);
axis([0 12 0 1]);
set(gca,'xtick',0:1:16,'ytick',(0:50:100)/100,'yticklabel',{'0','50','100'}, ...
    'linewidth',3,'FontWeight','bold','fontsize',18);
ylabel('percentage (%)');

ax = nexttile;
histogram(S.Tp, T_range,'Normalization','probability','FaceColor','k');
title(ax,'Tp (second)','fontsize',18);
axis([0 12 0 0.4]);
set(gca,'xtick',0:1:16,'ytick',(0:10:40)/100,'yticklabel',{'0','10','20','30','40'}, ...
    'linewidth',3,'FontWeight','bold','fontsize',18);
ylabel('percentage (%)');
cd(pic_w)
exportgraphics(gcf,[filedate,station_S, 'Hs_T_Tp_Histogram.png'])

%% N station Wave height, period, wind correlation diagram
% ====================== N station ======================
figure('outerposition',get(0,'screensize')); % 全螢幕儲存 Full screen Picture
t = tiledlayout(4,1,"TileSpacing","compact","Padding","tight");
ax = nexttile;
plot(waveday_N, N.Hs,'k','LineWidth',3) %波高 function(subvelopic)
ylabel('Hs(cm)')
axis([floor(dday_N(1)) ceil(dday_N(end)) 0 floor(max(N.Hs))+20]);
grid on
figset_linefont(ax)
figset_date(ax, waveday_N)
figset_date_minorticks(ax, waveday_N)
title(t, {['\bf',station_N,' station Wave height, period, wind correlation diagram'],['\rm',plotdate_all]},'FontSize',24);
set(ax, 'xticklabels', [])

ax = nexttile;
plot(waveday_N, N.T,'k','LineWidth',3) % 週期
ylabel('Tm02(second)')
axis([floor(dday_N(1)) ceil(dday_N(end)) 4 floor(max(N.T))+1]);
figset_linefont(ax)
figset_date(ax, waveday_N)
figset_date_minorticks(ax, waveday_N)
grid on
set(ax, 'xticklabels', [])

ax = nexttile;
plot(waveday_N, N.Tp,'k','LineWidth',3) % 尖峰週期
ylabel('Tp(second)')
axis([floor(dday_N(1)) ceil(dday_N(end)) 4 ceil(max(N.Tp)+1)]);
figset_linefont(ax)
figset_date(ax, waveday_N)
figset_date_minorticks(ax, waveday_N)
set(ax, 'xticklabels', [])
grid on

cd(func)
ax = nexttile;
% scale = 10;
if length(waveday_N) > length(wu)
    quiver_f(waveday_N(1:length(wu)),wu,wv);hold on % 風場資料
else
    quiver_f(waveday_N,wu(1:length(waveday_N)),wv(1:length(waveday_N)));hold on % 風場資料
end
axis([floor(dday_N(1)) ceil(dday_N(end)) -15 15]);
set(gca,'ytick',-15:5:15);
% legend('scale = 10')
ylabel('wind speed (m/s)');
xlabel(['month/day of ', datestr(dday_N(1), 'yyyy')]);
set(gca,'linewidth',2,'fontsize',18);hold on
set(gca, 'xticklabel',datelabel,'xtick',floor(waveday_N(1)):4:ceil(waveday_N(end))) ;
figset_linefont(ax)
figset_date(ax, waveday_N)
figset_date_minorticks(ax, waveday_N)
grid on
cd(pic_w)
exportgraphics(gcf,[filedate,station_N, 'Hs_T_Tp_wind_diagram.png'])

% ====================== S station ======================
figure('outerposition',get(0,'screensize')); % 全螢幕儲存 Full screen Picture
t = tiledlayout(4,1,"TileSpacing","compact","Padding","tight");
ax = nexttile;
plot(waveday_S, S.Hs,'k','LineWidth',3) %波高 function(subvelopic)
ylabel('Hs(cm)')
axis([floor(dday_S(1)) ceil(dday_S(end)) 0 floor(max(S.Hs))+20]);
grid on
figset_linefont(ax)
figset_date(ax, waveday_S)
figset_date_minorticks(ax, waveday_S)
title(t, {['\bf',station_S,' station Wave height, period, wind correlation diagram'],['\rm',plotdate_all]},'FontSize',24);
set(ax, 'xticklabels', [])

ax = nexttile;
plot(waveday_S, S.T,'k','LineWidth',3) % 週期
ylabel('Tm02(second)')
axis([floor(dday_S(1)) ceil(dday_S(end)) 4 floor(max(S.T))+1]);
figset_linefont(ax)
figset_date(ax, waveday_S)
figset_date_minorticks(ax, waveday_S)
grid on
set(ax, 'xticklabels', [])

ax = nexttile;
plot(waveday_S, S.Tp,'k','LineWidth',3) % 尖峰週期
ylabel('Tp(second)')
axis([floor(dday_S(1)) ceil(dday_S(end)) 4 ceil(max(S.Tp)+1)]);
figset_linefont(ax)
figset_date(ax, waveday_S)
figset_date_minorticks(ax, waveday_S)
set(ax, 'xticklabels', [])
grid on

cd(func)
ax = nexttile;
% scale = 10;
if length(waveday_S) > length(wu)
    quiver_f(waveday_S(1:length(wu)),wu,wv);hold on % 風場資料
else
    quiver_f(waveday_S,wu(1:length(waveday_S)),wv(1:length(waveday_S)));hold on % 風場資料
end
axis([floor(dday_S(1)) ceil(dday_S(end)) -15 15]);
set(gca,'ytick',-15:5:15);
% legend('scale = 10')
ylabel('wind speed (m/s)');
xlabel(['month/day of ', datestr(dday_S(1), 'yyyy')]);
set(gca,'linewidth',2,'fontsize',18);hold on
set(gca, 'xticklabel',datelabel,'xtick',floor(waveday_S(1)):4:ceil(waveday_S(end))) ;
figset_linefont(ax)
figset_date(ax, waveday_S)
figset_date_minorticks(ax, waveday_S)
grid on
cd(pic_w)
exportgraphics(gcf,[filedate,station_S, 'Hs_T_Tp_wind_diagram.png'])

%% Hs vs Tur
% ====================== N station ======================
figure('OuterPosition',get(0,'ScreenSize'))
t = tiledlayout(1,1,"TileSpacing","compact","Padding","tight");
ax = nexttile;
yyaxis left
plot(waveday_N, N.Hs ,'black','LineWidth',2)
ylabel('Hs (cm)','FontSize',18)
axis([floor(waveday_N(1)) ceil(waveday_N(end)) 0 ceil(max(N.Hs)/50)*50])
set(gca,'ycolor','black')
grid on
yyaxis right
plot(dday_N, tur_N,'o','color','r','LineWidth',2)
ylabel('Turbidity (NTU)','FontSize',18)
% ylim([0 ceil(max(tur_N)/50)*50])
% ylim([0 10])
set(gca,'ycolor','r')
legend('Hs','Turb')
xlabel(['month/day of ',datestr(dday_N(1), 'yyyy')])
figset_linefont(ax)
figset_date(ax, waveday_N)
figset_date_minorticks(ax, waveday_N)
title(t,{['\bf',station_N, ' Hs and Turbidity'],['\rm',plotdate_all]},'FontSize',24)
cd(pic_w)
exportgraphics(gcf,[filedate,station_N, 'Hs_Turbidity.png'])


% ====================== S station ======================
figure('OuterPosition',get(0,'ScreenSize'))
t = tiledlayout(1,1,"TileSpacing","compact","Padding","tight");
ax = nexttile;
yyaxis left
plot(waveday_S, S.Hs ,'black','LineWidth',2)
ylabel('Hs (cm)','FontSize',18)
axis([floor(waveday_S(1)) ceil(waveday_S(end)) 0 ceil(max(S.Hs)/50)*50])
set(gca,'ycolor','black')
grid on
yyaxis right
plot(dday_S, tur_S,'o','color','r','LineWidth',2)
ylabel('Turbidity (NTU)','FontSize',18)
% ylim([0 ceil(max(tur_S)/50)*50])
% ylim([0 10])
set(gca,'ycolor','r')
legend('Hs','Turb')
xlabel(['month/day of ',datestr(dday_S(1), 'yyyy')])
figset_linefont(ax)
figset_date(ax, waveday_S)
figset_date_minorticks(ax, waveday_S)
title(t,{['\bf',station_S, ' Hs and Turbidity'],['\rm',plotdate_all]},'FontSize',24)
cd(pic_w)
exportgraphics(gcf,[filedate,station_S, 'Hs_Turbidity.png'])

%% 
filename = sprintf("%s\\%sWave_results.txt", f_data, filedate);
fid3=fopen(filename,'w');
[maxHs_N, loc_maxHs_N] = max(N.Hs);
maxHs_T_N = N.T(loc_maxHs_N);
meanwaveheight_N = nanmean(N.Hs);
meanTm02_N = nanmean(N.T);

[maxHs_S, loc_maxHs_S] = max(S.Hs);
maxHs_T_S = S.T(loc_maxHs_S);
meanwaveheight_S = nanmean(S.Hs);
meanTm02_S = nanmean(S.T);

fprintf(fid3, 'H_{max} (cm) %28.2f %6.2f\n', maxHs_N, maxHs_S);
fprintf(fid3, 'H_{max} corresponding period (sec) %6.2f %6.2f\n', maxHs_T_N, maxHs_T_S);
fprintf(fid3, 'H_{mean} (m) %28.2f %6.2f\n', meanwaveheight_N, meanwaveheight_S);
fprintf(fid3, 'T_{mean} (sec) %26.2f %6.2f\n', meanTm02_N, meanTm02_S);

fclose(fid3);

