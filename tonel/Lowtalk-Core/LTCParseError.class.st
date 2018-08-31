Class {
	#name : #LTCParseError,
	#superclass : #LTCError,
	#category : #'Lowtalk-Core-Exception'
}

{ #category : #accessing }
LTCParseError >> description [
	"Return a textual description of the exception."

	^ self messageText
]
