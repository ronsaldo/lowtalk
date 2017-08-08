coercions
irConvertExplicitlyTo: targetType with: irBuilder at: node
	targetType isBooleanType ifTrue: [ ^ self].
	targetType isIntegerType ifTrue: [ ^ irBuilder
		send: #asInteger;
		pushLiteral: targetType;
		send: #lowtalkTruncateLiteralValueWithType:
	].
	targetType isFloatType ifTrue: [
		^ irBuilder send: #asFloat;
		pushLiteral: targetType;
		send: #lowtalkTruncateLiteralValueWithType:
	].
	targetType isSpecificDynamicObjectType ifTrue: [ ^ self ].
	
	targetType isPointerType ifTrue: [
		self halt
	].
	
	^ super irConvertExplicitlyTo: targetType with: irBuilder at: node