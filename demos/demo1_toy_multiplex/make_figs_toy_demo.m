%% function [] = make_figs_toy_demo(w_centrality_datafile,network_data_filename)
%
% Makes figures for the toy1 demo.
%
% inputs:  w_centrality_datafile: file containing variable multilayer_centrality
%          network_data_filename: file containing variable net in which net.A{t} is the ajdacency matrix of layer t
%
% Copyright Dane Taylor 13 December 2017

function [] = make_figs_toy_demo(w_centrality_datafile,network_data_filename)
   %load(w_centrality_datafile)

   sweep_coupling_fig1(w_centrality_datafile,network_data_filename)
   
   %view_differential(w_centrality_datafile,network_data_filename)

   %ee = [16];
   %view_layers_centralities(ee,w_centrality_datafile,network_data_filename)  

   plot_conditional_centralities([1,16,31],w_centrality_datafile,network_data_filename)
   
   
end

%% sweep_coupling_fig1
function [] = sweep_coupling_fig1(w_centrality_datafile,network_data_filename)

   load(w_centrality_datafile)
   N = size(multilayer_centrality.joint_centrality{1},1);
   T = size(multilayer_centrality.joint_centrality{1},2);

   positions{1} = [0.154639175257732 0.655612244897959 0.781433884102998 0.26478576505229];
   positions{2} = [0.154639175257732 0.389390870852157 0.781433884102999 0.265648854961832];
   positions{3} = [0.154639175257732 0.127551020408163 0.781433884102999 0.262755102040817];

   %marker_data = {symbol,DisplayName,Color}
   marker_data = {{'x', '+',  'square',   'o',  '<',  '>'},...
                 {'1',  '2',  '3',        '4',  '5',  '6'},...
                 {[0,0,0],[0 .2 1],[.1 1 0],[1 0 0],[0 .5 .5],[.5 .5 0]}};

   
   figure1 = figure('Color',[1 1 1]);
   axes1{1} = axes('Parent',figure1,'XScale','log','XMinorTick','on','Position',positions{1},'FontSize',14);box(axes1{1},'on');hold(axes1{1},'all');
   ylabel('MNC','Interpreter','latex','FontSize',14);
   xlabel('weight, $\omega$','Interpreter','latex','FontSize',14);
   title(['Ranking Dependence on $\omega$, ',multilayer_centrality.coupling_scheme],'Interpreter','latex','FontSize',14);
   semilogx1 = semilogx(multilayer_centrality.omegas,multilayer_centrality.marginal_node_centrality','Parent',axes1{1},'LineWidth',1);
   for n=1:N
      set(semilogx1(n),'Marker',marker_data{1}{n},...
         'DisplayName',marker_data{2}{n},...
         'Color',marker_data{3}{n});
   end

   axes1{2} = axes('Parent',figure1,'XScale','log','XMinorTick','on','Position',positions{2},'FontSize',14);box(axes1{2},'on');hold(axes1{2},'all');
   ylabel('MLC','Interpreter','latex','FontSize',14);
   xlabel('weight, $\omega$','Interpreter','latex','FontSize',14);
   semilogx2 = semilogx(multilayer_centrality.omegas,multilayer_centrality.marginal_layer_centrality,'Parent',axes1{2},'LineWidth',1);
   for n=1:T
      set(semilogx2(n),'Marker',marker_data{1}{n},...
         'DisplayName',marker_data{2}{n},...
         'Color',marker_data{3}{n});
   end
      
   legend1{1} = legend(axes1{1},'show');
   set(legend1{1},'Orientation','horizontal','Location','South','FontSize',12);
   legend1{2} = legend(axes1{2},'show');
   set(legend1{2},'Orientation','horizontal','Location','South','FontSize',12);

   
   for e = 1:(length(multilayer_centrality.omegas)-1)     
      diff_joint(e) = norm(multilayer_centrality.joint_centrality{e}(:)-...
         multilayer_centrality.joint_centrality{e+1}(:));
      diff_conditional(e) = norm(multilayer_centrality.conditional_node_centrality{e}(:)-...
         multilayer_centrality.conditional_node_centrality{e+1}(:));
   end
   
   axes1{3} = axes('Parent',figure1,'XScale','log','XMinorTick','on','Position',positions{3},'FontSize',14);box(axes1{3},'on');hold(axes1{3},'all');
   semilogx(multilayer_centrality.omegas(2:end),diff_joint,'--','Parent',axes1{3},...
      'Displayname','joint','LineWidth',1);
   hold on;
   semilogx(multilayer_centrality.omegas(2:end),diff_conditional,'Parent',axes1{3},...
      'Displayname','conditional','LineWidth',1)
   %ylabel('$||\bf{W}(\omega_s) - \bf{W}(\omega_{s+1})||_F$','Interpreter','latex','FontSize',14);
   ylabel('change','Interpreter','latex','FontSize',14);
   xlabel('coupling, $\omega$','Interpreter','latex','FontSize',14); 
   
   legend1{3} = legend(axes1{3},'show');
   set(legend1{3},'Orientation','vertical','FontSize',12);

   
end

% %% view_layers_centralities
% function [] = view_layers_centralities(ee,w_centrality_datafile,network_data_filename)
% 
%    load(w_centrality_datafile)
%    N = size(multilayer_centrality.joint_centrality{1},1);
%    T = size(multilayer_centrality.joint_centrality{1},2);  
% 
%    for e = ee
%       figure2 = figure('Color',[1 1 1]);
%       axes3 = axes('Parent',figure2,'XTickLabel',{'','','','',''},...
%          'Position',[0.154639175257732 0.525735294117647 0.781433884102998 0.382352941176471],...
%          'FontSize',14);
%       box(axes3,'on');
%       hold(axes3,'all');
%       ylabel('joint','Interpreter','latex','FontSize',14);
%       xlabel('$\omega$','Interpreter','latex','FontSize',14); 
%       title(['Centrality Trajectories, ','$\omega=',num2str(multilayer_centrality.omegas(e)),'$'],'Interpreter','latex',...
%          'FontSize',14);
% 
%       plot1 = plot(1:T,multilayer_centrality.joint_centrality{e}','x-');
%       set(plot1(1),'Marker','x','DisplayName','1','Color',[0 0 0]);
%       set(plot1(2),'Marker','+','Color',[0 0 1],'DisplayName','2');
%       set(plot1(3),'Marker','square','DisplayName','3');
%       set(plot1(4),'Marker','o','DisplayName','4');
% 
%       axes4 = axes('Parent',figure2,...
%          'Position',[0.154639175257732 0.151318645539397 0.781433884102999 0.374416648578251],...
%          'FontSize',14);
%       box(axes4,'on');
%       hold(axes4,'all');
%       ylabel('conditional','Interpreter','latex','FontSize',14);
%       xlabel('layer, $t$','Interpreter','latex','FontSize',14);
%       plot2 = plot(1:T,multilayer_centrality.conditional_node_centrality{e}');
%       set(plot2(1),'Marker','x','DisplayName','1','Color',[0 0 0]);
%       set(plot2(2),'Marker','+','Color',[0 0 1],'DisplayName','2');
%       set(plot2(3),'Marker','square','DisplayName','3');
%       set(plot2(4),'Marker','o','DisplayName','4');
% 
% 
%       %legends
%       legend3 = legend(axes3,'show');
%       set(legend3,'Orientation','horizontal','Location','South','FontSize',12);
%       legend4 = legend(axes4,'show');
%       set(legend4,'Orientation','horizontal','Location','South','FontSize',12);
%    end
% 
%    
% end



% 
% %% view_layer_comparison
% function [] = view_layer_comparison(e,w_centrality_datafile,network_data_filename)
% 
%    load(w_centrality_datafile)
%    N = size(multilayer_centrality.joint_centrality{1},1);
%    T = size(multilayer_centrality.joint_centrality{1},2);
% 
%    C = multilayer_centrality.conditional_node_centrality{e};
%    for ee = 1:T
%       for eee = 1:T
%          difference(ee,eee) = norm(C(:,ee) - C(:,eee));
%       end
%    end
%    f5 = figure;
%    imagesc(difference)
%    title(['Gradient across layers, ','$\omega=',num2str(multilayer_centrality.omegas(e)),'$'],'Interpreter','latex','FontSize',14);
%    colorbar
% end



%% plot_conditional_centralities
function [] = plot_conditional_centralities(ee,w_centrality_datafile,network_data_filename)

   load(w_centrality_datafile)
   N = size(multilayer_centrality.joint_centrality{1},1);
   T = size(multilayer_centrality.joint_centrality{1},2);  

   positions{1} = [0.154639175257732 0.655612244897959 0.781433884102998 0.26478576505229];
   positions{2} = [0.154639175257732 0.389390870852157 0.781433884102999 0.265648854961832];
   positions{3} = [0.154639175257732 0.127551020408163 0.781433884102999 0.262755102040817];
   
   %marker_data = {symbol,DisplayName,Color}
   marker_data = {{'x', '+',  'square',   'o'},...
                 {'1',  '2',  '3',        '4'},...
                 {[0,0,0],[0 .2 1],[.1 1 0],[1 0 0]}};
   
   figure2 = figure('Color',[1 1 1]);
   
   for e_index = 1:length(ee)

      axes1{e_index} = axes('Parent',figure2,'Position',positions{e_index},'FontSize',14);
   %   axes3 = axes('Parent',figure2,'XTickLabel',{'','','','',''},'Position',positions{e_index},'FontSize',14);
      box(axes1{e_index},'on'); hold(axes1{e_index},'all');
      ylabel(['$\omega=',num2str(multilayer_centrality.omegas(ee(e_index))),'$'],'Interpreter','latex','FontSize',14);
      %xlabel('layer,$t$','Interpreter','latex','FontSize',14); 
      %title(['Centrality Trajectories, ','$\omega=',num2str(multilayer_centrality.omegas(ee(e_index))),'$'],'Interpreter','latex','FontSize',14);

      plot1 = plot(1:T,multilayer_centrality.conditional_node_centrality{ee(e_index)}','k-');
      for n=1:N
         set(plot1(n),'Marker',marker_data{1}{n},...
            'DisplayName',marker_data{2}{n},...
            'Color',marker_data{3}{n});
      end
%       set(plot1(2),'Marker','+','Color',[0 0 1],'DisplayName','2');
%       set(plot1(3),'Marker','square','DisplayName','3');
%       set(plot1(4),'Marker','o','DisplayName','4');
   end
   xlabel('layer, $t$','Interpreter','latex','FontSize',14);
   legend1 = legend(axes1{1},'show');  
   %set(legend1,'Orientation','vertical','Location','NorthEast','FontSize',12);

end


