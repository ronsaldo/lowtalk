memory barriers
ssaWriteBarrierNoIncrement
	^ objectModel writeBarrierNoIncrement ifNil: [ ^ nil ] ifNotNil: [ :function | function ssaValue ]