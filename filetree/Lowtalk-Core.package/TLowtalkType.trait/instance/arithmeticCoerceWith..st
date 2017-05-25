coercions
arithmeticCoerceWith: otherType
	self = otherType ifTrue: [ ^ self ].
	
	"Always try to convert toward a dynamic object."
	self isDynamicObjectType ifTrue: [ ^ self ].
	otherType isDynamicObjectType ifTrue: [ ^ otherType ].
	
	^ self dispatchArithmeticCoerceWith: otherType