accessing
evaluateInEnvironment: environment at: node
	^ environment receiverType instanceOrNil ifNil: [ environment compiler objectType ]