% Figure 3a top panel: UCL 

x1CL = readmatrix('Fig3_UCL_CL_template_x1.csv');
y1CL = readmatrix('Fig3_UCL_CL_template_y1.csv');
x2CL = readmatrix('Fig3_UCL_CL_meanEEG_x2.csv');
y2CL = readmatrix('Fig3_UCL_CL_meanEEG_y2.csv');


x1HL = readmatrix('Fig3_UCL_HL_template_x1.csv');
y1HL = readmatrix('Fig3_UCL_HL_template_y1.csv');
x2HL = readmatrix('Fig3_UCL_HL_meanEEG_x2.csv');
y2HL = readmatrix('Fig3_UCL_HL_meanEEG_y2.csv');


figure
subplot(1,2,1)
plot(x1CL, y1CL, '-r', x2CL, y2CL, 'k-')
set(gca, 'ydir', 'reverse')
xlabel('Time (ms)')
ylabel('Voltage  (uV)')
title('UCL: Control heel lance')
ylim([-20 50])
xlim([-500 1000])
subplot(1,2,2)
plot(x1HL, y1HL, '-r', x2HL, y2HL, 'k-')
set(gca, 'ydir', 'reverse')
xlabel('Time (ms)')
ylabel('Voltage  (uV)')
title('UCL: Heel lance')
ylim([-20 50])
xlim([-500 1000])


% Figure 3b top panel: Exeter
x3CL = readmatrix('Fig3_Exeter_CL_template_x1.csv');
y3CL = readmatrix('Fig3_Exeter_CL_template_y1.csv');
x4CL = readmatrix('Fig3_Exeter_CL_meanEEG_x2.csv');
y4CL = readmatrix('Fig3_Exeter_CL_meanEEG_y2.csv');


x3HL = readmatrix('Fig3_Exeter_HL_template_x1.csv');
y3HL = readmatrix('Fig3_Exeter_HL_template_y1.csv');
x4HL = readmatrix('Fig3_Exeter_HL_meanEEG_x2.csv');
y4HL = readmatrix('Fig3_Exeter_HL_meanEEG_y2.csv');


figure
subplot(1,2,1)
plot(x3CL, y3CL, '-r', x4CL, y4CL, 'k-')
set(gca, 'ydir', 'reverse')
xlabel('Time (ms)')
ylabel('Voltage  (uV)')
title('Exeter: Control heel lance')
ylim([-20 40])
xlim([-500 1000])
subplot(1,2,2)
plot(x3HL, y3HL, '-r', x4HL, y4HL, 'k-')
set(gca, 'ydir', 'reverse')
xlabel('Time (ms)')
ylabel('Voltage  (uV)')
title('Exeter: Heel lance')
ylim([-20 50])
xlim([-500 1000])
