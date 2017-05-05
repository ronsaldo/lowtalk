accessing
buildSSAType
	^ SLVMStructureType name: self validName types: (fields collect: #ssaType) kind: SLVMStructureType genericKind names: self validFieldNames