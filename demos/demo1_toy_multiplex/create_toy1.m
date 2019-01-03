function [] = create_toy1(network_data_filename)



%% Load edge list for weighted, directed network and construct adjacency matrices

 net.T = 6; 
      net.N = 4;
      net.A = {}; 
      net.A{1} = zeros(net.N);
         net.A{1}(1,2) = 1;         
         net.A{1}(1,3) = 1;
         net.A{1}(1,4) = 1;   
         net.A{1} = net.A{1} + net.A{1}';
         %net.A{1} = net.A{1} / sum(sum(net.A{1}));         
      net.A{2} = zeros(net.N);  
         net.A{2}(1,2) = 1;
         net.A{2}(1,3) = 1;
         net.A{2}(3,4) = 1;
         net.A{2} = net.A{2} + net.A{2}';
         %net.A{2} = net.A{2} / sum(sum(net.A{2}));
      net.A{3} = zeros(net.N);
         net.A{3}(1,3) = 1;
         net.A{3}(2,4) = 1;
         net.A{3}(3,4) = 1;
         net.A{3} = net.A{3} + net.A{3}';  
         %net.A{3} = net.A{3} / sum(sum(net.A{3}));
      net.A{4} = zeros(net.N);
         net.A{4}(1,4) = 1;
         net.A{4}(2,4) = 1;
         net.A{4}(3,4) = 1;
         net.A{4} = net.A{4} + net.A{4}';   
         %net.A{4} = net.A{4} / sum(sum(net.A{4}));
      net.A{5} = zeros(net.N);
         net.A{5}(1,2) = 1;
         net.A{5}(2,4) = 1;
         net.A{5}(3,4) = 1;
         net.A{5} = net.A{5} + net.A{5}';  
         %net.A{3} = net.A{3} / sum(sum(net.A{3}));
      net.A{6} = zeros(net.N);
         net.A{6}(1,2) = 1;
         net.A{6}(2,3) = 1;
         net.A{6}(2,4) = 1;
         net.A{6} = net.A{6} + net.A{6}';   
         %net.A{4} = net.A{4} / sum(sum(net.A{4}));

         
      
      %network_data_filename = 'toy1_networkData.mat';   
      save(network_data_filename,'net');
      clear net;

      
%       net.T = 4; 
%       net.N = 3;
%       net.A = {};
%       net.A{1} = zeros(net.N);
%          net.A{1}(1,2) = 1;         
%          net.A{1}(1,3) = 1;
%          %net.A{1}(1,4) = 1;   
%          net.A{1} = net.A{1} + net.A{1}';
%          net.A{1}(1,1) = 1;
%       net.A{2} = zeros(net.N);  
%          %net.A{2}(1,2) = 1;
%          net.A{2}(1,3) = 1;
%          %net.A{2}(2,4) = 1;
%          %net.A{2}(3,4) = 1;
%          net.A{2} = net.A{2} + net.A{2}';
%       net.A{3} = zeros(net.N);
%          net.A{3}(1,3) = 1;
%          net.A{3}(2,3) = 1;
%          net.A{3} = net.A{3} + net.A{3}';   
%       net.A{4} = zeros(net.N);
%          net.A{4}(2,3) = 1;
%          %net.A{3}(2,4) = 1;
%          %net.A{3}(3,4) = 1;
%          net.A{4} = net.A{4} + net.A{4}';   
%          
% 
%       network_data_filenamnbvvb,,,,bb,,,,,,,,bbbb,nbmnbmmnmnnnmnbbbbbbnbmmnmnbmmmmmmmmnmmnbb,mmnbbmnnmmme = 'toy1_networkData.mat';   
%       save(network_data_filename,'net');
%       clear net;

   
end



