*-----------------------------------------------------------
* Program Number:Enigma
* Written by    :Stjepan Èeèura
* Date Created  :5.2.2021.
* Description   :Enigma
*
*-----------------------------------------------------------
START	ORG	$1000

ktcL	*tekst da bira kotac
	MOVE	#14,	D0
	LEA	brjLk,	A1
	TRAP	#15

	*za petlju
	MOVE	#1,	D7
	LEA	Lktc,	A6

	JMP	biranje
	
ktcS	*tekst da bira kotac
	MOVE	#14,	D0
	LEA	brjSk,	A1
	TRAP	#15

	*za petlju
	MOVE	#2,	D7
	LEA	Sktc,	A6

	JMP	biranje

ktcD	*tekst da bira kotac
	MOVE	#14,	D0
	LEA	brjDk,	A1
	TRAP	#15

	*za petlju
	MOVE	#3,	D7
	LEA	Dktc,	A6

biranje	*biranje kotaca
	MOVE	#4,	D0
	TRAP	#15

	*pamti kotac
	MOVE.L	D1,	D6

	*tekst da trazi namjestanje kotac
	MOVE	#14, D0
	LEA	nmjst,	A1
	TRAP	#15

	*unos namjestanja kotaca
	MOVE	#4,	D0
	TRAP	#15

	*pamti namjestanje kotac
	MOVE.L	D1,	D5

	*gleda koji kotac je izabran i ide na njega
kojije	CMP	#1,	D6
	BEQ	ucitO1
	CMP	#2,	D6
	BEQ	ucitO2
	CMP	#3,	D6
	BEQ	ucitO3
	CMP	#4,	D6
	BEQ	ucitO4
	CMP	#5,	D6
	BEQ	ucitO5

ucitO1	LEA	kotac1,	A5
	JMP	nmjktc
ucitO2	LEA	kotac2,	A5
	JMP	nmjktc
ucitO3	LEA	kotac3,	A5
	JMP	nmjktc
ucitO4	LEA	kotac4,	A5
	JMP	nmjktc
ucitO5	LEA	kotac5,	A5
	JMP	nmjktc

	*ovo namjesta kotac na koliko je vec zadano
	*u A6 trebam upisati, u A5 je kotac
nmjktc	MULS	#2,	D5
	MOVE	A5,	A4
	ADD	D5,	A5
	SUB	#2,	A5
	MOVE.L	#$0023,	D3
	MOVE.L	#$0000,	D4

nmjstnj	MOVE.B	(A5),	(A6)
	ADD	#1,	D4
	ADD	#1,	A5
	ADD	#1,	A6
	CMP	#52,	D4
	BEQ	pvrtktc
	MOVE.B	(A5),	D2
	CMP	D3,	D2
	BEQ	pvrt
	JMP	nmjstnj

pvrt	MOVE	A4,	A5
	CMP	#52,	D4
	BLT	nmjstnj
	MOVE.L	#$0023,	(A6)

pvrtktc	MOVE.B	D3,	(A6)
	CMP	#1,	D7
	BEQ	ktcS
	CMP	#2,	D7
	BEQ	ktcD

	*plug board odavde
	*ispis teksta za plug board
	LEA	plgbrd,	A1
	MOVE	#14,	D0
	TRAP	#15

	*Unos parova za plug board
	LEA	plgpr,	A1
	MOVE	#2,	D0
	TRAP	#15

	*odavde dupla unose u obrnutom smjeru
	LEA	plgpr,	A1
	MOVE	A1,	A2
	ADD	#20,	A2
	MOVE	A2,	A3

	*petlja da udupla
plbrpt	SUB	#1,	A3
	MOVE.B	(A3),	(A2)
	ADD	#1,	A2
	CMP	A1,	A3
	BGT	plbrpt

	*za kraj plugboarda
	MOVE.B	#$0023,	(A2)

	*Ispis da unese tekst
	LEA	tekst,	A1
	MOVE	#14,	D0
	TRAP	#15

	*unos teksta
	LEA	txt,	A1
	MOVE	#2,	D0
	TRAP	#15

txtfin	CMP.B	#$00,	(A1)
	BEQ	txtfswp
	ADD	#1,	A1
	JMP	txtfin

