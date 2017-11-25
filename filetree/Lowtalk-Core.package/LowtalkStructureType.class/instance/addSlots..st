adding
addSlots: aCollectionOfSlots
	aCollectionOfSlots ifNil: [ ^ self ].
	slots ifNil: [ slots := Dictionary new ].
	
	aCollectionOfSlots doWithIndex: [ :slot :index |
		slot index: index - 1.
		slots at: slot name ifPresent: [ 
			slot node semanticError: 'Structure {1} member name {1} is already in use.' format: { self validName . slot name printString }
		] ifAbsentPut: [ slot ].
	].

	allSlots := allSlots , aCollectionOfSlots.
	fields := fields , (aCollectionOfSlots collect: #type).
	fieldNames := fieldNames , (aCollectionOfSlots collect: #name).
