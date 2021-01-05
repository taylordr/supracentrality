

import networkx as nx
import numpy as np
from scipy import sparse
import matplotlib.pyplot as plt


################################################
## Basic graphs 
################################################


def undirected_chain(T):
    # Creates adjacency matrix for an undirected chain with T nodes
    A_tilde = np.zeros((T,T))#sparse.csr_matrix((T,T))
    for n in range(T):
        if n-1>=0 and n+1<T:
            A_tilde[n,n-1]=1
            A_tilde[n,n+1]=1
        elif n-1<0:
            A_tilde[n,n+1]=1
        elif n+1>=T:
            A_tilde[n,n-1]=1
    return A_tilde        



def directed_chain(T,gamma):
    At = np.zeros((T,T))
    for t in range(1,T):
        At[t-1,t] = 1        
    At = At + gamma*np.ones((T,T))
    return At







################################################
## Basic eigenvector centrality 
################################################


def sparse_power_method(G):
    #G = sparse.csr_matrix(G) #Converts matrix to sparse for easier analysis
    U = sparse.linalg.eigs(G,1,which='LR')[1] #Determines the largest eigenvalue and eigenvector
    e = np.abs(U.T)/ np.sum(np.abs(U))
    #print(np.shape(e))
    return e[0]

def power_method(G):
    x = np.ones(len(G))
    x = x/np.sum(x)
    for t in range(10000):
        x = np.dot(G,x)
    return x/np.sum(x)

def get_P(A): 
    N = np.shape(A)[0]
    Dinv = np.zeros((N,N)) #Initializes diagonal matrix
    for n in range(0,N): #Creates Diagonal Matirx
        if np.sum(A[n])>0:
            Dinv[n][n] = 1/np.sum(A[n])
    return np.dot(Dinv,A)
    
def google_matrix(A,alpha): 
    N = np.shape(A)[0]
    A = A.toarray()    
    P = get_P(A)
    G = alpha*P + (1-alpha)/N * np.ones(np.shape(A))    
    return G

def pagerank(A,alpha):      
    return power_method(google_matrix(A,alpha).T)    






################################################
## Supracentrality analyses
################################################

def supraCentralityMatrix(M,A_tilde,w,centrality_function):
    N = np.shape(M[0])[0]
    G = []
    for A in M:
        G.append(centrality_function(A)) #list of transposed Google matrices
    C = sparse.block_diag(G) + w*sparse.kron(A_tilde,sparse.identity(N)) #Determines Supracentrality matirx
    return C

def supraCentrality(M,A_tilde,w,alpha):
    N = np.shape(M[0])[0]
    T = np.shape(A_tilde)[0]
    C = supraCentralityMatrix(M,A_tilde,w,alpha)
    e = sparse_power_method(C)
    return e.reshape(T,N).T #Reshapes eigenvalue

def get_marginal_and_conditional(joints):# compute marginal and conditional centralities from the joint centralities
    N,T  = np.shape(joints)
    marginals = np.zeros(T)
    conditionals = np.zeros(np.shape(joints))   
    
    for t in range(T):
        marginals[t] = np.sum(joints[:,t])
        conditionals[:,t] = joints[:,t] / marginals[t] 
        
    return marginals,conditionals



def plot_joint_conditional_centralities(joints,conditionals):
    f1,ax = plt.subplots(1,2,figsize=(12,4))
    ax[0].plot(joints.T);
    ax[1].plot(conditionals.T);
    ax[0].set_xlabel('layer, $t$')
    ax[1].set_xlabel('layer, $t$')
    ax[0].set_ylabel('joint centrality, $W_{it}$')
    ax[1].set_ylabel(' conditional centrality, $Z_{it}$')
    ax[0].legend(['node '+str(i) for i in np.arange(1,1+np.shape(joints)[0])])
    ax[1].legend(['node '+str(i) for i in np.arange(1,1+np.shape(joints)[0])])
    plt.tight_layout()
    return f1,ax




################################################
## Basic supra and multiplex supra-adjacency matrix
################################################


