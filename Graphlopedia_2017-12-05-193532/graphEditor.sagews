︠cce2423f-329b-444b-b005-023d2eae6c38s︠
######  Tools for editing and maintaining Graphlopedia
import json
data = json.load(open("newgraphs.json"))

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

def buildGraph(x):
    H= Graph()
    H.add_vertices(vertices(x))
    H.add_edges(edges(x))
    return H

def drawGraph(x):
    H= buildGraph(x)
    P = H.plot(layout="graphviz",prog="neato") 
    return P 

def saveGraph(x):
    H= buildGraph(x)
    P = H.plot(layout="graphviz",prog="neato") 
    P.save("figs/"+x+".png")


        
def WriteGraphFileLatex(x, file):
    latex = open(file, 'a')
    latex.write("\n\n\graphname{"+ name(x) + "}\n")
    latex.write("\graphtitle{"+ title(x)+ "}\n")
    latex.write("\degrees{"+str(degrees(x))+ "}\n")
    latex.write("\\vertices{"+str(len(vertices(x)))+ "}\n")        
    latex.write("\edges{"+ str(edges(x)) + "}\n")
    if len(pics(x))>0:            
        for pic in pics(x):
            latex.write("\pictures{" + pic + "}\n")
    if len(comments(x))>0:
        latex.write("\comments \n  \\begin{enumerate} \n \n")
        for comment in comments(x):
            latex.write("    \item " + comment + ", \n" )
        latex.write("  \\end{enumerate} \n \n")
    if len(links(x))>0:
        latex.write("\links \n  \\begin{enumerate} \n")
        for link in links(x):
            latex.write("    \item \url{"+link+ "}, \n" )
        latex.write("  \\end{enumerate} \n \n")
    if len(refs(x))>0:    
        latex.write("\\refs \n  \\begin{enumerate} \n")
        for ref in refs(x):
            latex.write("    \item " + ref + ", \n")
        latex.write("  \\end{enumerate} \n \n")
    if len(authors(x))>0:
        latex.write("\owner{")
        for author in authors(x)[:-1]:
            latex.write(author + ", " )            
        latex.write(authors(x)[-1] + ".}" )
    latex.close()    
    
def WriteAllGraphsToSource():
    source = "GraphlopediaSource.tex"
    latex = open(source, 'w')
    latex.write("%%%%% Graphlopedia Source File \n %%% Do not edit here!  \n %%% Edit the master json file directly and rerun WriteAllGraphsToSource.")
    latex.close()
    for x in sorted(data.keys()):
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
    for x in sorted(data.keys()):
        TestGraph(x, 0)
        


︡04944748-38c4-45e7-b600-472ebfeaf803︡{"done":true}︡
︠64f24eef-011a-49ea-a831-864e00174c13s︠
9*8
︡d0b83712-662f-4754-a580-9433fd9d6684︡{"stdout":"72\n"}︡{"done":true}︡
︠e83c3823-9d40-4053-abe2-72aa9486020as︠
WriteAllGraphsToSource()
︡613f61ef-525b-4a1b-af2f-7515cbf80a67︡{"done":true}︡
︠6af5baff-faf6-45a3-bb1e-2094aba95b5fs︠
for x in sorted(data.keys()):
    saveGraph(x)
        
︡45cbee65-ef0d-4af5-8f1d-beb2c8675f02︡{"done":true}︡
︠a69d02bb-f08e-4602-b34c-3c2792d4678cs︠
saveGraph('G000012')
︡f1bba89e-1c4d-4470-ab3b-ae138ef21aa7︡{"done":true}︡
︠9a17a240-49eb-4ae4-890f-0f8031b602d8︠
︡86c93c02-46a0-4563-a8c7-7d63559a5055︡
︠6fd93092-f822-4641-81c1-57d7ea256173︠
︡6e214f57-2e70-4eee-9313-5bd3cffdc6f5︡
︠b32ee969-15ec-4533-b5d7-9628a7869a53s︠

