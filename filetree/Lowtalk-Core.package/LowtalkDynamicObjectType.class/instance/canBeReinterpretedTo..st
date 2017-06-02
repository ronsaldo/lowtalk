testing
canBeReinterpretedTo: targetType
	^ targetType isPointerType or: [ targetType isDynamicObjectType or: [ targetType isSpecificDynamicObjectType ] ]