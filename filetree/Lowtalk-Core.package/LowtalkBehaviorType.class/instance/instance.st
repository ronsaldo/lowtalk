accessing
instance
	<compileTime>
	thisClass ifNil: [ self error: 'Finding the instance type of a non-metaclass type.' ].
	^ thisClass