txtfswp	MOVE.B	#$23,	(A1)

	*pripreme za prevodenje
	MOVE	#0,	D7

	*da pri prvom prolasku samo kopira kotace
	LEA	Dshft,	A2
	LEA	Sshft,	A3
	LEA	Lshft,	A4
	MOVE.B	#0,	(A2)
	MOVE.B	#0,	(A3)
	MOVE.B	#0,	(A4)

	*povecanje kotaca odavde

	*ucitavanja kotaca
dKshift	LEA	Dktc,	A5
	LEA	xDktc,	A6
	LEA	Dshft,	A3
	MOVE	#1,	D1
	JMP	nmjPovK
sKshift	LEA	Sktc,	A5
	LEA	xSktc,	A6
	LEA	Sshft,	A3
	MOVE	#2,	D1
	JMP	nmjPovK
lKshift	LEA	Lktc,	A5
	LEA	xLktc,	A6
	LEA	Lshft,	A3
	MOVE	#3,	D1

	*pri prvom ulasku samo kopira 
	*povecava kotac za jedno prilikom rada
nmjPovK	MOVE	A5,	A4
	MOVE.B	(A3),	D3
	MOVE	D3,	D5
	MULS	#2,	D5
	ADD	D5,	A5
	MOVE.L	#$0000,	D4

povK	MOVE.B	(A5),	(A6)
	ADD	#1,	D4
	ADD	#1,	A5
	ADD	#1,	A6
	CMP	#52,	D4
	BEQ	pvrtpov
	MOVE.B	(A5),	D2
	CMP.B	#$23,	D2
	BEQ	pvrtpov
	JMP	povK

pvrtpov	MOVE	A4,	A5
	CMP	#52,	D4
	BLT	povK
	MOVE.B	#$23,	(A6)
	ADD	#1,	D3
	CMP	#26,	D3
	BEQ	povbrj
	MOVE.B	D3,	(A3)
	CMP	#0,	D7
	BEQ	povprov
	JMP	ucitsl

povbrj	MOVE.B	#$00,	(A3)

	*odavde provjera koje povecava
povprov	CMP	#1,	D1
	BEQ	sKshift
	CMP	#2,	D1
	BEQ	lKshift

	*ucitava slovo u D1
ucitsl	LEA	txt,	A1
	ADD	D7,	A1
	MOVE.B	(A1),	D1
	MOVE	#1,	D6

	CMP.B	#$23,	D1
	BEQ	fin
	

kjkrk	CMP	#1,	D6
	BEQ	plgprov
	CMP	#9,	D6
	BEQ	cnctfnd

	*gleda koji korak je i koji kotac ucitava
kjktc	CMP	#2,	D6
	BEQ	ucitDk
	CMP	#3,	D6
	BEQ	ucitSk
	CMP	#4,	D6
	BEQ	ucitLk
	CMP	#5,	D6
	BEQ	ucitRT
	CMP	#6,	D6
	BEQ	ucitLk
	CMP	#7,	D6
	BEQ	ucitSk
	CMP	#8,	D6
	BEQ	ucitDk	

	*ucitavanja kotaca ovdje
ucitDk	LEA	xDktc,	A4
	JMP	prtvsmj
ucitSk	LEA	xSktc,	A4
	JMP	prtvsmj
ucitLk	LEA	xLktc,	A4
	JMP	prtvsmj
ucitRT	LEA	rotator,	A4

prtvsmj	ADD	#1,	D6
	MOVE	A4,	A5
	CMP	#6,	D6
	BGT	prtvld	

	*u D2 je pomjer, u A4 i A5 je adresa prvog slova

	*funkcija koja provlaci kroz kotace	
prtvdl	ADD	#1,	A4
	ADD	D2,	A4
	MOVE	#0,	D2
	MOVE.B	(A4),	D4
	JMP prtvpt

prtvld	ADD	D2,	A4
	ADD	#1,	A5
	MOVE	#0,	D2
	MOVE.B	(A4),	D4

	*u D4 mi je gdje vodi D2, u D5 trazi mjesto

	*petlja za prolaz kroz kotace
