import json
import urllib.request
import re
import bibtexparser
import os

def writeSara2JSON(sfile, tfile):
	sara = json.load(sfile)
	graph = tfile
	vals = list(sara.values())
	graph.write('{')
	graph.write('\"description\": \"Graph Database\",')
	graph.write('\"graphs\": [')
	for entry in vals:
		graph.write('{')

		graph.write('\"id\": \"{}\",'.format(entry["name"]))
		graph.write('\"deg_seq\": {},'.format(entry["degrees"]))
		graph.write('\"name\": \"{}\",'.format(entry["title"]))
		graph.write('\"num_vert\": {},'.format(len(entry["vertices"])))
		graph.write('\"edges\": {},'.format(entry["edges"]))
		
		graph.write('\"images\": [')
		for image in entry["pictures"]:
			graph.write('{')
			graph.write('\"title\": \"{}\",'.format(entry["title"]))
			graph.write('\"src\": \"{}\"'.format(image))
			graph.write('}')
			if image != entry["pictures"][-1]:
				graph.write(',')
		graph.write('],')

		graph.write('\"links\": [')
		for link in entry["links"]:
			graph.write('{')
			graph.write('\"url\": \"{}\"'.format(link))
			graph.write('}')
			if link != entry["links"][-1]:
				graph.write(',')
		graph.write('],')

		graph.write('\"refs\": [')
#		sara_refs = entry["references"]
#		entry_name = entry["name"]
#		ref_list = autoBibRefs(sara_refs, entry_name)
#		graph.write(ref_list)
		graph.write('{}')
		graph.write('],')

		graph.write('\"comments\": {},'.format(json.dumps(entry["comments"])))

		graph.write('\"contrib\": [')
		for author in entry["authors"]:
			graph.write('{')
			graph.write('\"fi\": \"{}\",'.format(author[0]))
			graph.write('\"fname\": \"{}\",'.format(author.rsplit(" ",1)[0]))
			graph.write('\"lname\": \"{}\"'.format(author.rsplit(" ",1)[1]))
			graph.write('}')
			if author != entry["authors"][-1]:
				graph.write(',')
		graph.write(']')
		graph.write('}')
		if entry != vals[-1]:
			graph.write(',')
	graph.write(']')

	graph.write('}')

def autoBibRefs(sara_refs, entry_name):
	counter = 0
	output = ""
	os.system('cls')
	while True:
		print(entry_name)
		for x in sara_refs:
			print('** ' + x)
		print('\n\n# of Refs: {}'.format(len(sara_refs)))
		print('# inputted: {}'.format(counter))

		trigger = input("Reference Code: ")

		if trigger == 'mr':
			print('MathSciNet Mode Active:')
			mr_num = input('MR Number: ')
			url = "https://mathscinet-ams-org.offcampus.lib.washington.edu/mathscinet/search/publications.html?fmt=bibtex&pg1=MR&s1="+mr_num
			page = urllib.request.urlopen(url)
			rawHTML = page.read()
			bib = re.compile('<pre>(.*?)</pre>', re.DOTALL |  re.IGNORECASE).findall(rawHTML)[0]
			bib_dict = bibtexparser.loads(bib).entries[0]
			bibjson = json.dumps(bib_dict)
			output = output+bibjson+','
			counter = counter+1
		elif trigger == 'mn':
			print("Manual Mode Active:")
			man_input = input("Multiline Key-Values:\n")
			man_dict = dict(x.split() for x in man_input.splitlines())
			manjson = json.dumps(man_dict)
			output = otput+manjson+','
			counter = counter+1
		elif: trigger == 'ax':
			print('ArXiV Mode Active:')
			ar_num = input('ArXiV Number ')
			url = "https://arxiv2bibtex.org/?q="+ar_num
			page = urllib.request.urlopen(url)
			rawHTML = page.read()
			div1 = re.compile("<div id='biblatex'>(.*?)</div>", re.DOTALL |  re.IGNORECASE).findall(rawHTML)[0]
			bib = re.compile(">(.*?)</textarea>", re.DOTALL |  re.IGNORECASE).findall(div1)[0]
			bib_dict = bibtexparser.loads(bib).entries[0]
			bibjson = json.dumps(bib_dict)
			output = output+bibjson+','
			counter = counter+1
		elif trigger == 'nx':
			if not output:
				output = '{}'
			else:
				output = output[:-1]
			break
		else:
			print("Invalid Code")
	return output




if __name__ == '__main__':
	with open('./Graphlopedia_2017-12-05-193532/newgraphs.json') as sfile:
		with open('./graphs.json', 'w') as tfile:
			writeSara2JSON(sfile,tfile)