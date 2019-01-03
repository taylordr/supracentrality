%% DEMO of centrality analysis for toy multiplex network
% This reproduces Figure 3 in the Main Text and Figure SM1 in the Supporting
% Material
%
% Copyright Dane Taylor 2 January 2019 
 
   clear;clc;%cleanup

%% Add path to codebase
   code_path  = genpath('../../supracentrality');addpath(code_path);
   code_path2  = genpath('../../utility');addpath(code_path2);
   

%% Generate synthetic 'toy' network and save it to file
   network_data_filename = 'toy1.mat';
   create_toy1(network_data_filename);


%% Define centrality parameters
   
   multilayer_centrality.omegas = 10.^[-4:.2:4];%coupling strengths to sweep over
  
   multilayer_centrality.centrality_type = 'evec_centrality'; %centrality type (eigenvector, pagerank, hub, authority)

   %define the interlayer adjacency matrix describing the coupling between layers
   multilayer_centrality.coupling_scheme = 'custom';
   if strcmp(multilayer_centrality.coupling_scheme,'custom')
      multilayer_centrality.layer_adjacency_matrix = sparse([0,1,1,0,0,0; ...
                                                             1,0,1,0,0,0; ...
                                                             1,1,0,.01,0,0; ...
                                                             0,0,.01,0,1,1; ...
                                                             0,0,0,1,0,1; ...
                                                             0,0,0,1,1,0]);
   end
 


%% Compute supracentralities
   w_centrality_datafile = compute_w_centrality(network_data_filename,multilayer_centrality);



%% Reproduce Figure 3 in the paper 
   make_figs_toy_demo(w_centrality_datafile,network_data_filename)

   
   
%% Reproduce extended figures in the SI for other choices of the coupling \tilde{A}_{23} 
  
   multilayer_centrality.layer_adjacency_matrix = sparse([0,1,1,0,0,0; ...
                                                          1,0,1,0,0,0; ...
                                                          1,1,0,.1,0,0; ...
                                                          0,0,.1,0,1,1; ...
                                                          0,0,0,1,0,1; ...
                                                          0,0,0,1,1,0]);
   w_centrality_datafile = compute_w_centrality(network_data_filename,multilayer_centrality);   
   make_figs_toy_demo(w_centrality_datafile,network_data_filename)
         
   
   multilayer_centrality.layer_adjacency_matrix = sparse([0,1,1,0,0,0; ...
                                                          1,0,1,0,0,0; ...
                                                          1,1,0,1,0,0; ...
                                                          0,0,1,0,1,1; ...
                                                          0,0,0,1,0,1; ...
                                                          0,0,0,1,1,0]);
   w_centrality_datafile = compute_w_centrality(network_data_filename,multilayer_centrality);   
   make_figs_toy_demo(w_centrality_datafile,network_data_filename)


%% Analyze weak and strong-coupling limits, validating perturbation theory 
   %[weak_limit_datafile,strong_limit_datafile] = plot_limiting_behavior(network_data_filename,w_centrality_datafile);
   

