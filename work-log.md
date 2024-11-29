
# LOG

# 08.11.24
 Bytta slik at client har authority over position og rotation. Nest er å replicate state til server,
  og det er noe rot med kamera. Virker som man kun kan ha ett current camera når man åpner 2 viewports?
 Det er også mye rot igjen etter byttet fra server authoritative til client.

# 09.11.24
 Fiksa kamera, og replicate-er velocity, ikke state. Må da sørge for å implementere rpc for alle inputs
  som kan endre state, som jump og run (ikke movement). Litt usikker på hvordan rpc-er funker, og må
  kalles per nå.

# 10.11.24
 Fikser lobby-ui. Nå har jeg en meny som åpner og lukker med Escape fra game-instansen. Fra game, så endres
  en menu_visible attributt hos både single- og multiplayer-player, som avgjør om look_component.capture_mouse
  capture eller visible mus. Masse debug
 Begynt steam-multiplayer, kommet ganske langt i tutorial. 

# 10.11.24 BUG: When hosting or joining, movement controll remains in players hands, even though menu is up

# 12.11.24
 Fortsetter Steam multiplayer implementation. 
 Initiell implementasjon fullført (fullført Battery Acid Devs Steam tutorial 1 og 2 med endringer for mitt
  oppsett). Mangler å teste med en annen Steam-bruker på en annen maskin. Skal spørre om hjelp fra venner :>

# 13.11.24
 Skal få testa med venner i dag. Før det gjør jeg noen små-endringer og prøver å danne forståelse for
  Steam API løsningen.
 Implementerte et komponentbasert interaction-system. Kun bare-bones nå, legg til på systemet, og så bør det nok
  skrives om i framtiden.
 STEAM FUNKER!!! Fikk tiden til Timo og fikk sett at det fungerer å Host og Join hverandres lobby! Lite lag og!
  Systemet har per nå ikke mulighet for å bytte mellom ENet og Steam uten å starte spillet opp igjen. Og det
  er heller ikke mulig å gå tilbake til singleplayer. Kan være fint å lage en god implementasjon av dette, men
  kan ikke se at det haster heller. Så for første prototype kan jeg heller fokusere på annet.
 Neste er å sette opp en plan for hva som skal gjøres videre.

# 14.11.24
 Begynner planlegging og prototype av "internett"-lokalt nett-pc-skjerm (ingame).

# 15.11.24
 Planen min er å implementere "rommene" slik at de blir instantiated under det vanlige map-et, på posisjoner
  dynamisk avhengig av antall spillere. Så blir de fjernet enten ved at man ønsker å åpne en ny, eller at det har
  gått en god stund, eller at man manuelt lukker døra.
 Så langt har jeg lagd en signal-lenke fra pc-en til digital_rooms_manager, som skal dele ut plass, og så
  instantiate rommet.
 I tillegg til å ha fått til et system for å fjerne og legge til "posisjon-noder" til digitale rom. Avhengig av
  max-spillere, så kan man legge til x antall rom. Skal det legges til et rom når det allerede er maks rom sjekkes
  det etter et rom uten spillere, også blir det fjerna. Skulle det være spillere i alle så skjer ingenting. 
 Neste blir å implementere en dynamisk måte å gi posisjoner til disse nodene.

# 16.11.24
 Endret filstrukturen til å være organisert etter funksjon, i stedet for asset-type.
 Har satt opp en muligheten for asynkrone signal-calls med noden Service
 Digital rooms blir nå dynamisk tildelt en posisjon. Neste er å skape en data-type for rommene, lagre dem, og kunne
  sende dem som parameter og hente fra en "database"

# 17.11.24
 Rommene replikeres ikke slik de skal. Bør bygge om systemet slik at clients caller rpc som spawner hos server.
  Og trenger måte å skille mellom singleplayer og multiplayer

 Må først bygge om slik at man enten velger singleplayer eller multiplayer
 Dette viser seg å være en del jobb, siden jeg har gjort noen valg som må utbedres

# 18.11.24
 Jobba på meny-styring, og satt opp funksjoner for leave game 
 Må fortsatt få til _remove_game

# 20.11.24
 Meny-styring fiksing. Ønsker å ha menyene oppe og gå før jeg begynner på "room"-replication
 Rot og fanteri med menyene, fiksa alt jeg fant B>
 Neste blir å gjøre om shared-net til global singleton (om dette passer seg). digital_rooms_manager fant ikke 
  gruppemedlemmer av "computers", fordi de var i World-scene treet. Og i tillegg har jeg tenkt at det gir mer 
  mening å ha shared-net som en global, siden den skal være felles interaface mellom alle som skal interact med
  "nettet"

