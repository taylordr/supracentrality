
%% Demo 3 - Analyze a time-respectiving analysis of a Temporal Network PhD Exchange
%
%  
% Copyright - Dane Taylor 2 January 2019
   
   clear;clc; 
   code_path  = genpath('../../supracentrality');addpath(code_path);
   code_path2  = genpath('../../utility');addpath(code_path2);

%% Load Network Data

   copyfile('PhD Exchange Network Data/PhD_exchange_network.mat','PhD_exchange.mat')
   network_data_filename = 'PhD_exchange.mat';
   GC_network_data_filename = reduce_to_GC(network_data_filename);%build adjacnccy matrices   

   
%% Choose the centrality matrix as eigenvector, pagerank, hub, authority   
   multilayer_centrality.centrality_type = 'authority_scores';
   multilayer_centrality.omegas = 10.^[0:.5:4];         
    
%% Define interlayer coupling as a directed chain with teleportation
   multilayer_centrality.coupling_scheme = 'directedChain_tele';
   multilayer_centrality.layer_tele = 10^-2;% interlayer teleportation rate
   
%% Compute supracentrality
   w_centrality_datafile = compute_w_centrality(GC_network_data_filename,multilayer_centrality);
   

%% Reproduce Table SM3 in the Supporting Material
   top10_MNC_datafile = identify_top_MNC(GC_network_data_filename,w_centrality_datafile);   


%% Reproduce results in Figure SM3 in the Supporting Material
   plot_marginals_vs_w(GC_network_data_filename,w_centrality_datafile);
   dominant_layer = 37;
   plot_supracentralities_vs_degrees(GC_network_data_filename,w_centrality_datafile,dominant_layer);




%% Explore three choices for the layer teleportation  

   TELES = [10^-2,10^-3,10^-4];
   for i = 1:length(TELES)
      multilayer_centrality.layer_tele = TELES(i);% interlayer teleportation rate
      data_file{i} = compute_w_centrality(GC_network_data_filename,multilayer_centrality);
      TA_file{i} = compute_TA_centrality_and_FOM_scores(GC_network_data_filename,data_file{i});
      top10_MNC_data{i} = identify_top_MNC(GC_network_data_filename,data_file{i});
   end


%% Make Figure 6a 
    
   load(GC_network_data_filename);   
   for t = 1:net.T      
      intralayer_edge_count(t) = sum(sum(net.A{t})); %number of edges in each layer
   end
   times = net.time_stamps;%load timestamps
   clear net; 
   
   f1 = figure;
   line_style = {'-','--','-.'};
   for i = 1:length(TELES)
      subplot(4,1,1)
      load(data_file{i});
      plot(times,multilayer_centrality.marginal_layer_centrality(3,:)/sum(multilayer_centrality.marginal_layer_centrality(3,:)),line_style{i},'linewidth',2);hold on;

      subplot(4,1,2) 
      load(data_file{i});
      plot(times,multilayer_centrality.marginal_layer_centrality(5,:)/sum(multilayer_centrality.marginal_layer_centrality(5,:)),line_style{i},'linewidth',2);hold on;

      subplot(4,1,3)
      load(data_file{i});
      plot(times,multilayer_centrality.marginal_layer_centrality(7,:)/sum(multilayer_centrality.marginal_layer_centrality(7,:)),line_style{i},'linewidth',2);hold on;
   end
   subplot(4,1,4)
   load(data_file{i});
   bar(times,intralayer_edge_count);
   ylabel('$\overline{d}_t$','interpreter','latex')
   xlabel('time','interpreter','latex')
   
   subplot(4,1,1)
   title('$\omega=10^1$','interpreter','latex')
   ylabel('MLC, $x_t$','interpreter','latex')
   legend({'\gamma=10^{-2}','\gamma=10^{-3}','\gamma=10^{-4}'});
   subplot(4,1,2)
   title('$\omega=10^3$','interpreter','latex')
   ylabel('MLC, $x_t$','interpreter','latex')
   subplot(4,1,3)
   title('$\omega=10^3$','interpreter','latex')
   ylabel('MLC, $x_t$','interpreter','latex')

   for i = 1:length(TELES)
      load(data_file{i});
      [v_tilde,eevalls] = eigs(full(multilayer_centrality.layer_adjacency_matrix),1);
      asymtotics_MLC = abs(v_tilde)/sum(abs(v_tilde));
      plot(times,asymtotics_MLC,':k','linewidth',2)
   end




%% Reproduce figure 6b
 
   load(GC_network_data_filename);   
   for t = 1:net.T; GT_degrees(t) = sum(net.A{t}(:,37));end
   clear net; 
   

   f2 = figure;
   line_style = {'-','--','-.'};
   for i = 1:length(TELES)
      subplot(4,1,1)
      load(data_file{i});
      plot(times,multilayer_centrality.conditional_node_rank{3}(37,:),line_style{i},'linewidth',2);hold on;

      subplot(4,1,2) 
      load(data_file{i});
      plot(times,multilayer_centrality.conditional_node_rank{5}(37,:),line_style{i},'linewidth',2);hold on;

      subplot(4,1,3)
      load(data_file{i});
      plot(times,multilayer_centrality.conditional_node_rank{7}(37,:),line_style{i},'linewidth',2);hold on;   
   end
   subplot(4,1,4)
   load(data_file{i});
   bar(times,GT_degrees);
   ylabel('$d^{(t)}_i$','interpreter','latex')
   xlabel('time','interpreter','latex')

   subplot(4,1,1)
   title('$\omega=10^1$','interpreter','latex')
   ylabel('rank, $r_i^{(t)}$','interpreter','latex')
   legend({'\gamma=10^{-2}','\gamma=10^{-3}','\gamma=10^{-4}'});
   subplot(4,1,2)
   title('$\omega=10^3$','interpreter','latex')
   ylabel('rank, $r_i^{(t)}$','interpreter','latex')
   subplot(4,1,3)
   title('$\omega=10^3$','interpreter','latex')
   ylabel('rank, $r_i^{(t)}$','interpreter','latex')
   






 

   