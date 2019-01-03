function top10_datafile = identify_top_TA_centralities(TA_centrality_and_FOM_scores_datafile,GC_network_data_filename)


top10_datafile = [TA_centrality_and_FOM_scores_datafile(1:(end-4)),'_top10.txt'];


if ~exist(top10_datafile)
   
   load(TA_centrality_and_FOM_scores_datafile)
   load(GC_network_data_filename)
      
   

   %% Sort according to TA centrality
   
   fID = fopen(top10_datafile,'w');
   fprintf(fID,'Top10 Time-Averaged Centrality\n\n');
   
   [sorted_TA_centrality,top_ranking_TAs] = sort(TA_centrality,'descend');   
   top_ranking_TAs = top_ranking_TAs(1:10);   
   
   for R = 1:length(top_ranking_TAs)
      school_name = net.node_labels{top_ranking_TAs(R),1};
      %string = [school_name,' ',...
                %TA_centrality(top_ranking_TAs(R)),' ',...
                %FOM_scores(top_ranking_TAs(R))];
      %fprints(string);
      fprintf(fID,'%i %s %f %f\n',top_ranking_TAs(R),school_name,...
         TA_centrality(top_ranking_TAs(R)),FOM_scores(top_ranking_TAs(R)));

   end
   %fclose(fID);

   fprintf(fID,'\n\n\n\n')
   
   %% Sort according to FOM score
   
   fprintf(fID,'Top10 First-Order Mover Scores\n\n');
   
   [sorted_FOM_scores,top_ranking_FOMs] = sort(FOM_scores,'descend');  
   top_ranking_FOMs = top_ranking_FOMs(1:10);   
   for R = 1:length(top_ranking_FOMs)
      school_name = net.node_labels{top_ranking_FOMs(R),1};
      %string = [school_name,' ',...
                %TA_centrality(top_ranking_TAs(R)),' ',...
                %FOM_scores(top_ranking_TAs(R))];
      %fprints(string);
      fprintf(fID,'%i %s %f %f\n',top_ranking_FOMs(R),school_name,...
         FOM_scores(top_ranking_FOMs(R)),TA_centrality(top_ranking_FOMs(R)));

   end
   %fclose(fID);

   fprintf(fID,'\n\n\n\n')
   
    %% Sort according to relative FOM score
   
   fprintf(fID,'Top10 Ratio TA Centrality / FOM Scores\n\n');

   [sorted_FOM_scores,top_ranking_FOMs] = sort(FOM_scores./TA_centrality,'descend');  
   top_ranking_FOMs = top_ranking_FOMs(1:10);   
   for R = 1:length(top_ranking_FOMs)
      school_name = net.node_labels{top_ranking_FOMs(R),1};
      %string = [school_name,' ',...
                %TA_centrality(top_ranking_TAs(R)),' ',...
                %FOM_scores(top_ranking_TAs(R))];
      %fprints(string);
      fprintf(fID,'%i %s %f %f %f\n',top_ranking_FOMs(R),school_name,...
        TA_centrality(top_ranking_FOMs(R)), FOM_scores(top_ranking_FOMs(R)),...
         FOM_scores(top_ranking_FOMs(R))./TA_centrality(top_ranking_FOMs(R)));

   end
   fclose(fID);
   
   
end













