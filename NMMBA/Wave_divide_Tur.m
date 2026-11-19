%% divide wind wave and swell (TUR)
% By Tingyu Dai
clear; close all; clc; 

%% 
cd 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\20150515_0530'
load DATA_CUR.mat 
load DATA_W.mat
load DATA_WIND.mat
func = 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\Functions';
pic_w = 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\201500515_0530\pictures\Wave';
pic_c = 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\20150515_0530\pictures\Current';
Tc = 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\Coastline';

%% power spectrum
cd(func)
windo = hann(512);
nfft = 2048;
overlap = 256;
[p_tur_20150515, f_tur_20150515] = pwelch(tur_20150515, windo, overlap, nfft, 600);

%% turn the tur to SSC (2011, Shuhua Bian et. al. )
% the sensor in the paper is OBS-3A, turbidity range is 0.4 to 4000 NTU
% mine is OBS-3+, its range is for 0 to 250 (lower)
% tur_3A = tur.*(4000/250);
% tur_3A = tur_high.*4;
SSC_20150515 = 0.344*tur_20150515.^1.318;

% 24926538 = Cr U C I O

%% power spectrum
cd(func)
windo = hann(512);
nfft = 2048;
overlap = 256;
[p_SSC_20150515, f_SSC_20150515] = pwelch(SSC_20150515, windo, overlap, nfft, 600);

%% 2024
cd 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\20130524_0608'
load DATA_CUR.mat 
load DATA_W.mat
load DATA_WIND.mat

cd 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\20240109_0202'
load DATA_CUR.mat 
load DATA_W.mat
load DATA_WIND.mat

cd 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\20240311_0418'
load DATA_CUR.mat 
load DATA_W.mat
load DATA_WIND.mat

cd 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\20240618_0715'
load DATA_CUR.mat 
load DATA_W.mat
load DATA_WIND.mat

cd 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\20241104_1202'
load DATA_CUR.mat 
load DATA_W.mat
load DATA_WIND.mat

%% power spectrum
cd(func)
windo = hann(512);
nfft = 2048;
overlap = 256;
[p_tur_20130524, f_tur_20130524] = pwelch(tur_20130524, windo, overlap, nfft, 600);
[p_tur_20240109, f_tur_20240109] = pwelch(tur_20240109, windo, overlap, nfft, 600);
[p_tur_20240311, f_tur_20240311] = pwelch(tur_20240311, windo, overlap, nfft, 600);
[p_tur_20240618, f_tur_20240618] = pwelch(tur_20240618, windo, overlap, nfft, 600);
[p_tur_20241104, f_tur_20241104] = pwelch(tur_20241104, windo, overlap, nfft, 600);


%% turn the tur to SSC (2011, Shuhua Bian et. al. )
% the sensor in the paper is OBS-3A, turbidity range is 0.4 to 4000 NTU
% mine is OBS-3+, its range is for 0 to 250 (lower)
% tur_3A = tur.*(4000/250);
% tur_3A = tur_high.*4;
SSC_20130524 = 0.344*tur_20130524.^1.318;
SSC_20240109 = 0.344*tur_20240109.^1.318;
SSC_20240311 = 0.344*tur_20240311.^1.318;
SSC_20240618 = 0.344*tur_20240618.^1.318;
SSC_20241104 = 0.344*tur_20241104.^1.318;

SSC_20130524(SSC_20130524 < 0) = 0;
SSC_20240109(SSC_20240109 < 0) = 0;
SSC_20240311(SSC_20240311 < 0) = 0;
SSC_20240618(SSC_20240618 < 0) = 0;
SSC_20241104(SSC_20241104 < 0) = 0;


%% power spectrum
cd(func)
windo = hann(512);
nfft = 2048;
overlap = 256;
[p_SSC_20130524, f_SSC_20130524] = pwelch(SSC_20130524, windo, overlap, nfft, 600);
[p_SSC_20240109, f_SSC_20240109] = pwelch(SSC_20240109, windo, overlap, nfft, 600);
[p_SSC_20240311, f_SSC_20240311] = pwelch(SSC_20240311, windo, overlap, nfft, 600);
[p_SSC_20240618, f_SSC_20240618] = pwelch(SSC_20240618, windo, overlap, nfft, 600);
[p_SSC_20241104, f_SSC_20241104] = pwelch(SSC_20241104, windo, overlap, nfft, 600);