︡86bb9527-b787-48e7-940e-c578ed2d7ef1︡{"done":true}︡
︠b342e058-100f-44ea-8513-b7c9da15e131︠
TestGraph('G000stderr":"Error in lines 2-2\nTraceback (most recent call last):\n  File \"/projects/sage/sage-7.5/local/lib/python2.7/site-packages/smc_sagews/sage_server.py\", line 995, in execute\n    exec compile(block+'\\n', '', 'single') in namespace, locals\n  File \"\", line 1, in <module>\n  File \"/projects/sage/sage-7.5/local/lib/python/json/__init__.py\", line 291, in load\n    **kw)\n  File \"/projects/sage/sage-7.5/local/lib/python/json/__init__.py\", line 339, in loads\n    return _default_decoder.decode(s)\n  File \"/projects/sage/sage-7.5/local/lib/python/json/decoder.py\", line 364, in decode\n    obj, end = self.raw_decode(s, idx=_w(s, 0).end())\n  File \"/projects/sage/sage-7.5/local/lib/python/json/decoder.py\", line 380, in raw_decode\n    obj, end = self.scan_once(s, idx)\nValueError: Expecting , delimiter: line 153 column 3 (char 6254)9c347951-24ce-41bf-b0d0-837a548b1e20
︡e65a0f35-2af0-4fd3-bad8-922248f231b8︡{"stdout":"('\\n\\nERROR in GRAPH:', 'G000044', 'degree seq', [3, 3, 3, 3, 3, 3, 3, 3], 'should be', [3, 3, 2, 2, 3, 2, 3, 2], '\\n', [1, 2, 3, 4, 5, 6, 7, 8], [[1, 2], [1, 3], [1, 8], [2, 3], [2, 5], [4, 5], [4, 7], [5, 6], [6, 7], [7, 8]])\n1\n"}︡{"done":true}︡
︠9e44a2cb-ee84-46d9-bfe8-f7aabe3d24d7︠
         

︡44712938-fb13-4f81-a1a7-12a04b3a9e73︡{"done":true}︡
︠27b53da0-75fc-4723-8897-afcc96bba826s︠
P=drawGraph('G000020')
︡afa91e79-b715-4d57-98db-9cb14859f7b6︡{"done":true}︡
︠2d3f96cd-b633-4247-ab42-f7fa8d51e1b6︠
'G000020'
︡13cece02-f04f-44fd-bf6e-b6b14c06377f︡
︠9bc6bdba-88ad-4d2c-8942-ad4a52ada9b1s︠
P.show()
︡02d06457-6118-4226-8062-3289f9300a79︡{"file":{"filename":"/projects/4bceee9d-ee2e-43c5-b8ba-9c1264da2e5c/.sage/temp/compute5-us/25183/tmp_W1GwMn.svg","show":true,"text":null,"uuid":"65897e8b-c087-473a-b758-ddb55db58964"},"once":false}︡{"done":true}︡
︠f6872c3c-7651-4988-ae86-a4fd9c5235dbss︠
PrintGraphLatex('G000044')
︡f1681f9e-3da3-4d96-8e54-9f6bd5475c94︡{"stdout":"\\graphname{G000044}\n\\graphtitle{The staircase of order eight, St8}\n\\degrees{[3, 3, 3, 3, 3, 3, 3, 3]}\n\\pictures{G000044.png}\n\n\\pictures{extra/G000044.png}\n\n\\vertices{[1, 2, 3, 4, 5, 6, 7, 8]}\n\\edges{[[1, 2], [1, 3], [1, 4], [2, 3], [2, 8], [3, 5], [4, 5], [4, 6], [5, 7], [6, 7], [6, 8], [7, 8]]}\n\\vertices{[1, 2, 3, 4, 5, 6, 7, 8]}\n\\link{https://arxiv.org/pdf/1611.07899.pdf}\n\\refs{N. Kothari. \"Generating Near-Bipartite Bricks\" (2016). Page 4.}\n\\owner{\nKatrina Warner.}\n"}︡{"done":true}︡
︠42295d70-9cef-4673-b93d-8767babb0e08︠

︡31c5698d-ee76-49b6-8811-803f11f83baf︡
︠bc591179-4578-45b5-b0b2-bd548a2e6816︠
︡25e11fc1-bf89-4c05-889e-ab0386900983︡
︠efb16a07-ea99-479e-a3e0-db9708935bab︠
︡4909f2f7-6481-4e7c-b6af-7e754abfa5fa︡
︠16eb4455-74fb-4ba1-8be5-ecc59858d42es︠
data['G000044']['comments']=[]
︡a3c18c1f-96a3-4934-8cdf-dac6da47b954︡{"done":true}︡
︠c6111dcc-084b-4010-8409-090598dfd31bs︠
runTests()
︡85a921e2-fd40-4da4-bf3a-556b839d7928︡{"stderr":"Error in lines 1-1\nTraceback (most recent call last):\n  File \"/usr/local/lib/python2.7/dist-packages/smc_sagews/sage_server.py\", line 995, in execute\n    exec compile(block+'\\n', '', 'single') in namespace, locals\n  File \"\", line 1, in <module>\nNameError: name 'runTests' is not defined\n"}︡{"done":true}︡
︠46c17254-2123-4573-8e45-df991454a4c7s︠
count = 1
for i in sorted(data.keys()):
    print count,i, degrees(i)
    count = count +1

︡400d82fa-11fa-4e16-9369-d1bb8877b31a︡{"stdout":"1 G000001 [2, 2, 2]\n2 G000002 [1, 1]\n3 G000003 [2, 1, 1]\n4 G000004 [2, 2, 1, 1]\n5 G000005 [2, 2, 2, 1, 1]\n6 G000006 [3, 1, 1, 1]\n7 G000007 [4, 4, 4, 4, 4, 4]\n8 G000008 [3, 3, 2, 2, 2, 2]\n9 G000009 [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3]\n10 G000010 [7, 5, 2, 2, 2, 2, 1, 1]\n11 G000011 [3, 3, 2, 2, 2, 2]\n12 G000012 [2, 2, 2, 2]\n13 G000013 [3, 3, 3, 3, 2, 2, 2, 2]\n14 G000014 [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3]\n15 G000015 [4, 4, 4, 4, 2, 2]\n16 G000016 [4, 3, 3, 3, 3]\n17 G000017 [3, 3, 3, 3, 2, 2, 2, 2, 1, 1, 1, 1]\n18 G000018 [9, 4, 4, 4, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3]\n19 G000019 [4, 4, 3, 3, 3, 3]\n20 G000020 [4, 4, 4, 3, 3, 3, 3, 3, 3, 3, 3]\n21 G000021 [3, 3, 3, 3, 3, 3]\n22 G000022 [3, 3, 3, 3, 3, 3, 3, 3]\n23 G000023 [2, 2, 2, 2, 2]\n24 G000024 [4, 4, 4, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]\n25 G000025 [4, 3, 3, 2, 2, 2]\n26 G000026 [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3]\n27 G000027 [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3]\n28 G000028 [6, 3, 3, 3, 3, 3, 3]\n29 G000029 [4, 4, 4, 2, 2, 2]\n30 G000030 [9, 9, 6, 6, 6, 5, 5, 2, 2, 2]\n31 G000031 [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3]\n32 G000032 [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3]\n33 G000033 [4, 4, 4, 4, 4]\n34 G000034 [6, 5, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3]\n35 G000035 [3, 3, 2, 2, 2]\n36 G000036 [3, 3, 3, 3, 2, 2, 2, 2, 2, 1, 1]\n37 G000037 [4, 3, 3, 2, 2, 2, 2, 1, 1, 1, 1]\n38 G000038 [3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 2, 2, 1, 1]\n39 G000039 [3, 2, 2, 2, 2, 1, 1, 1, 1, 1]\n40 G000040 [5, 5, 5, 5, 5, 5]\n41 G000041 [4, 4, 4, 4, 4]\n42 G000042 [3, 2, 2, 1]\n43 G000043 [3, 3, 3, 3]\n44 G000044 [3, 3, 3, 3, 3, 3, 3, 3]\n45 G000045 [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3]\n46 G000046 [4, 4, 4, 4, 4]\n47 G000047 [3, 3, 3, 3, 3, 3]\n48 G000048 [5, 4, 4, 4, 4, 3, 3, 3]\n49 G000049 [5, 5, 5, 4, 4, 4, 3]\n50 G000050 [4, 4, 4, 3, 3, 3, 3, 3, 3]\n51 G000051 [3, 3, 3, 3, 3, 3, 3, 3, 3, 3]\n52 G000052 [6, 4, 4, 4, 4, 4, 4]\n53 G000053 [5, 5, 5, 5, 5, 5]\n54 G000054 [4, 4, 4, 4, 4, 4, 3, 3]\n55 G000055 [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3]\n56 G000056 [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3]\n57 G000057 [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3]\n58 G000058 [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3]\n59 G000059 [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3]\n60 G000060 [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3]\n61 G000061 [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3]\n62 G000062 [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3]\n63 G000063 [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3]\n64 G000064 [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3]\n"}︡{"done":true}︡
︠81284ff1-8ca6-4e80-ad7b-edffc2f78996s︠
data['G000064']
︡ee10924a-39c7-4b59-be76-89438c603c1c︡{"stdout":"{u'name': u'G000064', u'links': [u'https://arxiv.org/pdf/1403.2118.pdf'], u'title': u'Twinplex', u'pictures': [], u'vertices': [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], u'comments': [], u'edges': [[1, 2], [1, 8], [1, 9], [2, 3], [2, 11], [3, 4], [3, 10], [4, 5], [4, 12], [5, 6], [5, 9], [6, 7], [6, 11], [7, 8], [7, 10], [8, 12], [9, 10], [11, 12]], u'degrees': [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3], u'authors': [u'Aaron Bode'], u'references': [u'N. Robertson, P. Seymour, R. Thomas, Excluded Minors in Cubic Graphs, 1995.']}\n"}︡{"done":true}︡
︠baf81a7f-aaf2-4393-abd7-1022b0481637s︠
vertices('G000064')
︡3387acff-115d-42d1-b94e-fcb808a0cef5︡{"stdout":"[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]\n"}︡{"done":true}︡
︠aa5cd019-2051-4455-a6a8-084125afb263︠

               
︡9d4bdcf7-f09d-4a3c-baab-9c9121476a6a︡{"done":true}︡
︠44f7d30a-5b7d-4fc8-b13f-01ea7ee5ddbd︠
edges('G000064')

︡735329a4-b4a6-4f1a-9400-71bece815f05︡{"stdout":"[[1, 2], [1, 8], [1, 9], [2, 3], [2, 11], [3, 4], [3, 10], [4, 5], [4, 12], [5, 6], [5, 9], [6, 7], [6, 11], [7, 8], [7, 10], [8, 12], [9, 10], [11, 12]]\n"}︡{"done":true}︡
︠044c3f0b-d2e3-43de-a66e-00b5d818b476s︠
G=buildGraph('G000064')
︡ab1610db-3ca9-4279-b61a-36be50c5eaf9︡{"done":true}︡
︠e4c0d021-0c19-4b57-8b4c-1904daa2c39ds︠
K=buildGraph('G000063')
︡d091d2b6-d170-4017-9f4f-29d40cfcd790︡{"done":true}︡
︠86d9d177-d08e-46de-8b86-5aa51726f86as︠
G.is_isomorphic(K)
︡59fbce1e-1401-478e-9734-df907d79359e︡{"stdout":"False\n"}︡{"done":true}︡
︠dcfdd6b5-9504-40d2-bb95-63a0f8658ecds︠
G.degree_sequence()
︡5e7709a5-5893-4254-9cff-33c99f107e11︡{"stdout":"[3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3]\n"}︡{"done":true}︡
︠a7a5e2db-3696-4bc6-bce8-a39a044d5a6es︠
K.degree_sequence()
︡c77a236a-15be-434e-b376-f2a524af695f︡{"stdout":"[3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3]\n"}︡{"done":true}︡
︠63573475-e28b-4f8e-901b-3736cc442f12s︠


 
︡9e25da3d-2dd1-4a33-a695-f9dff686f9c0︡{"done":true}︡
︠4d10540a-5f97-445d-9832-7d6c37faf6d1s︠

︡6698179b-1703-4661-a576-19cc3de7fc7b︡{"done":true}︡
︠30c22927-0f13-4690-9b52-5fc14c681be8s︠
graph('G000012')
︡b8514dc7-01f1-488e-bf5f-f16e20731486︡{"stdout":"{u'name': u'G000012', u'links': [u'https://en.wikipedia.org/wiki/Trivially_perfect_graph'], u'title': u'trivially perfect', u'pictures': [u'G000012.png'], u'vertices': [1, 2, 3, 4, 5, 6, 7, 8], u'comments': [u'trivially perfect', u'maximal cliques', u'comparability graph of trees', u'arborescent comparability graphs', u'quasi-threshold graphs'], u'edges': [[1, 2], [1, 5], [1, 3], [1, 4], [1, 6], [1, 7], [1, 8], [3, 4], [3, 5], [4, 5], [6, 7], [6, 8]], u'degrees': [7, 3, 3, 3, 3, 2, 2, 1], u'authors': [u'Katrina Warner'], u'references': [u'\"Trivially Perfect Graphs.\" Wikipedia, Wikimedia Foundation, en.wikipedia.org/wiki/Trivially\\\\_perfect\\\\_graph.']}\n"}︡{"done":true}︡
︠8f7b863b-b842-401c-9b92-3af1888bf261s︠
G=buildGraph('G000012')
︡947994cc-8338-4da4-838c-01860bdb48fc︡{"done":true}︡
︠845db114-320a-4c76-acff-00f8e043d957︠
G.graphviz_string

︡13807281-592a-4650-828b-4f2d2eacc1f0︡{"file":{"filename":"/projects/4bceee9d-ee2e-43c5-b8ba-9c1264da2e5c/.sage/temp/compute5-us/25183/tmp_kNLLP8.svg","show":true,"text":null,"uuid":"5c3f033c-1e92-4f9e-9111-84bb08e8e035"},"once":false}︡{"done":true}︡
︠1dddf359-2a32-451b-b55e-c16abe2e7321s︠

︡9272fd3d-bdca-4e4d-ad6a-5a481974c4e6︡{"done":true}︡
︠fda03e56-2ade-40dd-8b3b-42e075ff1e28s︠
x = 'G000012'
︡d558d5db-fd82-45cc-b76a-f566c4007b89︡{"done":true}︡
︠112a1553-bf1b-4189-9f32-303631349fa5s︠
#http://doc.sagemath.org/html/en/reference/notebook/sagenb/notebook/interact.html#sagenb.notebook.interact.interact
@interact
def _(Name = name(x), Title = title(x), Comments = 'minimal nontrivially perfect', Vertices = [1,2,3,4], Edges = [[1,2],[1,4],[2,3],[3,4]], Degrees = [2,2,2,2], Links = links(x)[0], Refs = refs(x)[0], Pics = pics(x), Authors =  authors(x)[0]): data[x]['title'] = Title; print data[x]
︡b8c289ae-133a-4d29-b991-cdd34c4ea32a︡{"interact":{"controls":[{"control_type":"input-box","default":"G000012","label":"Name","nrows":1,"readonly":false,"submit_button":null,"type":"<type 'unicode'>","var":"Name","width":null},{"control_type":"input-box","default":"4-cycle","label":"Title","nrows":1,"readonly":false,"submit_button":null,"type":"<type 'unicode'>","var":"Title","width":null},{"control_type":"input-box","default":"minimal nontrivially perfect","label":"Comments","nrows":1,"readonly":false,"submit_button":null,"type":"<type 'str'>","var":"Comments","width":null},{"button_classes":null,"buttons":true,"control_type":"selector","default":0,"label":"Vertices","lbls":["1","2","3","4"],"ncols":null,"nrows":null,"var":"Vertices","width":null},{"button_classes":null,"buttons":true,"control_type":"selector","default":0,"label":"Edges","lbls":["[1, 2]","[1, 4]","[2, 3]","[3, 4]"],"ncols":null,"nrows":null,"var":"Edges","width":null},{"button_classes":null,"buttons":true,"control_type":"selector","default":0,"label":"Degrees","lbls":["2","2","2","2"],"ncols":null,"nrows":null,"var":"Degrees","width":null},{"control_type":"input-box","default":"https://en.wikipedia.org/wiki/Trivially_perfect_graph","label":"Links","nrows":1,"readonly":false,"submit_button":null,"type":"<type 'unicode'>","var":"Links","width":null},{"control_type":"input-box","default":"\"Trivially Perfect Graphs.\" Wikipedia, Wikimedia Foundation, en.wikipedia.org/wiki/Trivially\\_perfect\\_graph.","label":"Refs","nrows":1,"readonly":false,"submit_button":null,"type":"<type 'unicode'>","var":"Refs","width":null},{"button_classes":null,"buttons":true,"control_type":"selector","default":0,"label":"Pics","lbls":["G000012.png"],"ncols":null,"nrows":null,"var":"Pics","width":null},{"control_type":"input-box","default":"Katrina Warner","label":"Authors","nrows":1,"readonly":false,"submit_button":null,"type":"<type 'unicode'>","var":"Authors","width":null}],"flicker":false,"id":"4f40dcfb-93ab-4116-ab68-73f0e9c9243a","layout":[[["Name",12,null]],[["Title",12,null]],[["Comments",12,null]],[["Vertices",12,null]],[["Edges",12,null]],[["Degrees",12,null]],[["Links",12,null]],[["Refs",12,null]],[["Pics",12,null]],[["Authors",12,null]],[["",12,null]]],"style":"None"}}︡{"done":true}︡
︠b78c49fb-4a5b-4ea4-ab56-15c50cdf21fb︠

#http://doc.sagemath.org/html/en/reference/notebook/sagenb/notebook/interact.html#sagenb.notebook.interact.interact
@interact
def _(Name = "", Title = '', Comments = '', Vertices = '', Edges = '', Degrees = '', Links = '', Refs = '', Pics = '', Authors =  'Sara Billey'): print data[Name] 

︡186cc81a-52a1-4556-8d5c-1d56876e6222︡{"interact":{"controls":[{"control_type":"input-box","default":"","label":"Name","nrows":1,"readonly":false,"submit_button":null,"type":"<type 'str'>","var":"Name","width":null},{"control_type":"input-box","default":"","label":"Title","nrows":1,"readonly":false,"submit_button":null,"type":"<type 'str'>","var":"Title","width":null},{"control_type":"input-box","default":"","label":"Comments","nrows":1,"readonly":false,"submit_button":null,"type":"<type 'str'>","var":"Comments","width":null},{"control_type":"input-box","default":1,"label":"Vertices","nrows":1,"readonly":false,"submit_button":null,"type":null,"var":"Vertices","width":null},{"control_type":"input-box","default":"","label":"Edges","nrows":1,"readonly":false,"submit_button":null,"type":"<type 'str'>","var":"Edges","width":null},{"control_type":"input-box","default":"","label":"Degrees","nrows":1,"readonly":false,"submit_button":null,"type":"<type 'str'>","var":"Degrees","width":null},{"control_type":"input-box","default":"","label":"Links","nrows":1,"readonly":false,"submit_button":null,"type":"<type 'str'>","var":"Links","width":null},{"control_type":"input-box","default":"","label":"Refs","nrows":1,"readonly":false,"submit_button":null,"type":"<type 'str'>","var":"Refs","width":null},{"control_type":"input-box","default":"","label":"Pics","nrows":1,"readonly":false,"submit_button":null,"type":"<type 'str'>","var":"Pics","width":null},{"control_type":"input-box","default":"Sara Billey","label":"Authors","nrows":1,"readonly":false,"submit_button":null,"type":"<type 'str'>","var":"Authors","width":null}],"flicker":false,"id":"5d85e652-df0b-4875-a838-80602c403567","layout":[[["Name",12,null]],[["Title",12,null]],[["Comments",12,null]],[["Vertices",12,null]],[["Edges",12,null]],[["Degrees",12,null]],[["Links",12,null]],[["Refs",12,null]],[["Pics",12,null]],[["Authors",12,null]],[["",12,null]]],"style":"None"}}︡{"done":true}︡
︠ac153465-8df4-4c90-ae7f-8149bfe819e1s︠


︡3cbe4af3-6a5e-4270-af6b-94d8448b4570︡{"done":true}︡
︠6e426c0e-5a67-466a-bc84-568d19496063s︠
PrintGraphLatex('G000044')

︡f637904e-bda3-46bb-b35c-7378cc51c790︡{"stdout":"\\graphname{G000044}\n\\graphtitle{The staircase of order eight, St8}\n\\degrees{[3, 3, 3, 3, 3, 3, 3, 3]}\n\\pictures{G000044.png}\n\n\\pictures{extra/G000044.png}\n\n\\vertices{[1, 2, 3, 4, 5, 6, 7, 8]}\n\\edges{[[1, 2], [1, 3], [1, 8], [2, 3], [2, 5], [4, 5], [4, 7], [5, 6], [6, 7], [7, 8]]}\n\\comments{\nStair Case, \nOrder 8, \nERROR in GRAPH: G000044 degree seq [3, 3, 3, 3, 3, 3, 3, 3] should be [3, 3, 2, 2, 3, 2, 3, 2]  [1, 2, 3, 4, 5, 6, 7, 8] [[1, 2], [1, 3], [1, 8], [2, 3], [2, 5], [4, 5], [4, 7], [5, 6], [6, 7], [7, 8]].}\n\\vertices{[1, 2, 3, 4, 5, 6, 7, 8]}\n\\link{https://arxiv.org/pdf/1611.07899.pdf}\n\\refs{N. Kothari. \"Generating Near-Bipartite Bricks\" (2016). Page 4.}\n\\owner{\nKatrina Warner.}\n"}︡{"done":true}︡
︠5f6440aa-3dad-4106-95f7-35b5c2618296s︠

buildGraph('G000044').plot(layout="graphviz",prog="neato")
︡8ab95b67-f9fc-428d-978a-ac2fee6b1d0c︡{"file":{"filename":"/projects/4bceee9d-ee2e-43c5-b8ba-9c1264da2e5c/.sage/temp/compute5-us/25183/tmp_FHtpHb.svg","show":true,"text":null,"uuid":"0ae073e6-54ea-4620-b50d-59ce28afa298"},"once":false}︡{"done":true}︡
︠261a58b8-a64e-4f0c-98e1-29e909908501s︠
graph('G000044')
︡4b692bbd-6187-45d9-b349-eb1973d8757b︡{"stdout":"{u'name': u'G000044', u'links': [u'https://arxiv.org/pdf/1611.07899.pdf'], u'title': u'The staircase of order eight, St8', u'pictures': [u'G000044.png', u'extra/G000044.png'], u'vertices': [1, 2, 3, 4, 5, 6, 7, 8], u'comments': [], u'edges': [[1, 2], [1, 3], [1, 4], [2, 3], [2, 8], [3, 5], [4, 5], [4, 6], [5, 7], [6, 7], [6, 8], [7, 8]], u'degrees': [3, 3, 3, 3, 3, 3, 3, 3], u'authors': [u'Katrina Warner'], u'references': [u'N. Kothari. \"Generating Near-Bipartite Bricks\" arXiv (2016). Page 4.']}\n"}︡{"done":true}︡
︠0ff5c366-0324-4a46-a43e-1f2183d15307s︠
︡85c78598-7fb8-41cc-83c8-681e50951bf5︡{"done":true}︡
︠75e84ef8-eea2-4b39-aa41-62c2c76e09cds︠
data['G000037']['edges'] = [[1,4],[1,9],[1,10],[1,11],[2,3],[2,4],[2,5],[3,7],[3,8],[5,6],[6,7]]

︡970bc614-4721-423c-8efe-f430259e7e93︡{"done":true}︡
︠1ad3a59d-7978-4c9e-af36-47a46d249495s︠
buildGraph('G000044').degree_sequence()
︡76928a60-165f-42cd-9731-de2d611fa748︡{"stdout":"[3, 3, 3, 3, 3, 3, 3, 3]\n"}︡{"done":true}︡
︠cd95aff8-8eac-448c-8be8-94f643d157c9s︠

PrintGraphLatex("G000017")
︡384bd28f-5322-485c-90a6-b9b74c53658c︡{"stdout":"\\graphname{G000017}\n\\graphtitle{total domishold raft}\n\\degrees{[3, 3, 3, 3, 2, 2, 2, 2, 1, 1, 1, 1]}\n\\pictures{G000017.png}\n\n\\vertices{[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]}\n\\edges{[[1, 4], [1, 5], [1, 9], [2, 3], [2, 6], [2, 10], [3, 7], [3, 11], [4, 8], [4, 12], [5, 6], [7, 8]]}\n\\comments{\nA total domishold graph that is not connected-domishold.}\n\\vertices{[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]}\n\\link{arxiv.org/pdf/1610.06539v1.pdf}\n\\refs{Chiarelli, Nina, and Martin Milanic. A Threshold Approach to Connected Domination. 21 Oct. 2016, arxiv.org/pdf/1610.06539v1.pdf.}\n\\owner{\nAaron Bode.}\n"}︡{"done":true}︡
︠feedee6e-7245-41ef-972e-8f82741927dds︠
for x in sorted(data.keys()):
    if [4, 4, 4, 4, 2, 2] == degrees(x):
        print x
︡006a5638-1d1c-4e6a-b304-b57972808856︡{"stdout":"G000015\n"}︡{"done":true}︡
︠50ce03a0-f9bd-4fe1-a761-57b7ad97d764s︠
data['G000015']
︡b7746cab-e73a-468a-b080-0f7d98298e9a︡{"stdout":"{u'name': u'G000015', u'links': [], u'title': u'graph $F_2$', u'pictures': [u'G000015.png'], u'vertices': [1, 2, 3, 4, 5, 6], u'comments': [], u'edges': [[1, 2], [1, 3], [1, 4], [1, 5], [2, 3], [2, 4], [2, 6], [3, 4], [3, 6], [4, 5]], u'degrees': [4, 4, 4, 4, 2, 2], u'authors': [u'Aaron Bode'], u'references': [u'N. Chiarelli, Martin Milanic, A threshold approach to connected domination, University of Primorska, 2016.']}\n"}︡{"done":true}︡
︠fd6a3989-07e6-4fa6-a3eb-579da6654b0es︠
sum([1,2,3])
︡6c2373f1-f309-40b7-b62f-665bab268aed︡{"stdout":"6\n"}︡{"done":true}︡
︠03a7f0b2-97a5-47dd-aa18-3ae6f537a930s︠
sorted([2,3,1])
︡3bcc8181-0860-4efe-a474-aef70590f8b5︡{"stdout":"[1, 2, 3]\n"}︡{"done":true}︡
︠0f7fa09c-3b69-49fc-ba25-3d4ef90f036es︠
def foo(a,k):
    if a == 0:
        fun = sorted
    else:
        fun = sum
    return fun(k)
︡126b9b26-d2c6-435e-ad75-6f313eb4bb8b︡{"done":true}︡
︠39248c4a-4fc3-4ac0-8dad-fd05bcbd2969s︠
a = False

if a==False:
    print 9
else:
    print 10
︡568cd9e4-e486-4bef-a6f0-b95a814a9c64︡{"stdout":"9\n"}︡{"done":true}︡
︠4675c6dc-d72f-425e-bd39-85ec6221f7fass︠
foo(1,[2,3,1])
︡d26530a6-ae29-4208-a084-485dd311d619︡{"stdout":"6\n"}︡{"done":true}︡
︠fbec5975-ea11-4e6a-9887-b544aac35030︠

def printGraphJson(x, file = 0):
    if file == 0:
        mywrite = print
    else:
        gfile = open(x+".json", 'w')
        mywrite = gfile.write
    mywrite("{\n  \"name\": " + name(x) + ",\n")
    mywrite("  \"title\": " + title(x)+ ",\n")
    mywrite("  \"degrees\": "+str(degrees(x))+ ",\n")
    mywrite("  \"vertices\: " +str(len(vertices(x)))+  ",\n")
    mywrite("  \"edges\: " + str(edges(x)) + ",\n")
    mywrite("  \"pictures\": " + pics(x)+ ",\n")
    mywrite("  \"comments\: " + comments(x) + ",\n")        
        for comment in comments(x)[:-1]:
            mywrite(comment + ", \n" )
        mywrite(comments(x)[-1] + ".}\n" )    
    if len(links(x))>0:
        for link in links(x):
            mywrite("\link{"+link+ ",\n")
    if len(refs(x))>0:            
        for ref in refs(x):
            mywrite("\\refs{" + ref + ",\n")
    if len(authors(x))>0:
        mywrite("\owner{")
        for author in authors(x)[:-1]:
            mywrite(author + ", " )            
        mywrite(authors(x)[-1] + "}" )
    gfile.close()
## extra fields approvedby,     embedding

def makeGraphJson(x):
    if 
    gfile = open(x+".json", 'w')
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









