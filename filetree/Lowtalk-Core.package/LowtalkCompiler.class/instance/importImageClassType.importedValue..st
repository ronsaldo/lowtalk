as yet unclassified
importImageClassType: aBehavior importedValue: aValue
	self assert: isSandboxed not.
	^ importedImageClasses at: aBehavior put: aValue