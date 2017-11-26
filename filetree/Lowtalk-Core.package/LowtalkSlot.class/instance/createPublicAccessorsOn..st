as yet unclassified
createPublicAccessorsOn: behavior
	self isPrivate ifTrue: [ ^ self ].
	self createGetterOn: behavior.
	self createSetterOn: behavior.