# 21.11.24
 Overgang fra scene til global for SharedNet gikk på skinner. Null stress. Fant også ut at medlemmer av gruppa
  "computers" trolig ikke ble funnet fordi _ready funksjonen som .connect til dem, lå i, ble kjørt øyeblikkelig,
  lenge før World blir lagt til og det finnes medlemmer av "computers"
 SharedNet bruker nå rpc, krever fiksing som vil gi god forståelse for rpc. 

# 22.11.24
 Eksamen gikk veldig bra B>
 I dag: Begynne på system for å sendes til rommet, og tilbake.
 Plan: Hver spiller har en kropp i verden. Når man entrer et digitalt rom, mister man kontrollen over kroppen sin, 
  og med får kontroll over en ny "kropp" i rommet. Denne eksisterer bare så lenge spilleren er i rommet.
 Bra så langt. Fått til at karakteren spawner "i rommet", men det er noe tull med replication. Får en warning, og 
  og karen replikerer ikke på host, men gjør det på client.
 Nå replikeres det ganske så bra. Eneste er at is_controlable endrer seg kun på host når man bruker escape (tull 
  med toggle_menu_control). Har også begynt på "remove_controller_from_room", men her trengs det mer jobb
 Noe tull med signal connections ved room-computers

# 23.11.24
 Plan: gjøre om is_controlable -setting slik at det blir "bedre". Og se på remove_controller_from_room.
 Trenger å lage et global-script som holder styr på hvem og hvor gjeldende game instance skal være og kontrollere.


# 25.11.24
 Ser nå med Network Profiler, at replikeringen av state machine i "world" og i digital room er unødvendig krevende.
  Om det i stedet er én spiller, som heller blir sendt bort til rommet, og så sitter en mesh med en hurtbox igjen i 
  det som blir stolen.
 Plan: Gjøre om slik at man kun flytter karakteren når man går til rom. Og forbedre kontroll (dette blir enklere da).

# 26.11.24
 Plan: Bygge om dive-mechanic sånn at det kun er én CharacterBody per spiller, som replikerer verdier.
  Delmål:
  - Sende kontroller til rom i stedet for å lage en ny kontroller
  - Legge igjen en mesh (med mulighet for hurtbox) etter spilleren når karakteren sendes til rommet.
  - Fjerne mesh og plassere karakter tilbake, men ta mesh dynamisk fra den som er der.

 Har gjennomført alt B>    

 Begynte så vidt på å begynne med skeletal transform for å rotere hodet når man ser opp og ned, men også for muligheten
  til å rotere hodet når man ser rundt på en skjerm.
 Dette krever Quaternions (som jeg tror jeg skjønner helt greit. Man setter opp en vektor, og så roterer man med en 
  vinkel rundt denne vektoren). Neste blir å forstå seg på bone_pose_rotation for å flytte hodet.

# 27.11.24
 Plan: Lage og sette opp det som ligger foran en visuelt funksjonabel "terminal"
  Delmål:
  - Lage en "terminal"/datamaskin i blender
  - Lage karakter-animasjon for å sitte på datamaskin (samt å falle, og crouch i samme slengen)
  - Logikken og eventuell state for å interagere med pc.
  - Sette opp skjerm
  - Sette opp at man styrer det på skjermen med mus og tastatur

  Fikk laget datamaskin og satt opp scene og script filer. Neste blir å lage animasjoner, sette opp work-station for
   datamaskin, og så begynne på datamaskinens funksjonalitet.

 Alle animasjoner fullført B>
 Nå må jeg sette meg inn i AnimationTree for å få til overgang mellom disse.

# 28.11.24
 Er på ferten av å få til AnimationTree. Men det trenger arbeid. Sist endra jeg AnimationTree på single_player, fortsett
  her.

# 29.11.24
 AnimationTree er løst ved å bruke AnimationNodeStateMachinePlayback sin .travel() metode, og sette animasjons-state-navn 
  i export under hver state-machine state.
 Har satt opp begynnelsen av "ComputerState". Den setter posisjon og rotasjon(men gir ikke riktig på rotasjon). Trenger å 
  fikse en generell meny-kontroll også.
 Neste blir å sette seg inn i 2D skjerm, og prøve å fikse en meny manager

# END LOG
