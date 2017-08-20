memory barriers
ssaReleaseReference
	^ objectModel releaseReference ifNil: [ ^ nil ] ifNotNil: [ :function | function ssaValue ]