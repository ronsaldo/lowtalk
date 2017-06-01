as yet unclassified
ssaValueType
	| headerType slotsType |
	headerType := compiler objectModel headerType ssaType.
	slotsType := self ssaSlotsType.
	^ SLVMStructureType name: #objectInstanceType types: { headerType . slotsType} kind: SLVMStructureType genericKind names: #(header slots)