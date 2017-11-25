accessing
buildSSAType
	self slots.
	ssaType := self ssaTypeClass new.
	ssaType name: self validName;
		kind: self ssaTypeClass genericKind;
		types: (fields collect: #ssaType);
		names: self validFieldNames.
	compiler isSandboxed ifFalse: [ ssaType behavior: self classObject ].
	^ ssaType