accessing
chainExpression
	^ super chainExpression ==> [ :list |
		list third ifEmpty: [
			list second ifNil: [
				list first
			] ifNotNil: [
				list second copy receiver: list first
			]
		] ifNotEmpty: [
			| position chained |
			position := list third first first.
			chained := list third collect: #second.
			list second ifNil: [
				list first isMessageSend ifFalse: [ 
					PPFailure message: 'a chain has to start with a message send'
				] ifTrue: [
					LowtalkASTMessageChain new
						position: position;
						receiver: list first receiver;
						messages: { list first copy receiver: nil; yourself } , chained;
						yourself
				]
			] ifNotNil: [
				LowtalkASTMessageChain new
					position: position;
					receiver: list first;
					messages: { list second } , chained;
					yourself
			]
		]
	]