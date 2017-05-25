accessing
asLowtalkTypeIn: aNode
	(compiler objectModel isRegisteredClass: self) ifFalse: [ 
		aNode semanticError: 'Expected a type object.'
	].

	^ (LowtalkClassType target: compiler compilationTarget) classObject: self