
%% Analyze eigenvector centrality of multiplex airline networks
%
% 
% Copyright Dane Taylor 5 July 2018
 
   clear;clc; 
   code_path  = genpath('../../supracentrality');addpath(code_path);
   code_path2  = genpath('../../utility');addpath(code_path2);
   
%% Load European airline network and find the giant component

   load_process_airline_data();
   network_data_filename = 'multiplex_airlines.mat';   
   GC_network_data_filename = reduce_to_GC(network_data_filename);%build adjacency matrices

   
%% Define supracentrality parameters

   multilayer_centrality.coupling_scheme = 'all2all';
   multilayer_centrality.centrality_type = 'evec_centrality';
   multilayer_centrality.omegas = 10.^[-2:.25:2];

   
%% Compute supracentralities
   w_centrality_datafile = compute_w_centrality(GC_network_data_filename,multilayer_centrality);

   
%% Study Centrality Profiles and reproduce Figure 4 in the paper
   plot_marginals_vs_w(GC_network_data_filename,w_centrality_datafile);


%% Reproduce insets in Fig. 4 by comparing centralities to perturbation theory 
   [weak_limit_datafile,strong_limit_datafile] = plot_limiting_behavior(GC_network_data_filename,w_centrality_datafile);

   
%% Reproduce Table 2 in the paper: the top airports
   top10_MNC_datafile = identify_top_MNC(GC_network_data_filename,w_centrality_datafile);   
    
   
%% Reproduce Fig. 5 by comparing centralities to node degrees   
   dominant_layer = 2;
   plot_supracentralities_vs_degrees(GC_network_data_filename,w_centrality_datafile,dominant_layer);


   
   
   
   
   
   
   
   
   
   
   
   
   