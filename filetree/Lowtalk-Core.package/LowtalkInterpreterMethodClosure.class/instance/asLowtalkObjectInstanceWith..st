converting
asLowtalkObjectInstanceWith: aCompiler
	| function |
	function := aCompiler generateInterpreterMethod: definition. 
	^ function