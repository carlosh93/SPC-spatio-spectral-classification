function e=mse_c(a,b)
    [m,n,l]=size(a);
    e=sum((a-b).^2,3)./l;
end