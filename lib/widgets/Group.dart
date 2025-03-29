import 'package:flutter/material.dart';
import 'package:fonhakaton2025/data/models/group.dart';



final List<Group> groups = [
  Group(
      groupId: 1,
      name: "Logistika",
      iconName: "water",
      color: "#2196F3",
      description:
          """Radna grupa za logistiku je odgovorna za upravljanje resursima u toku blokada.\nLogistika se bavi: \n-Donacijama: novcanim i konkretnim -u kontaktu je sa ljudima koji doniraju i dogovara se oko vremena dolaska ukoliko je donacija velika\n-Zajednickom kasom: koje je stanje novcanih donacija i evidencija na sta se sve troše pare i koliko (znaci svi prihodi i rashodi)\n-Prostornom organizacijom fakulteta: koja prostorija se koristi u koje svrhe, za koju radnu grupu, gde je menza, sad kad su veliki protesti gde se spava, organizuje ljude koji sprovode u delo donesene prostorne odluke""".trimLeft()),
  Group(
      groupId: 2,
      name: "Dnevni red",
      iconName: "schedule",
      color: "#607D8B",
      description: """Dnevni red se bavi poslovima vezanim za optimizaciju rada plenuma, kao i komunikacijom sa upravom fakulteta, profesorima i asistentima.\nOni:\n-Sastavljaju dnevni red: spisak tacaka koje su relevantne za diskusiju i glasanja na plenumu tog dana. \n-Vodjenje plenuma: organizacija moderatora i zapisnicara.\n -Izvestajem nakon svakog plenuma: od zapisnika sa plenuma prave izvestaj.\n-Komunikacijom sa upravom, profesorima i asistentima: izvestavaju ih o odlukama plenuma, i plenum o odlukama uprave""".trimLeft()),
  Group(
      groupId: 3,
      name: "Mediji",
      iconName: "auto_awesome",
      color: "#673AB7",
      description:
          """Radna grupa za medije bavi se pre svega obavestavanjem javnosti o aktuelnim desavanjima vezanim za blokade.\nZaduzenja:\n-Upravljanje nalozima na drustvenim mrezama\n-Priprema studenata za javne nastupe\n-Editovanje snimaka\n-Priprema programa""".trimLeft()),
  Group(
      groupId: 4,
      name: "Komunikacije",
      iconName: "local_fire_department",
      color: "#F44336",
      description: """Ova radna grupa odgovorna je za komunikaciju sa drugim fakultetima.\nOd samog pocetka blokada bilo je najbitnije da ostanemo ujedinjeni i medjusobno se konsultujemo o idejama za dalji tok blokada.\nZaduzenja: \n-Ova radna grupa ide na sastanke sa radnim grupama za komunikacije drugih fakulteta\n-Oni prate javno dostupne odluke drugih fakulteta i obavestavaju svoj plenum o njima\n-Ova radna grupa bira delegate koji ce ici na zajednicke skupove""".trimLeft()),
  Group(
      groupId: 5,
      name: "Agitacija i motivacija",
      iconName: "local_florist",
      color: "#E91E63",
      description: """Radna grupa za agitaciju i motivaciju ima ključnu ulogu u mobilizaciji ljudi i povećavanju angazovanja učesnika.\nNjihov cilj je da  inspirišu i ohrabre ljude da se pridruže protestima. \nOni rade naodržavanju energije i odlučnosti među učesnicima tokom protesta.\n\nZaduzenja radne grupe:\n-Pravljenje transparenata\n-Komunikacija sa licnostima koje odrzavaju radionice/predavanja/.. \n-Organizacija zajednickih aktivnosti""".trimLeft()
      ),
  Group(
      groupId: 6,
      name: "Bezbednost",
      iconName: "shield",
      color: "#795548",
      description: """Radna grupa za bezbednost kljucna je u organizaciji svih akcija i blokada.\nZaduzenja bezbednosti:\n-Redarenje na blokadama\n-Sastavljanje bezbednosnog plana pred svaku akciju\n-Organizacija cuvara zgrade fakulteta\n-Odrzavanje reda i mira na fakultetu""".trimLeft()),
];
