%% Map of all Typhoon
clear; close all; clc;

%% work path
Tc = 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\Coastline';
DJ = 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\20150917_1015\杜鵑2015\2015_DUJUAN_OBS_TrackData_14e6d704e290083a13bb66d196a48491';
MJ = 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\20150917_1015\彩虹2015';
WP = 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\20190723_0807\薇帕2019\2019_WIPHA_OBS_TrackData_6c62ec62fb620cef13de90f020b45eae';
GN_ATN = 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\20201026_1123\Typhoon';
AR = 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\20220625_0721\艾利2022\2022_AERE_OBS_Track_f5343605a782a0524d05baa8606dead9';
NG = 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\20221021_1107\奈格2022\2022_NALGAE_OBS_Track_5e379ac7493399ff3ddefbaec983d3cd';
func = 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\Functions';

%% Load data
cd(Tc)
coastline = load("World_coastline_i.dat");
% cd(func)
% coastline = load('coa_i_N90_0_E90_180.dat');

cd(DJ)
path.dj = load('2015_DUJUAN_Track_Onlynumber.txt');
cd(MJ)
path.mj = load('Mujigae_track_numberonly.txt');
cd(WP)
path.wp = load('2019.WIPHA.Track_numberonly.txt');
cd(GN_ATN)
path.gn = load("Goni_track_numberonly.txt");
path.atn = load('Atsani_track_numberonly.txt');
cd(AR)
path.ar = load("2022_AERE_Track_onlynumber.txt");
cd(NG)
path.ng = load('NALGAE_Track_numberonly.txt');

lon.dj = path.dj(:,6);
lon.mj = path.mj(:,6);
lon.wp = path.wp(:,7);
lon.gn = path.gn(:,6);
lon.atn = path.atn(:,6);
lon.ar = path.ar(:,6);
lon.ng = path.ng(:,6);

lat.dj = path.dj(:,5);
lat.mj = path.mj(:,5);
lat.wp = path.wp(:,6);
lat.gn = path.gn(:,5);
lat.atn = path.atn(:,5);
lat.ar = path.ar(:,5);
lat.ng = path.ng(:,5);

dday.dj = datenum(path.dj(1:end,1),path.dj(1:end,2),path.dj(1:end,3),path.dj(1:end,4),0,0);
dday.mj = datenum(path.mj(1:end,1),path.mj(1:end,2),path.mj(1:end,3),path.mj(1:end,4),0,0);
dday.wp = datenum(path.wp(1:end,1),path.wp(1:end,2),path.wp(1:end,3),path.wp(1:end,4),0,0);
dday.gn = datenum(path.gn(1:end,1),path.gn(1:end,2),path.gn(1:end,3),path.gn(1:end,4),0,0);
dday.atn = datenum(path.atn(1:end,1),path.atn(1:end,2),path.atn(1:end,3),path.atn(1:end,4),0,0);
dday.ar = datenum(path.ar(1:end,1),path.ar(1:end,2),path.ar(1:end,3),path.ar(1:end,4),0,0);
dday.ng = datenum(path.ng(1:end,1),path.ng(1:end,2),path.ng(1:end,3),path.ng(1:end,4),0,0);

atm.dj = path.dj(:,7);
atm.mj = path.mj(:,7);
atm.wp = path.wp(:,8);
atm.gn = path.gn(:,7);
atm.atn = path.atn(:,7);
atm.ar = path.ar(:,7);
atm.ng = path.ng(:,7);


% 提取字段名稱和值
field_names = fieldnames(lon);   % 提取字段名稱
field_values = struct2cell(lon); % 提取字段值

% 將字段名稱和字段值合併到一個 cell 陣列
lon_data = [field_names, field_values];

% 提取字段名稱和值
field_names = fieldnames(lat);   % 提取字段名稱
field_values = struct2cell(lat); % 提取字段值

% 將字段名稱和字段值合併到一個 cell 陣列
lat_data = [field_names, field_values];



