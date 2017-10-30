coercions
implicitlyConvertedTo: targetType at: node
	self flag: 'TODO: Remove this conversion hack.'.
	(targetType isSpecialSelfType and: [ node isSelf or: [ node isSuper ] ]) ifTrue: [ 
		^ self
	].

	(self canBeImplicitlyConvertedTo: targetType) ifFalse: [
		node semanticError: 'Cannot implicitly convert value of type "{1}" to type "{2}"' format: { self name . targetType name }
	]