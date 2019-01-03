function top10_MNC_datafile = identify_top_MNC(GC_network_data_filename,w_centrality_datafile)


   load(GC_network_data_filename,'net');
   node_labels = net.node_labels;
   clear net;
   
   load(w_centrality_datafile)
   
   top10_MNC_datafile = [w_centrality_datafile(1:(end-4)),'_top10_MNC.txt'];
   OMEGAS = [1,ceil(length(multilayer_centrality.omegas)/2),length(multilayer_centrality.omegas)];   
   fID = fopen(top10_MNC_datafile,'w');
   
   for t=OMEGAS
      fprintf(fID,'Top10 MNC for omega = %f\n\n',multilayer_centrality.omegas(t));      
      [sorted_MNC,top_ranking_MNC] = sort(multilayer_centrality.marginal_node_centrality(:,t),'descend');            
      for R = 1:10
         airport_name = node_labels{top_ranking_MNC(R),1};
         fprintf(fID,'%i %s %f\n',top_ranking_MNC(R),airport_name,sorted_MNC(R) );
      end
      fprintf(fID,'\n\n\n\n');
   
   end
   fclose(fID);
   
   
   
end













