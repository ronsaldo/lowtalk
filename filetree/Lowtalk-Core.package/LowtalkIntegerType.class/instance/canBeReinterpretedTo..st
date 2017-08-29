testing
canBeReinterpretedTo: targetType
	^ targetType isPointerType or:
	[ targetType isDynamicObjectType or:
	[ targetType isSpecificDynamicObjectType or:
	[ (targetType isIntegerType and: [targetType size = self size]) or:
	[ (targetType isFloatType and: [targetType size = self size]) ] ] ] ]