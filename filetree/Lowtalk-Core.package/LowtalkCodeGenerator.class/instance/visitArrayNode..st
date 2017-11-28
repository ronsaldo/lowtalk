visiting
visitArrayNode: aNode
	| arrayClass arraySize arrayObject value elementPointer |
	self assert: aNode type isDynamicObjectType.

	"Create the array object"
	arrayClass := builder addDynamicLiteral: compiler objectModel arrayClass.
	arraySize := aNode expressionList size.
	arrayObject := builder send: (builder addDynamicLiteral: #basicNew:)
		returnType: compiler objectType ssaType
		receiver: arrayClass arguments: { builder addDynamicLiteral: arraySize }.
		
	"Set the array elements"
	aNode expressionList doWithIndex: [ :valueExpression :index |
		value := self coerceImplicitly: (self visitNode: valueExpression) type: valueExpression type to: compiler objectType at: valueExpression.
		elementPointer := builder getReference: arrayObject element: (builder constInt: index - 1).
		builder store: value in: elementPointer
	].

	^ arrayObject