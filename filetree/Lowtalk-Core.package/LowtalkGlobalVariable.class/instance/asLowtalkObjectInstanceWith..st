converting
asLowtalkObjectInstanceWith: aCompiler
	bindingObject ifNotNil: [ ^ bindingObject ].
	
	(self valueType isFunctionType and: [ self isConstant ]) ifTrue: [
		(self ssaValue isExternal and: [ self ssaValue isEmpty ]) ifTrue: [ ^ nil ].
		"^ self ssaValue compiledMethodMetaDataValue"
		^ bindingObject := aCompiler objectModel createGlobalVariableAssociationFunction value: self name value: self ssaValue compiledMethodMetaDataValue
	] ifFalse: [
		(self ssaValue isExternal and: [ self ssaValue initialValue isNil ]) ifTrue: [ ^ nil ].
			
		^ self ssaValue headerReferenceOfType: aCompiler objectType
	].
	