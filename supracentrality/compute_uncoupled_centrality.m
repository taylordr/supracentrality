%% function uncoupled_centrality_datafile = compute_uncoupled_centrality(GC_network_data_filename,w_centrality_datafile)
%
%
%
%
%
% Copyright - Dane Taylor 21 June 2018


function uncoupled_centrality_datafile = compute_uncoupled_centrality(GC_network_data_filename,w_centrality_datafile)
 

   uncoupled_centrality_datafile = [w_centrality_datafile(1:(end-4)),'_uncoupled_centrality.mat'];

   if 1%~exist(uncoupled_centrality_datafile)


      load(GC_network_data_filename);%load network in struct net
      load(w_centrality_datafile);%load multilayer_centrality
      
      T = net.T;
      N=net.N;
      
      spectral_radii = zeros(1,net.T);
      evecs_v = zeros(net.N,net.T);
      evecs_u = zeros(net.N,net.T);
      
      for t = 1:net.T
         [evecs_v(:,t),spectral_radii(t)] = eigs(multilayer_centrality.matrix_function(net.A{t}),1,'largestreal');
         [evecs_u(:,t),spectral_radii(t)] = eigs(multilayer_centrality.matrix_function(net.A{t})',1,'largestreal');
      end
      evecs_v = abs(evecs_v);
      evecs_u = abs(evecs_u);
       
      max_layer_ids = find(abs(spectral_radii - max(spectral_radii))<10^-14);
      
       
%       
%       strong_limit_coupling_matrix = multilayer_centrality.layer_adjacency_matrix(max_layer_ids,max_layer_ids);
%       
%       v = .00000000001*ones(net.T,1);
%       v(max_layer_ids)=1;
%       AAA = full((v*v') .* multilayer_centrality.layer_adjacency_matrix);
%       
%       [eevecs,eevals] = eigs(AAA);eevals=diag(eevals);
%       %[eevecs,eevals] = eigs(strong_limit_coupling_matrix);eevals=diag(eevals);
%       ii = find(eevals==max(eevals));     
%        
%       layer_weights = zeros(1,net.T);
%       layer_weights(max_layer_ids) = abs(eevecs(max_layer_ids,ii));
%       uncoupled_centrality = evecs_v * diag(layer_weights);
%       uncoupled_centrality =  uncoupled_centrality / norm(uncoupled_centrality);
%        

             
      for t = 1:net.T
         vv{t} = zeros(net.N*net.T,1);
         uu{t} = zeros(net.N*net.T,1);
         vv{t}((t-1)*net.N + (1:net.N)) = evecs_v(:,t);         
         uu{t}((t-1)*net.N + (1:net.N)) = evecs_u(:,t);
      end
      A_hat = kron(multilayer_centrality.layer_adjacency_matrix,eye(net.N)); 
      
      %XX = zeros(net.T,net.T);
      X = zeros(net.T,net.T);
      for t = 1:net.T
         for tt = 1:net.T
            %XX(t,tt) = uu{t}'*A_hat*vv{tt};
            X(t,tt) =  multilayer_centrality.layer_adjacency_matrix(t,tt) * ...
            ( evecs_u(:,t)'*evecs_v(:,tt) ) / abs(evecs_u(:,t)'*evecs_v(:,t));
         end
         %bb(t) = uu{t}'*vv{t};
      end
      X = X(max_layer_ids,max_layer_ids);
      %bb = bb(max_layer_ids);
       
      [eevecs1,eevals1] = eigs(X);eevals1=diag(eevals1);
      ii = find(eevals1==max(eevals1));     
      eevecs1 = eevecs1(:,ii);
        
      layer_weights = zeros(1,net.T);
      layer_weights(max_layer_ids) = abs(eevecs1);
      uncoupled_centrality = evecs_v * diag(layer_weights);
      uncoupled_centrality =  uncoupled_centrality / norm(uncoupled_centrality);
     
      
      %% Save variables          
      save(uncoupled_centrality_datafile,'uncoupled_centrality');
      
      
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
         %do nothing because it's aldready defined
   end
end

function C = pagerank(A,alpha)
   N = length(A);
   A = A + eye(N);% add self edges to all nodes
   deg = sum(A,1);   
   C = alpha * (A*diag(deg.^-1) ) + (1-alpha) * ones(N,N)/N;%matrix function for pagerank        
end
