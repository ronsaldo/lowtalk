accessing
resolveValueType
	| result |
	typeExpression ifNotNil: [
		result := typeExpression value.
		(result isFunctionType and: [ self isVisibleInC and: [ result hasSmalltalkConvention ]]) ifTrue: [ 
			result cdecl.
		].
		^ result
	].
	self halt