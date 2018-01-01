# graphlopedia
## Purpose
Create and maintain a database of graphs and networks with mathematical relevance. This database is a *fingerprint database* as defined by Billey and Tenner in <a href="https://sites.math.washington.edu/~billey/papers/fingerprints.pdf"> Fingerprint Databases for Theorems </a>

### Updates and Edits:
* References should be given as a bibtex string for now
* Later goal will be to integrate it as a JSON object, however, this isn't the first priority
  * use pandoc-citeproc --bib2json to convert the bib files into the appropriate JSON
  * Why use JSON instead of bib?:
    - JSON can easly be made into an SQL database for website in future.
    - https://sqlizer.io/#/

* refs can be made by altering https://mathscinet.ams.org/mathscinet/search/publications.html?fmt=bibtex&pg1=MR&s1=1019150 by changing the s1 variable to the appropriate MathSciNet ID number.

* bash script for getting refs: 

~~~~
curl -s "https://mathscinet.ams.org/mathscinet/search/publications.html?fmt=bibtex&pg1=MR&s1=1019150" | sed -n "/<pre>/,/<\/pre>/p" | sed '1d;$d' | pbcopy
~~~~

note: pbcopy should be chaged to clip or xclip

UPDATE:
Test case added to check JSON file
utils added to convert old JSON format to new structure

More updates AGAIN