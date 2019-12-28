function  obj = myHyperspectral_shiftKronmulti(G, M, N, L,media,shots,H)
% with sparsity reduction in wavelet basis
obj.adjoint = 0;
obj.G = G;
obj.M = M;
obj.N = N;
obj.L = L;
obj.media=media;
obj.shots=shots;
obj.H = H;
obj = class(obj, 'myHyperspectral_shiftKronmulti');

