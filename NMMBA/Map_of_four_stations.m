%% Taiwan observation stations
%% MiaoLi, NMMBA, FuAn Temple, Qimei

% North station：22°02'48.2"N 120°41'31.9"E
% South station：22°02'16.8"N 120°41'22.0"E
% NMMBA：22.0467°N 120.6975°E

clear; close all; clc;

%% load data
cd('E:\INTERTIDAL\代婷與的PDF們\NMMBA\Coastline')
tc = load('Taiwan_nearcolstline.dat');


cd('E:\INTERTIDAL\代婷與的PDF們\NMMBA\Coastline\GEBCO_21_Oct_2025_31473d7dd4d7')
file_name = dir('*.nc');
ncdisp(file_name.name)
sea_bottom_lon = ncread(file_name.name, 'lon');
sea_bottom_lat = ncread(file_name.name, 'lat');
sea_bottom_elvt = ncread(file_name.name, 'elevation');

NMMBA = [120.6975, 22.0467];
offset_locate = 0.009;
% NMMBA = [120.6975, 22.0467];
N_sta = [120.6921941111, 22.0467218889];
S_sta = [120.6894444, 22.038];
% coastline(:,1) = coastline(:,1)+offset_locate;

MiaoLi = [120.7531, 24.6599];
QiMei = [119.4197, 23.2301];

B1 = [120.6985-0.009, 22.0717];
B2 = [120.7032-0.009, 22.0717];

color_select = [0 0 1;
    .8 .8 .8];

for jj = 1:3
    bluegray(:, jj) = linspace(color_select(1, jj), color_select(2, jj), 255);
end


