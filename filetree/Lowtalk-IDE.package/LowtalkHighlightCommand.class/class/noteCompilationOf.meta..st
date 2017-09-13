private
noteCompilationOf: aSelector meta: isMeta
	isMeta ifTrue: [
		((self class >> aSelector) hasPragmaNamed: #styleTable:) ifTrue: [
			self resetCache
		]
	]