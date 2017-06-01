module construction
translateSSAConstant: value type: valueType
	^ valueType convertValue: value toSSAConstantWith: self