%% 
figure("OuterPosition", [1 1 1920 1080])
tt = tiledlayout(1, 2, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
contourf(sea_bottom_lon, sea_bottom_lat, sea_bottom_elvt', [-9000:500:-500, -500:10:0], 'LineStyle', 'none')
hold on
contour(sea_bottom_lon, sea_bottom_lat, sea_bottom_elvt', -500:100:0, 'LineStyle', '-', 'Color', 'w')
fill_coa = fillseg(tc, [0 168/255 0]); hold on
set(fill_coa,'edgecolor','none'); hold on
plot(tc(:, 1), tc(:, 2), 'Color', 'k', 'LineWidth', 2)
plot(NMMBA(1), NMMBA(2), 'MarkerSize', 100, 'LineWidth', 3, 'Marker', 'square', 'color', 'r')

axis equal
axis([119.15 122.35 21.5 25.5])
colormap(bluegray)
clim([-3500 0])
clbr = colorbar;
% clbr.Label.String = 'Level (m)';
% clbr.Label.String.Fontsize = 18;
text(ax, 0.01, 0.99, '(a)', 'FontSize', 30, 'Units', 'normalized', ...
        'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'BackgroundColor', 'w')

set(ax, 'LineWidth', 2, 'fontsize', 24, ...
    'xtick', 119:1:123, 'ytick', 21:1:25, ...
    'TickDir', 'out', 'Ticklength', [.01 0])
set(ax.XAxis, 'Minortick', 'on', 'Minortickvalue', 119:.5:123.5)
set(ax.YAxis, 'Minortick', 'on', 'Minortickvalue', 21:.5:25.5)

% ylabel('\bfLatitude (^{\circ}N)')
% xlabel('\bfLongitude (^{\circ}E)')
%
ax = nexttile;
igg = find(tc(:, 1) >= 120.66 & tc(:, 1) <= 120.74 & tc(:, 2) >= 22 & tc(:, 2) <= 22.2);
cticks = -300:50:0;
contourf(sea_bottom_lon, sea_bottom_lat, sea_bottom_elvt', -300:10:0, 'LineStyle', 'none'); hold on
[cc, hh] = contour(sea_bottom_lon, sea_bottom_lat, sea_bottom_elvt', -250:50:-50, 'Color', 'w', 'linewidth', 2, 'ShowText', 'on');
clabel(cc, hh, 'Color', 'w')
colormap(bluegray)
% shading interp
% plot(coastline(:,1),coastline(:,2),'k','LineWidth',4);hold on % coast line
% for ii = 1:3000
%     plot(tc(igg, 1)+.009+ii/10000, tc(igg, 2), 'Color', '#00A600', 'LineWidth', 3); hold on
% end
fill_coa = fillseg([tc(:, 1)+.009, tc(:, 2)], [0 168/255 0]); hold on
set(fill_coa,'edgecolor','none'); hold on
plot(tc(igg, 1)+.009, tc(igg, 2), 'Color', 'k', 'LineWidth', 3); hold on
% plot(coastline(340930:341024,1)*0+120.74,coastline(340930:341024,2),'k','LineWidth',4) % frame line
% plot(coastline(340930:430000,1),coastline(340930:430000,2)*0+22.1,'k','LineWidth',4) % frame line


plot(N_sta(1), N_sta(2),'o','MarkerEdgeColor','none','MarkerFaceColor','b');hold on % North station
text(N_sta(1), N_sta(2)+0.005,'North station','Color','b','FontSize',24, ...
    'HorizontalAlignment','right', 'BackgroundColor', 'w');hold on
plot(S_sta(1), S_sta(2),'o','MarkerEdgeColor','none','MarkerFaceColor','b');hold on % South station
text(S_sta(1)+0.005, S_sta(2),'South station','Color','b','FontSize',24, ...
    'BackgroundColor', 'w');hold on

plot(NMMBA(1), NMMBA(2), 'ro','LineWidth',3); hold on
text(NMMBA(1), NMMBA(2)+0.002, {'  \bfNational Museum of','   \bfMarine Biology','  \bfand Aquarium'},'Color','r','FontSize',20)
plot(120.6936, 22.0246,'o','MarkerEdgeColor','k','MarkerFaceColor','k')
text(120.6936, 22.0246,' Dapingding','Color','k','FontSize',18)
plot(120.7162, 22.0744,'o','MarkerEdgeColor','k','MarkerFaceColor','k')
text(120.7162, 22.0744,' Checheng','Color','k','FontSize',18)

clbr = colorbar;
clbr.Label.String = '\bfElevation (m)';
% clim([-300 0])
clbr.Ticks = cticks;
% clbr.TickLabels = {[num2str(cticks(1:end-1)'); ' ≥ 0']};
set(clbr, 'fontsize', 24)
% xline(120.74,'k','LineWidth',3)
% yline(22,'k','LineWidth',3)
% plot(proportional_line(:,1),proportional_line(:,2),'k','LineWidth',3); hold on
% text(proportional_line(2,1)+0.001,proportional_line(1,2),'1 km','Color','k','FontSize',16)
axis equal
set(gca,'tickdir','out')
set(gca,'xtick',91:0.02:181,'ytick',0:0.02:45)
% set(gca,'XTickLabel',strcat(get(gca,'XTickLabel'), '\circE'))
% set(gca,'YTickLabel',strcat(get(gca,'YTickLabel'), '\circN'))
text(ax, 0.01, 0.99, '(b)', 'FontSize', 30, 'Units', 'normalized', ...
        'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'BackgroundColor', 'w')
% grid on
% legend(['N & S distance：',num2str(sqrt(0.0027^2+0.0087^2)*111),' km'])
axis([120.66 120.7401 22 22.1])
ylabel(tt, '\bfLatitude (^{\circ}N)', 'fontsize', 24)
xlabel(tt, '\bfLongitude (^{\circ}E)', 'fontsize', 24)
set(gca,'LineWidth',2)
set(gca,'FontSize',24)
% set(gca,'FontWeight','bold')
% title('Map of NMMBA','FontSize',30)


exportgraphics(gcf, 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\Map_of_NS_stations.png')
% close gcf

%% Two station zoomed in
load("scsize.mat")
figure("OuterPosition", scsize/2)
tt = tiledlayout(1, 1, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
plot(tc(:, 1), tc(:, 2), 'Color', 'k', 'LineWidth', 3); hold on
fill_coa = fillseg(tc,repmat(.8,1,3)); hold on
set(fill_coa,'edgecolor','none'); hold on
plot(MiaoLi(1), MiaoLi(2), 'bo', 'MarkerSize', 8, 'LineWidth', 3, 'MarkerFaceColor', 'b')
axis equal
axis([120.7 120.82 24.6 24.7])

xline(120.82, 'k', 'LineWidth', 2)
yline(24.6, 'k', 'LineWidth', 2)

set(ax, 'LineWidth', 2, 'fontsize', 18, ...
    'xtick', 120.7:.04:120.82, 'ytick', 24.6:.04:24.7, ...
    'TickDir', 'out', 'Ticklength', [.01 0])
set(ax.XAxis, 'Minortick', 'on', 'Minortickvalue', 120.7:.02:120.82)
set(ax.YAxis, 'Minortick', 'on', 'Minortickvalue', 24.6:.02:24.7)
title(tt, '\bfMap of MilaoLi W station', 'fontsize', 24)
grid on

ylabel('\bfLatitude (^{\circ}N)')
xlabel('\bfLongitude (^{\circ}E)')

exportgraphics(gcf, 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\Map_of_MiaoLi_station.png')


%% 
figure("OuterPosition", scsize/2)
tt = tiledlayout(1, 1, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
plot(tc(:, 1), tc(:, 2), 'Color', 'k', 'LineWidth', 3); hold on
fill_coa = fillseg(tc,repmat(.8,1,3)); hold on
set(fill_coa,'edgecolor','none'); hold on
plot(B1(1), B1(2), 'bo', 'MarkerSize', 8, 'LineWidth', 3, 'MarkerFaceColor', 'b')
plot(B2(1), B2(2), 'bo', 'MarkerSize', 8, 'LineWidth', 3, 'MarkerFaceColor', 'b')
axis equal
axis([120.68 120.7 22.06 22.08])

text(B1(1), B1(2), '  B1', 'FontSize', 18)
text(B2(1), B2(2), ' B2', 'FontSize', 18)

xline(120.7, 'k', 'LineWidth', 2)
yline(22.08, 'k', 'LineWidth', 2)
yline(22.06, 'k', 'LineWidth', 2)

set(ax, 'LineWidth', 2, 'fontsize', 18, ...
    'xtick', 120.68:.02:120.7, 'ytick', 22.06:.02:22.08, ...
    'TickDir', 'out', 'Ticklength', [.01 0])
set(ax.XAxis, 'Minortick', 'on', 'Minortickvalue', 120.68:.01:120.7)
set(ax.YAxis, 'Minortick', 'on', 'Minortickvalue', 22.06:.01:22.08)
title(tt, '\bfMap of FuAn B1 & B2 station', 'fontsize', 24)

ylabel('\bfLatitude (^{\circ}N)')
xlabel('\bfLongitude (^{\circ}E)')

exportgraphics(gcf, 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\Map_of_FuAn_station.png')

%% 
% cd(func)
figure('OuterPosition',get(0,'ScreenSize'))
% for j = 1:550
%     plot(tc(340940:341020,1)+0.009+j*0.0001,tc(340940:341020,2),'color',[0.8 0.8 0.8],'LineWidth',4);hold on
% end
fill_coa = fillseg([tc(:, 1)+0.009, tc(:, 2)],repmat(.8,1,3)); hold on
set(fill_coa,'edgecolor','none'); hold on
plot(tc(:,1)+0.009,tc(:,2),'k','LineWidth',4);hold on % coast line
plot(tc(340930:341024,1)*0+120.74,tc(340930:341024,2),'k','LineWidth',4);hold on % frame line
plot(tc(340930:430000,1),tc(340930:430000,2)*0+22.1,'k','LineWidth',4);hold on % frame line
plot(120.6921941111, 22.0467218889,'o','MarkerEdgeColor','none','MarkerFaceColor','b');hold on % North station
text(120.6921941111, 22.0467218889+0.005,'North station','Color','b','FontSize',24,'HorizontalAlignment','right');hold on
plot(120.6894444, 22.038,'o','MarkerEdgeColor','none','MarkerFaceColor','b');hold on % South station
text(120.6894444, 22.038,'   South station','Color','b','FontSize',24);hold on
plot(120.6975, 22.0467, 'ro','LineWidth',3); hold on
text(120.6975, 22.0467+0.002, {'  \bfNational Museum of','   \bfMarine Biology','  \bfand Aquarium'},'Color','r','FontSize',20)

plot(B1(1)+0.009, B1(2), 'bo', 'MarkerSize', 5, 'LineWidth', 3, 'MarkerFaceColor', 'b')
plot(B2(1)+0.009, B2(2), 'bo', 'MarkerSize', 5, 'LineWidth', 3, 'MarkerFaceColor', 'b')

text(B1(1), B1(2), '    B1', 'FontSize', 18)
text(B2(1)+0.009, B2(2)-0.0019, 'B2', 'FontSize', 18, 'HorizontalAlignment', 'center')

% plot(120.6936, 22.0246,'o','MarkerEdgeColor','k','MarkerFaceColor','k')
% text(120.6936, 22.0246,' Dapingding','Color','k','FontSize',18)
% plot(120.7162, 22.0744,'o','MarkerEdgeColor','k','MarkerFaceColor','k')
% text(120.7162, 22.0744,' Checheng','Color','k','FontSize',18)

xline(120.74,'k','LineWidth',3)
yline(22,'k','LineWidth',3)

% plot(proportional_line(:,1),proportional_line(:,2),'k','LineWidth',3); hold on
% text(proportional_line(2,1)+0.001,proportional_line(1,2),'1 km','Color','k','FontSize',16)
axis equal
set(gca,'tickdir','out')
set(gca,'xtick',91:0.02:181,'ytick',0:0.02:45)
% set(gca,'XTickLabel',strcat(get(gca,'XTickLabel'), '\circE'))
% set(gca,'YTickLabel',strcat(get(gca,'YTickLabel'), '\circN'))
grid on
% legend(['N & S distance：',num2str(sqrt(0.0027^2+0.0087^2)*111),' km'])
axis([120.66 120.74 22 22.1])
set(gca,'LineWidth',4)
set(gca,'FontSize',18)
set(gca,'FontWeight','bold')
title('Map of NMMBA N, S & FuAn Temple B1, B2 station','FontSize',30)
ylabel('\bfLatitude (^{\circ}N)')
xlabel('\bfLongitude (^{\circ}E)')

cd('E:\INTERTIDAL\代婷與的PDF們\NMMBA')
exportgraphics(gcf,'MAP_of_NMMBA_and_FuAn.png')



