%control lance amplitude Fig2b
x1 = readmatrix('Fig2_CL_x_data.csv');
y1 = readmatrix('Fig2_CL_y_data.csv');

figure
plot(x1(2,:), y1(2,:), '-', x1(1,:), y1(1,:), '--')
set(gca, 'ydir', 'reverse')
xlabel('Time post-stimulus (s)')
title('\rm Time pre-stimulus (s)', 'Position', [0.5,-11.5,1])
ylabel('Amplitude  (uV)')
legend({'post-stimulus', 'pre-stimulus'})
ax1=gca;
ax2 = axes('Position', get(ax1, 'Position'), 'Color', 'none');
set(ax2, 'XAxisLocation', 'top', 'YAxisLocation', 'Right')
set(ax2, 'XLim', get(ax1, 'XLim'), 'YLim', get(ax1, 'YLim'))
set(ax2, 'XTick', get(ax1, 'XTick'), 'YTick', get(ax1, 'YTick'))
OppTickLabels = {'0' '-0.1' '-0.2' '-0.3' '-0.4' '-0.5' '-0.6' '-0.7' '-0.8' '-0.9' '-1'};
set(ax2, 'XTickLabel', OppTickLabels, 'YTickLabel',[]);


%heel lance amplitude Fig2a
x2 = readmatrix('Fig2_HL_x_data.csv');
y2 = readmatrix('Fig2_HL_y_data.csv');

figure
plot(x2(2,:), y2(2,:), '-', x2(1,:), y2(1,:), '--')
set(gca, 'ydir', 'reverse')
xlabel('Time post-stimulus (s)')
title('\rm Time pre-stimulus (s)', 'Position', [0.5,-21.5,1])
ylabel('Amplitude  (uV)')
legend({'post-stimulus', 'pre-stimulus'})
ax1=gca;
ax2 = axes('Position', get(ax1, 'Position'), 'Color', 'none');
set(ax2, 'XAxisLocation', 'top', 'YAxisLocation', 'Right')
set(ax2, 'XLim', get(ax1, 'XLim'), 'YLim', get(ax1, 'YLim'))
set(ax2, 'XTick', get(ax1, 'XTick'), 'YTick', get(ax1, 'YTick'))
OppTickLabels = {'0' '-0.1' '-0.2' '-0.3' '-0.4' '-0.5' '-0.6' '-0.7' '-0.8' '-0.9' '-1'};
set(ax2, 'XTickLabel', OppTickLabels, 'YTickLabel',[]);


%CL tstat Fig2d
allt = readmatrix('Fig2_CL_tstat_time_df.csv');
x = allt(2,:);
y = allt(1,:);

figure; hold on
plot(x, y, '-')
set(gca, 'ydir', 'reverse')
xlabel('Time (s)')
ylabel('t-statistic')
yline([-1.96, 1.96], '--')

%HL tstat Fig 2c
figure; hold on
allt = readmatrix('Fig2_HL_tstat_time_df.csv');
x = allt(2,:);
y = allt(1,:);

plot(x, y, '-')
set(gca, 'ydir', 'reverse')
xlabel('Time (s)')
ylabel('t-statistic')
yline([-1.96, 1.96], '--')