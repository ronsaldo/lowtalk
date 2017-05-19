message dispatching
lowtalkPerform: selector withArguments: arguments inSuperclass: superClass node: sendingNode
	| precedence slot value valueType |
	(selector == #class) ifTrue: [ ^ type ].
	
	precedence := selector precedence.
	precedence = 1 ifTrue: [ 
		type slotNamed: selector ifPresent: [ :slotDescription |
			^ slots at: slotDescription index + 1
		]
	].
	precedence = 3 ifTrue: [
		type slotNamed: selector allButLast ifPresent: [ :slotDescription |
			slot := slots at: slotDescription index + 1.
			value := arguments first value.
			valueType := arguments first inferType.
			slot value: (valueType convertValue: value toType: slot valueType at: sendingNode).
			^ self
		]
	].

	^ super lowtalkPerform: selector withArguments: arguments inSuperclass: superClass node: sendingNode