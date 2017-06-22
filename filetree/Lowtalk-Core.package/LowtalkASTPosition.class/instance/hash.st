comparing
hash
	^ self class identityHash bitXor:
		( collection identityHash bitXor: 
		( start hash bitXor: stop hash))