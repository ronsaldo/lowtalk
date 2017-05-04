accessing
parent: aParent
	parent := aParent.
	
	self assert: self isNamespace ==> [ aParent isNamespace ].
	