def supraadjacency(As,At,w=1):
    #A = sparse.block_diag(As) + w/(1-w)* sparse.kron(At,sparse.identity(np.shape(As[0])[0])) #Calculates supraadjacency matrix
    A = sparse.block_diag(As) + w* sparse.kron(At,sparse.identity(np.shape(As[0])[0])) #Calculates supraadjacency matrix
    return A

def supraPageRank(M,P,w,alpha):    
    N = np.shape(M[0])[0]
    T = np.shape(P)[0]
    A = supraadjacency(M,P,w)
    x = pagerank(A,alpha) #Calculates Pagerank
    return x.T.reshape(T,N).T #Reshapes eigenvector into format convenient for analysis



def aggregate_layers(As):
    AA = As[0]
    for t in range(1,len(As)):
        AA += As[t]
    return AA

def multiplex_positions(pos_i,# layer positions
                        pos_t,# node positions
                        beta=1# slides layers apart/together
                       ):

 
    pos = np.zeros((len(pos_t)*len(pos_i),2))
    s = 0
    for t in range(len(pos_t)):
        for i in range(len(pos_i)):
            pos[s,:] = beta*pos_i[i] + (1/beta)*pos_t[t]
            s += 1
    return pos






################################################
## Toy multiplex networks
################################################


def get_toy1():
    graph = {}
    graph['As'] = []
    graph['As'].append(np.array([[0,1,1,1],[1,0,0,0],[1,0,0,0],[1,0,0,0]]))#layer 1
    graph['As'].append(np.array([[0,1,1,0],[1,0,0,0],[1,0,0,1],[0,0,1,0]]))#layer 2
    graph['As'].append(np.array([[0,0,1,0],[0,0,0,1],[1,0,0,1],[0,1,1,0]]))#layer 3
    graph['As'].append(np.array([[0,0,0,1],[0,0,0,1],[0,0,0,1],[1,1,1,0]]))#layer 4
    graph['As'].append(np.array([[0,1,0,0],[1,0,0,1],[0,0,0,1],[0,1,1,0]]))#layer 5
    graph['As'].append(np.array([[0,1,0,0],[1,0,1,1],[0,1,0,0],[0,1,0,0]]))#layer 6
    
    N = 4
    T = 6
    

    #G = nx.from_numpy_matrix(aggregate_layers(A))
    #pos_i = np.array(list(nx.kamada_kawai_layout(G).values()))  
    #pos_i = np.array(list(nx.circular_layout(G).values()))  

    # position of node-layer pairs
    thetas = np.linspace(2*np.pi/N,2*np.pi,N) -2
    pos_i = np.array([np.sin(thetas),np.cos(thetas)]).T
    pos_i[[2, 3],:] = pos_i[[3, 2],:]
    pos_t = np.array([np.linspace(-T/2,T/2,T),np.zeros(T)]).T
    pos = multiplex_positions(pos_i,pos_t,beta=.6)

    graph['pos'] = pos
    graph['N'] = 4
    graph['T'] = 6    
    return graph




def visualize_toy1(graph):
    As = graph['As']
    pos = graph['pos']
    
    At = undirected_chain(len(As))
    A_inter = np.array(sparse.kron(At,sparse.identity(np.shape(As[0])[0])).todense())
    A_intra  = np.array(sparse.block_diag(As).todense())

    G_intra = nx.from_numpy_matrix(A_intra)
    G_inter = nx.from_numpy_matrix(A_inter)
    
    
    fig1 = plt.figure(figsize=(12,4))
    ax = fig1.add_subplot(1, 1, 1)
    nodes = nx.draw_networkx_nodes(G_intra,pos,alpha=1,node_size=400,node_color='lightgray',cmap='hot',ax=ax)

    show_labels = True
    if show_labels:
        labels =  np.arange(len(As)*len(As[0]))
        labels = dict(zip(labels,np.mod(labels,len(As[0]))+1))
        labels2 = nx.draw_networkx_labels(G_intra, pos,labels,font_size=18,alpha=0.5,ax=ax);


    intra_edges = nx.draw_networkx_edges(G_intra, pos,alpha=1,width=4,ax=ax)
    inter_edges = nx.draw_networkx_edges(G_inter, pos,alpha=.15,width=2,ax=ax)

    plt.tight_layout()
    ax.set_axis_off()


    return fig1,ax



