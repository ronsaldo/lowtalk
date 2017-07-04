initialization
initialize
	StructureMetaMessageTypes := Dictionary newFromPairs: #(
		basicNew StructureNew
		new StructureNew
		basicNewPointer StructureNewPointer
		newPointer StructureNewPointer
	)