%=========== Distance From N station ==============
dist_lon = {};
dist_lat = {};
distance = {};
nearest = [];
for ii = 1:7
    dist_lon{ii,1} = lon_data{ii,2}-120.6921941111;
    dist_lat{ii,1} = lat_data{ii,2}-22.0467218889;
    distance{ii,1} = sqrt(dist_lon{ii}.^2+dist_lat{ii}.^2)*111000;
    nearest(ii,1) = min(distance{ii});
end



%% Figure setting
figsetting_map  = @(map) set(map,...
    'box','on', 'TickDir','out',...
    'TickLength',[0.008 0.025], 'LineWidth',3,...
    'FontSize',18, 'FontWeight','bold');

%% Map
cd(func)
figure('OuterPosition',get(0,'ScreenSize'))
t = tiledlayout(1,1,"TileSpacing","compact","Padding","tight");
ax1 = nexttile;
plot(coastline(:,1),coastline(:,2),'k-','LineWidth',1.2);hold on
fill_coa = fillseg(coastline,repmat(.8,1,3));
set(fill_coa,'edgecolor','none')
plot(lon.dj,lat.dj,'r','LineWidth',3);hold on
plot(lon.mj,lat.mj,'cyan','LineWidth',3);hold on
plot(lon.wp,lat.wp,'color',[0.8500 0.3250 0.0980],'LineWidth',3);hold on
plot(lon.gn,lat.gn,'g','LineWidth',3);hold on
plot(lon.atn,lat.atn,'color',[0.95 0.95 0.12],'LineWidth',3);hold on
plot(lon.ar,lat.ar,'m','LineWidth',3);hold on
plot(lon.ng,lat.ng,'b','LineWidth',3);hold on
plot([142 142+0.01038*500],[30 30],'|-k','LineWidth',4); hold on
text(142+0.01038*50,31,'500 km','FontSize',18)
text(lon.dj(14),lat.dj(14),'  201521 DUJUAN','Color','R','FontSize',16)
text(lon.mj(1),lat.mj(1),'  201522 MUJIGAE','Color','cyan','FontSize',16)
text(lon.wp(1),lat.wp(1),'201907 WIPHA         ','Color',[0.8500 0.3250 0.0980],'FontSize',16,'HorizontalAlignment','right')
text(lon.gn(40),lat.gn(40)-0.8,'202019 GONI','Color','g','FontSize',16,'HorizontalAlignment','center')
text(lon.atn(1),lat.atn(1)-0.5,'202020 ATSANI','Color',[0.95 0.95 0.3],'FontSize',16,'FontWeight','bold','HorizontalAlignment','center')
text(lon.ar(10),lat.ar(10),'        202204 AERE','Color','m','FontSize',16)
text(lon.ng(1),lat.ng(1)-0.5,'  202222 NALGAE','Color','b','FontSize',16,'HorizontalAlignment','center')
% ylabel('Latitude (\circN)')
% xlabel('Longetude (\circE)')
axis equal
set(gca, 'Ytick', -90:5:90, 'Xtick', -180:5:180)
set(gca,'XTickLabel',strcat(get(gca,'XTickLabel'), '\circE'))
set(gca,'YTickLabel',strcat(get(gca,'YTickLabel'), '\circN'))
axis([100 150 05 40])
figsetting_map(ax1)
title(t, '\bfTyphoon map','\rm2015~2022','FontSize',24)
cd('E:\INTERTIDAL\代婷與的PDF們\NMMBA')
exportgraphics(gcf,'Typhoon_map.png','Resolution',300)

%% 
% figure('OuterPosition',get(0,'ScreenSize'))
% tiledlayout(7,1,'TileSpacing','compact','Padding','tight')
% nexttile;
% plot(dday.dj,atm.dj);hold on
% plot(dday.mj,atm.mj)
% axis([datenum(2015,9,17) datenum(2015,10,15) 900 1020])





















