"
I am a special Debugger for syntax errors encountered when filing in class descriptions from a non-interactive source such as an external file. As a StringHolder, the string to be viewed is the method code or expression containing the error.

The user may fix the error and accept the method to continue the fileIn.

"
Class {
	#name : #SyntaxErrorDebugger,
	#superclass : #Object,
	#instVars : [
		'contents',
		'class',
		'selector',
		'debugSession',
		'window',
		'editor',
		'location',
		'announcer',
		'syntaxError',
		'errorMessage'
	],
	#category : #'Tools-Debugger'
}

{ #category : #'instance creation' }
SyntaxErrorDebugger class >> buildMorphicViewOn: aSyntaxErrorDebugger [
	"Answer an Morphic view on the given SyntaxError."

	| window editor |
	window := (SystemWindow labelled: 'Syntax Error: ' , aSyntaxErrorDebugger errorMessage)
		model: aSyntaxErrorDebugger.
	window
		addMorph:
			((PluggableListMorph
				on: aSyntaxErrorDebugger
				list: #list
				selected: #listIndex
				changeSelected: nil
				menu: #listMenu:) doubleClickSelector: #listDoubleClick)
		frame: (0 @ 0 corner: 1 @ 0.15).
	window
		addMorph:
			(editor := RubScrolledTextMorph new
				on: aSyntaxErrorDebugger
				text: #contents
				accept: #contents:notifying:
				readSelection: #contentsSelection
				menu: #codePaneMenu:shifted:)
		frame: (0 @ 0.15 corner: 1 @ 1).
	aSyntaxErrorDebugger window: window.
	aSyntaxErrorDebugger editor: editor.
	window extent: 380 @ 220.
	^ window openInWorld
]

{ #category : #'instance creation' }
SyntaxErrorDebugger class >> open: aSyntaxErrorDebugger [
	"Answer a standard system view whose model is an instance of me."
	<primitive: 19>
	"Simulation guard"
	| process |
	process := Processor activeProcess.
	UIManager default spawnNewProcessIfThisIsUI: process.
	UIManager default defer: [
		self buildMorphicViewOn: aSyntaxErrorDebugger.
	].
	^ process suspend
]

{ #category : #'tools registry' }
SyntaxErrorDebugger class >> registerToolsOn: registry [
	"Add ourselves to registry. See [Smalltalk tools]"
	registry register: self as: #syntaxErrorDebugger
]

{ #category : #'instance creation' }
SyntaxErrorDebugger class >> syntaxError: aSyntaxError [

	^ self new
		syntaxError: aSyntaxError;
		yourself
]

{ #category : #accessing }
SyntaxErrorDebugger >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #menu }
SyntaxErrorDebugger >> browseMethodFull [
	"Create and schedule a full Browser and then select the current class and message."

	| myClass |
	(myClass := self selectedClassOrMetaClass) ifNotNil:
		[Smalltalk tools browser
			openOnClass: myClass selector: self selectedMessageName]
]

{ #category : #other }
SyntaxErrorDebugger >> category [
	^(class organization categoryOfElement: selector) ifNil: [ Protocol unclassified ]
]

{ #category : #initialization }
SyntaxErrorDebugger >> checkForUnprintableCharacters: aString [
	| types printables |
	types := String typeTable.
	printables := '!@#$%&*-_=+<>{}?/\,¬∑¬£¬¢¬ß¬∂¬™¬∫¬ñ¬ó¬ì¬ë¬î¬í¬Ö√ö√¶√ö¬Ø√ó¬ø¬´¬ª`~`' asSet.
	^ aString
		detect: [ :aChar | (types at: aChar asciiValue ifAbsent: [ #xLetter ]) == #xBinary and: [ (printables includes: aChar) not ] ]
		ifFound: [ :badChar |
			'<<<This string contains a character (ascii value ' , badChar asciiValue printString
				, ') that is not normally used in code>>> ' , aString ]
		ifNone: [ aString ]
]

{ #category : #other }
SyntaxErrorDebugger >> closeWindow [
	debugSession ifNotNil: [ debugSession terminate ].
	window close
]

{ #category : #accessing }
SyntaxErrorDebugger >> codePaneMenu: aMenu shifted: shifted [
	"Note that unless we override perform:orSendTo:,
	PluggableTextController will respond to all menu items in a
	text pane"

	| donorMenu |
	donorMenu := (PragmaMenuBuilder pragmaKeyword: RubSmalltalkCodeMode menuKeyword model: editor)
		menu.
	^ aMenu addAllFrom: donorMenu
]

{ #category : #accessing }
SyntaxErrorDebugger >> contents [
	^contents
]

{ #category : #accessing }
SyntaxErrorDebugger >> contents: stringOrText [
	contents := stringOrText
]

{ #category : #other }
SyntaxErrorDebugger >> contents: aString notifying: aController [
	"Compile the code in aString and proceed. Do not notify anybody of errors, because nobody would have been notified of errors if this syntax error had not arisen"

	aController hasUnacceptedEdits: false.

	syntaxError doitFlag
		ifTrue: [ self class compiler evaluate: aString ]
		ifFalse: [ self resume: aString ].
	self closeWindow
]

{ #category : #other }
SyntaxErrorDebugger >> contentsSelection [
	"Return the interval of text in the code pane to select when I set the pane's contents"

	^ location
		ifNil: [1 to: 0]  "null selection"
		ifNotNil: [ location to: location + self sourceErrorString size - 1 ]
]

{ #category : #menu }
SyntaxErrorDebugger >> debug [

	"Show the stack of the process leading to this syntax editor, typically showing the stack of the compiler as called from fileIn."

	(OupsDebugRequest newForContext: debugSession interruptedContext)
		process: debugSession interruptedProcess;
		submit
]

{ #category : #accessing }
SyntaxErrorDebugger >> editor: anEditor [
	editor := anEditor
]

{ #category : #accessing }
SyntaxErrorDebugger >> errorMessage [
	^ errorMessage
]

{ #category : #initialization }
SyntaxErrorDebugger >> highlightError [
	"copy in the error message"
	contents := contents
					copyReplaceFrom: location
					to: location - 1
					with: self sourceErrorString.
	"convert to Text that we can add Attributes"
	contents := contents asText.
	"use the ST80Styler"
	location ifNil: [ ^ self ].
	contents addAttribute: TextColor red from: location to: location + self sourceErrorString size - 1.
	contents addAttribute: TextEmphasis bold from: location to: location + self sourceErrorString size - 1
]

{ #category : #'message list' }
SyntaxErrorDebugger >> list [
	"Answer an array of one element made up of the class name, message category, and message selector in which the syntax error was found. This is the single item in the message list of a view/browser on the receiver."

	selector ifNil: [^ Array with: (class name, '  ', (self category ifNil: ['']), '  ', '<none>')].
	self category ifNil: [^ Array with: (class name, '    ', '<none>')].
	^ Array with: (class name, '  ', self category, '  ', selector)
]

{ #category : #'message list' }
SyntaxErrorDebugger >> listDoubleClick [
	self debug
]

{ #category : #'message list' }
SyntaxErrorDebugger >> listIndex [
	"There is always exactly one element in my list and it is always selected."

	^ 1
]

{ #category : #menu }
SyntaxErrorDebugger >> listMenu: aMenu [
	^aMenu addList: {
		{'Proceed' . #proceed}.
		{'Debug calling process' . #debug}.
		{'Browse full' . #browseMethodFull}}
]

{ #category : #accessing }
SyntaxErrorDebugger >> model [
	^ self
]

{ #category : #menu }
SyntaxErrorDebugger >> proceed [
	"The user has has edited and presumably fixed the syntax error and the filein can now proceed."

	debugSession
			resume;
			clear
]

{ #category : #menu }
SyntaxErrorDebugger >> resume: aValue [

	debugSession
			resume: aValue;
			clear
]

{ #category : #'text menu support' }
SyntaxErrorDebugger >> selectedClass [
	"Answer the class in which the syntax error occurred."

	^ class
]

{ #category : #'text menu support' }
SyntaxErrorDebugger >> selectedClassOrMetaClass [
	"Answer the class of the method being compiled."

	^ class
]

{ #category : #'text menu support' }
SyntaxErrorDebugger >> selectedMessageName [
	"Answer the selector of the method being compiled."

	^ selector
]

{ #category : #other }
SyntaxErrorDebugger >> shoutAboutToStyle: aPluggableShoutMorphOrView [
	^ true
]

{ #category : #accessing }
SyntaxErrorDebugger >> sourceErrorString [
	^ errorMessage , ' -> '
]

{ #category : #initialization }
SyntaxErrorDebugger >> syntaxError: aSyntaxError [
	"extract the instance properties from a SyntaxErrorNotification"

	syntaxError := aSyntaxError.
	class :=  aSyntaxError errorClass.
	errorMessage := aSyntaxError errorMessage.
	location := aSyntaxError location.
	debugSession := (Processor activeProcess newDebugSessionNamed: 'Stack of the Syntax Error' startedAt: aSyntaxError signalerContext).
	contents := self checkForUnprintableCharacters: aSyntaxError errorCode.
	selector := class compiler parseSelector: contents.
	self highlightError
]

{ #category : #accessing }
SyntaxErrorDebugger >> window [
	^window
]

{ #category : #accessing }
SyntaxErrorDebugger >> window: aWindow [
	window := aWindow
]
