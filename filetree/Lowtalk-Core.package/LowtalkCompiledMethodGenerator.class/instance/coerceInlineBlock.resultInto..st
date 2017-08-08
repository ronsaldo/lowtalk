visiting
coerceInlineBlock: blockNode resultInto: targetType
	blockNode isBlockNode ifFalse: [ 
		self halt.
	].

	self coerceImplicitlyFrom: blockNode returnType to: targetType at: blockNode