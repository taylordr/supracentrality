%% plot_limiting_behavior(w_centrality_datafile,uncoupled_centrality_datafile,TA_centrality_and_FOM_scores_datafile)
%
% Compare observed centralities to their predicted asymptotic limits
%
% copywright - Dane Taylor, 2 January 2019



function [weak_limit_datafile,strong_limit_datafile] = plot_limiting_behavior(GC_network_data_filename,w_centrality_datafile)

%Analyze weak-coupling limit 
   weak_limit_datafile = compute_uncoupled_centrality(GC_network_data_filename,w_centrality_datafile);
   load(weak_limit_datafile);

   load(w_centrality_datafile)
   joint_weak = multilayer_centrality.joint_centrality{1};
   %clear multilayer_centrality;
   
   %Analyze strong-coupling limit
   strong_limit_datafile = compute_TA_centrality_and_FOM_scores(GC_network_data_filename,w_centrality_datafile);
   load(strong_limit_datafile);

   %normalize centralities to sum to one
   conditionals_strong = multilayer_centrality.conditional_node_centrality{end};
   conditionals_strong = conditionals_strong / mean(sum(conditionals_strong));
   
   
   figure;
   subplot(1,2,1)
   loglog(uncoupled_centrality(:)/sum(sum(uncoupled_centrality)),joint_weak(:)/sum(sum(joint_weak)),'x '); hold on;
   add_diag_line(uncoupled_centrality(:)/sum(sum(uncoupled_centrality)),joint_weak(:)/sum(sum(joint_weak)))
   ylabel('actual','interpreter','latex')
   xlabel('asymptotic','interpreter','latex')
   title('Uncoupled Limit')
              
   subplot(1,2,2)
   loglog(TA_centrality/sum(TA_centrality),mean(conditionals_strong')','r+ '); hold;
   add_diag_line(TA_centrality/sum(TA_centrality),mean(conditionals_strong')')
   ylabel('actual','interpreter','latex')   
   xlabel('asymptotic','interpreter','latex')
   title('Aggregated Limit')

   
end




function add_diag_line(x,y)
   mmin = min([x,y]);
   mmax = max([x,y]);
   plot([.8*mmin,2*mmax],[.8*mmin,2*mmax],':k')
end


