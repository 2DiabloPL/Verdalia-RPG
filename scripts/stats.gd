extends Node


############
#statystyki#
############
#statystyki poziomowe
var LVL: int = 0		#poziom gracza
var LVLP: int = 0		#suma poziomów profesji
var LVLK: int = 0		#poziom profesji kowala
var LVLD: int = 0		#poziom profesji drwala

#ilość punktów doświadczenia
var expLVL:int = 0		#ilość punktów doświadczenia poziomu gracza
var expDLVL:int = 0		#ilość punktów doświadczenia poziomu profesji drwala
var expKLVL:int = 0 	#ilość punktów doświadczenia poziomu profesji kowala

#statystyki podstawowe, gracz je podnosi punktami
var STR: int = 10		#siła gracza
var INT: int = 10		#inteligencja gracza
var WIS: int = 10		#mądrość gracza	
var VIT: int = 10		#żywotność gracza
var DEX: int = 10		#zwinność gracza
var DEF: int = 10		#obrona gracza

#statystyki zależne
var PER: int 			#percepcja gracza
var CRT: int 			#szansa gracza na trafienie krytyczne
var CRTD:int 			#moc trafienia krytycznego
var SPD: int = 100		#szybkość gracza

#statystyka zależna od poziomu profesji
var CRV: int 			#kreatywność gracza

#statystyki zależne 
var MaxHP: int			#max punkty życia gracza
var HP: int				#punkty życia gracza
var MaxMP: int			#max punkty many gracza
var MP: int				#punkty many gracza
var MaxSP: int			#max punkty zmęczenia gracza
var SP: int				#punkty zmęczenia gracza


#signal give_exp(osoba, amount)
