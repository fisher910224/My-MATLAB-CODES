%% NMMBA N and S and Wind station map
% North station：22°02'48.2"N 120°41'31.9"E
% South station：22°02'16.8"N 120°41'22.0"E
% Dapingding：N 22.0246 E 120.6936
% Checheng：N 22.0744 E 120.7162
% NMMBA：22.0467°N 120.6975°E
clear; close all; clc;


%% work path
GPS = 'E:\INTERTIDAL\代婷與的PDF們\後灣2024第一季~第二季0311~0418\GPS\20240311_0418';
Tc = 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\Coastline';
func = 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\Functions';

%% load data
cd(Tc)
coastline = load("Taiwan_nearcolstline.dat");
proportional_line = [120.661, 22.005;120.661+1/111.321, 22.005];


cd('E:\INTERTIDAL\代婷與的PDF們\NMMBA\Coastline\GEBCO_21_Oct_2025_31473d7dd4d7')
file_name = dir('*.nc');
ncdisp(file_name.name)
sea_bottom_lon = ncread(file_name.name, 'lon');
sea_bottom_lat = ncread(file_name.name, 'lat');
sea_bottom_elvt = ncread(file_name.name, 'elevation');

offset_locate = 0.009;
NMMBA = [120.6975, 22.0467];
N_sta = [120.6921941111, 22.0467218889];
S_sta = [120.6894444, 22.038];
coastline(:,1) = coastline(:,1)+offset_locate;

color_select = [0 0 1;
    .8 .8 .8];

for jj = 1:3
    bluegray(:, jj) = linspace(color_select(1, jj), color_select(2, jj), 255);
end



%% map
cd(func)
figure('OuterPosition',get(0,'ScreenSize'))
% fill_coa = fillseg(coastline,repmat(.8,1,3)); hold on
% set(fill_coa,'edgecolor','none'); hold on
tt = tiledlayout(1, 1, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
cticks = -300:50:0;
contourf(sea_bottom_lon, sea_bottom_lat, sea_bottom_elvt', -300:10:20, 'LineStyle', 'none'); hold on
[cc, hh] = contour(sea_bottom_lon, sea_bottom_lat, sea_bottom_elvt', -250:50:-50, 'Color', 'w', 'linewidth', 2, 'ShowText', 'on');
clabel(cc, hh, 'Color', 'w')
colormap(bluegray)
% shading interp
plot(coastline(:,1),coastline(:,2),'k','LineWidth',4);hold on % coast line
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
clbr.TickLabels = {[num2str(cticks(1:end-1)'); ' ≥ 0']};
set(clbr, 'fontsize', 18)
% xline(120.74,'k','LineWidth',3)
% yline(22,'k','LineWidth',3)
% plot(proportional_line(:,1),proportional_line(:,2),'k','LineWidth',3); hold on
% text(proportional_line(2,1)+0.001,proportional_line(1,2),'1 km','Color','k','FontSize',16)
axis equal
set(gca,'tickdir','out')
set(gca,'xtick',91:0.02:181,'ytick',0:0.02:45)
% set(gca,'XTickLabel',strcat(get(gca,'XTickLabel'), '\circE'))
% set(gca,'YTickLabel',strcat(get(gca,'YTickLabel'), '\circN'))
text(ax, 0.01, 0.99, '(b)', 'FontSize', 18, 'Units', 'normalized', ...
        'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'BackgroundColor', 'w')
% grid on
% legend(['N & S distance：',num2str(sqrt(0.0027^2+0.0087^2)*111),' km'])
axis([120.66 120.74 22 22.1])
ylabel('\bfLatitude (^{\circ}N)')
xlabel('\bfLongitude (^{\circ}E)')
set(gca,'LineWidth',4)
set(gca,'FontSize',18)
set(gca,'FontWeight','bold')
title('Map of NMMBA','FontSize',30)
cd('E:\INTERTIDAL\代婷與的PDF們\NMMBA')
exportgraphics(gcf,'MAP_of_NMMBA.png')





