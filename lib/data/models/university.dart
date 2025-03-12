class University {
  final int id;
  final String name;
  final String location;

  University({
    required this.id,
    required this.name,
    required this.location,
  });

  University medicinskiBeograd = University(
    id: 101,
    name: "Medicinski fakultet Univerziteta u Beogradu",
    location: "dr Subotića starijeg 8, Beograd 11000"
  );
  University pravniBeograd = University(
    id: 102,
    name: "Pravni fakultet Univerziteta u Beogradu",
    location: "Bulevar kralja Aleksandra 67, Beograd 11000"
  );
  University matematickiBeograd = University(
    id: 103,
    name: "Univerzitet u Beogradu, Matematički fakultet",
    location: "Studentski trg 16, Beograd 11000"
  );
  University etfBeograd = University(
    id: 104,
    name: "Elektrotehnicki fakultet Univerziteta u Beogradu",
    location: "Bulevar kralja Aleksandra 73, Beograd 11000"
  );
  University fduBeograd = University(
    id: 105,
    name: "Fakultet dramskih umetnosti Univerziteta umetnosti",
    location: "Bulevar umetnosti 20, Beograd 11000"
  );
  University fonBeograd = University(
    id: 106,
    name: "Fakultet organizacionih nauka Univerziteta u Beogradu",
    location: "Jove Ilića 154, Beograd 11000"
  );
  University geografskiBeograd = University(
    id: 107,
    name: "Geografski fakultet Univerziteta u Beogradu",
    location: "Studentski trg 3, Beograd 11000"
  );
  University fakultetTehnickihNaukaNoviSad = University(
  id: 201,
  name: "Fakultet tehničkih nauka Univerziteta u Novom Sadu",
  location: "Trg Dositeja Obradovića 6, Novi Sad 21000"
);

University ekonomskiFakultetSubotica = University(
  id: 202,
  name: "Ekonomski fakultet Univerziteta u Novom Sadu",
  location: "Segedinski put 9-11, Subotica 24000"
);

University tehnickiFakultetMihajloPupinZrenjanin = University(
  id: 203,
  name: "Tehnički fakultet 'Mihajlo Pupin' Univerziteta u Novom Sadu",
  location: "Đure Đakovića bb, Zrenjanin 23000"
);

University medicinskiFakultetNis = University(
  id: 301,
  name: "Medicinski fakultet Univerziteta u Nišu",
  location: "Bulevar dr Zorana Đinđića 81, Niš 18000"
);

University pravniFakultetNis = University(
  id: 302,
  name: "Pravni fakultet Univerziteta u Nišu",
  location: "Trg Kralja Aleksandra 11, Niš 18000"
);

University ekonomskiFakultetKragujevac = University(
  id: 401,
  name: "Ekonomski fakultet Univerziteta u Kragujevcu",
  location: "Đure Pucara Starog 3, Kragujevac 34000"
);

University fakultetInzenjerskihNaukaKragujevac = University(
  id: 402,
  name: "Fakultet inženjerskih nauka Univerziteta u Kragujevcu",
  location: "Sestre Janjić 6, Kragujevac 34000"
);

University drzavniUniverzitetNoviPazar = University(
  id: 501,
  name: "Državni univerzitet u Novom Pazaru",
  location: "Vuka Karadžića bb, Novi Pazar 36300"
);



  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      id: json['id'],
      name: json['name'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
    };
  }
}
