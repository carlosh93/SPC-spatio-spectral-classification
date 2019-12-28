function Y=HmrDirect(x,Hmr,DRGB,M,N,L)
Y=Hmr*x(1:M*N);
for k=2:L
    Y=[Y;Hmr*x(1+M*N*(k-1):M*N*k)];
end
if ~isempty(DRGB)
    Y=[Y;DRGB*x(:)];
end

end