%% Turbidity 
clear; close all; clc;

%% path
S770_2015 = 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\20150917_1015\S770';
S770_202406 = 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\20240618_0715\S770';
S770_202401 = 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\20240109_0202\S770';
S770_2022 = 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\20221021_1107\S770';
AQP_2022 = 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\20221021_1107\AQP';
AQP_202401 = 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\20240109_0202\AQP';
AQP_202406 = 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\20240618_0715\AQP';
AQP_2015 = 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\20150917_1015\AQP';
func = 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\Functions';

%% load data
cd(S770_2015)
wave{1} = load("2015_09_wave.txt");
cd(S770_2022)
wave{2} = load("2022_10_waveN.txt");
cd(S770_202401)
wave{3} = load("24Feb04192730_N.txt");
cd(S770_202406)
wave{4} = load("NN_20240716.txt");

cd(AQP_2015)
AQP{1} = load("2015_09_N.txt");
cd(AQP_2022)
AQP{2} = load("2022_10_N.txt");
cd(AQP_202401)
AQP{3} = load("NN010901_separated.txt");
cd(AQP_202406)
AQP{4} = load("NN20240716_separated.txt");

% ================= date =================
cd(func)
minu = zeros(5000,1);
for i = 1:5000
    minu(i+1,1) = minu(i,1)+10;
    if minu(i+1,1)>=60
        minu(i+1,1) = 0;
    end
end

[T{1},Hs{1}] = huang_waveheight(wave{1},4,1200);
[T{2},Hs{2}] = huang_waveheight(wave{2},1,1200);
[T{3},Hs{3}] = huang_waveheight(wave{3},1,1200);
[T{4},Hs{4}] = huang_waveheight(wave{4},1,1200);

dday{1} = datenum(AQP{1}(:,1),AQP{1}(:,2),AQP{1}(:,3),AQP{1}(:,4),AQP{1}(:,5),0);
dday{2} = datenum(AQP{2}(:,1),AQP{2}(:,2),AQP{2}(:,3),AQP{2}(:,4),AQP{2}(:,5),0);
dday{3} = datenum(AQP{3}(:,1),AQP{3}(:,2),AQP{3}(:,3),AQP{3}(:,4),minu(1:length(AQP{3}(:,1))),0);
dday{4}= datenum(AQP{4}(:,1),AQP{4}(:,2),AQP{4}(:,3),AQP{4}(:,4),minu(1:length(AQP{4}(:,1))),0);

waveday{1} = houravg(dday{1}, length(dday{1}), 2)';
waveday{2} = houravg(dday{2}, length(dday{2}), 3)';
waveday{3} = houravg(dday{3}, length(dday{3}), 3)';
waveday{4} = houravg(dday{4}, length(dday{4}), 6)';

Tur{1} = -6.763*0.01*(AQP{1}(:,13)*5/65536).^2+5.21*10*(AQP{1}(:,13)*5/65536)-0.4731;
Tur{2} = -6.763*0.01*(AQP{2}(:,13)*5/65536).^2+5.21*10*(AQP{2}(:,13)*5/65536)-0.4731;
Tur{3} = -6.763*0.01*(AQP{3}(:,12)*5/65536).^2+5.21*10*(AQP{3}(:,12)*5/65536)-0.4731;
Tur{4} = -6.763*0.01*(AQP{4}(:,12)*5/65536).^2+5.21*10*(AQP{4}(:,12)*5/65536)-0.4731;

for ii = 1:4
    dateduration{ii} = [floor(datenum(dday{ii}(1))):4:ceil(datenum(dday{ii}(end)))];
end

for jj = 1:4
    for ii = 1:length(dateduration{jj})
        datetxt{jj}(:,ii) = {datestr(dateduration{jj}(ii),6)};
    end
end

%% 
figure('OuterPosition',get(0,'ScreenSize'))
t = tiledlayout(2,2,"TileSpacing","compact","Padding","tight");
for ii = 1:4
    ax(ii) = nexttile;
    yyaxis left
    if length(waveday{ii}) < length(Hs{ii})
        plot(waveday{ii}, Hs{ii}(1:length(waveday{ii})),'k','LineWidth',3)
    else
        plot(waveday{ii}(1:length(Hs{ii})), Hs{ii},'k','LineWidth',3)
    end
    set(gca, 'ytick', 0:100:400, 'xtick', floor(waveday{ii}(1)):4:ceil(waveday{ii}(end)))
    ylabel('Hs (cm)')
    set(gca, 'ycolor', 'k')
    ylim([0 400])
    yyaxis right
    plot(dday{ii}, Tur{ii}, 'ro','LineWidth',3)
    ylim([0 150])
    ylabel('Turbidity (NTU)','Color','r')
    set(gca, 'ytick', 0:50:150)
    set(gca,'xticklabel',datetxt{ii})
    set(gca, 'ycolor', 'r', 'fontsize', 20, 'linewidth',3,'FontWeight','bold')
    grid on
    xlim([floor(waveday{ii}(1)) ceil(waveday{ii}(end))])
    title(ax(ii), [datestr(floor(waveday{ii}(1)),'yyyy/mm/dd'),'~',datestr(floor(waveday{ii}(end)),'mm/dd')],'FontSize',30)
end

cd('E:\INTERTIDAL\代婷與的PDF們\NMMBA')
exportgraphics(gcf,'Hs_Tur_15_22_2401_2406.png')
% 
% yyaxis left
% if length(waveday{1}) < length(Hs{1})
%     plot(waveday{1}, Hs{1}(1:length(waveday{1})),'k','LineWidth',3)
% else
%     plot(waveday{1}(1:length(Hs{1})), Hs{1},'k','LineWidth',3)
% end
% set(gca, 'ytick', 0:100:400, 'xtick', floor(waveday{1}(1)):4:ceil(waveday{1}(end)))
% ylabel('Hs (cm)')
% set(gca, 'ycolor', 'k')
% ylim([0 400])
% yyaxis right
% plot(dday{1}, Tur{1}, 'ro','LineWidth',3)
% ylim([0 150])
% ylabel('Turbidity (NTU)','Color','r')
% set(gca, 'ytick', 0:50:150)
% set(gca,'xticklabel',datetxt{1})
% set(gca, 'ycolor', 'r', 'fontsize', 24, 'linewidth',3)
% grid on
% xlim([floor(waveday{1}(1)) ceil(waveday{1}(end))])