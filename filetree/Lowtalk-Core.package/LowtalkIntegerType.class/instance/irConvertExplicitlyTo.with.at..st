coercions
irConvertExplicitlyTo: targetType with: irBuilder at: node
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
	
	^ super irConvertExplicitlyTo: targetType with: irBuilder at: node