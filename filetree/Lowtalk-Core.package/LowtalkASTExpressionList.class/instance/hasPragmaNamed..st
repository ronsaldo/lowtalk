enumerating
hasPragmaNamed: aPragmaName
	pragmaList do: [ :pragma | pragma selector == aPragmaName ifTrue: [^ true ]].
	^ false