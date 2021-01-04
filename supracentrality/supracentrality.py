

import networkx as nx
import numpy as np
from scipy import sparse


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

def supraCentralityMatrix(M,A_tilde,w,alpha):
    N = np.shape(M[0])[0]
    G = []
    for A in M:
        G.append(google_matrix(A.T,alpha).T) #list of transposed Google matrices
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



################################################
## Boring centrality for supra-adjacency matrix
################################################


def supraadjacency(As,At,w):
    A = sparse.block_diag(As) + w/(1-w)* sparse.kron(At,sparse.identity(np.shape(As[0])[0])) #Calculates supraadjacency matrix
    return A

def supraPageRank(M,P,w,alpha):    
    N = np.shape(M[0])[0]
    T = np.shape(P)[0]
    A = supraadjacency(M,P,w)
    x = pagerank(A,alpha) #Calculates Pagerank
    return x.T.reshape(T,N).T #Reshapes eigenvector into format convenient for analysis





