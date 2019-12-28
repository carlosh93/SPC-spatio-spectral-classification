function [] =save_pdf(gca,gcf,save_name,database_name)

save_path=['Results/Figures/Visual/',database_name,'/'];

ax = gca; 
outerpos = ax.OuterPosition; 
ti = ax.TightInset;  
left = outerpos(1) + ti(1); 
bottom = outerpos(2) + ti(2); 
ax_width = outerpos(3) - ti(1) - ti(3); 
ax_height = outerpos(4) - ti(2) - ti(4); 
% ax.Position = [left bottom ax_width ax_height];
ax.Position = [0 0 ax_width+left+0.02 ax_height];

fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition; 
fig.PaperSize = [fig_pos(3) fig_pos(4)];

set(fig,'Units','inches')
screenposition = get(fig,'Position');
set(fig,'PaperSize',screenposition(3:4));
print(fig,[save_path,save_name],'-dpdf');

close all
end


%     set(gcf,'Units','inches');
%     screenposition = get(gcf,'Position');
%     set(gcf,...
%         'PaperPosition',[0 0 1 1],...
%         'PaperSize',[screenposition(3:4)]);
%     print -dpdf -painters epsFig