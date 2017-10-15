accessing
metaClass
	metaClass ifNotNil: [ ^ metaClass ].
	classObject ifNotNil: [
		^ metaClass := classObject behavior asClassType
	].

	metaClassClass ifNil: [ 
		metaClassClass := self metaSuperclass metaClassClass.
		self assert: metaClassClass isNotNil.
	].

	metaClass := self class target: compilationTarget.
	metaClass
		compiler: compiler;
		name: (name , ' class') asSymbol;
		metaClass: metaClassClass;
		metaClassClass: metaClassClass;
		thisClass: self;
		superclass: self metaSuperclass;
		environment: self environment;
		slotsExpression: metaSlotsExpression.

	compiler addPendingObject: metaClass.
	^ metaClass