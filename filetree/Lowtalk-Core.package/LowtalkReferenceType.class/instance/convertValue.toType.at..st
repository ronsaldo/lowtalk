converting
convertValue: value toType: targetType at: sendingNode
	targetType isReferenceType ifFalse: [ 
		^ referenced convertValue: value value toType: targetType at: sendingNode
	].
	^ super convertValue: value toType: targetType at: sendingNode