prtvpt	MOVE.B	(A5),	D5
	CMP	D5,	D4
	BEQ	kjkrk
	ADD	#2,	D2
	ADD	#2,	A5
	JMP	prtvpt

	*updatea slovo u D1 nakon pretvorbi, tj. s pozicije u D2
cnctfnd	LEA	cnnctr,	A3
	DIVS	#2,	D2
	ADD	D2,	A3
	MOVE.B	(A3),	D1

	*provjerava plugboard je li stavljeno slovo tu
plgprov	LEA	plgpr,	A2

plgprvp	MOVE.B	(A2),	D3
	CMP	D1,	D3
	BEQ	swap
	ADD	#2,	A2
	
	*ubaci cmp i beq ako je # da preskoci swap i ide na plgjmp
	CMP.B	#$23,	D3
	BEQ	plgjmp
	JMP	plgprvp

swap	ADD	#1,	A2
	MOVE.B	(A2),	D1
	*sada se u D1 nalazi slovo poslije plugboarda

	*provjera na koju operaciju connectora ide	
plgjmp	CMP	#9,	D6
	BEQ	ispisF

	*trazi poziciju slova na connectoru
cnctsrc	LEA	cnnctr,	A3
	MOVE	#0,	D2

	*petlja na koju se treba vracat
cnctpta	MOVE.B	(A3),	D4
	CMP	D4,	D1
	BEQ	dljcnct
	ADD	#1,	D2
	ADD	#1,	A3
	JMP	cnctpta	

	*dodaje jedno za prolaz kroz korake
dljcnct	ADD	#1,	D6
	MULS	#2,	D2
	JMP	kjktc

	*ispisuje broj nakon pretvorbe
ispisF	MOVE	#6,	D0
	TRAP	#15

	*povecava D7 za jedno i D6 vraca na nula
	ADD	#1,	D7
	MOVE	#2,	D6

	*moze direktno na desni kotac zato sto njeg mora okrenut ionako
	JMP	dKshift

fin	

	*kraj programa
	MOVE.B	#9,D0
	TRAP	#15		Halt Simulator

	STOP 	#2000

brjLk	DC.B	'Biraj lijevi obruc', $D, $A, 0
brjSk	DC.B	'Biraj srednji obruc', $D, $A, 0
brjDk	DC.B	'Biraj desni obruc', $D, $A, 0

kotac1	DC.B 	'ZEFZBRWHUBHPEVCOAJPSNKTXICJWXGDLSTKYYUVFLQGMMAODRIQN#', $D, $A, 0
kotac2	DC.B 	'XEENMJNMLUOSHIVXJLIKBAYDPVDPQGUCRRAQSZGBTHCFFWZTWOKY#', $D, $A, 0
kotac3	DC.B 	'MFEHWJGOAIPGTKDVULLTVYFBQESUBWZACSJCXMNXHRIDOZYQKPRN#', $D, $A, 0
kotac4	DC.B 	'NDUCVBBRGWCHTVDKPEZPJTQOKZYSXGIFRQFIHXSUOAENMJWLAMLY#', $D, $A, 0
kotac5	DC.B 	'NOGDMNEUWGQIBZCSLMKFSXZAAVIYYJXLOTTCHQVPRBFRUWDEPKJH#', $D, $A, 0

rotator	DC.B	'JUVFWSKHDGETBXRLPOAQCYIMZNUJFVSWHKGDTEXBLROPQAYCMINZ#', $D, $A, 0

nmjst	DC.B	'Obruc namjesti na: ', $D, $A, 0

plgbrd	DC.B	'Unesi parove plugboarda: ', $D, $A, 0

tekst	DC.B	'Unesi tekst', $D, $A, 0
ektekst	DC.B	'Tekst je: ', $D, $A, 0

cnnctr	DC.B	'LVOXFZAMNDSYRKUHEJPBGQTWIC', $D, $A, 0

Lktc	DS.B	80
Sktc	DS.B	80
Dktc	DS.B	80

xLktc	DS.B	80
xSktc	DS.B	80
xDktc	DS.B	80

Dshft	DS.B	10
Sshft	DS.B	10
Lshft	DS.B	10

plgpr	DS.B	80

txt	DS.B	100

ektxt	DS.B	100

	END	START
*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~8~
