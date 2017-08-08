converting
convertValue: value toType: targetType at: sendingNode
	self = targetType ifTrue: [ ^ value ].
	^ targetType convertLiteralValue: value fromType: self at: sendingNode