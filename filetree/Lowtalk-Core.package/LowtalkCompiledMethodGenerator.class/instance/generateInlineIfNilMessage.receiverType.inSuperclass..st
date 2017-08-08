inline messages
generateInlineIfNilMessage: message receiverType: receiverType inSuperclass: inSuperclass
	| receiverValueType |
	receiverValueType := receiverType withoutReferences.
	self coerceImplicitlyFrom: receiverType to: receiverValueType at: message.
	
	irBuilder
		pushDup;
		pushLiteral: nil;
		send: #==;
		jumpAheadTo: #ifElse if: (#(ifNotNil: ifNotNil:ifNil:) includes: message selector).

	(#(ifNil: ifNil:ifNotNil:) includes: message selector) ifTrue: [
		irBuilder popTop.
		self inlineBlock: message arguments first.
		self coerceInlineBlock: message arguments first resultInto: message type.
	] ifFalse: [
		self inlineBlock: message arguments first cull: 1 types: {receiverValueType}.
		self coerceInlineBlock: message arguments first resultInto: message type.
	].
	
	irBuilder jumpAheadTo: #ifMerge.

	irBuilder jumpAheadTarget: #ifElse.
	message arguments size > 1 ifTrue: [ 
		(message selector == #ifNotNil:ifNil:) ifTrue: [
			irBuilder popTop.
			self inlineBlock: message arguments second.
			self coerceInlineBlock: message arguments second resultInto: message type.
		] ifFalse: [
			self inlineBlock: message arguments second cull: 1 types: {receiverValueType}.
			self coerceInlineBlock: message arguments second resultInto: message type.
		].
	].

	irBuilder jumpAheadTarget: #ifMerge.
