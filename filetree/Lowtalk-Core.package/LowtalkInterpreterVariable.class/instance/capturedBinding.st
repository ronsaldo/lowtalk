accessing
capturedBinding
	self valueType isMetaType ifTrue: [
		self value ifNotNil: [ :v | ^ v binding ]
	].
	^ self binding