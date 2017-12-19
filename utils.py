import json

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
		graph.write('\"\"')
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

if __name__ == '__main__':
	with open('./Graphlopedia_2017-12-05-193532/newgraphs.json') as sfile:
		with open('./graphs.json', 'w') as tfile:
			writeSara2JSON(sfile,tfile)