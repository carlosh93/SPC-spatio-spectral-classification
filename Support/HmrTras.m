function Y=HmrTras(x,HmrT,DRGBT,K,L)
Y=HmrT*x(1:K);
for k=2:L
    Y=[Y;HmrT*x(1+K*(k-1):K*k)];
end
if ~isempty(DRGBT)
    Y=Y+DRGBT*x(L*K+1:end);
end

end