private
attributesFor: anAttributeName
	^ self textAttributes at: anAttributeName ifAbsentPut: [ self parseAttributes: anAttributeName ]