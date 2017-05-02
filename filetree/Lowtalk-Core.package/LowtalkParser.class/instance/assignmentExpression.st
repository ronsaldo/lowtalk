accessing
assignmentExpression
	^ super assignmentExpression ==> [ :list |
		list second ifNotNil: [
			LowtalkASTAssignment new
				position: list second first;
				reference: list first;
				value: list second second;
				yourself
		] ifNil: [
			list first
		]
	]