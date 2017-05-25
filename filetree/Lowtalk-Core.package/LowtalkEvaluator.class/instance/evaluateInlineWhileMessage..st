as yet unclassified
evaluateInlineWhileMessage: message
	| selector blockCullArguments blockCullArgumentTypes condition |
	selector := message selector.	
	blockCullArguments := #().
	blockCullArgumentTypes := #().
	
	condition := nil.
	
	#whileFalse: == selector ifTrue: [
		condition := [ :value | value == false ]
	].
	#whileTrue: == selector ifTrue: [
		condition := [ :value | value == true ]
	].
	#whileNil: == selector ifTrue: [
		condition := [ :value | value == nil ]
	].
	#whileNotNil: == selector ifTrue: [
		condition := [ :value | value ~~ nil ]
	].

	[ condition value: (self evaluateInlineBlock: message receiver arguments: #() types: #() at: message) ] whileTrue:
	[
		self evaluateInlineBlock: message arguments first arguments: #() types: #() at: message
	].
	^ nil