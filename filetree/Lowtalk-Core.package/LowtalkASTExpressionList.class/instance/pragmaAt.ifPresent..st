enumerating
pragmaAt: aPragmaName ifPresent: aBlock
	pragmaList do: [ :pragma | pragma selector == aPragmaName ifTrue: [ ^ aBlock value: pragma ]].