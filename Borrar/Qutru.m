function [D,Da,F] = Qutru(x, TT, Tole)
% hyperimg=x;
   x=x./max(x(:));
   [M N L]=size(x);
%        Tole=5e-2; DATOS OpT OpR
%        Tole=6e-3; 
%        Tolei=5e-3;
%        HH=1;
    % aux=gpuArray(zeros(M,M));
% while HH==1
    aux=zeros(M,M);
    ab=zeros(M,N,length(TT));
    D=sparse([]);
    Da=sparse([]);
    Ava=zeros(M,N);
    for tt=1:length(TT)
        T=TT(tt);
        for i=1:T:N
            for j=1:T:M
             Dm=zeros(M,N);
             a=i:i+T-1;
             b=j:j+T-1;
                if Ava(a,b)==0 
                              f=x(a,b,:);
                              f=reshape(f,T*T,L);
                              Tar=mean(f,1);
                              TarC=zeros(T,T,L);
                                  for k1=1:T
                                      for k2=1:T
                                          TarC(k1,k2,:)=Tar(:);
                                      end
                                  end          
                        Msca=mse_c(x(a,b,:),TarC);
%                         imagesc(Msca)
%                         caxis([0 1e-4])
%                         colorbar
%                         pause(0.05)
                        if max(Msca(:))<(Tole*max(Tar(:)))
                            Dm(a,b)=1;
                            D=sparse([D;Dm(:)']);
                            Da=sparse([Da;(1/(T*T))*Dm(:)']);
                            Ava(a,b)=1;
                        end
                        Sa(a,b)=max(Msca(:))<(Tole*max(abs(Tar(:))));
                end
            end
        end
            ab(:,:,tt)=Sa;
    end
%             ass=sparse(M,M);
%             for ii=1:M*M
%                 ass(ii,ii)=1;
%             end
%             aux=~Ava;
%             aux=aux(:);
%             D1=sparse(ass(find(aux),:));
%             D=[D;D1];
%             Da=[Da;D1];
%         [F,C]=size(D);
%         aa=ceil(log2(sqrt(F)));
%         D=[D;sparse(2^(2*aa)-F,C)];
%         Da=[Da;sparse(2^(2*aa)-F,C)];
%             if((sqrt(F/L))==2 || (sqrt(F/L))==4 || (sqrt(F/L))==8 || sqrt(F/L)==16 || sqrt(F/L)==32 || sqrt(F/L)==64)
%                 HH=0;
%             else
%                 Tole=Tole-Tolei/20
%             end
% end
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
    
%     figure(1)
%     maskRec=zeros(M,M);
%     for ttt=length(TT):-1:1
% % %         subplot(length(TT),2,2*ttt-1)
% % %         imagesc(ab(:,:,ttt))
% % %         title(['Adquirida RGB Decim ',num2str(TT(ttt))])
%         maskRec=(maskRec.*(~ab(:,:,ttt))+log2(TT(ttt))*ab(:,:,ttt));
%     end
% %     figure;
% % %     abr=[];
%     for ttt=1:length(TT)
%         abr(:,:,ttt)=(maskRec==(log2(TT(ttt))));
% % %         subplot(length(TT),2,2*ttt)
% % %         imagesc(abr(:,:,ttt))
% % %         title(['Adquirida SPC hadamard preview D2 Decim ',num2str(TT(ttt))])
%     end
%     figure
%     contourf(imrotate(maskRec',90))
%     axis square
%     title(['Mascara datos reconstruidos RGB'])
%     colorbar
%     a=0;
%     for yy=1:length(TT)
%         aux=abr(:,:,yy)./log2(TT(ttt));
%         a=a+sum(aux(:));
%     end
end