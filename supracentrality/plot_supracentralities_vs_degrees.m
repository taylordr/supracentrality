%% function [] = plot_supracentralities_vs_degrees(GC_network_data_filename,w_centrality_datafile)
%
%
%
%
% Copywright - Dane Taylor, 2 January 2019


function [] = plot_supracentralities_vs_degrees(GC_network_data_filename,w_centrality_datafile,dominant_layer_id)



   %% Load centrality data
   load(GC_network_data_filename,'net');
   load(w_centrality_datafile);
   strong_limit_datafile = compute_TA_centrality_and_FOM_scores(GC_network_data_filename,w_centrality_datafile);
   load(strong_limit_datafile)


   %% Study degrees
   intralayer_degrees = zeros(net.N,net.T);
   aggregated_A = zeros(size(net.A{1}));   
   for t=1:net.T
      intralayer_degrees(:,t) = sum(net.A{t},2) + 10^-10;
      aggregated_A = aggregated_A + net.A{t};
   end 

   total_degrees = sum(aggregated_A,2);
   total_degrees2 = sum(aggregated_A*aggregated_A,2);
   total_degree_profile = repmat(total_degrees,1);


    
 

   %dominant_layer_id = 2; #this is Ryanair for the European airline data
   %dominant_layer_id = 37; #this is time layer 1966 fort MGP data
   dominant_layer_degrees = repmat(intralayer_degrees(:,dominant_layer_id),1,1);
   dominant_layer_centrality_degrees = sum(multilayer_centrality.matrix_function(net.A{dominant_layer_id}),2) + 10^-10 ;


   %% Compute correlation coefficients between centralities and degrees
   for w = 1:length(multilayer_centrality.omegas) 
      
      x = multilayer_centrality.conditional_node_centrality{w}(:);          
      temp = corrcoef([x,intralayer_degrees(:)]);
      R_intralayer(w) = temp(1,2); 

      x2 = multilayer_centrality.marginal_node_centrality(:,w);
      temp = corrcoef([x2,total_degree_profile(:)]);
      R_total(w) = temp(1,2);

      temp = corrcoef([x2,dominant_layer_degrees(:)]);
      R_dominant(w) = temp(1,2);
   
      temp = corrcoef([x2,dominant_layer_centrality_degrees]);
      R_centrality(w) = temp(1,2);

      %temp = corrcoef([x,total_degrees_centrality_profile(:)]);
      %R_centrality2(w) = temp(1,2);
   end
   
   
   
   figure
   subplot(1,2,1)
   scatter(TA_centrality/sum(TA_centrality),total_degrees/sum(total_degrees),'x '); hold on
   scatter(TA_centrality/sum(TA_centrality),total_degrees2/sum(total_degrees2))
   %scatter(TA_centrality/sum(TA_centrality),total_degrees_centrality/sum(total_degrees_centrality))
   xlabel('layer-aggregated centrality','interpreter','latex')
   ylabel('layer-aggregated degrees','interpreter','latex')
   legend({'degrees (i.e., 1-paths)','number of 2-paths'})
   title('Strong Coupling and Degrees','interpreter','latex')
   set(gca, 'XScale', 'log')
   set(gca, 'YScale', 'log')
   
   subplot(1,2,2)
   semilogx(multilayer_centrality.omegas,R_intralayer,'-.','linewidth',2);hold on;
   semilogx(multilayer_centrality.omegas,R_total,'--','linewidth',2);
   semilogx(multilayer_centrality.omegas,R_dominant,'linewidth',2);   
   semilogx(multilayer_centrality.omegas,R_centrality,':','linewidth',2);hold on;
   %semilogx(multilayer_centrality.omegas,R_centrality2,'-.','linewidth',2);hold on;
   legend({'intralayer degrees','total degrees','dominant-layer degrees'})      
   title('Correlation with Degrees','interpreter','latex')
   xlabel('coupling strength, $\omega$','interpreter','latex')
   ylabel('correlation coefficient, $r$','interpreter','latex')

    
  
   



end