%% 
figure("OuterPosition", get(0, "ScreenSize"))
t = tiledlayout(1,2,"TileSpacing","compact", "Padding","tight");
ax1 = nexttile;
plot(f_tur_20130524, p_tur_20130524, 'LineWidth',2); hold on
plot(f_tur_20150515, p_tur_20150515, 'LineWidth',2); hold on
plot(f_tur_20240109, p_tur_20240109, 'LineWidth',2); hold on
plot(f_tur_20240311, p_tur_20240311, 'LineWidth',2); hold on
plot(f_tur_20240618, p_tur_20240618, 'LineWidth',2); hold on
plot(f_tur_20241104, p_tur_20241104, 'LineWidth',2); hold on
xlabel(t, 'freq (Hz)', 'fontsize', 18)
ylabel('PSD of tur (NTU\cdotHz)')
legend('20130524~0608','20150515~0530', '20240109~0202', '20240311~0409', '20240618~0715', '20241104~1202')
set(ax1, 'XScale', 'log', 'fontsize', 18, 'linewidth', 2)
title(t, '\bfTUR & SSC power spectrum', 'FontSize', 24)

ax2 = nexttile;
plot(f_SSC_20130524, p_SSC_20130524, 'LineWidth',2); hold on
plot(f_SSC_20150515, p_SSC_20150515, 'LineWidth',2); hold on
plot(f_SSC_20240109, p_SSC_20240109, 'LineWidth',2); hold on
plot(f_SSC_20240311, p_SSC_20240311, 'LineWidth',2); hold on
plot(f_SSC_20240618, p_SSC_20240618, 'LineWidth',2); hold on
plot(f_SSC_20241104, p_SSC_20241104, 'LineWidth',2); hold on
ylabel('PSD of SSC (mg/l\cdotHz)')
legend('20130524~0608','20150515~0530', '20240109~0202', '20240311~0409', '20240618~0715', '20241104~1202')
set(ax2, 'Xscale', 'log', 'fontsize', 18, 'linewidth', 2)

%% wave 2015
[Tsw_20130524, SW_20130524] = dai_waveheight_sw(wave_20130524,4,1200);
[Tww_20130524, WW_20130524] = dai_waveheight_ww(wave_20130524,4,1200);
[Tm02_20130524, Hs_20130524] = huang_waveheight(wave_20130524,4,1200);
SW_20130524(SW_20130524>100) = NaN;
WW_20130524(WW_20130524>100) = NaN;
Hs_20130524(Hs_20130524>100) = NaN;
wave_20130524_dday = zeros(length(dday_20130524), 3);
wave_20130524_dday(1:2:end,1) = Hs_20130524(1:end);
wave_20130524_dday(2:2:end,1) = Hs_20130524(1:end);
wave_20130524_dday(1:2:end,2) = WW_20130524(1:end);
wave_20130524_dday(2:2:end,2) = WW_20130524(1:end);
wave_20130524_dday(1:2:end,3) = SW_20130524(1:end);
wave_20130524_dday(2:2:end,3) = SW_20130524(1:end);

%% wave 2015
[Tsw_20150515, SW_20150515] = dai_waveheight_sw(wave_20150515,4,1200);
[Tww_20150515, WW_20150515] = dai_waveheight_ww(wave_20150515,4,1200);
[Tm02_20150515, Hs_20150515] = huang_waveheight(wave_20150515,4,1200);
wave_20150515_dday = zeros(length(dday_20150515), 3);
wave_20150515_dday(1:2:end,1) = Hs_20150515(1:1078);
wave_20150515_dday(2:2:end,1) = Hs_20150515(1:1078);
wave_20150515_dday(1:2:end,2) = WW_20150515(1:1078);
wave_20150515_dday(2:2:end,2) = WW_20150515(1:1078);
wave_20150515_dday(1:2:end,3) = SW_20150515(1:1078);
wave_20150515_dday(2:2:end,3) = SW_20150515(1:1078);

