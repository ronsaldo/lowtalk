inline messages
compileInlineWhileMessage: message
	| doneCondition |
	self assert: message arguments size <= 1.
	
	irBuilder jumpBackTarget: #whileLoopCondition.
	self inlineBlock: message receiver.
	
	doneCondition := false.
	(#(whileTrue whileTrue: whileFalse whileFalse:) includes: message selector) ifTrue: [ 
		self coerceInlineBlock: message receiver resultInto: compiler booleanType.
		doneCondition := #(whileFalse whileFalse:) includes: message selector
	] ifFalse: [ 
		self assert: (#(whileNotNil: whileNil:) includes: message selector).
		irBuilder pushLiteral: nil.
		message selector == #whileNotNil: ifTrue: [ 
			irBuilder send: #~~.
		] ifFalse: [ 
			irBuilder send: #==.
		].
	].
	
	irBuilder jumpAheadTo: #whileDone if: doneCondition.

	message arguments size = 1 ifTrue: [
		self inlineBlock: message arguments first.
		irBuilder popTop
	].

	irBuilder jumpBackTo: #whileLoopCondition.
	irBuilder jumpAheadTarget: #whileDone.
	irBuilder pushLiteral: nil.
