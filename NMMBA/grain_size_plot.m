clear; close all; clc;

%% read data
csv_data = readtable('E:\INTERTIDAL\代婷與的PDF們\NMMBA\曾若玄老師_粒徑數據_20260324 .xlsx', 'ReadVariableNames', false);

grain_size = table2array(csv_data(3:end, "Var2"));
std_percent = table2array(csv_data(3:end, "Var3"));
grain_percent = table2array(csv_data(3:end, "Var8"));
% mean_grain_size = table2array(csv_data(2, "Var9"));
mean_grain_size = 57.4;
grain_sorting = table2array(csv_data(2, "Var10"));
grain_skewness = table2array(csv_data(2, "Var11"));
grain_kurtosis = table2array(csv_data(2, "Var12"));

ci_data = readtable('E:\INTERTIDAL\代婷與的PDF們\NMMBA\20260319_Sample.xlsx', 'ReadVariableNames', false);
ci_low = table2array(ci_data(3:end, "Var3"));
ci_high = table2array(ci_data(3:end, "Var4"));

figset_linefont = @(ax) set(ax, 'fontsize', 20, 'linewidth', 1.5, "TickLength", [0.01 0.02], 'TickDir', 'out');



%% plot
figure("OuterPosition", [1 1 1200 900])
tiledlayout(1, 1, "TileSpacing", "compact", "Padding", "tight")
ax = nexttile;
plot(grain_size, std_percent, 'LineWidth', 2, 'Color', [.8 .8 .8], 'DisplayName', '45 \mum std sample'); hold on
% X_patch = [grain_size(:)', fliplr(grain_size(:)')];
% Y_patch = [ci_low(:)', fliplr(ci_high(:)')];
% fill(X_patch, Y_patch, [0.9294, 0.6941, 0.1255], 'EdgeColor', 'none', 'FaceAlpha', 0.5, 'DisplayName', '\pm2 standard deviation'); hold on
plot(grain_size, grain_percent, 'LineWidth', 2, 'Color', 'k', 'DisplayName', 'NMMBA sample')
set(ax, 'Xscale', 'log', 'Xtick', [0.4, 1, 2, 4, 6, 10, 20, 40, 60, 100, 200, 400, 1000, 2000])
[~, ff] = max(grain_percent);
xline(grain_size(ff), 'k--', 'LineWidth', 1.5, 'HandleVisibility', 'off')
grain_txt = sprintf("peak size: %.2f \\mum", grain_size(ff));
text(grain_size(ff)+25, 8, grain_txt, 'FontSize', 18)

data_txt = sprintf("mean particle size: %.2f \\mum\n" + ...
    "sorting: %.2f\n" + ...
    "skewness: %.2f\n" + ...
    "kurtosis: %.2f", mean_grain_size, grain_sorting, grain_skewness, grain_kurtosis);
text(0.03, 0.89, data_txt, 'FontSize', 18, 'Units', 'normalized')

legend('Box', 'off')
ylabel(ax, 'Volume (%)')
xlabel(ax, 'particle diameter (\mum)')
axis square
% grid on
figset_linefont(ax)

exportgraphics(gcf, 'E:\INTERTIDAL\代婷與的PDF們\NMMBA\pictures\grain_size_distribution_20251217_sample.png')
