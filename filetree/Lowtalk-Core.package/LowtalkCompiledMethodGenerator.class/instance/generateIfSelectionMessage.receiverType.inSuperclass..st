inline messages
generateIfSelectionMessage: message receiverType: receiverType inSuperclass: inSuperclass
	(#(ifTrue: ifFalse: ifTrue:ifFalse: ifFalse:ifTrue:) includes: message selector) ifTrue: [
		^ self generateInlineIfBooleanMessage: message receiverType: receiverType inSuperclass: inSuperclass
	].

	(#(ifNil: ifNotNil: ifNil:ifNotNil: ifNotNil:ifNil:) includes: message selector) ifTrue: [ 
		^ self generateInlineIfNilMessage: message receiverType: receiverType inSuperclass: inSuperclass
	].

	self error: 'Unsuporter if selection message'.