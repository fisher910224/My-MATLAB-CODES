clear; close all; clc;

%% work path
SINO = 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\20150917_1015\S770';
func = 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\Functions';
AQP = 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\20150917_1015\AQP';
pic_w = 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\20150917_1015\pictures\Wave';
pic_c = 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\20150917_1015\pictures\Current';
wind = 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\20150917_1015\wind';
Tc = 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\Coastline';
DJ = 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\20150917_1015\杜鵑2015\2015_DUJUAN_OBS_TrackData_14e6d704e290083a13bb66d196a48491';
mtf = 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\Matlab functions';

%% Load data
cd(SINO)
wave = load("2015_09_wave.txt");

cd(func)
nfft = 1200;
data = wave;
sr = 4;


win=hann(nfft); % [常態分布]頻率通常用1024或1200做切割，差不多是20分鐘(1024s≒17min)左右一個Burst
rho=1025; % density (kg/m^3)
g=9.81; % gravity acceleration (kg*m/s^2)

temp=data(:,3:end);% 純資料部分

[a,b]=size(temp);
tc=[]; % data numbers (1200)
for i=1:a
    tc=[tc;[1:b]'];
end
pres=reshape(temp',numel(temp),1);

ig=find(tc == 1);
k = [];
L = [];
waterdepth = [];

cd(func)
for kk=1:length(ig)
     zs=-nanmean(pres(ig(kk):ig(kk)+1200-1));       % zs is the vertical position of the pressure sensor        
     h=(-zs+30)/100.;                               % h is the water depth
     press=detrend(pres(ig(kk):ig(kk)+1200-1));     % Remove a linear trend from a vector, usually for FFT processing.
     [ss]=pres2ss(press, sr, h, 0.3);               % COUNTING DYNAMIC PRESS
     [psd_eta2,freq]=pwelch(ss,win,nfft/2,nfft,sr); % psd_eta2 = E{1/2*a^2}
     psd(:,kk) = psd_eta2;
     % [ss,k(kk,:),L(kk,:)]=pres2ss_for_wl(press, sr, h, 0.3);
     % [psd_eta2,freq]=pwelch(press,win,nfft/2,nfft,sr);
     % cd(mtf)
     % [Hm0,Tm01,Tm02,Tp,fp,f,Syy] = WaveSpectraFun(ss,4,[],1200,16,0.4,0.05,100,1,-5,'on','on','off','jonswap');
     % Hm01(kk,1) = Hm0;
     % Tm022(kk,1) = Tm02;
     % Tp2(kk,1) = Tp;
     % Syy1(:,kk) = Syy;
     % [Hm0,Hm0sea,Hm0swell,Tp,Tpsea,Tpswell,fp,fseparation,f,Syy] = SeaSwellFun(ss,4,[],1200,16,0,60,1,-5,0.05,0.1,'on','on','off','jonswap');
     % Hss(kk,1) = Hm0sea;
     % Hsw(kk,1) = Hm0swell;
     % Tps(kk,1) = Tpsea;
     % Tpsw(kk,1) = Tpswell;
     % [hs(kk,1),Tp(kk,1),Tm02(kk,1),Tm01(kk,1),hsw(kk,1),Tpsw(kk,1),Tm02sw(kk,1),Tm01sw(kk,1),hws(kk,1),Tpws(kk,1),Tm02ws(kk,1),Tm01ws(kk,1)]=mpars1d(freq,psd_eta2,7);
     df=freq(2)-freq(1);
     S0=nansum(psd_eta2)*df;                        % 書中的m0 page.57
     S2=nansum((freq.^2).*psd_eta2)*df;             % 書中的m2 page.57
     m0_sw_seven = nansum(psd_eta2(freq < 1/7))*df;
     m0_ww_seven = nansum(psd_eta2(freq >=1/7))*df;
     m0_sw_eight = nansum(psd_eta2(freq < 1/8))*df;
     m0_ww_eight = nansum(psd_eta2(freq >=1/8))*df;
     m0_sw_nine = nansum(psd_eta2(freq < 1/9))*df;
     m0_ww_nine = nansum(psd_eta2(freq >=1/9))*df;
     m0_sw_ten = nansum(psd_eta2(freq < 1/10))*df;
     m0_ww_ten = nansum(psd_eta2(freq >=1/10))*df;
     T(kk,1)=sqrt(S0/S2);                             % 書中的Tm02 page.61
     Hs(kk,1)=4*sqrt(S0);                             % 4*sigma (sigma^2 = m0)
     Sw(kk,1)=4*sqrt(m0_sw_seven);
     Ww(kk,1)=4*sqrt(m0_ww_seven);
     Sw8(kk,1)=4*sqrt(m0_sw_eight);
     Ww8(kk,1)=4*sqrt(m0_ww_eight);
     Sw9(kk,1)=4*sqrt(m0_sw_nine);
     Ww9(kk,1)=4*sqrt(m0_ww_nine);
     Sw10(kk,1)=4*sqrt(m0_sw_ten);
     Ww10(kk,1)=4*sqrt(m0_ww_ten);
     [k(kk,1),L(kk,1)] = dpr_nt(T(kk,1),h);
     waterdepth(kk,1) = h;
end

% save psd.mat psd freq

%%
clc
numCols = width(psd); % psd 的列數（不同的 PSD 信號數量）

% 預分配結果矩陣，提高計算效率
hs = zeros(numCols, 1);
Tp = zeros(numCols, 1);
Tm02 = zeros(numCols, 1);
Tm01 = zeros(numCols, 1);
hsw = zeros(numCols, 1);
Tpsw = zeros(numCols, 1);
Tm02sw = zeros(numCols, 1);
Tm01sw = zeros(numCols, 1);
hws = zeros(numCols, 1);
Tpws = zeros(numCols, 1);
Tm02ws = zeros(numCols, 1);
Tm01ws = zeros(numCols, 1);

% find(isempty(psd))
% find(isempty(freq))
% numel(freq) - numel(unique(freq))
% find(all(psd == 0, 1)) % 找出全零的列
% fp = psd(:, 1); % 選擇第一列
% csabsdfp = cumsum(abs(diff(fp)));
% find(csabsdfp > 0) % 應該返回非空
% csy = csabsdfp(csabsdfp > 0);
% disp(csy); % 應該是非空的有效數據
% save csy.mat csy

for ii = 1:numCols
    [hs(ii,1),Tp(ii,1),Tm02(ii,1),Tm01(ii,1),hsw(ii,1),Tpsw(ii,1),Tm02sw(ii,1),Tm01sw(ii,1),hws(ii,1),Tpws(ii,1),Tm02ws(ii,1),Tm01ws(ii,1)] = mpars1d(freq, psd(:, ii), 1/7);
end

%% 
figure('OuterPosition',get(0,'ScreenSize'))
t = tiledlayout(3,1,"TileSpacing","compact",'Padding','tight');
ax1 = nexttile;
% plot(-hs*sqrt(-1)); hold on
plot(abs(hs),'LineWidth',3)
set(gca,'linewidth',3, 'fontsize',18)

ax2 = nexttile;
plot(Hs,'LineWidth',3)
set(gca,'linewidth',3, 'fontsize',18)

ax3 = nexttile;
plot(hs-Hs,'LineWidth',3);
ylim([-1 1])
set(gca,'linewidth',3, 'fontsize',18)

title(ax1, "Dr. stu. Wang's function (Hs, mpars1d)" , 'FontSize',20)
title(ax2, "My calculated Hs", 'FontSize', 20)
title(ax3, 'first plot minus second plot','FontSize', 20)
cd(pic_w)
exportgraphics(gcf,'function_compare_Hs.png')

%% 
figure('OuterPosition',get(0,'ScreenSize'))
t = tiledlayout(3,1,"TileSpacing","compact",'Padding','tight');
ax1 = nexttile;
% plot(-hs*sqrt(-1)); hold on
plot(abs(Tm02),'LineWidth',3)
set(gca,'linewidth',3, 'fontsize',18)

ax2 = nexttile;
plot(T,'LineWidth',3)
set(gca,'linewidth',3, 'fontsize',18)

ax3 = nexttile;
plot(Tm02-T,'LineWidth',3);
set(gca,'linewidth',3, 'fontsize',18)
ylim([-1 1])

title(ax1, "Dr. stu. Wang's function (Tm02, mpars1d)" , 'FontSize',20)
title(ax2, "My calculated Tm02", 'FontSize', 20)
title(ax3, 'first plot minus second plot','FontSize', 20)
cd(pic_w)
exportgraphics(gcf,'function_compare_Tm02.png')

%% 
figure('OuterPosition',get(0,'ScreenSize'))
t = tiledlayout(2,1,"TileSpacing","compact","Padding","tight");
ax1 = nexttile;
plot(hws,'LineWidth',3); hold on
plot(Hsww,'LineWidth',3)
set(gca,'linewidth',3, 'fontsize',18)
legend('Dr. Wang','My','fontsize',18)
title(ax1, 'Wind wave','fontsize',24)
title(t, '\bf7 sec','fontsize',30)

ax2 = nexttile;
plot(abs(hsw),'LineWidth',3); hold on
set(gca,'linewidth',3, 'fontsize',18)
plot(Hssw,'LineWidth',3)
legend('Dr. Wang','My','fontsize',18)
title(ax2, 'Swell', 'FontSize',24)
% cd(pic_w)
% exportgraphics(gcf,'function_compare_sw_ww.png')
% 

%% 
cd(func)
[Tww,Hsww] = dai_waveheight_ww(wave,4,1200);

[Tsw,Hssw] = dai_waveheight_sw(wave,4,1200);

for ii = 1:width(psd)
    try
        [hs(ii,1),Tp(ii,1),Tm02(ii,1),Tm01(ii,1),hsw(ii,1),Tpsw(ii,1),Tm02sw(ii,1),Tm01sw(ii,1),hws(ii,1),Tpws(ii,1),Tm02ws(ii,1),Tm01ws(ii,1)] = mpars1d(freq, psd(:,ii), 7);
    catch ME
        warning('Error in column %d: %s', ii, ME.message);
        hs(ii,1) = NaN; Tp(ii,1) = NaN; Tm02(ii,1) = NaN; Tm01(ii,1) = NaN;
        hsw(ii,1) = NaN; Tpsw(ii,1) = NaN; Tm02sw(ii,1) = NaN; Tm01sw(ii,1) = NaN;
        hws(ii,1) = NaN; Tpws(ii,1) = NaN; Tm02ws(ii,1) = NaN; Tm01ws(ii,1) = NaN;
    end
end


%=========== date =============
cd(AQP)
AQP_N = load("2015_09_N.txt");
dday = datenum(AQP_N(1:end-1,1),AQP_N(1:end-1,2),AQP_N(1:end-1,3),AQP_N(1:end-1,4),AQP_N(1:end-1,5),0);
length_AQP = length(dday);
cd(func)
waveday = houravg(dday,length_AQP,2)';
dateduration = [floor(datenum(dday(1))):4:ceil(datenum(dday(end)))]';
for ii = 1:length(dateduration)
    datetxt(:,ii) = {datestr(dateduration(ii),6)};
end

% figure('OuterPosition',get(0,'ScreenSize'))
% plot(pres)
% 
% figure('OuterPosition',get(0,'ScreenSize'))
% plot(press)
% 
% figure('OuterPosition',get(0,'ScreenSize'))
% plot(ss)

figsetting_ax   = @(ax) set(ax, ...
    'box','on',...
    'TickLength',[0.008 0.025], 'LineWidth',3,...
    'FontSize',18, 'FontWeight','bold', ...
    'xticklabel', datetxt, 'xtick', [floor(datenum(dday(1))):4:ceil(datenum(dday(end)))]) ;



%%
figure('OuterPosition',get(0,'ScreenSize'))
plot(Hs) ;hold on
cd(mtf)
for kk = 1:length(ig)
    [Hs1,Hz1,Tz1,Ts1,H1,T1]=WaveZerocrossingFun(pres(ig(kk):ig(kk)+1200-1),1,1200,[]);
    % [T,H] = zero_up(pres(ig(kk):ig(kk)+1200-1),(1:1200));
    Hsssss(kk,1) = Hs1;
    Tsssss(kk,1) = Ts1;
end
plot(Hsssss)
ylabel('Wave Height (cm)')
xlabel('Data Numbers')
legend('huang\_waveheight','WaveZerocrossingFun')
set(gca,'FontWeight','bold','FontSize',16,'LineWidth',3)
title('huang\_waveheight Compared to WaveZerocrossingFun','FontSize',24)

% figure('OuterPosition',get(0,'ScreenSize'))
% plot(psd_eta2)
% xlim([0 300])
%%
figure('OuterPosition',get(0,'ScreenSize'))
ax1 = nexttile;
plot(Hs,Hsssss,'k.')
axis square
lsline(ax1)
[R,P] = corrcoef(Hs,Hsssss);
R2 = R(1,2)*R(2,1); 
txt_R = {'R^2=',num2str(R2)};
text(300,10,txt_R,"FontSize",18)
ylabel('Hs from huang\_waveheight (cm)')
xlabel('Hs from ZeroCrossingFun (cm)')
axis([0 400 0 180])
set(gca,'FontWeight','bold','FontSize',16,'LineWidth',3)
cd 'F:\代婷與的PDF們\NMMBA\Matlab functions'
exportgraphics(gcf,'2015_09_corr_huang_zero.png')

%% Wave length
figure('OuterPosition',get(0,'ScreenSize'))
t = tiledlayout(2,1,"TileSpacing","compact","Padding","tight");
ax1 = nexttile;
plot(waveday,L(3:end-2)/20,'LineWidth',2); hold on
plot(waveday,waterdepth(3:end-2),'LineWidth',2)
legend('wave length/20','water depth')
ylabel('m')
xlim([floor(dday(1)) ceil(dday(end))])
grid on
% set(gca, 'fontsize',16,'fontweight','bold','linewidth',2)
figsetting_ax(ax1)
xlabel([])
title(t,'\bfDispersion relation：wave length & water depth','fontsize',24)

ax2 = nexttile;
plot(waveday,waterdepth(3:end-2)./L(3:end-2),'LineWidth',3); hold on
yline(0.5,'r:','LineWidth',3)
yline(0.04,'r:','LineWidth',3)
axis([floor(dday(1)) ceil(dday(end)) 0 0.7])
text(waveday(1000),0.02,'Shallow-water wave','FontSize',18,'FontWeight','bold')
text(waveday(1000),0.42,'Transitional water wave','Color','r','FontSize',18,'FontWeight','bold')
text(waveday(1000),0.6,'Deep-water wave','FontSize',18,'FontWeight','bold')
set(gca,'TickDir','out')
grid on
figsetting_ax(ax2)
title(ax2, ['\bfRation of water depth & wave length',''])
cd(pic_w)
exportgraphics(gcf,'wavelength_waterdepth.png')


%% period 
figure;
plot(Tz); hold on
plot(T)






%%
cd 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\Matlab functions'
% for kk = 1:length(ig)
%     [Hm0,Tm01,Tm02,Tp,fp,f,Syy] = WaveSpectraFun(pres(ig(kk):ig(kk)+1200-1),4,[],1200,16,0.4,0.05,100,1,-5,'on','on','off','jonswap');
%     Hm01(kk,1) = Hm0;
%     Tm022(kk,1) = Tm02;
%     Tp2(kk,1) = Tp;
%     % Syy1(kk,1) = Syy;
% end
% for kk = 1:1200
%     [Hm0,Tm01,Tm02,Tp,fp,f,Syy] = WaveSpectraFun(ss(kk),1,[],1,16,0.4,0.05,100,1,-5,'on','on','off','jonswap');
%     Hm01(kk,1) = Hm0;
%     Tm022(kk,1) = Tm02;
%     Tp2(kk,1) = Tp;
%     % Syy1(kk,1) = Syy;
% end

figure('OuterPosition',get(0,'ScreenSize'))
plot(Hs); hold on
plot(Hsssss); hold on
plot(Hm01)
ylabel('Wave Height (cm)')
xlabel('Data Numbers')
legend('huang\_waveheight','WaveZerocrossingFun','WaveSpectraFun')
set(gca,'FontWeight','bold','FontSize',16,'LineWidth',3)
title('huang\_waveheight & WaveZerocrossingFun & WaveSpectraFun','THROUGH \bfpres2ss','FontSize',24)
exportgraphics(gcf,'2015_09_3different_function.png')
%%
figure('OuterPosition',get(0,'ScreenSize'))
ax1 = nexttile;
plot(Hs,Hm01,'k.')
axis square
lsline(ax1)
[R,P] = corrcoef(Hs,Hm01);
R2 = R(1,2)*R(2,1); 
txt_R = {'R^2=',num2str(R2)};
text(300,10,txt_R,"FontSize",18)
ylabel('Hs from huang\_waveheight (cm)')
xlabel('Hs from WaveSpectraFun (cm)')
axis([0 400 0 180])
set(gca,'FontWeight','bold','FontSize',16,'LineWidth',3)
cd 'F:\代婷與的PDF們\NMMBA\Matlab functions'
exportgraphics(gcf,'2015_09_corr_huang_spec.png')

%%
figure('OuterPosition',get(0,'ScreenSize'))
ax1 = nexttile;
plot(Hsssss,Hm01,'k.')
axis square
lsline(ax1)
[R,P] = corrcoef(Hsssss,Hm01);
R2 = R(1,2)*R(2,1); 
txt_R = {'R^2=',num2str(R2)};
text(80,10,txt_R,"FontSize",18)
ylabel('Hs from WaveZerocrossing (cm)')
xlabel('Hs from WaveSpectraFun (cm)')
axis([0 140 0 140])
set(gca,'FontWeight','bold','FontSize',16,'LineWidth',3)
cd 'F:\代婷與的PDF們\NMMBA\Matlab functions'
exportgraphics(gcf,'2015_09_corr_spec_zero.png')

%%
% cd 'F:\代婷與的PDF們\NMMBA\Matlab functions'
% for kk = 1:length(ig)
%     [Hm0,Hm0sea,Hm0swell,Tp,Tpsea,Tpswell,fp,fseparation,f,Syy] = SeaSwellFun(pres(ig(kk):ig(kk)+1200-1),4,[],1200,1,0.004,1000,1,-3,0.14,1000,'on','on','off','off');
%     Hss(kk,1) = Hm0sea;
%     Hsw(kk,1) = Hm0swell;
%     Tps(kk,1) = Tpsea;
%     Tpsw(kk,1) = Tpswell;
% end
figure('OuterPosition',get(0,'ScreenSize'))
plot(Hss); hold on
plot(Hsw); hold on
plot(Hssw); hold on
plot(Hsww)
legend('SeaSwellFun-Sea','SeaSwellFun-Swell','huang\_waveheight-ww','huang\_waveheight-sw')




%% Zerocrossing by myself
cd(func)
[T_zero,Tp_zero,Hs_zero,~,Tz] = Zeroupcrossing_forS770(wave,0.4,4);
% figure('OuterPosition',get(0,'ScreenSize'))
% plot(Hs); hold on
% plot(Hm01); hold on
% plot(Hs_zero);
% legend('huang\_waveheight','WaveZerocrossingFun','Zeroupcrossing_forS770')

%%
figure('OuterPosition',get(0,'ScreenSize'))
plot(waveday,Hs(3:end-2),'b','LineWidth',3); hold on
plot(waveday,Hs_zero(3:end-2),'r','LineWidth',3); hold on
legend('frequency','time')
ylabel('Wave Height (cm)')
xlabel('Date')
set(gca,'xtick', [floor(datenum(dday(1))):4:ceil(datenum(dday(end)))])
set(gca,'xticklabel',datetxt)
xlim([floor(datenum(dday(1))) ceil(datenum(dday(end)))])
set(gca,'FontWeight','bold','FontSize',16,'LineWidth',3)
title('Wave height-calculated by frequency & time','FontSize',24)
cd 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\20150917_1015\pictures'
exportgraphics(gcf,'2015_09_Hs_HS_Zero.png')

%%
cd(func)
[Tp,T,Hs] = huang_waveheightTp(wave,4,1200);
figure('OuterPosition',get(0,'ScreenSize'))
plot(T); hold on
plot(T_zero);
legend('T from huang\_waveheight','T from Zeroupcrossing\_forS770')
ylabel('Period (s)')
xlabel('Data Numbers')
set(gca,'FontWeight','bold','FontSize',16,'LineWidth',3)
title('huang\_waveheight & Zerocrossing\_forS770','FontSize',24)
cd 'F:\代婷與的PDF們\NMMBA\20150917_1015\pictures'
exportgraphics(gcf,'2015_09_T_T_Zero.png')

%%
figure('OuterPosition',get(0,'ScreenSize'))
plot(Tp); hold on
plot(Tp_zero);
legend('Tp from huang\_waveheight','Tp from Zeroupcrossing\_forS770')
ylabel('Period (s)')
xlabel('Data Numbers')
set(gca,'FontWeight','bold','FontSize',16,'LineWidth',3)
title('huang\_waveheight & Zerocrossing\_forS770','FontSize',24)
cd 'F:\代婷與的PDF們\NMMBA\20150917_1015\pictures'
exportgraphics(gcf,'2015_09_Tp_Tp_Zero.png')

%% Very
%% Very
%% Important founding!!!!!!!!!























%% Power spectrum
figure('OuterPosition',get(0,'ScreenSize'))
% plot(f,Syy1(:,1)); hold on
% diff_hour = floor((datenum(2015,10,5,0,0,0)-datenum(2015,9,17,11,0,0)*24)+1);
diff_hour = floor((datenum(2015,10,4,0,0,0)-datenum(2015,9,17,11,0,0))*24*3)+1;
% psdm = [];
% for ii = 2:height(psd)
%     psdm(ii-1,1) = mean(psd(ii-1,:));
% end
% 
% for ii = 5:height(psd)
%     for jj = 1:width(psd)
%         if psd(ii-2,jj) < psd(ii,jj) && psd(ii-2,jj) < psd(ii-1,jj) && psd(ii-2,jj) < psd(ii-3,jj) && psd(ii-2,jj) < psd(ii-4,jj)
%             psd(ii-2,jj) = mean(psd(ii,jj)+psd(ii-2,jj)+psd(ii-3,jj)+psd(ii-4,jj));
%         end
%     end
% end


% plot(freq,psdm*10^-4, 'LineWidth',2); hold on
plot(freq,psd(:,diff_hour)*10^-4,'LineWidth',2,'Color','b'); hold on
% plot(freq,psd(:,1)*10^-4,'LineWidth',2); hold on
% plot(freq,psd(:,842)*10^-4,'LineWidth',2); hold on
xline(1/7, 'r:', 'LineWidth',2)
xline(1/10, 'r:', 'LineWidth',2)
txt_sw7 = {'SW wave height (7 sec)：',[num2str(4*sqrt(nansum(psd(freq<1/7,diff_hour))*df),'%.1f'),' cm']};
txt_ww7 = {'WW wave height (7 sec)：',[num2str(4*sqrt(nansum(psd(freq>=1/7,diff_hour))*df),'%.1f'),' cm']};
txt_sw10 = {'SW wave height (10 sec)：',[num2str(4*sqrt(nansum(psd(freq<1/10,diff_hour))*df),'%.1f'),' cm']};
txt_ww10 = {'WW wave height (10 sec)：',[num2str(4*sqrt(nansum(psd(freq>=1/10,diff_hour))*df),'%.1f'),' cm']};
text(1/7,max(psd(:,diff_hour)*10^-4)*0.9,'  7 sec','FontSize',18,'Color','r')
text(1/10,max(psd(:,diff_hour)*10^-4)*0.9,'  10 sec','FontSize',18,'Color','r')
text(0.17, max(psd(:,diff_hour)*10^-4)*0.75,txt_sw7,"FontSize",18,"Color",'k')
text(0.3, max(psd(:,diff_hour)*10^-4)*0.75,txt_ww7,"FontSize",18,"Color",'k')
text(0.17, max(psd(:,diff_hour)*10^-4)*0.6,txt_sw10,"FontSize",18,"Color",'k')
text(0.3, max(psd(:,diff_hour)*10^-4)*0.6,txt_ww10,"FontSize",18,"Color",'k')
xlim([0 0.4])
xlabel('Frequency (Hz)')
ylabel('\itS\eta\eta (m^2s)')
legend(['df = ',num2str(df)])
set(gca, 'fontsize', 18, 'fontweight', 'bold', 'linewidth', 2)
txt = {[datestr(diff_hour/24/3+datenum(2015,9,17,11,0,0),26),' ',datestr(diff_hour/24/3+datenum(2015,9,17,11,0,0),15)]};
title('Power spectrum of Wave height',txt, 'FontSize',24)

% 4*sqrt(nansum(psd(:,diff_hour)*10^-4)*df)
% 4*sqrt(nansum(psd(freq<1/7,diff_hour))*df)
% 4*sqrt(nansum(psd(freq>=1/7,diff_hour))*df)
% Sw(diff_hour)
% Ww(diff_hour)
% Hs(diff_hour)
% [a,b] = max(Hs);
% datestr(1191/24/3+datenum(2015,9,17,11,0,0),5)

% filename = [datestr(diff_hour/24/3+datenum(2015,9,17,11,0,0),'yyyymmdd'),'_waveheight.png'];
% cd(pic_w)
% exportgraphics(gcf, filename)

%% Power spectrum
figure('OuterPosition',get(0,'ScreenSize'))
% plot(f,Syy1(:,1)); hold on
% diff_hour = floor((datenum(2015,10,5,0,0,0)-datenum(2015,9,17,11,0,0)*24)+1);
diff_hour = floor((datenum(2015,9,28,0,0,0)-datenum(2015,9,17,11,0,0))*24*3)+1;
psdm = [];
for ii = 1:height(psd)
    psdm(ii,1) = mean(psd(ii,:));
end
% plot(freq,psdm*10^-4, 'LineWidth',2); hold on
plot(freq,psd(:,diff_hour)*10^-4,'LineWidth',2,'Color','b'); hold on
% plot(freq,psd(:,1)*10^-4,'LineWidth',2); hold on
% plot(freq,psd(:,842)*10^-4,'LineWidth',2); hold on
xline(1/7, 'r:', 'LineWidth',2)
xline(1/10, 'r:', 'LineWidth',2)
txt_sw7 = {'SW wave height (7 sec)：',[num2str(4*sqrt(nansum(psd(freq<1/7,diff_hour))*df),'%.1f'),' cm']};
txt_ww7 = {'WW wave height (7 sec)：',[num2str(4*sqrt(nansum(psd(freq>=1/7,diff_hour))*df),'%.1f'),' cm']};
txt_sw10 = {'SW wave height (10 sec)：',[num2str(4*sqrt(nansum(psd(freq<1/10,diff_hour))*df),'%.1f'),' cm']};
txt_ww10 = {'WW wave height (10 sec)：',[num2str(4*sqrt(nansum(psd(freq>=1/10,diff_hour))*df),'%.1f'),' cm']};
text(1/7,max(psd(:,diff_hour)*10^-4)*0.9,'  7 sec','FontSize',18,'Color','r')
text(1/10,max(psd(:,diff_hour)*10^-4)*0.9,'  10 sec','FontSize',18,'Color','r')
text(0.3, max(psd(:,diff_hour)*10^-4)*0.75,txt_sw7,"FontSize",18,"Color",'k')
text(0.3, max(psd(:,diff_hour)*10^-4)*0.35,txt_ww7,"FontSize",18,"Color",'k')
text(0.3, max(psd(:,diff_hour)*10^-4)*0.6,txt_sw10,"FontSize",18,"Color",'k')
text(0.3, max(psd(:,diff_hour)*10^-4)*0.2,txt_ww10,"FontSize",18,"Color",'k')
xlim([0 0.4])
xlabel('Frequency (Hz)')
ylabel('\itS\eta\eta (m^2s)')
legend(['df = ',num2str(df)])
set(gca, 'fontsize', 18, 'fontweight', 'bold', 'linewidth', 2)
txt = {[datestr(diff_hour/24/3+datenum(2015,9,17,11,0,0),26),' ',datestr(diff_hour/24/3+datenum(2015,9,17,11,0,0),15)]};
title('Power spectrum of Wave height',txt, 'FontSize',24)

% 4*sqrt(nansum(psd(:,diff_hour)*10^-4)*df)
% 4*sqrt(nansum(psd(freq<1/7,diff_hour))*df)
% 4*sqrt(nansum(psd(freq>=1/7,diff_hour))*df)
% Sw(diff_hour)
% Ww(diff_hour)
% Hs(diff_hour)
% [a,b] = max(Hs);
% datestr(1191/24/3+datenum(2015,9,17,11,0,0),5)
filename = [datestr(diff_hour/24/3+datenum(2015,9,17,11,0,0),'yyyymmdd'),'_waveheight.png'];
cd(pic_w)
exportgraphics(gcf, filename)


%% Very
%% Very
%% Very
%% Very
%% Very
%% Very
%% Very
%% Very
%% Very
%% Very
%% NICE














%% diffrent frequency compare
figure('OuterPosition',get(0,'ScreenSize'))
t = tiledlayout(4,1,'TileSpacing','compact','Padding','tight');
ax1 = nexttile;
plot(waveday,Hs(3:end-2),'k', 'LineWidth',2); hold on
plot(waveday,Sw(3:end-2),'r', 'LineWidth',2);hold on
plot(waveday,Ww(3:end-2),'b', 'LineWidth',2)
legend('Observed wave','Swell','Wind wave')
ylabel('Wave height (cm)')
grid on
xlim([floor(dday(1)) ceil(dday(end))])
% set(gca, 'fontsize',16,'fontweight','bold','linewidth',2)
figsetting_ax(ax1)
set(ax1, 'xticklabel',[])

ax2 = nexttile;
plot(waveday,Hs(3:end-2),'k', 'LineWidth',2); hold on
plot(waveday,Sw8(3:end-2),'r', 'LineWidth',2);hold on
plot(waveday,Ww8(3:end-2),'b', 'LineWidth',2)
legend('Observed wave','Swell','Wind wave')
ylabel('cm')
xlim([floor(dday(1)) ceil(dday(end))])
grid on
% set(gca, 'fontsize',16,'fontweight','bold','linewidth',2)
figsetting_ax(ax2)
set(ax2, 'xticklabel',[])

ax3 = nexttile;
plot(waveday,Hs(3:end-2),'k', 'LineWidth',2); hold on
plot(waveday,Sw9(3:end-2),'r', 'LineWidth',2);hold on
plot(waveday,Ww9(3:end-2),'b', 'LineWidth',2)
legend('Observed wave','Swell','Wind wave')
ylabel('cm')
xlim([floor(dday(1)) ceil(dday(end))])
grid on
% set(gca, 'fontsize',16,'fontweight','bold','linewidth',2)
figsetting_ax(ax3)
set(ax3, 'xticklabel',[])

ax4 = nexttile;
plot(waveday,Hs(3:end-2),'k', 'LineWidth',2); hold on
plot(waveday,Sw10(3:end-2),'r', 'LineWidth',2); hold on
plot(waveday,Ww10(3:end-2),'b', 'LineWidth',2)
legend('Observed wave','Swell','Wind wave')
xlabel('Date')
ylabel('cm')
xlim([floor(dday(1)) ceil(dday(end))])
grid on
% set(gca, 'fontsize',16,'fontweight','bold','linewidth',2)
figsetting_ax(ax4)
title(ax1, '\bfSeparate by 7 sec/0.14 Hz','FontSize',18)
title(ax2, '\bfSeparate by 8 sec/0.125 Hz','FontSize',18)
title(ax3, '\bfSeparate by 9 sec/0.11 Hz','FontSize',18)
title(ax4, '\bfSeparate by 10 sec/0.1 Hz','FontSize',18)
title(t, '\bfDifferent frequencies of Wave height','2015/09/17~10/15','fontsize',24)
cd(pic_w)
exportgraphics(gcf, 'Diff_freq.png')
