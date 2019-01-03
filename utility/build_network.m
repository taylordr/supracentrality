%function function net_filename = build_network(edge_list_filename,node_labels_filename)
%
% this script builds a network given an edge list for a weighted temporal network
%
% INPUT:    edge_list_filename - edge list filename
%           node_labels_filename - file containing node labels/names
%
% OUTPUT:   net_filename - the .mat file containing the network variable 'net
%
%
% Copyright - Dane Taylor 15 September 2016


function net_filename = build_network(edge_list_filename,node_labels_filename)

   net_filename = [edge_list_filename(1:(end-4)),'_net_data.mat'];
   
   if ~exist(net_filename)

      data = load(edge_list_filename);

      from = data(:,1);
      to = data(:,2);
      weight = data(:,3);
      time = data(:,4);


      net.N = max([from;to]);     
      net.time_stamps = min(time):1:max(time);
      net.T = length(net.time_stamps); %assumes time stamps are integers

      %allocate memory for adjacency matrices
      for t=1:net.T
         net.A{t} = spalloc(net.N,net.N,1);
      end
      for t=1:net.T
         time_conversion(net.time_stamps(t)) = t;
      end

      %construct adjacency matrices
      for e=1:length(from)
         net.A{time_conversion(time(e))}(from(e),to(e)) = weight(e);
      end

      fileID = fopen(node_labels_filename,'r');
      for n=1:net.N
         text = fgets(fileID);
         net.node_labels{n} = text;
      end
      fclose(fileID)                  
      
      save(net_filename,'net');

   end
   
end