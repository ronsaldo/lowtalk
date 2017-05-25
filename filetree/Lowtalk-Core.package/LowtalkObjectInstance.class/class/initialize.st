initialization
initialize
	ClassPrimitiveSelectors := Set newFrom: #(basicNew basicNew:).
	ObjectPrimitiveSelectors := Set newFrom: #(
		basicAt: basicAt:put: basicSize
		identityHash class
		== ~~
		castTo:
		).
	