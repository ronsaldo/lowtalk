visiting
isMessageACandidateForInlining: message receiver: receiver
	receiver isSuper ifTrue: [ ^ false ].
	message isCascaded ifTrue: [ ^ false ].
	^ true