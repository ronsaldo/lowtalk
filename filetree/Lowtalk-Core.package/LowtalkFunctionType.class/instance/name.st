accessing
name
	^ name ifNil: [name := ByteString streamContents: [ :out |
		out nextPut: $(.
		arguments doWithIndex: [ :arg :index|
			index > 1 ifTrue: [out nextPutAll: ', '].
			out nextPutAll: arg name.
		].
		out nextPutAll: ') -> '; nextPutAll: returnType name.
		variadic ifTrue: [ out nextPutAll: ' cvariadic' ].
	 ]]