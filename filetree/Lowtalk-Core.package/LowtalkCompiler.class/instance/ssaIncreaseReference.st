memory barriers
ssaIncreaseReference
	^ objectModel increaseReference ifNil: [ ^ nil ] ifNotNil: [ :function | function ssaValue ]