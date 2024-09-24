function B = standardlogit(Y,X,NT,J)

% Estiamte coefficients for standard logit
%
% Model inputs -
%  Y - 'JxTxN' by '1' vector of choice indicators
%  X - 'JxTxN' by 'number of characterstics'
%  mfo - a structure of model information and must include 'N' the number
%  of individuals, 'T' the number of choice situations, and 'J' the number
%  of choices per choice situation
%
% Model outputs - 
%  B - vector of utility parameters

%% likelihood function
function [ll,g] = calclike(parms)
        
    v = reshape(X*parms,[J NT]);
    
    pr = bsxfun(@rdivide,exp(v),sum(exp(v),1));
    ll = -Y'*log(pr(:));
    g = -X'*(Y - pr(:));   

end

%% estimate
o1 = optimset('Display','off','MaxIter',1e6,'MaxFunEvals',1e10,'GradObj','on','DerivativeCheck','off');
B = fminunc(@calclike,zeros(size(X,2),1),o1);

end




