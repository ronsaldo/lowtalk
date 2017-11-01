initialization
initialize
	StructureMetaMessageTypes := Dictionary newFromPairs: #(
		basicNew StructureNewObject
		new StructureNewObject
		basicNewValue StructureNew
		newValue StructureNew
		basicNewPointer StructureNewPointer
		newPointer StructureNewPointer
	)