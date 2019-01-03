%% [w_centrality_datafile] = compute_w_centrality(network_data_filename,multilayer_centrality)
%
% This function computes the joint, marginal and conditional eigenvector centralities. 
%
% inputs:  network_data_filename: file containing variable net in which net.A{t} is the adjacency matrix of layer t
%          multilayer_centrality: variable containing centrality parameters
%
% Copyright Dane Taylor 2 January 2019

function [w_centrality_datafile] = compute_w_centrality(network_data_filename,multilayer_centrality)

   w_centrality_datafile = [network_data_filename(1:(end-4)),'_',num2str(multilayer_centrality.centrality_type)];
   w_centrality_datafile = [w_centrality_datafile,'_',multilayer_centrality.coupling_scheme,'.mat'];
   
   %modify the name if there is layer teleportation
   if strcmp(multilayer_centrality.coupling_scheme,'directedChain_tele')
      temp = w_centrality_datafile;
      w_centrality_datafile = [temp(1:end-4),'_gamma',char(string(multilayer_centrality.layer_tele)),'.mat'];
   end

   if 1%~exist(w_centrality_datafile)      
      multilayer_centrality = define_centrality_matrix_function(multilayer_centrality);
      multilayer_centrality = define_coupling_scheme(network_data_filename,multilayer_centrality);
      multilayer_centrality = compute_centralities_for_all_couplings(network_data_filename,multilayer_centrality);                              
      
      
      save(w_centrality_datafile,'multilayer_centrality');
      
   end   
end

%% define_centrality_matrix_function
function multilayer_centrality = define_centrality_matrix_function(multilayer_centrality)
   switch multilayer_centrality.centrality_type
      case 'evec_centrality'
         multilayer_centrality.matrix_function = @(A) A;
      case 'pagerank'
         multilayer_centrality.matrix_function = @(A) pagerank(A,.85);
      case 'hub_scores'
         multilayer_centrality.matrix_function = @(A) A*A';%matrix function for hub scores
      case 'authority_scores'
         multilayer_centrality.matrix_function = @(A) A'*A;%matrix function for authority scores            
      case 'custom' %already defined
         %do nothing because it's already defined
   end
end

function C = pagerank(A,alpha)
   N = length(A);
   A = A + eye(N);% add self edges to all nodes
   deg = sum(A,1);    
   C = alpha * (A*diag(deg.^-1) ) + (1-alpha) * ones(N,N)/N;%matrix function for pagerank    
    
end

%% define_coupling_scheme
function multilayer_centrality = define_coupling_scheme(network_data_filename,multilayer_centrality)

   load(network_data_filename);%load struct 'net'
   switch multilayer_centrality.coupling_scheme
      case 'all2all'        
         multilayer_centrality.layer_adjacency_matrix = sparse(ones(net.T)) ;
      case 'all2all_no_self_edge'        
         multilayer_centrality.layer_adjacency_matrix = sparse(ones(net.T)) - eye(net.T);
      case 'undirChain'        
         multilayer_centrality.layer_adjacency_matrix = spdiags(ones(net.T,2),[-1,1],net.T,net.T);%couple layers using an undirected chain
      case 'undirChainRegular'        
         multilayer_centrality.layer_adjacency_matrix = spdiags(ones(net.T,2),[-1,1],net.T,net.T);%couple layers using an undirected chain
         multilayer_centrality.layer_adjacency_matrix(1,1) = 1;
         multilayer_centrality.layer_adjacency_matrix(net.T,net.T) = 1;
      case 'directedChain_tele'        
         multilayer_centrality.layer_adjacency_matrix =  full(gallery('tridiag',net.T,0,0,1)) + multilayer_centrality.layer_tele*ones(net.T);
         
      case 'custom'        
         %do nothing because it's already defined
   end
end


%% compute_centralities_for_all_couplings
function multilayer_centrality = compute_centralities_for_all_couplings(network_data_filename,multilayer_centrality);

   load(network_data_filename);%load struct 'net'
   A_hat = spalloc(net.N*net.T,net.N*net.T,net.N*net.T);
   for t=1:net.T
      ids = (t-1)*net.N + (1:net.N);
      A_hat(ids,ids) = multilayer_centrality.matrix_function( net.A{t} );
   end

   for e = 1:length(multilayer_centrality.omegas)

      % Supracentrality matrix
      CC = A_hat + (multilayer_centrality.omegas(e)) * ...
         kron(multilayer_centrality.layer_adjacency_matrix,speye(net.N)) ;               

      % Joint Centrality
      [multilayer_centrality.joint_centrality{e},multilayer_centrality.eigenvalues{e}]=eigs(CC,1);

      multilayer_centrality.joint_centrality{e} = sign(sum(multilayer_centrality.joint_centrality{e}))*multilayer_centrality.joint_centrality{e};
      multilayer_centrality.joint_centrality{e} = reshape(multilayer_centrality.joint_centrality{e},net.N,net.T);

      % Marginal Centrality  
      multilayer_centrality.marginal_layer_centrality(e,:) = sum(multilayer_centrality.joint_centrality{e})';
      multilayer_centrality.marginal_node_centrality(:,e) = sum(multilayer_centrality.joint_centrality{e}');

      % Conditional Centrality
      multilayer_centrality.conditional_node_centrality{e} = multilayer_centrality.joint_centrality{e} ./ ...
            repmat(multilayer_centrality.marginal_layer_centrality(e,:),net.N,1);
         
      % Conditional Rank
      multilayer_centrality.conditional_node_rank{e} = multilayer_centrality.conditional_node_centrality{e};
      for t = 1:size(multilayer_centrality.conditional_node_centrality{e},2)
         [sorted_CNC,sorted_ids] = sort(multilayer_centrality.conditional_node_centrality{e}(:,t),'descend');
         [~, rnk1] = ismember(multilayer_centrality.conditional_node_centrality{e}(:,t),sorted_CNC);
         multilayer_centrality.conditional_node_rank{e}(:,t) = rnk1';
      end
   end
end







