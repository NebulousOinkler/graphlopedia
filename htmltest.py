from html.parser import HTMLParser
import bibtexparser
import re
import json

#url = "https://mathscinet.ams.org/mathscinet/search/publications.html?fmt=bibtex&pg1=MR&s1=1019150"
#page = urllib.request.urlopen(url)
page = open('C:/Users/Sharat/Desktop/htmlTest.html')
rawHTML = page.read()

output  = re.compile('<pre>(.*?)</pre>', re.DOTALL |  re.IGNORECASE).findall(rawHTML)
output = output[0]

bib = bibtexparser.loads(output).entries[0]
bib['author'] = bib['author'] + ' and ' + 'Bob, Barker S.'
print(bib)
print(json.dumps(bib))