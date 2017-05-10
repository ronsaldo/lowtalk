accessing
buildSSAType
	ssaType := SLVMStructureType new.
	ssaType name: self validName;
		kind: SLVMStructureType genericKind;
		types: (fields collect: #ssaType);
		names: self validFieldNames.
	^ ssaType