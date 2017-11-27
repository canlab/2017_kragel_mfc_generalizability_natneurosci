%% parameterization 1 (reported in main text)
close all;
load(which('bsModCompWithinROI.mat'))

figure; 

subplot(1,3,1)
distributionPlot(b(:,1:6,29),'color',{[0 118 14]/255; [205 62 78]/255; [196 58 250]/255; [230 148 34]/255;  [70 130 180]/255; [120 18 134]/255},'showMM',5)
set(gca,'YLim',[-.5 2])
xlabel 'Pain'
set(gca,'XTick',[])
set(gca,'Linewidth',2)
ylabel 'Generalization Index' 
h=findobj(gca,'type','line');
set(h,'color','k','linewidth',2)

subplot(1,3,2)
distributionPlot(b(:,1:6,30),'color',{[0 118 14]/255; [205 62 78]/255; [196 58 250]/255; [230 148 34]/255;  [70 130 180]/255; [120 18 134]/255},'showMM',5)
set(gca,'YLim',[-.5 2])
xlabel 'Cognitive Control'
set(gca,'XTick',[])
set(gca,'Linewidth',2)
h=findobj(gca,'type','line');
set(h,'color','k','linewidth',2)

subplot(1,3,3)
distributionPlot(b(:,1:6,31),'color',{[0 118 14]/255; [205 62 78]/255; [196 58 250]/255; [230 148 34]/255;  [70 130 180]/255; [120 18 134]/255},'showMM',5)
set(gca,'YLim',[-.5 2])
set(gca,'XTick',[])
set(gca,'Linewidth',2)
xlabel 'Negative Emotion'
h=findobj(gca,'type','line');
set(h,'color','k','linewidth',2)

saveas(gcf, [basedir 'Results' filesep 'SFig3a'], 'png')

%%  parameterization 2 (reported in supplement)

load(which('bsModCompWithinROIParam2.mat'))
b=-1*b;

figure; 
subplot(1,3,1)
distributionPlot(b(:,1:6,29),'color',{[0 118 14]/255; [205 62 78]/255; [196 58 250]/255; [230 148 34]/255;  [70 130 180]/255; [120 18 134]/255},'showMM',5)
set(gca,'YLim',[-.05 .25])
xlabel 'Pain'
set(gca,'XTick',[])
set(gca,'Linewidth',2)
ylabel 'Generalization Index' 
h=findobj(gca,'type','line');
set(h,'color','k','linewidth',2)

subplot(1,3,2)
distributionPlot(b(:,1:6,30),'color',{[0 118 14]/255; [205 62 78]/255; [196 58 250]/255; [230 148 34]/255;  [70 130 180]/255; [120 18 134]/255},'showMM',5)
set(gca,'YLim',[-.05 .25])
xlabel 'Cognitive Control'
set(gca,'XTick',[])
set(gca,'Linewidth',2)
h=findobj(gca,'type','line');
set(h,'color','k','linewidth',2)

subplot(1,3,3)
distributionPlot(b(:,1:6,31),'color',{[0 118 14]/255; [205 62 78]/255; [196 58 250]/255; [230 148 34]/255;  [70 130 180]/255; [120 18 134]/255},'showMM',5)
set(gca,'YLim',[-.05 .25])
set(gca,'XTick',[])
set(gca,'Linewidth',2)
xlabel 'Negative Emotion'
h=findobj(gca,'type','line');
set(h,'color','k','linewidth',2)
saveas(gcf, [basedir 'Results' filesep 'SFig3c'], 'png')

%%  parameterization 3 (reported in supplement)

load(which('bsModCompWithinROIParam3.mat'))


figure; 

subplot(1,3,1)
distributionPlot(b(:,1:6,29),'color',{[0 118 14]/255; [205 62 78]/255; [196 58 250]/255; [230 148 34]/255;  [70 130 180]/255; [120 18 134]/255},'showMM',5)
set(gca,'YLim',[-200 800])

xlabel 'Pain'
set(gca,'XTick',[])
set(gca,'Linewidth',2)
ylabel 'Generalization Index' 
h=findobj(gca,'type','line');
set(h,'color','k','linewidth',2)

subplot(1,3,2)
distributionPlot(b(:,1:6,30),'color',{[0 118 14]/255; [205 62 78]/255; [196 58 250]/255; [230 148 34]/255;  [70 130 180]/255; [120 18 134]/255},'showMM',5)
set(gca,'YLim',[-200 800])

xlabel 'Cognitive Control'
set(gca,'XTick',[])
set(gca,'Linewidth',2)
h=findobj(gca,'type','line');
set(h,'color','k','linewidth',2)

subplot(1,3,3)
distributionPlot(b(:,1:6,31),'color',{[0 118 14]/255; [205 62 78]/255; [196 58 250]/255; [230 148 34]/255;  [70 130 180]/255; [120 18 134]/255},'showMM',5)
set(gca,'YLim',[-200 800])

set(gca,'XTick',[])
set(gca,'Linewidth',2)
xlabel 'Negative Emotion'
h=findobj(gca,'type','line');
set(h,'color','k','linewidth',2)

saveas(gcf, [basedir 'Results' filesep 'SFig3b'], 'png')
