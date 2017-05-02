printing
printOn: aStream
	aStream nextPutAll: '(chain '; print: receiver.
	messages do: [ :message | aStream space; print: message ].
	aStream nextPut: $)