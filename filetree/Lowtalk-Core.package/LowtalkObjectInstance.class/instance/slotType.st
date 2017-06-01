as yet unclassified
slotType
	slots class = ByteArray ifTrue: [ ^ compiler byteType ].
	slots class = Array ifTrue: [ ^ compiler objectType ].
	self halt