Class {
	#name : #ReSuperWithoutSendTest,
	#superclass : #TestCase,
	#category : #'GeneralRules-Tests-Migrated'
}

{ #category : #tests }
ReSuperWithoutSendTest >> testBasicCheck [

	| ast |
	ast :=  self class compiler parse: 'testMethod ^super'.
	self assert: (ReSuperWithoutSend new basicCheck: ast variableNodes first).
	self deny: (ReSuperWithoutSend new basicCheck: ast statements first).
	ast := self class compiler parse: 'testMethod ^ super doit'.
	self deny: (ReSuperWithoutSend new basicCheck: ast variableNodes first).
	ast := self class compiler parse: 'testMethod ^ self doit: super'.
	self assert: (ReSuperWithoutSend new basicCheck: ast variableNodes second)
]
