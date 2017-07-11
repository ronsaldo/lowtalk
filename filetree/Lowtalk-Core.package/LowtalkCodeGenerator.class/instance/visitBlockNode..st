visiting
visitBlockNode: aNode
	| definitionAndCaptures definition captures |
	definitionAndCaptures := LowtalkCodeGenerator new compiler: compiler;
		generateClosure: aNode parentCodeGenerator: self.
		
	definition := definitionAndCaptures first.
	captures := definitionAndCaptures second.
	aNode type isBlockType ifTrue: [
		^ builder instantiateClosure: definition captures: captures
	].

	self halt.
	^ builder addDynamicLiteral: nil