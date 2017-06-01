converting
asSSAConstantValueIn: module
	| slotValues |
	slotValues := slots collect: [ :slot |
		slot valueType convertValue: slot value toSSAConstantWith: type compiler
	].

	^ SLVMConstant structure: type ssaType slots: slotValues