from html.parser import HTMLParser

url = "https://mathscinet.ams.org/mathscinet/search/publications.html?fmt=bibtex&pg1=MR&s1=1019150"
page = urllib.request.urlopen(url)
rawHTML = page.read()

parser = HTMLParser()
t = parser.feed(rawHTML)
print(t)