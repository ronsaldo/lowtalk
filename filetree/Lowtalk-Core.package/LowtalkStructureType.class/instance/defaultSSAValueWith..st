accessing
defaultSSAValueWith: builder
	self slots.
	^ SLVMConstant structure: self ssaType
		slots: (allSlots collect: [ :s | s type defaultSSAValueWith: builder ])