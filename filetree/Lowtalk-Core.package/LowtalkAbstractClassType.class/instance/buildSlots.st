slots
buildSlots
	self assert: slots isNil.
	slots := Dictionary new.
	slotsList := (slotsExpression value ifNil: #()) collect: [:sl | sl asLowtalkSlotWith: compiler].
	self superclass ifNotNil: [ :sc |
		slotsList := slotsList , (sc slotsList collect: #copy)
	].

	self fillSlotDictionary.
	self applySlotsLayout