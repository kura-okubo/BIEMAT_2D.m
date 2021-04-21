% Plot result of 2D dynamic rupture
clear all;
set(0,'DefaultTextFontsize',18, ...
    'DefaultTextFontname','Arial', ...
    'DefaultTextFontWeight','normal', ...
    'DefaultTextFontname','Arial', ...
    'DefaultAxesFontsize',18, ...
    'DefaultAxesFontname','Arial', ...
    'DefaultLineLineWidth', 2.0)
if ~exist("./FIGURE", "dir"); mkdir("./FIGURE"); end

%% Load data
load("OUTPUT/data_ex_modeIII.mat");
Tmax = max(A.t);
%% Plot initial stress state
fig = figure(1);
fig.Units = 'point';
fig.Position = [0 500 800 600];
clf(fig,'reset'); cla(fig,'reset'); hold on;

plot(A.x/1e3, A.F0/1e6, 'k');
yline(prm.Tu/1e6, 'r--', 'LineWidth', 2);
yline(prm.sn*prm.fs/1e6, 'm--', 'LineWidth', 2);
yline(prm.sn*prm.fd/1e6, 'b--', 'LineWidth', 2);
yline(prm.tau0/1e6, 'g--', 'LineWidth', 2);

xlim([-16, 16]);
% ylim([60, 84]);
xlabel("x [km]");
ylabel("Initial traction F [MPa]");
legend({"F0", "Tu", "taup", "taud", "tau0"});
box on
figname = sprintf("FIGURE/initstress_%s.png", prm.pname);
saveas(gcf, figname);

%% Plot slip velocity evolution
fig = figure(2);
fig.Units = 'point';
fig.Position = [0 500 800 600];
clf(fig,'reset'); cla(fig,'reset'); hold on;

% s = mesh(A.x/1e3, A.t, A.D');
s = surf(A.x/1e3, A.t, A.D');
s.EdgeColor = 'k';
view([144, 33]);
% 
xlim([-20, 20]);
ylim([0, Tmax]);
xlabel("x [km]");
ylabel("Time [s]");
zlabel("Slip velocity [m/s]");

figname = sprintf("FIGURE/slipvel_%s.png", prm.pname);
saveas(gcf, figname);

%% Plot displacement evolution
fig = figure(3);
fig.Units = 'point';
fig.Position = [0 500 800 600];
clf(fig,'reset'); cla(fig,'reset'); hold on;

% s = mesh(A.x/1e3, A.t, A.U');
s = surf(A.x/1e3, A.t, A.U');
s.EdgeColor = 'k';
view([144, 33]);
% 
xlim([-20, 20]);
ylim([0, Tmax]);
% zlim([0, 1.6]);
xlabel("x [km]");
ylabel("Time [s]");
zlabel("Slip [m]");

figname = sprintf("FIGURE/displacement_%s.png", prm.pname);
saveas(gcf, figname);

%% Plot evolution of traction on the fault 
fig = figure(4);
fig.Units = 'point';
fig.Position = [0 500 800 600];
clf(fig,'reset'); cla(fig,'reset'); hold on;

s = surf(A.x/1e3, A.t, A.T'/1e6);

s.EdgeColor = 'k';
view([144, 33]);
% 
xlim([-20, 20]);
ylim([0, Tmax]);
% zlim([60, 84]);
xlabel("x [km]");
ylabel("Time [s]");
zlabel("Traction [MPa]");

figname = sprintf("FIGURE/traction_%s.png", prm.pname);
saveas(gcf, figname);

%% Plot history of slip velocity

%% Plot history of traction