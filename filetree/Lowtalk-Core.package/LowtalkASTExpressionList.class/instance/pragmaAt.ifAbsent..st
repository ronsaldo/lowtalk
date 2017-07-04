enumerating
pragmaAt: aPragmaName ifAbsent: aBlock
	pragmaList do: [ :pragma | pragma selector == aPragmaName ifTrue: [ ^ pragma ]].
	^ aBlock value