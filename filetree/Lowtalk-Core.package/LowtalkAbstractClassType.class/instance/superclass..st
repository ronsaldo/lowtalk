superclass
superclass: superClassLazyValue
	<compileTime>
	<lazy>
	superclass ifNotNil: [ superClassLazyValue semanticError: 'Cannot change the super class of a class that is already instantiated.' ].

	self
		superclassExpression: superClassLazyValue.