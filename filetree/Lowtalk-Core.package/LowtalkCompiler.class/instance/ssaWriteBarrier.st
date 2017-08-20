memory barriers
ssaWriteBarrier
	^ objectModel writeBarrier ifNil: [ ^ nil ] ifNotNil: [ :function | function ssaValue ]