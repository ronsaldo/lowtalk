as yet unclassified
resolveType
	valueType := self resolveValueType.
	type := (LowtalkReferenceType target: compiler compilationTarget) referenced: valueType.