%% wave 202401
[Tsw_20240109, SW_20240109] = dai_waveheight_sw(wave_20240109,1,1200);
[Tww_20240109, WW_20240109] = dai_waveheight_ww(wave_20240109,1,1200);
[Tm02_20240109, Hs_20240109] = huang_waveheight(wave_20240109,1,1200);
wave_20240109_dday = NaN(length(dday_20240109), 3);
wave_20240109_dday(1:3:end,1) = Hs_20240109(1:1151);
wave_20240109_dday(1:3:end,2) = WW_20240109(1:1151);
wave_20240109_dday(1:3:end,3) = SW_20240109(1:1151);
wave_20240109_dday(2:3:end,1) = Hs_20240109(1:1151);
wave_20240109_dday(2:3:end,2) = WW_20240109(1:1151);
wave_20240109_dday(2:3:end,3) = SW_20240109(1:1151);
wave_20240109_dday(3:3:end,1) = Hs_20240109(1:1150);
wave_20240109_dday(3:3:end,2) = WW_20240109(1:1150);
wave_20240109_dday(3:3:end,3) = SW_20240109(1:1150);

%% wave 202403
[Tsw_20240311, SW_20240311] = dai_waveheight_sw(wave_20240311,1,1200);
[Tww_20240311, WW_20240311] = dai_waveheight_ww(wave_20240311,1,1200);
[Tm02_20240311, Hs_20240311] = huang_waveheight(wave_20240311,1,1200);
wave_20240311_dday = NaN(length(dday_20240311), 3);
wave_20240311_dday(1:3:end,1) = Hs_20240311(1:1373);
wave_20240311_dday(1:3:end,2) = WW_20240311(1:1373);
wave_20240311_dday(1:3:end,3) = SW_20240311(1:1373);
wave_20240311_dday(2:3:end,1) = Hs_20240311(1:1373);
wave_20240311_dday(2:3:end,2) = WW_20240311(1:1373);
wave_20240311_dday(2:3:end,3) = SW_20240311(1:1373);
wave_20240311_dday(3:3:end,1) = Hs_20240311(1:1373);
wave_20240311_dday(3:3:end,2) = WW_20240311(1:1373);
wave_20240311_dday(3:3:end,3) = SW_20240311(1:1373);

%% wave 202401
[Tsw_20240618, SW_20240618] = dai_waveheight_sw(wave_20240618,1,1200);
[Tww_20240618, WW_20240618] = dai_waveheight_ww(wave_20240618,1,1200);
[Tm02_20240618, Hs_20240618] = huang_waveheight(wave_20240618,1,1200);
wave_20240618_dday = NaN(length(dday_20240618), 3);

for ii = 1:4
    wave_20240618_dday(ii:6:end,1) = Hs_20240618(1:end);
    wave_20240618_dday(ii:6:end,2) = WW_20240618(1:end);
    wave_20240618_dday(ii:6:end,3) = SW_20240618(1:end);
end
for ii = 5:6
    wave_20240618_dday(ii:6:end,1) = Hs_20240618(1:end-1);
    wave_20240618_dday(ii:6:end,2) = WW_20240618(1:end-1);
    wave_20240618_dday(ii:6:end,3) = SW_20240618(1:end-1);
end

%% wave 202411
[Tsw_20241104, SW_20241104] = dai_waveheight_sw(wave_20241104,1,1200);
[Tww_20241104, WW_20241104] = dai_waveheight_ww(wave_20241104,1,1200);
[Tm02_20241104, Hs_20241104] = huang_waveheight(wave_20241104,1,1200);
wave_20241104_dday = NaN(length(dday_20241104), 3);

for ii = 1:6
    wave_20241104_dday(ii:6:end-6,1) = Hs_20241104(1:end);
    wave_20241104_dday(ii:6:end-6,2) = WW_20241104(1:end);
    wave_20241104_dday(ii:6:end-6,3) = SW_20241104(1:end);
end


%% Turbidity compare
figure('OuterPosition',get(0, 'ScreenSize'));
tt = tiledlayout(5,1,"TileSpacing","compact", "Padding","tight");
%============ 2015/05/15 ==============
ax1 = nexttile;
yyaxis left
plot(dday_20150515, wave_20150515_dday(:,1), 'k-', 'linewidth', 1.5); hold on
plot(dday_20150515, wave_20150515_dday(:,2), 'b-', 'linewidth', 1.5); hold on
plot(dday_20150515, wave_20150515_dday(:,3), 'r-', 'linewidth', 1.5); hold on
set(ax1, 'ycolor', 'k')
ylim([0 250])
grid on

