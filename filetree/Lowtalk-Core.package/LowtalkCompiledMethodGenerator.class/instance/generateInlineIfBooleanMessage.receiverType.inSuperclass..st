inline messages
generateInlineIfBooleanMessage: message receiverType: receiverType inSuperclass: inSuperclass
	| receiverValueType |
	receiverValueType := receiverType withoutReferences.
	self coerceImplicitlyFrom: receiverType to: receiverValueType at: message.
	
	irBuilder jumpAheadTo: #ifElse if: (#(ifFalse: ifFalse:ifTrue:) includes: message selector).
	self inlineBlock: message arguments first.
	self coerceInlineBlock: message arguments first resultInto: message type.
	irBuilder jumpAheadTo: #ifMerge.

	irBuilder jumpAheadTarget: #ifElse.
	message arguments size > 1 ifTrue: [ 
		self inlineBlock: message arguments second.
		self coerceInlineBlock: message arguments second resultInto: message type.
	] ifFalse: [ 
		irBuilder pushLiteral: nil
	].
	irBuilder jumpAheadTarget: #ifMerge.
