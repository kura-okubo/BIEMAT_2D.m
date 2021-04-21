function [D, U, T] = D3(K3, dt, NS, NT, mu, cs, F0, tau0, Tu, sn, fs, fd, Dc)

taup = fs*sn;
taud = fd*sn;
W = ((fs-fd)/Dc)*sn;
D = zeros(NS+1, NT+1);
U = zeros(NS+1, NT+1);
T = zeros(NS+1, NT+1);

h = waitbar(0,'1','Name','Compute Slip rate D3');
steps = NT+1;

for n = 1:NT+1
    
    waitbar(n/steps,h,sprintf('Loop t = %4.2f/%4.2f [s]', (n-1)*dt, dt*NT));

    for i = 1:NS+1
        
        % 1. compute D3^{i, n}
        Tfric = linearslipweakening(U(i, n), tau0, taup, taud, W, Dc, F0(i));
        
        S = 0;
        for k = 1:NS+1
            for m = 1:n-1
                ikshift = (i-k)+(NS+1);
                S = S + D(k, m) * K3(ikshift, n, m);
            end
        end
        
        D(i, n) = (2*cs/mu)*Tfric - S;
        T(i, n) = Tfric+tau0;
%         T(i, n) = (mu/(2*cs))*(D(i, n) + S) + tau0; % check equilibrium
        
        % 2. compute U3^{i, n+1}
        if  n <= NT
            %evaluate critical crack criterion
            if D(i, n)<0
                U(i, n+1) = U(i, n);
            elseif  U(i, n) == 0
                if (i ~= 1) && (i ~= NS+1) %Not edge
                    if T(i-1, n) >= Tu || T(i+1, n) >= Tu
                        % crack propagates if traction on next node exceeds
                        % Tu
                        U(i, n+1) = U(i, n) + D(i, n) * dt;
                    else
                        U(i, n+1) = 0;
                    end
                end
            else
                % crack propagates once it starts to be broken
                U(i, n+1) = U(i, n) + D(i, n) * dt;
            end    
            U(i, n+1) = U(i, n) + D(i, n) * dt;

        end
        
    end
end

delete(h)

end

function Tfric = linearslipweakening(U, tau0, taup, taud, W, Dc, F0)

if U == 0
    Tfric = F0 - tau0;
elseif (0<U) && (U<Dc)
    Tfric = (taup - tau0) - W*U;
else
    Tfric = taud - tau0;
end

end