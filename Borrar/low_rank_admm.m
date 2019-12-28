function X = low_rank_admm(X_ini,DmUwt, Yh, lmb, dim, parm)

if ~isfield(parm,  'tol'), TOL  = 1e-6;
else, TOL    = parm.tol;  end
if ~isfield(parm, 'prnt'), PRNT = 1;    
else, PRNT   = parm.prnt; end
if ~isfield(parm, 'mitr'), MITR = 200;  
else, MITR   = parm.mitr; end
if ~isfield(parm,  'rho'), rho  = 0.5;  
else, rho    = parm.rho;  end

% save a matrix-vector multiply
Nx           = dim(1);
Ny           = dim(2);

% cache the factorization
DmUwttYh     = DmUwt'*Yh;
DmUwttDmUwt  = DmUwt'*DmUwt + (rho + lmb)*speye(Nx);

% initialization
X            = X_ini; %zeros(Nx, Ny);
Z            = zeros(Nx, Ny);
G            = zeros(Nx, Ny);

rho_chng   = 1; 
for t = 1:MITR
    Z_old    = Z;

    % x-update
    Temp    = DmUwttYh + rho*(Z - G);
    X       = DmUwttDmUwt\Temp;

    % z-update ;
    [Uxg, Sxg, Vxg] = svd(X + G, 'econ');
    Sxg     = diag(soft(diag(Sxg), lmb/rho));
    Z       = Uxg*Sxg*Vxg';

    % u-update
    G       = G + (X - Z);
    
    if mod(t, 10) == 1
           
        s_norm   = norm(X - Z, 'fro');
        r_norm   = norm(-rho*(Z - Z_old), 'fro');
               
        if s_norm > 10*r_norm
            rho  = rho*2;
            G    = G/2;
            rho_chng = 1;  
        elseif r_norm > 10*s_norm
            rho  = rho/2;
            G    = G*2;
            rho_chng = 1;  
        end  
        
        if rho_chng   
            DmUwttDmUwt  = DmUwt'*DmUwt + (rho + lmb)*speye(Nx);
            rho_chng   = 0; 
        end    
        
        if PRNT
            fprintf('itr = %f, res = %f, dual = %f, rho = %f\n', t, r_norm, s_norm, rho); 
        end
        
        if (s_norm < TOL) && (r_norm < TOL) 
            break;
        end   
    end
end
end