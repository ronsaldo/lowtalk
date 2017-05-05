accessing
ssaType
	^ ssaType ifNil: [ssaType := self buildSSAType ]