import json
import networkx as nx
import matplotlib.pyplot as plt
import Pydot

data = json.load(open("newgraphs.json", encoding="utf-8"))

def graph(x):
    return data[x]

def name(x):
    return data[x]["name"]

def title(x):
    return data[x]["title"]

def comments(x):
    return data[x]["comments"]

    
def vertices(x):
    return data[x]["vertices"]

def edges(x):
    return data[x]["edges"]

def degrees(x):
    return data[x]["degrees"]

def links(x):
    return data[x]["links"]

def refs(x):
    return data[x]["references"]

def pics(x):
    return data[x]["pictures"]

def authors(x):
    return data[x]["authors"]    

def makeGraphDrawing(x):
    plt.close()
    G=nx.Graph()
    G.add_nodes_from(vertices(x))
    G.add_edges_from(edges(x))
    nx.graphviz_layout(G,prog='neato')            # Z: added this line to produce better pictures, delete if it busts things
    nx.draw(G)
    plt.savefig(x + ".png")

def makeGraphJson(x):
    gfile = open("../json"+x+".json", 'w')
    gfile.write("{\n  \"name\": " + name(x) + ",\n")
    gfile.write("  \"title\": " + title(x)+ ",\n")
    gfile.write("  \"degrees\": "+str(degrees(x))+ ",\n")
    gfile.write("  \"vertices\: " +str(len(vertices(x)))+  ",\n")
    gfile.write("  \"edges\: " + str(edges(x)) + ",\n")

    gfile.write("  \"pictures\": " + pics(x)+ ",\n")
    gfile.write("  \"comments\: " + comments(x) + ",\n")        
        for comment in comments(x)[:-1]:
            gfile.write(comment + ", \n" )
        gfile.write(comments(x)[-1] + ".}\n" )    
    if len(links(x))>0:
        for link in links(x):
            gfile.write("\link{"+link+ ",\n")
    if len(refs(x))>0:            
        for ref in refs(x):
            gfile.write("\\refs{" + ref + ",\n")
    if len(authors(x))>0:
        gfile.write("\owner{")
        for author in authors(x)[:-1]:
            gfile.write(author + ", " )            
        gfile.write(authors(x)[-1] + "}" )
    gfile.close()
## extra fields approvedby,     embedding
    
              
def WriteGraphFileLatex(x, file):
    latex = open(file, 'a')
    latex.write("\n\n\graphname{"+ name(x) + "}\n")
    latex.write("\graphtitle{"+ title(x)+ "}\n")
    latex.write("\degrees{"+str(degrees(x))+ "}\n")
    if len(pics(x))>0:            
        for pic in pics(x):
            latex.write("\pictures{" + pic + "}\n")
    latex.write("\\vertices{"+str(len(vertices(x)))+ "}\n")        
    latex.write("\edges{"+ str(edges(x)) + "}\n")
    if len(comments(x))>0:
        latex.write("\comments{")
        for comment in comments(x)[:-1]:
            latex.write(comment + ", \n" )
        latex.write(comments(x)[-1] + ".}\n" )    
    if len(links(x))>0:
        for link in links(x):
            latex.write("\link{"+link+ "}\n")
    if len(refs(x))>0:            
        for ref in refs(x):
            latex.write("\\refs{" + ref + "}\n")
    if len(authors(x))>0:
        latex.write("\owner{")
        for author in authors(x)[:-1]:
            latex.write(author + ", " )            
        latex.write(authors(x)[-1] + ".}" )
    latex.close()

def PrintGraphLatex(x):
    print("\graphname{"+ name(x) + "}")
    print("\graphtitle{"+ title(x)+ "}")
    print("\degrees{"+str(degrees(x))+ "}")
    if len(pics(x))>0:            
        for pic in pics(x):
            print("\pictures{" + pic + "}\n")    
    print("\\vertices{"+str(vertices(x))+ "}")        
    print("\edges{"+ str(edges(x)) + "}")
    if len(comments(x))>0:
        print("\comments{")
        for comment in comments(x)[:-1]:
            print(comment + ", " )
        print(comments(x)[-1] + ".}" )
    print("\\vertices{"+str(vertices(x))+ "}")        
    if len(links(x))>0:
        for link in links(x):
            print("\link{"+link+ "}")
    if len(refs(x))>0:            
        for ref in refs(x):
            print("\\refs{" + ref + "}")
    if len(authors(x))>0:
        print("\owner{")
        for author in authors(x)[:-1]:
            print(author + ", " )            
        print(authors(x)[-1] + ".}" )

def WriteAllGraphsToSource():
    source = "GraphlopediaSource.tex"
    latex = open(source, 'w')
    latex.write("%%%%% Graphlopedia Source File \n %%% Do not edit here!  \n %%% Edit the master json file directly and rerun WriteAllGraphsToSource.")
    latex.close()
    for x in sorted(data.keys(), key=str.lower):
        WriteGraphFileLatex(x,source)
    latex = open(source, 'a')    
    latex.write("%%%%% Completed Graphlopedia Source File. %%% ")
    latex.close()


def TestGraph(x, v):
    errors = 0
    if v == 1:
        PrintGraphLatex(x)
    ## check all necessary keys are present
    L = [name(x), title(x), comments(x), vertices(x), edges(x), degrees(x), links(x), refs(x), pics(x),  authors(x)]
    if not( 10 == len(L)):
        print("\n\nERROR in GRAPH:",x, "missing keys:", graph(x).keys())
        errors +=1
    ## check for extra keys
    if len(graph(x))>10:
        print("\n\nERROR in GRAPH:",x, "extra keys:", graph(x).keys())
        errors +=1
    ## check vertices
    if not([i for i in range(1,len(vertices(x))+1)] == vertices(x)):
        print("\n\nERROR in GRAPH:",x, "vertex set:", vertices(x),range(1,len(vertices(x))+1))
        errors +=1
    degs = [0 for i in range(len(vertices(x))+1)]
    ## check edges contain 2 values from vertices
    for edge in edges(x):
        if len(edge) == 2:
            for i in edge:
              degs[i]=degs[i]+1
            if not((edge[0] in vertices(x)) and (edge[1] in vertices(x))):
              print("\n\nERROR in GRAPH:",x, "bad edge:", edge)
              errors +=1
        else:
            print("\n\nERROR in GRAPH:",x, "long bad edge:", edge)
            errors +=1
    if not (degs[1:] == degrees(x)):
        print("\n\nERROR in GRAPH:",x, "degree seq", degrees(x), "should be", degs[1:], "\n", vertices(x), edges(x))
        errors +=1
    if errors == 0:
        print(x, "test complete")
    return errors


    
def runTests():
    for x in sorted(data.keys(), key=str.lower):
        TestGraph(x, 0)


def grindSource():
    runTests()
    WriteAllGraphsToSource()
