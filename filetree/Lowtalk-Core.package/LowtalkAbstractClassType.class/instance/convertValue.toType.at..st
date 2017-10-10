converting
convertValue: value toType: targetType at: sendingNode
	targetType isClassType ifTrue: [ ^ value ].
	^ super convertValue: value toType: targetType at: sendingNode