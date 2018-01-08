import json
from jsonschema import validate
import collections as col
import unittest
import os

class JSONValidation(unittest.TestCase):
    def setUp(self):
        with open(os.path.join(os.getcwd(), 'graphlopedia_src/graphs.schema.json')) as schemaJSON:
            self.schema = json.load(schemaJSON)
        with open(os.path.join(os.getcwd(),'graphlopedia_src/graphs.json')) as docJSON:
            self.doc = json.load(docJSON)
        self.graphs = iter(self.doc["graphs"])
    
    def test_JSONValidation(self):
        self.assertIsNone(validate(self.doc,self.schema),"Schema Validation Failed")
        
        for graph in self.graphs:
            with self.subTest(msg=graph["id"]):
                #Make sure number of vertices is a nonnegative integer
                self.num_vert = graph["num_vert"]
                self.assertIsInstance(self.num_vert,int)
                self.assertGreaterEqual(self.num_vert, 0)
                
                self.edgeEntryList = [vert for edge in graph["edges"] for vert in edge]
                
                #Test if edge entries are the same as vertex entries
                edgeEntries = set(self.edgeEntryList)
                vertexEntries = set(range(1,self.num_vert+1))
                self.assertEqual(edgeEntries, vertexEntries)
                
                #Test if Degree Sequence is correct
                self.derivedDegreeSequence = sorted(list(col.Counter(self.edgeEntryList).values()), reverse=True)
                self.providedDegreeSequence = sorted(graph["deg_seq"], reverse=True)
                self.assertEqual(self.derivedDegreeSequence, self.providedDegreeSequence, "Degree Sequence Provided Does Not Match Edge List")