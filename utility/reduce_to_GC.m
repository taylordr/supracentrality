%%



function GC_network_data_filename = reduce_to_GC(network_data_filename)

   GC_network_data_filename = [network_data_filename(1:(end-4)),'_GC.mat'];
   
   if ~exist(GC_network_data_filename)

      load(network_data_filename);%load struct 'net'
      net2 = net;
      net.A = {};
      net.N = [];

      %aggregate adjacency matrices of layers
      M = net2.A{1};
      for t=2:net2.T
         M = M+net2.A{t}; 
      end 

      %find connected components
      comps = components(sparse(M+M'));   
      %disp([int2str(max(comps)),' components found'])

      %find ids of nodes in giant component
      nodes_in_GC=find(comps==mode(comps));   
      net.N=length(nodes_in_GC);%new number of nodes

      %build adjacency matrix for subset of nodes in GC
      for t=1:net.T
         net.A{t}=net2.A{t}(nodes_in_GC,nodes_in_GC);
      end
      net.node_labels = {};
      for n=1:net.N
         net.node_labels{n,1} = net2.node_labels{nodes_in_GC(n),1};
         net.node_labels{n,2} = net2.node_labels{nodes_in_GC(n),2};
      end
      
      
      save(GC_network_data_filename,'net','nodes_in_GC')

   end

end

