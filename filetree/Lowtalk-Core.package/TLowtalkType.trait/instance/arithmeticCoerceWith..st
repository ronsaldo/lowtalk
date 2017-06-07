coercions
arithmeticCoerceWith: otherType
	self = otherType ifTrue: [ ^ self ].
	(self isReferenceType or: [ otherType isReferenceType ]) ifTrue: [ ^ self withoutReferences arithmeticCoerceWith: otherType withoutReferences ].
	
	"Always try to convert toward a dynamic object."
	self isDynamicObjectType ifTrue: [ ^ self ].
	otherType isDynamicObjectType ifTrue: [ ^ otherType ].
	
	^ self dispatchArithmeticCoerceWith: otherType