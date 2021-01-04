

import networkx as nx
import numpy as np
from scipy import sparse


################################################
## Load temporal network 
################################################


def load_temporal_PhD_flow_graph(foldername):
    # load school names from file
    file1 = open(foldername+'/school_names.txt','r') 
    graph = {}
    graph['nodenames'] = [x.strip() for x in file1]
    graph['N'] = len(graph['nodenames'])
    
    # load graph  from file
    file2 = open(foldername+'/PhD_exchange.txt','r') 
    edges = np.array(np.loadtxt(file2),'int')
    graph['layer_names'] = [str(j) for j in np.unique(edges[:,3])]
    graph['T'] = len(graph['layer_names'])

    # a tensor in containing network adjacency matrix at each time
    graph['A_tensor'] = []
    for t in range(graph['T']):
        graph['A_tensor'].append(sparse.csr_matrix((graph['N'],graph['N'])))
    
    for edge in edges:
        node_A = edge[0]-1     
        node_B = edge[1]-1
        weight = edge[2]
        year_id   = np.where([s == str(edge[3]) for s in graph['layer_names'] ])[0][0]
        graph['A_tensor'][year_id][node_A,node_B] += weight
    
    # Uncomment the following if you want to add self-edges of some small weight

    #for t,year in enumerate(graph['layer_names']):
    #    graph['A_tensor'][year_id] =  graph['A_tensor'][year_id] + sparse.eye(graph['N'])*10**-14
    
    return graph




################################################
## Load time-aggregated network 
################################################

def load_PhD_flow_graph(data_folder):

    # load school names from file
    file1 = open(data_folder+'/school_names.txt','r') 

    graph = {}
    graph['nodenames'] = [x.strip() for x in file1]
    graph['N'] = len(graph['nodenames'])
    
    # load graph  from file
    file2 = open(data_folder+'/PhD_exchange.txt','r') 
    edges = np.array(np.loadtxt(file2),'int')
    #graph['A'] = zeros((graph['N'],graph['N']))
    graph['A'] = sparse.csr_matrix((graph['N'],graph['N']))
    for edge in edges:
        graph['A'][edge[0]-1,edge[1]-1] += edge[2]
        
    # compute number of edges
    graph['M'] = np.sum(graph['A'])
    
    print('Loaded network with:') 
    print(str(graph['N']) + ' nodes') 
    print(str(int(graph['M'])) + ' edges') 

    return graph


