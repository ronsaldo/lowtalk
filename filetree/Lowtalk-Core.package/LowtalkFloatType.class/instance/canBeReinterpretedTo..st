testing
canBeReinterpretedTo: targetType
	^ targetType isIntegerType and: [targetType size = self size]