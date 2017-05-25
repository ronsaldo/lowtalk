converting
convertValue: value toType: targetType at: sendingNode
	targetType isDynamicObjectType ifTrue: [ ^ value ].
	^ super convertValue: value toType: targetType at: sendingNode