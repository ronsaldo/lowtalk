converting
convertValue: value toSSAConstantWith: compiler
	| convertedSlots |
	convertedSlots := value slotValues collect: [ :slot | baseType convertValue: slot toSSAConstantWith: compiler].
	^ SLVMConstant array: self ssaType slots: convertedSlots