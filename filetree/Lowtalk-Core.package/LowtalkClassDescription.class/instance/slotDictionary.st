slots
slotDictionary
	^ slotDictionary ifNil: [ slotDictionary := self buildSlotDictionary ]