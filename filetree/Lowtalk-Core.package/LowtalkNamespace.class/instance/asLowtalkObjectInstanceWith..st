converting
asLowtalkObjectInstanceWith: aCompiler
	^ self ssaValue ifNotNil: [:value | value headerReferenceOfType: aCompiler objectType]