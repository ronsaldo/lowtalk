slots
buildSlotDictionary
	| result superInstanceSize |
	superInstanceSize := self superclass ifNil: [0] ifNotNil: #instanceSize.
	instanceSize := superInstanceSize + slots size.
	result := Dictionary new.
	slots doWithIndex: [ :slot :index |
		slot index: superInstanceSize + index - 1.
		result at: slot name put: slot
	].
	^ result