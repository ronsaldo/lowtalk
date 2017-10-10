as yet unclassified
classTypeForObject: anObject
	^ classTypesForObjects at: anObject ifAbsentPut: [
		(LowtalkClassType target: compilationTarget) classObject: anObject
	]