from tkinter import *
import json
import bibtexparser

class App:
	def __init__(self, master, graphs_dict):
# Load Root Frame
		self.frame = Frame(master)
		self.frame.pack()

# Save JSON Dict
		self.graphs = graphs_dict["graphs"]
		self.g_index = 0

# Info Frame
		self.info_frame = Frame(self.frame)
		self.info_frame.grid(row=1,column=1)

# Info
		self.filler = Frame(self.info_frame)
		self.filler.grid(row=1,column=1)
		Label(self.filler,text="", width=50).grid(row=1,column=1)

		self.header = Frame(self.filler)
		self.header.grid(row=1,column=1)

		self.ref_frame = Frame(self.filler)
		self.ref_frame.grid(row=2,column=1)

# Text Frame
		self.text_frame = Frame(self.frame)
		self.text_frame.grid(row=1,column=2)

# Textbox
		self.textbox = Frame(self.text_frame)
		self.textbox.grid(row=1,column=1)
		self.scroll = Scrollbar(self.textbox)
		self.tbox = Text(self.textbox, height=30, width=50)
		self.tbox.pack(side=LEFT, fill=Y)
		self.scroll.pack(side=RIGHT,fill=Y)
		self.scroll.config(command=self.tbox.yview)
		self.tbox.config(yscrollcommand=self.scroll.set)

# Buttons
		self.buttons = Frame(self.text_frame)
		self.buttons.grid(row=2,column=1)
		self.fill_info(self.graphs[self.g_index])

		self.quit = Button(self.buttons, text="Quit", fg="red", width=10, command=self.frame.quit)
		self.quit.grid(row=1,column=4)
		self.next = Button(self.buttons, text="Next", width=10, command=self.next_graph)
		self.next.grid(row=1,column=3)
		self.prev = Button(self.buttons, text="Previous", width=10, command=self.prev_graph)
		self.prev.grid(row=1,column=2)

	def fill_info(self, G):
		self.header.destroy()
		self.ref_frame.destroy()
		self.tbox.delete(1.0, END)

		self.header = Frame(self.filler)
		self.header.grid(row=1,column=1)
		self.ref_frame = Frame(self.filler)
		self.ref_frame.grid(row=2,column=1)

		self.save = Button(self.buttons, text="Save", fg="green", width=10, command= lambda: self.save_contents(G))
		self.save.grid(row=1,column=1)
		
		self.id = Label(self.header,text=G["id"])
		self.id.grid(row=1,column=1)
		self.name = Label(self.header,text=G["name"])
		self.name.grid(row=2,column=1)

		for index, ref in enumerate(G["refs"]):
			block = Frame(self.ref_frame)
			block.pack()
			if ref:
				self.aty = ", ".join([ref["author"], ref["title"], str(ref["year"])])
				self.ref_label = Text(block, height=3, width=35, wrap=WORD, borderwidth=3)
				self.ref_label.insert(END, self.aty)
				self.ref_label.config(state=DISABLED)
				self.ref_label.pack(side=LEFT)

				DeleteRefButton(index, block, G, self.delete_contents)


	def delete_contents(self, index, block, G):
		ref_list = G["refs"]
		del ref_list[index]
		block.destroy()
		self.fill_info(G)

	def save_contents(self, G):
		contents = self.tbox.get(1.0, END)
		if contents:
			bib_dict = bibtexparser.loads(contents).entries[0]
			G["refs"].append(bib_dict)
			self.fill_info(G)

	def next_graph(self):
		self.g_index += 1
		self.fill_info(self.graphs[self.g_index])

	def prev_graph(self):
		self.g_index -= 1
		self.fill_info(self.graphs[self.g_index])

class DeleteRefButton:

	def __init__(self, index, block, G, command):
		self.index = index
		self.block = block

		self.delete = Button(self.block, text="Del", fg="red", width=5, command= lambda: command(self.index, self.block, G) )
		self.delete.pack(side=RIGHT)

if __name__ == '__main__':
	root = Tk()
	with open('./graphs.json') as sfile:
		graphs_dict = json.load(sfile)
		app = App(root, graphs_dict)

	root.mainloop()
	
	with open('./graphs.json', 'w') as tfile:
		json.dump(graphs_dict,tfile)
#	root.destroy()