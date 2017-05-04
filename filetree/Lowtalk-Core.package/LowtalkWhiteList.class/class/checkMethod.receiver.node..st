as yet unclassified
checkMethod: method receiver: receiver node: sendingNode
	| selector |
	selector := method selector.
	(method hasPragmaNamed: #compileTime) ifTrue: [ ^ self ].
	(SelectorsAlwaysAllowed includes: selector) ifTrue: [ ^ self ].

	^ sendingNode semanticError: 'Compile time expression calling unsupported selector {1}' format: { selector }.