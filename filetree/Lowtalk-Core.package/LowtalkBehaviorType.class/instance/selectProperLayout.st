slots
selectProperLayout
	layoutType ifNil: [
		(objectSlots isNotEmpty and: [ nativeSlots isNotEmpty ]) ifTrue: [ 
			self flag: 'TODO: Implement support for mixed pointer and native data.'.
			self error: 'mixed pointer and native slots not yet supported.'
		] ifFalse: [ 
			nativeSlots ifNotEmpty: [
				layoutType := #bytes
			] ifEmpty: [ 
				layoutType := #pointers
			]
		]
	]