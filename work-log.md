
# LOG

# 08.11.24
# Bytta slik at client har authority over position og rotation. Nest er å replicate state til server,
#  og det er noe rot med kamera. Virker som man kun kan ha ett current camera når man åpner 2 viewports?
# Det er også mye rot igjen etter byttet fra server authoritative til client.

# 09.11.24
# Fiksa kamera, og replicate-er velocity, ikke state. Må da sørge for å implementere rpc for alle inputs
#  som kan endre state, som jump og run (ikke movement). Litt usikker på hvordan rpc-er funker, og må
#  kalles per nå.

# 10.11.24
# Fikser lobby-ui. Nå har jeg en meny som åpner og lukker med Escape fra game-instansen. Fra game, så endres
#  en menu_visible attributt hos både single- og multiplayer-player, som avgjør om look_component.capture_mouse
#  capture eller visible mus. Masse debug
# Begynt steam-multiplayer, kommet ganske langt i tutorial. 

# 10.11.24 BUG: When hosting or joining, movement controll remains in players hands, even though menu is up

# 12.11.24
# Fortsetter Steam multiplayer implementation. 
# Initiell implementasjon fullført (fullført Battery Acid Devs Steam tutorial 1 og 2 med endringer for mitt
#  oppsett). Mangler å teste med en annen Steam-bruker på en annen maskin. Skal spørre om hjelp fra venner :>

# 13.11.24
# Skal få testa med venner i dag. Før det gjør jeg noen små-endringer og prøver å danne forståelse for
#  Steam API løsningen.
# Implementerte et komponentbasert interaction-system. Kun bare-bones nå, legg til på systemet, og så bør det nok
#  skrives om i framtiden.
# STEAM FUNKER!!! Fikk tiden til Timo og fikk sett at det fungerer å Host og Join hverandres lobby! Lite lag og!
#  Systemet har per nå ikke mulighet for å bytte mellom ENet og Steam uten å starte spillet opp igjen. Og det
#  er heller ikke mulig å gå tilbake til singleplayer. Kan være fint å lage en god implementasjon av dette, men
#  kan ikke se at det haster heller. Så for første prototype kan jeg heller fokusere på annet.
# Neste er å sette opp en plan for hva som skal gjøres videre.

# END LOG
