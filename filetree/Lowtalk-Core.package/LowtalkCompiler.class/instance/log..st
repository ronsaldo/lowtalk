compiling
log: string
	verbose ifTrue: [
		FileStream stdout nextPutAll: string; lf.
	]