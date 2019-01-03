function [] = load_process_airline_data()
   %clear all;clc;

   %% Load node info
   airline_info_file = 'airline_data/airports.txt';

   AB = importdata(airline_info_file);
   net.N = length(AB.data);
   net.node_lat_long = AB.data;
   net.node_ids = zeros(net.N,1);
   for i=1:net.N 
      net.node_ids(i) = str2num(AB.textdata{i,1});
      net.node_labels{i,2} = i;
      net.node_labels{i,1} = AB.textdata{i,2};
   end
   clear AB;

   %% Load network info
   net_info_file = 'airline_data/network.txt';
   fid = fopen(net_info_file);

   layer_id = 1;
   net.A{layer_id} = spalloc(net.N,net.N,net.N);

   tline = fgetl(fid);
   while ischar(tline)
      net.A{layer_id} = spalloc(net.N,net.N,net.N);
      number_edges(layer_id) = str2num(tline);
      tline = fgetl(fid);

      for e=1:number_edges(layer_id)
         tline = fgetl(fid);
         C = str2num(tline);
         net.A{layer_id}(C(1),C(3:end))=1;
         net.A{layer_id}(C(3:end),C(1))=1;
      end
      tline = fgetl(fid);
      tline = fgetl(fid);
      layer_id = layer_id+1;
   end
   fclose(fid);

   net.T = length(net.A);


   %% 
   % 
   % for t=1:net.T
   %    spy(net.A{t})
   %    pause(1)
   % end

   save('multiplex_airlines.mat','net')

end


