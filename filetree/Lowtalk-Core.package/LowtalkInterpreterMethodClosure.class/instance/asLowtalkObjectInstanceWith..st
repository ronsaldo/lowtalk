converting
asLowtalkObjectInstanceWith: aCompiler
	| function |
	function := aCompiler generateInterpreterMethod: definition.
	self flag: 'Do we need to encapsulate in a closure?'.
	^ function