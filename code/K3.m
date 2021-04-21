function K = K3(ds, dt, et, NS, NT, cs)

K = zeros(2*NS-1, NT+1, NT+1);
t = (0:NT) * dt;
I3 = @(s, t) H(s)*H(t) + (1/pi) * sign(s) * H(t - (abs(s)/cs)) * (sqrt((cs*t/s)^2-1) - acos(abs(s)/(cs*t))) ;

h = waitbar(0,'1','Name','Compute Kernel K3',...
             'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');

steps = NS+1;
for i = 1:NS+1
    
    if getappdata(h,'canceling')
        delete(h)
        error("Cancel button was called.");
    end
    % Update waitbar and message
    waitbar(i/steps,h,sprintf('Loop  x  = %4.2f/%4.2f [km]', (i-1)*ds/1e3, ds*NS/1e3));
    
%     for k = 1:NS+1
    for k = 1:NS+1
        for n = 1:NT+1
            for m = 1:n-1
                
                tn = t(n);
                tm = t(m);
                tmshort = tm - et*dt;
                tmlong = tm + (1-et)*dt;
                % shift indice for k
                ikshift = (i-k)+(NS+1);
                K(ikshift, n, m) = I3((i-k+0.5)*ds, tn-tmshort) - ...
                                I3((i-k-0.5)*ds, tn-tmshort) - ...
                                I3((i-k+0.5)*ds, tn-tmlong) + ...
                                I3((i-k-0.5)*ds, tn-tmlong);
            end
        end
    end
end

delete(h)

end

