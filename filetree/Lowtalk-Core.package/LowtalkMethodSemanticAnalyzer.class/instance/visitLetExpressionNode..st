visiting
visitLetExpressionNode: node
	"Infer the proper type of the let expression."
	| variable |
	node typeExpression ifNotNil: [
		node valueType: (self solveTypeExpression: node typeExpression).
	].

	"Check the node value"
	node initialValue ifNotNil: [
		node initialValue accept: self.
		node valueType ifNil: [ node valueType: node initialValue type asValueType ].
		node initialValue type implicitlyConvertedTo: node valueType at: node
	].

	"Create the local variable."
	variable := LowtalkMethodLocalVariable new
		valueType: node valueType;
		name: node identifier;
		isConstant: false.
	environment setSymbol: variable name value: variable ifPresent: [ 
		node semanticError: 'Local variable name {1} is already in use in the current scope.' format: { variable name printString }
	].

	node binding: variable.
	method addTemporary: variable.
	node type: node valueType ref.
	