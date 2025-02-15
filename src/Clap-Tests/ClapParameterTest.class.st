Class {
	#name : #ClapParameterTest,
	#superclass : #TestCase,
	#category : #'Clap-Tests-Unit'
}

{ #category : #testing }
ClapParameterTest class >> isAbstract [
	^ self = ClapParameterTest
]

{ #category : #testing }
ClapParameterTest class >> shouldInheritSelectors [
	^ true
]

{ #category : #accessing }
ClapParameterTest >> classToTest [
	^ self subclassResponsibility
]

{ #category : #'tests - fixture' }
ClapParameterTest >> namedSubject [
	^ self classToTest id: self subjectName asSymbol
]

{ #category : #'tests - fixture' }
ClapParameterTest >> subjectName [
	^ 'foo'
]

{ #category : #tests }
ClapParameterTest >> testCanonicalName [
	self
		assert: self namedSubject canonicalName
		equals: self subjectName asString
]

{ #category : #tests }
ClapParameterTest >> testIdentifierDerivedFromCanonicalName [
	self
		assert: self namedSubject identifier
		equals: self subjectName asSymbol
]

{ #category : #tests }
ClapParameterTest >> testMismatchesAtEnd [
	| subject argv match |
	subject := self namedSubject.
	argv := #() readStream.

	match := subject matchOn: argv.

	self assert: match isMismatch.
	self
		assert: match specification
		identicalTo: subject
]

{ #category : #tests }
ClapParameterTest >> testSubjectIdentifier [
	| subject |
	subject := self classToTest id: #subjectId.
	subject canonicalName: self subjectName.

	self
		assert: subject identifier
		equals: #subjectId.
	self
		assert: subject canonicalName
		equals: self subjectName
]
