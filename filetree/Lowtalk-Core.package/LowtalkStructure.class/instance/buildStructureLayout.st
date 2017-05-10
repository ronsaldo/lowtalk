as yet unclassified
buildStructureLayout
	| slotData slotDictionary |
	slotData := self slots.
	slotData ifNil: [ ^ self ]. "Opaque structure"
	
	"TODO: Support bit fields."
	slotDictionary := Dictionary new.
	slotData doWithIndex: [ :slot :index |
		slot index: index - 1.
		self setSymbol: slot name value: slot ifPresent: [ 
			slot node semanticError: 'Structure member name {1} is already in use.' format: { slot name printString }
		].
	].

	type fields: (slotData collect: #type).
	type environment: self.