yyaxis right
plot(dday_20150515, SSC_20150515, '.', 'MarkerSize',20, 'Color',"#EDB120"); hold on
ylim([0 500])
ylabel('SSC (mg/l)', 'fontsize', 24);
title(ax1, plotdate_all_20150515)

set(ax1, 'XTick', floor(dday_20150515(1)):4:ceil(dday_20150515(end)), 'XTickLabel', ...
    {datestr(floor(dday_20150515(1)):4:ceil(dday_20150515(end)), 'mm/dd')}, ...
    'linewidth', 2, 'fontsize', 18, 'Ycolor', "#EDB120", ...
    'XLim', [floor(dday_20150515(1)) ceil(dday_20150515(end))])

%============ 2024/01/09 ==============
ax2 = nexttile;
yyaxis left
plot(dday_20240109, wave_20240109_dday(:,1), 'k-', 'linewidth', 1.5); hold on
plot(dday_20240109, wave_20240109_dday(:,2), 'b-', 'linewidth', 1.5); hold on
plot(dday_20240109, wave_20240109_dday(:,3), 'r-', 'linewidth', 1.5); hold on
set(ax2, 'ycolor', 'k')
ylabel(tt, 'Wave height (cm)', 'fontsize', 24)
ylim([0 250])
grid on

yyaxis right
plot(dday_20240109, SSC_20240109, '.', 'MarkerSize',20, 'Color',"#EDB120"); hold on
ylim([0 500])
ylabel('SSC (mg/l)', 'fontsize', 24);
title(ax2, plotdate_all_20240109)

set(ax2, 'XTick', floor(dday_20240109(1)):4:ceil(dday_20240109(end)), 'XTickLabel', ...
    {datestr(floor(dday_20240109(1)):4:ceil(dday_20240109(end)), 'mm/dd')}, ...
    'linewidth', 2, 'fontsize', 18, 'Ycolor', "#EDB120", ...
    'XLim', [floor(dday_20240109(1)) ceil(dday_20240109(end))])

%============ 2024/03/11 ==============
ax3 = nexttile;
yyaxis left
plot(dday_20240311, wave_20240311_dday(:,1), 'k-', 'linewidth', 1.5); hold on
plot(dday_20240311, wave_20240311_dday(:,2), 'b-', 'linewidth', 1.5); hold on
plot(dday_20240311, wave_20240311_dday(:,3), 'r-', 'linewidth', 1.5); hold on
set(ax3, 'ycolor', 'k')
ylabel(tt, 'Wave height (cm)', 'fontsize', 24)
ylim([0 250])
grid on

yyaxis right
plot(dday_20240311, SSC_20240311, '.', 'MarkerSize',20, 'Color',"#EDB120"); hold on
ylim([0 500])
ylabel('SSC (mg/l)', 'fontsize', 24);
title(ax3, plotdate_all_20240311)

set(ax3, 'XTick', floor(dday_20240311(1)):4:ceil(dday_20240311(end)), 'XTickLabel', ...
    {datestr(floor(dday_20240311(1)):4:ceil(dday_20240311(end)), 'mm/dd')}, ...
    'linewidth', 2, 'fontsize', 18, 'Ycolor', "#EDB120", ...
    'XLim', [floor(dday_20240311(1)) ceil(dday_20240311(end))])

%============ 2024/06/18 ==============
ax4 = nexttile;
yyaxis left
plot(dday_20240618, wave_20240618_dday(:,1), 'k-', 'linewidth', 1.5); hold on
plot(dday_20240618, wave_20240618_dday(:,2), 'b-', 'linewidth', 1.5); hold on
plot(dday_20240618, wave_20240618_dday(:,3), 'r-', 'linewidth', 1.5); hold on
set(ax4, 'ycolor', 'k')
ylabel(tt, 'Wave height (cm)', 'fontsize', 24)
ylim([0 250])
grid on

