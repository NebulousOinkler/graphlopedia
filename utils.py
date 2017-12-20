import json
import urllib.request
import re
import bibtexparser

def writeSara2JSON(sfile, tfile):
	sara = json.load(sfile)
	graph = tfile
	vals = list(sara.values())
	graph.write('{')
	graph.write('\"description\": \"Graph Database\",')
	graph.write('\"graphs\": [')
	for entry in vals:
		graph.write('{')

		graph.write(f'\"id\": \"{entry["name"]}\",')
		graph.write(f'\"deg_seq\": {entry["degrees"]},')
		graph.write(f'\"name\": \"{entry["title"]}\",')
		graph.write(f'\"num_vert\": {len(entry["vertices"])},')
		graph.write(f'\"edges\": {entry["edges"]},')
		
		graph.write(f'\"images\": [')
		for image in entry["pictures"]:
			graph.write('{')
			graph.write(f'\"title\": \"{entry["title"]}\",')
			graph.write(f'\"src\": \"{image}\"')
			graph.write('}')
			if image != entry["pictures"][-1]:
				graph.write(',')
		graph.write('],')

		graph.write(f'\"links\": [')
		for link in entry["links"]:
			graph.write('{')
			graph.write(f'\"url\": \"{link}\"')
			graph.write('}')
			if link != entry["links"][-1]:
				graph.write(',')
		graph.write('],')

		graph.write(f'\"refs\": [')
		ref_list = autoBibRefs(entry["references"])
		graph.write(ref_list)
		graph.write('],')

		graph.write(f'\"comments\": {json.dumps(entry["comments"])},')

		graph.write(f'\"contrib\": [')
		for author in entry["authors"]:
			graph.write('{')
			graph.write(f'\"fi\": \"{author[0]}\",')
			graph.write(f'\"fname\": \"{author.rsplit(" ",1)[0]}\",')
			graph.write(f'\"lname\": \"{author.rsplit(" ",1)[1]}\"')
			graph.write('}')
			if author != entry["authors"][-1]:
				graph.write(',')
		graph.write(']')
		graph.write('}')
		if entry != vals[-1]:
			graph.write(',')
	graph.write(']')

	graph.write('}')

def autoBibRefs(sara_refs):
	counter = 0
	output = ""
	while True:
		print("\n"*50)
		for x in sara_refs:
			print('** ' + x)
		print(f'\n\n# of Refs: {len(sara_refs)}')
		print(f'# inputted: {counter}')

		option = input("Reference Code: ")
		trigger = option[:2]

		if trigger == 'MR':
			mr_num = option[2:]
			url = "https://mathscinet.ams.org/mathscinet/search/publications.html?fmt=bibtex&pg1=MR&s1="+mr_num
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