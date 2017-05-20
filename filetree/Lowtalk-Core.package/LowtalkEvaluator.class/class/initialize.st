initialization
initialize
	
	InlineMessages := Dictionary newFromPairs: #(
		ifNil: evaluateInlineIfMessage:receiver:receiverType:inSuperclass:
		ifNotNil: evaluateInlineIfMessage:receiver:receiverType:inSuperclass:
		ifTrue: evaluateInlineIfMessage:receiver:receiverType:inSuperclass:
		ifFalse: evaluateInlineIfMessage:receiver:receiverType:inSuperclass:
		
		ifNil:ifNotNil: evaluateInlineIfMessage:receiver:receiverType:inSuperclass:
		ifNotNil:ifNil: evaluateInlineIfMessage:receiver:receiverType:inSuperclass:
		ifTrue:ifFalse: evaluateInlineIfMessage:receiver:receiverType:inSuperclass:
		ifFalse:ifFalse: evaluateInlineIfMessage:receiver:receiverType:inSuperclass:
	).
	