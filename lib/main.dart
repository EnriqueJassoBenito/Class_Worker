import 'package:clase_workers_list/Worker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Clase Workers & List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Worker> lista = [];
  TextEditingController _txtNombreCtrl = TextEditingController();
  TextEditingController _txtApellidoCtrl = TextEditingController();
  TextEditingController _txtEdadCtrl = TextEditingController();

  int _idCounter = 1; // Contador para generar ID único

  void _addWorkers() {
    final name = _txtNombreCtrl.text.trim();
    final lastname = _txtApellidoCtrl.text.trim();
    final age = _txtEdadCtrl.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Debe de ingresar el nombre")),
      );
      return;
    }

    if (lastname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Debe de ingresar el apellido")),
      );
      return;
    }

    if (age.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Debe de ingresar la edad")),
      );
      return;
    }

    final ageInt = int.tryParse(age);

    if (ageInt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Edad no válida")),
      );
      return;
    }

    if (ageInt < 18) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Eres menor de edad")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Edad válida, mayor de 18")),
    );

    Worker worker = Worker(
      id: _idCounter,
      nombre: name,
      apellidos: lastname,
      edad: ageInt,
    );

    setState(() {
      lista.add(worker);
      _idCounter++;
    });

    _txtNombreCtrl.clear();
    _txtApellidoCtrl.clear();
    _txtEdadCtrl.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Trabajador agregado exitosamente")),
    );
  }

  void _removeWorker(int id) {
    setState(() {
      lista.removeWhere((worker) => worker.id == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Trabajador eliminado")),
    );
  }

  Widget getWorkersList() {
    if (lista.isEmpty) {
      return const Text("No hay trabajadores en la lista.");
    }

    return Container(
      height: 200, // Altura fija para la lista
      child: ListView.builder(
        itemCount: lista.length,
        itemBuilder: (context, index) {
          final worker = lista[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              title: Text("ID: ${worker.id} Nombre: ${worker.nombre} Apellidos: ${worker.apellidos}"),
              subtitle: Text("Edad: ${worker.edad}"),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _removeWorker(worker.id),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                "Lista de trabajadores:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              getWorkersList(),
              const SizedBox(height: 14),
              TextField(
                controller: _txtNombreCtrl,
                decoration: const InputDecoration(
                  labelText: "Nombre del trabajador",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _txtApellidoCtrl,
                decoration: const InputDecoration(
                  labelText: "Apellidos del trabajador",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _txtEdadCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Edad del trabajador",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _addWorkers,
                child: const Text("Agregar a la lista"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
