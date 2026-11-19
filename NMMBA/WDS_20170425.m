cd('C:\Users\fishe\Desktop\代婷與備份\原始資料rawdata\106年度data(all)\106年度第2季原始資料\HOWAN201704')

was = load('S7042501.was');
wds = load('S7042501.wds');


% wds(wds == 0) = NaN;
kk = 1:49:25921+49;
WDS = [];
for jj = 1:90
    for ii = 1:529
        WDS(ii,jj) = nansum(wds(kk(ii):kk(ii+1)-ii, jj));
    end
end
WDS(WDS == 0) = NaN;
% pcolor(was)
%% 
figure
tiledlayout(2,1,"TileSpacing","compact","Padding","tight")
ax1 = nexttile;
contourf(1:49:479*49, was(1,:), log(was(2:479+1, :)'), 'LineStyle','none'); hold on
colorbar

ax2 = nexttile;
contourf(1:length(wds), 1:90, wds', 'LineStyle','none'); hold on
colorbar

%% 
figure('OuterPosition', get(0., 'ScreenSize'))
% figure;
tt = tiledlayout(1,1,"TileSpacing","compact","Padding","tight");
theta = linspace(0, 360, 90);  % 假設方向是 0 到 360 度，共 90 個值
theta_rad = deg2rad(theta);
% ttttyt = nansum(wds(:,1:90));
% polarplot(theta_rad, wds); hold on

temp=360;
a=linspace(0,temp,size(wds(1:49,:)',1));
freq = 0.01:0.01:0.49;
% Creates artificial dataset to plot in polar cordinates
[df,ddir]=meshgrid(freq,a); 
ddir=deg2rad(ddir);
[px,py]=pol2cart(ddir,df);
contourf(px(:,1:30), -py(:,1:30), wds(1:30,:)', 10, 'LineColor', 'none');
colormap([1 1 1; jet])
% h = polarplot(px,py); hold on
% 格式設定使其看起來像極座標圖
axis equal;
axis off;
hold on;
r_labels = 0.05:0.05:0.3;  % 頻率線
for r = r_labels
    th = linspace(0, 2*pi, 500);
    [x, y] = pol2cart(th, r);
    plot(x, y, ':', 'LineWidth', 2, 'Color', [.5 .5 .5]); hold on
end
plot([-.3 .3], [0 0], ':', 'LineWidth', 2, 'Color', [.5 .5 .5]); hold on
plot([0 0], [-.3 .3], ':', 'LineWidth', 2, 'Color', [.5 .5 .5]); hold on
plot([-.3*cosd(30) .3*cosd(30)], [-.3*sind(30) .3*sind(30)], ':', 'LineWidth', 2, 'Color', [.5 .5 .5]); hold on
plot([.3*cosd(30) -.3*cosd(30)], [-.3*sind(30) .3*sind(30)], ':', 'LineWidth', 2, 'Color', [.5 .5 .5]); hold on
plot([-.3*sind(30) .3*sind(30)], [-.3*cosd(30) .3*cosd(30)], ':', 'LineWidth', 2, 'Color', [.5 .5 .5]); hold on
plot([.3*sind(30) -.3*sind(30)], [-.3*cosd(30) .3*cosd(30)], ':', 'LineWidth', 2, 'Color', [.5 .5 .5]); hold on

theta_labels = 0:30:330;
for th = theta_labels
    [x, y] = pol2cart(deg2rad(th), 0.32);
    % text(x, y, sprintf('%d', th), 'HorizontalAlignment','center');
    text(x, y, sprintf('%d', th), 'HorizontalAlignment','center', 'FontSize',18);
end
colorbar;
clim([0 4*10^-4])

% 標註頻率值
for r = r_labels
    [x, y] = pol2cart(deg2rad(10), r);
    text(x+.01, y, sprintf('%.2g Hz', r), 'FontSize', 18, 'Color', 'k');
end
set(gca,'FontSize',18)
view([90 -90])
title(tt, '\bf2017/04/25 11:00 a.m.', 'FontSize',24)

% Removes artificial dataset but keeps axis
% delete(h);                                                                  
% hold on
% dirSpec = wds(1:49,:)';
% % Plots contour graph on to polar axis
% contourf(px(:,1),-py,dirSpec,100,'LineStyle','none'); hold on
% shading interp
% 
% % Plot aesthetics
% % Roates and flips plot to enable 0 degrees = North

% % Sets axis ticks for diffined values (frequency values in this case)
% set(gca,'XTick',[0.1 0.2 0.3 0.4 0.5])            
% 
% figure
% for ii = 1:49
%     polarplot(theta_rad, aa1(ii,:)'); hold on
% end
%% 這我寫的

cd('E:\INTERTIDAL\代婷與的PDF們\NMMBA\Functions')
figure("OuterPosition",get(0,"ScreenSize"))
tt = tiledlayout(2,3,"TileSpacing","compact","Padding","tight");
for ii = 1:7*12:6*7*12
    ax = nexttile;
    polarcontourf_dai(wds(kk(ii):kk(ii)+48,:), 0.01:0.01:0.49, "Fontsize", 12, "Linewidth", 2, "Grid","on")
    c = colorbar;
    c.Label.String = '\bfS(f) (m^2/Hz)';
    title(ax, ["\bf", datestr(datenum(2017,4,25, ii+10, 0, 0), 'yyyy/mm/dd HH:MM')], 'fontsize', 24)
end
% ax = nexttile;
% polarcontourf_dai(wds(kk(ii):kk(ii)+48,:), 0.01:0.01:0.49, "Fontsize", 15, "Linewidth", 2, "Grid","on")
% title(tt,["\bf", datestr(datenum(2017,4,25, ii+10, 0, 0), 'yyyy/mm/dd HH:MM')], 'fontsize', 24)
% ax = gca;
% tt.TitleHorizontalAlignment = 'left';
cd('E:\INTERTIDAL\代婷與的PDF們\NMMBA\pictures\2017\WDS')
exportgraphics(gcf, "201704_wds.png")

%% 
% contourf(1:length(WDS), theta_rad, WDS', 'LineStyle','none'); hold on
% delete tt
func = "E:\INTERTIDAL\代婷與的PDF們\NMMBA\Functions";
cd(func)
tiledlayout(2,3,"TileSpacing","compact","Padding","tight")
for ii = 1:6
    ax(ii) = nexttile;
    dayevent = kk(ii):kk(ii+1)-1;
    aa1 = nan(49, 90);
    aa1(wds(dayevent,:) == 1*10^-4) = 1*10^-4;
    PolarContourf(wds(kk(ii):kk(ii+1)-1,:)', 0.01:0.01:0.49); hold on
    shading interp
    colorbar
    title(ax(ii), datestr(datenum(2017,4,25,ii+10,0,0),'yyyy/mm/dd HH:MM'))
end
% set(ax(1), 'YTickLabel', ['N', '', '' , 'W', '', '', 'S', '', '', 'E', '' ,''])
% ax2 = nexttile;
% PolarContourf(wds(50:98,:)', 0.01:0.01:0.49); hold on
% shading interp
% colorbar
% 
% ax1 = nexttile;
% PolarContourf(wds(99:49,:)', 0.01:0.01:0.49); hold on
% shading interp
% colorbar
% 
% ax2 = nexttile;
% PolarContourf(wds(50:98,:)', 0.01:0.01:0.49); hold on
% shading interp
% colorbar