yyaxis right
plot(dday_20240618, SSC_20240618, '.', 'MarkerSize',20, 'Color',"#EDB120"); hold on
ylim([0 500])
ylabel('SSC (mg/l)', 'fontsize', 24);
title(ax4, plotdate_all_20240618)

set(ax4, 'XTick', floor(dday_20240618(1)):4:ceil(dday_20240618(end)), 'XTickLabel', ...
    {datestr(floor(dday_20240618(1)):4:ceil(dday_20240618(end)), 'mm/dd')}, ...
    'linewidth', 2, 'fontsize', 18, 'Ycolor', "#EDB120", ...
    'XLim', [floor(dday_20240618(1)) ceil(dday_20240618(end))])

%============ 2024/11/04 ==============
ax5 = nexttile;
yyaxis left
plot(dday_20241104, wave_20241104_dday(:,1), 'k-', 'linewidth', 1.5); hold on
plot(dday_20241104, wave_20241104_dday(:,2), 'b-', 'linewidth', 1.5); hold on
plot(dday_20241104, wave_20241104_dday(:,3), 'r-', 'linewidth', 1.5); hold on
set(ax5, 'ycolor', 'k')
ylabel(tt, 'Wave height (cm)', 'fontsize', 24)
ylim([0 250])
grid on

yyaxis right
plot(dday_20241104, SSC_20241104, '.', 'MarkerSize',20, 'Color',"#EDB120"); hold on
ylim([0 500])
ylabel('SSC (mg/l)', 'fontsize', 24);
title(ax5, plotdate_all_20241104)

set(ax5, 'XTick', floor(dday_20241104(1)):4:ceil(dday_20241104(end)), 'XTickLabel', ...
    {datestr(floor(dday_20241104(1)):4:ceil(dday_20241104(end)), 'mm/dd')}, ...
    'linewidth', 2, 'fontsize', 18, 'Ycolor', "#EDB120", ...
    'XLim', [floor(dday_20241104(1)) ceil(dday_20241104(end))])

%% Turbidity compare 2013~?
figure('OuterPosition',get(0, 'ScreenSize'));
tt = tiledlayout(2,1,"TileSpacing","compact", "Padding","tight");

ax0 = nexttile;
yyaxis left
plot(dday_20130524, wave_20130524_dday(:,1), 'k-', 'linewidth', 1.5); hold on
plot(dday_20130524, wave_20130524_dday(:,2), 'b-', 'linewidth', 1.5); hold on
plot(dday_20130524, wave_20130524_dday(:,3), 'r-', 'linewidth', 1.5); hold on
set(ax0, 'ycolor', 'k')
ylim([0 250])
grid on

yyaxis right
plot(dday_20130524, SSC_20130524, '.', 'MarkerSize',20, 'Color',"#EDB120"); hold on
ylim([0 500])
ylabel('SSC (mg/l)', 'fontsize', 24);
title(ax0, plotdate_all_20130524)

set(ax0, 'XTick', floor(dday_20130524(1)):4:ceil(dday_20130524(end)), 'XTickLabel', ...
    {datestr(floor(dday_20130524(1)):4:ceil(dday_20130524(end)), 'mm/dd')}, ...
    'linewidth', 2, 'fontsize', 18, 'Ycolor', "#EDB120")


ax1 = nexttile;
yyaxis left
plot(dday_20150515, wave_20150515_dday(:,1), 'k-', 'linewidth', 1.5); hold on
plot(dday_20150515, wave_20150515_dday(:,2), 'b-', 'linewidth', 1.5); hold on
plot(dday_20150515, wave_20150515_dday(:,3), 'r-', 'linewidth', 1.5); hold on
set(ax1, 'ycolor', 'k')
ylim([0 250])
grid on

yyaxis right
plot(dday_20150515, SSC_20150515, '.', 'MarkerSize',20, 'Color',"#EDB120"); hold on
ylim([0 500])
ylabel('SSC (mg/l)', 'fontsize', 24);
title(ax1, plotdate_all_20150515)

set(ax1, 'XTick', floor(dday_20150515(1)):4:ceil(dday_20150515(end)), 'XTickLabel', ...
    {datestr(floor(dday_20150515(1)):4:ceil(dday_20150515(end)), 'mm/dd')}, ...
    'linewidth', 2, 'fontsize', 18, 'Ycolor', "#EDB120")


