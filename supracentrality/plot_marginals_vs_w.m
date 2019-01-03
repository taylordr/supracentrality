function [] = plot_marginals_vs_w(GC_network_data_filename,w_centrality_datafile)

   load(w_centrality_datafile)

   figure;
   subplot(1,2,1);
   loglog(multilayer_centrality.omegas,multilayer_centrality.marginal_layer_centrality);
   title('Marginal Layer Centralities','interpreter','latex')
   xlabel('coupling strength, $\omega$','interpreter','latex')
   ylabel('MLC','interpreter','latex')
   
   
   subplot(1,2,2);
   loglog(multilayer_centrality.omegas,multilayer_centrality.marginal_node_centrality');
   title('Marginal Node Centralities','interpreter','latex')
   xlabel('coupling strength, $\omega$','interpreter','latex')
   ylabel('MNC','interpreter','latex')
   
   
   
end













