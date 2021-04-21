function A = biemat_2d(prm)
% biemat_2d: 
%
% D = biemat_2d(prm)
%
% [Input]
% prm: Input parameters 
%
% [Output]
% A: structure containing results
%
% 2021/04/21

%% Set initial condition
NS = round(prm.L/prm.ds);
NT = round(prm.T/prm.dt);

x = (0:NS) * prm.ds - prm.L/2; % shift x so that mid point is zero
t = (0:NT) * prm.dt;

% define initial distribution of friction F^{i, 0}
F0 = ones(NS+1, 1) *  prm.tau0;

% find mid point as nucleation
nuc_index = (- prm.Lc/2 <= x) & (x <= prm.Lc/2);
F0(nuc_index) = prm.tau_nuc;
plot(x, F0);

% Compute CFL condition
prm.ht = prm.cs*prm.dt/prm.ds;
prm.CFL = prm.et * prm.ht;
fprintf("[ht, et] = [%4.2f, %4.2f]\nCFL number %4.2f should be < 1/2.\n", prm.ht, prm.et, prm.CFL);

prm.D0 = 4*2*prm.Tu*prm.ds/prm.mu;
fprintf("Dc  %4.2f should be >  %4.2f\n", prm.Dc, prm.D0);

%% Compute kernel matrix
K = K3(prm.ds, prm.dt, prm.et, NS, NT, prm.cs);

%% compute slip-rate matrix
[D, U, T] = D3(K, prm.dt, NS, NT, prm.mu, prm.cs, F0,...
            prm.tau0, prm.Tu, prm.sn, prm.fs, prm.fd, prm.Dc);

%% Store results
A.x = x;
A.t = t;
A.F0 = F0;
A.K = K;
A.D = D;
A.U = U;
A.T = T;

end