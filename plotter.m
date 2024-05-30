%%
close all;
%%
fig=figure();
width=800;
height=700;
subplot(2,2,1);
x=data(:,1);
y=data(:,2);
hold on;
scatter(x,y);
p = polyfit(x, y, 1);
px = [min(x) max(x)];
py = polyval(p, px);

plot(px, py);
grid on;
grid minor;
linkdata on;
xlabel("Szabad cellák száma");
ylabel("Megtett lépések száma");
legend("show", 'Adatpontok','Lineáris trendvonal');
hold off
%%
subplot(2,2,2);
x=data(:,1);
y=data(:,3);
y2=data(:,4);
hold on;
yyaxis left;
scatter(x,y,XDataSource = 'data(:,1)',YDataSource = 'data(:,3)');
p1 = polyfit(x, y, 1);
px1 = [min(x) max(x)];
py1 = polyval(p1, px1);
ylabel("Fordulások száma");


plot(px1, py1);
yyaxis right;
scatter(x,y2, 'd');

grid on;
grid minor;
linkdata on;
xlabel("Szabad cellák száma");
legend("show", '90°', 'Lineáris trendvonal', '180°');
hold off;

%%
subplot(2,2,4);
hold on;
histogram(data(:,end));
mu = mean(data(:,end));
sigma = std(data(:, end));
xline(mu, 'Color', 'm');
xline(mu - 2*sigma, 'Color', 'r', 'LineStyle', '-.');
xline(mu + 2*sigma, 'Color', 'r', 'LineStyle', '-.');
xline(mu - sigma, 'Color', 'r', 'LineStyle', '--');
xline(mu + sigma, 'Color', 'r', 'LineStyle', '--');
xlabel("Úthossz a bejárt cellákkal arányosan");
sMean2= sprintf("μ = %.3f; σ = %.3f", mu, sigma);
title(sMean2);
grid on;
hold off;

%%
subplot(2,2,3);
hold on;
histogram(data(:,2));
mu = mean(data(:,2));
sigma = std(data(:, 2));
xline(mu, 'Color', 'm');
xline(mu - 2*sigma, 'Color', 'r', 'LineStyle', '-.');
xline(mu + 2*sigma, 'Color', 'r', 'LineStyle', '-.');
xline(mu - sigma, 'Color', 'r', 'LineStyle', '--');
xline(mu + sigma, 'Color', 'r', 'LineStyle', '--');
xlabel("Megtett lépések száma");
sMean2= sprintf("μ = %.3f; σ = %.3f", mu, sigma);
title(sMean2);
grid on;
hold off;

%%
set(gcf,'position',[0,0,width,height]);

printfig = fig
printfig.Units = 'centimeters';        % set figure units to cm
printfig.PaperUnits = 'centimeters';   % set pdf printing paper units to cm
printfig.PaperSize = printfig.Position(3:4);  % assign to the pdf printing paper the size of the figure
print -dpdf fig1;           % print the figure