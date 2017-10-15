slots
buildSlots
	self assert: slots isNil.
	slots := Dictionary new.
	slotsList := (slotsExpression value ifNil: #()) collect: [:sl | sl asLowtalkSlotWith: compiler].
	self superclass ifNotNil: [ :sc |
		slotsList := (sc slotsList collect: #copy) , slotsList
	].

	self fillSlotDictionary.
	self applySlotsLayout