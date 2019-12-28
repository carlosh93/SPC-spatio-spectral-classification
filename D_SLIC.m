function [D,Da,F] = D_SLIC(IM,M,N,L,MB)
    Ir=resize3D(IM,3/L);
    [~, Am, ~ , ~] = slic_original(Ir, MB, 10, 0, 'median');
    NBR=max(Am(:));
    D=zeros(NBR,M*N);
    Da=zeros(NBR,M*N);
    for iN=1:NBR
        aux=Am==iN;
        aux=aux(:);
        D(iN,:)=aux; %intentando normalizar la suma 
        Da(iN,:)=aux./sum(aux); %intentando normalizar la suma para invertir 
    end
    [F,C]=size(D);
    A1=mod(log2(F),1);
    A2=mod(log2(F/12),1);
    A3=mod(log2(F/20),1);
    Ec=max([A1,A2,A3]); %porque tengo que ir al de mas arriba entonces buscar el que este mas cerca
    if Ec==A1
        CE=2^ceil(log2(F))-F;
    elseif Ec==A2
        CE=12*2^ceil(log2(F/12))-F;
    else
        CE=20*2^ceil(log2(F/20))-F;
    end
%     aa=ceil(log2(sqrt(F)));
    D=[D;zeros(CE,C)];
    Da=[Da;zeros(CE,C)];
    [F,C]=size(D);
end