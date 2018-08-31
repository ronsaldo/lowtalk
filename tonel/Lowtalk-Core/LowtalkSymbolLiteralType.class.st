Class {
	#name : #LowtalkSymbolLiteralType,
	#superclass : #LowtalkStringLiteralType,
	#category : #'Lowtalk-Core-Types'
}

{ #category : #converting }
LowtalkSymbolLiteralType >> convertLiteralValue: value fromType: sourceType at: aNode [
	^ value asSymbol
]

{ #category : #coercions }
LowtalkSymbolLiteralType >> dispatchArithmeticCoerceWith: otherType [
	^ otherType arithmeticCoerceWithSymbolLiteral: self
]

{ #category : #accessing }
LowtalkSymbolLiteralType >> name [
	^ #_SymbolLiteral
]
