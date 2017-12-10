import json
import ast
import os
import sys

latex = open("latex.tex", 'w')
latex.write("\\documentclass{article}\n" + "\\usepackage{spverbatim}\n" + "\\usepackage{listings}\n")
latex.write('\\usepackage{etoolbox, listing}\n')
latex.write('\\usepackage[left=1.0in,right = 1.0in,top = 1.0in, bottom = 1.0in]{geometry}')
latex.write('\lstset{\n' + 'basicstyle=\small\\ttfamily,\n' + 'columns=flexible,\n' + 'breaklines=true\n' + '}\n')
#latex.write("\setlength{\oddsidemargin}{0in}\n\setlength{\evensidemargin}{0in} \n\setlength{\\textwidth}{6.5in}\n\setlength{\headsep}{0pt}\n\setlength{\headheight}{0pt}\n\setlength{\\topmargin}{0in}\n\setlength{\\textheight}{9.5in}\n")
latex.write("\pagenumbering{gobble}\n")
latex.write("\\begin{document}\n")


def makeString(x):
  #need to turn lists and keys into strings to write them to file
  if type(x) == str:
    return(x)

  if type(x) == list:
    
    if not x:
      return("[]")

    else:
      if type(x[0]) == str:
        temp = ""
        for index in x:
          temp = temp + index + ", "
        temp = temp[:-2] #Gets rid of last comma
        return(temp)

      else:
        temp = ""
        for index in x:
          temp = temp + str(index) + ","
        temp = temp[:-1] #comma
        return("[" + temp + "]")

def mathMode(value):
  #split strings by $ to print in math mode or verbatim
  tempo = value.split('$')
  for index in range(len(tempo)):
    if index%2 == 0:
      tempo[index] = tempo[index]
    else:
      tempo[index] = '$' + tempo[index] + '$'
  return(''.join(tempo))

if len(sys.argv) < 2:
    print("You must supply a file name as an argument when running this program.")
    sys.exit(2)
    
data = json.load(open(sys.argv[1]))

for [key, value] in data.items():
  latex.write(key + "\n\n")
  for [key1, value1] in value.items():
    if key1 == 'links':
      latex.write("\\textbf{" + key1 + "}" + ": \\verb;" + makeString(value1) + ";\n\n")
    else:
      latex.write("\\textbf{" + key1 + "}" + ": " + mathMode(makeString(value1)) + '\n\n')
  latex.write("\\newpage")
  latex.write("\n")
  
latex.write("\end{document}")
latex.close()

#os.system("pdflatex latex.tex")

#need to fix underscores and create hyperlinks on references




