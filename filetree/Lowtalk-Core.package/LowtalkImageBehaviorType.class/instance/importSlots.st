as yet unclassified
importSlots
	slotsList := self classObject allSlots collect: [ :sl | sl asLowtalkSlotWith: compiler ].
	self fillSlotDictionary