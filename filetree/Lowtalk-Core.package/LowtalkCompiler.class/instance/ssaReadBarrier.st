memory barriers
ssaReadBarrier
	^ objectModel readBarrier ifNil: [ nil ] ifNotNil: [ :function | function ssaValue ]