as yet unclassified
createPublicAccessors
	"TODO: Create the public accessors"
	self slots valuesDo: [ :slot |
		slot createPublicAccessorsOn: self
	]