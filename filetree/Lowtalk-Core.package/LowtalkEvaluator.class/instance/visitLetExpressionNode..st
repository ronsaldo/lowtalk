visiting
visitLetExpressionNode: node
	| initialValue variable |
	node typeExpression ifNotNil: [
		node valueType: (self solveTypeExpression: node typeExpression).
	].

	"Check the node value"
	node initialValue ifNotNil: [
		initialValue := self visitNode: node initialValue.
		node valueType ifNil: [
			node valueType: (initialValue lowtalkInferTypeForNodeType: node initialValue type asValueType)
		] ifNotNil: [ 
			node initialValue type implicitlyConvertedTo: node valueType at: node
		].
		initialValue := node initialValue type convertValue: initialValue toType: node valueType at: node
	] ifNil: [
		node valueType ifNil: [ node valueType: compiler objectType ].
		initialValue := node valueType defaultValue
	].

	variable := LowtalkCompileTimeLocalVariable new
			name: node identifier;
			value: initialValue;
			valueType: node valueType;
			compiler: self compiler;
			yourself.
	environment setSymbol: variable name value: variable ifPresent: [
		node semanticError: 'Variable name {1} is already in use in this scope.' format: { variable name printString }.
	].

	node setTypeIfNil: node valueType ref.
	^ variable