%% wind and wave
figure('OuterPosition',get(0, 'ScreenSize'))
tt = tiledlayout(2,1,"TileSpacing","compact","Padding","tight");
ax1 = nexttile;
quiver_f(daym_20150515,wu_20150515(1:end-1), wv_20150515(1:end-1), "ShowArrowHead","off","Color",'b'); hold on
% plot(daym_20150515, Hs_20150515(1:3:end-6)/100)
axis([floor(daym_20150515(1)) ceil(daym_20150515(end)) -10 10])
grid on
set(ax1, 'linewidth', 2, 'fontsize', 18, 'XTick', floor(dday_20150515(1)):4:ceil(dday_20150515(end)), 'XTickLabel', ...
    {datestr(floor(dday_20150515(1)):4:ceil(dday_20150515(end)), 'mm/dd')}, 'Clipping', 'off')

ax2 = nexttile;
yyaxis left
plot(dday_20150515, wave_20150515_dday(:,1), 'k-', 'linewidth', 1.5); hold on
plot(dday_20150515, wave_20150515_dday(:,2), 'b-', 'linewidth', 1.5); hold on
plot(dday_20150515, wave_20150515_dday(:,3), 'r-', 'linewidth', 1.5); hold on
set(ax2, 'ycolor', 'k')
ylim([0 250])
grid on

yyaxis right
plot(dday_20150515, SSC_20150515, '.', 'MarkerSize',20, 'Color',"#EDB120"); hold on
ylim([0 500])
ylabel('SSC (mg/l)', 'fontsize', 24);
title(ax1, plotdate_all_20150515)
xlim([floor(daym_20150515(1)) ceil(daym_20150515(end))])
set(ax2, 'XTick', floor(dday_20150515(1)):4:ceil(dday_20150515(end)), 'XTickLabel', ...
    {datestr(floor(dday_20150515(1)):4:ceil(dday_20150515(end)), 'mm/dd')}, ...
    'linewidth', 2, 'fontsize', 18, 'Ycolor', "#EDB120")

%% wind and wave 2013
figure('OuterPosition',get(0, 'ScreenSize'))
tt = tiledlayout(2,1,"TileSpacing","compact","Padding","tight");
ax1 = nexttile;
quiver_f(daym_20130524,wu_20130524(1:end-1), wv_20130524(1:end-1), "ShowArrowHead","off","Color",'b'); hold on
% plot(daym_20150515, Hs_20150515(1:3:end-6)/100)
axis([floor(daym_20130524(1)) ceil(daym_20130524(end)) -10 10])
grid on
set(ax1, 'linewidth', 2, 'fontsize', 18, 'XTick', floor(dday_20130524(1)):4:ceil(dday_20130524(end)), 'XTickLabel', ...
    {datestr(floor(dday_20130524(1)):4:ceil(dday_20130524(end)), 'mm/dd')}, 'Clipping', 'off')

ax2 = nexttile;
yyaxis left
plot(dday_20130524, wave_20130524_dday(:,1), 'k-', 'linewidth', 1.5); hold on
plot(dday_20130524, wave_20130524_dday(:,2), 'b-', 'linewidth', 1.5); hold on
plot(dday_20130524, wave_20130524_dday(:,3), 'r-', 'linewidth', 1.5); hold on
set(ax2, 'ycolor', 'k')
ylim([0 250])
grid on

yyaxis right
plot(dday_20130524, SSC_20130524, '.', 'MarkerSize',20, 'Color',"#EDB120"); hold on
ylim([0 500])
ylabel('SSC (mg/l)', 'fontsize', 24);
title(ax1, plotdate_all_20130524)
xlim([floor(daym_20130524(1)) ceil(daym_20130524(end))])
set(ax2, 'XTick', floor(dday_20130524(1)):4:ceil(dday_20130524(end)), 'XTickLabel', ...
    {datestr(floor(dday_20130524(1)):4:ceil(dday_20130524(end)), 'mm/dd')}, ...
    'linewidth', 2, 'fontsize', 18, 'Ycolor', "#EDB120")

