as yet unclassified
evaluateInlineIfMessage: message receiver: receiver receiverType: receiverType inSuperclass: superClass
	| selector blockCullArguments blockIndex emptyResult blockCullArgumentTypes result resultType |
	selector := message selector.	
	blockCullArguments := #().
	blockCullArgumentTypes := #().
	emptyResult := receiver.
	(#(ifNil: ifNotNil: ifNil:ifNotNil: ifNotNil:ifNil:) includes: selector) ifTrue: [ 
		receiver ifNil: [
			blockIndex := (#(ifNil: ifNil:ifNotNil:) includes: selector) ifTrue: [ 1 ] ifFalse: [ 2 ].
		] ifNotNil: [
			blockIndex := (#(ifNotNil: ifNotNil:ifNil:) includes: selector) ifTrue: [ 1 ] ifFalse: [ 2 ].
			blockCullArguments := { receiver }.
			blockCullArgumentTypes := { receiverType withoutReferences }
		]
	].

	(#(ifTrue: ifFalse: ifTrue:ifFalse: ifFalse:ifTrue:) includes: selector) ifTrue: [ 
		emptyResult := nil.
		receiver == true ifTrue: [
			blockIndex := (#(ifTrue: ifTrue:ifFalse:) includes: selector) ifTrue: [ 1 ] ifFalse: [ 2 ].
		] ifFalse: [ 
			receiver == false ifTrue: [
				blockIndex := (#(ifFalse: ifFalse:ifTrue:) includes: selector) ifTrue: [ 1 ] ifFalse: [ 2 ].
			] ifFalse: [
				^ self evaluateNormalMessage: message receiver: receiver receiverType: receiverType inSuperclass: superClass
			]
		].
	].

	blockIndex > message arguments size ifTrue: [ ^ emptyResult ].
	result := self cullInlineBlock: (message arguments at: blockIndex) arguments: blockCullArguments types: blockCullArgumentTypes at: message.
	resultType := (message arguments at: blockIndex) type withoutReferences returnType.
	^ resultType convertValue: result toType: message type at: message