import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentForm extends StatefulWidget {
  @override
  _AppointmentFormState createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  String? _selectedSpecialty;
  String? _selectedShift;

  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Datos de la Cita',
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Color blanco para el texto
          ),
        ),
        backgroundColor: Color.fromARGB(255, 44, 66, 112),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF3B5998),
              Color(0xFF0077B6),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize
                  .min, // Ajusta el tamaño de la Column según el contenido
              children: [
                Center(
                  child: Text(
                    'Agendar Cita',
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                _buildSpecialtyDropdown(),
                SizedBox(height: 16.0),
                _buildShiftDropdown(),
                SizedBox(height: 32.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_selectedSpecialty != null &&
                          _selectedShift != null) {
                        await _fetchAppointmentDetails();
                        //_showAppointmentDialog();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Color(0xFF3B5998),
                      padding: EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 32.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Agendar Cita',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialtyDropdown() {
    final List<String> specialties = [
      'Cardiología',
      'Cirugía Cardiaca',
      'Cirugía General',
      'Cirugía Plástica',
      'Dermatología',
      'Endocrinología',
      'Fonoaudiología',
      'Gastroenterología',
      'Hematología',
      'Infectología',
      'Inmunología',
      'Maxilofacial',
      'Nefrología',
      'Neonatología',
      'Neurocirugía',
      'Neurología',
      'Nutrición',
      'Odontología',
      'Oncología',
      'Otorrinolaringología',
      'Pediatría',
      'Psicología',
      'Psiquiatría',
      'Traumatología'
    ];

    return DropdownButtonFormField<String>(
      value: _selectedSpecialty,
      hint: Text(
        'Selecciona una especialidad',
        style: TextStyle(color: Colors.white70),
      ),
      items: specialties
          .map((specialty) => DropdownMenuItem<String>(
                value: specialty,
                child: Text(
                  specialty,
                  style: TextStyle(color: Color.fromARGB(255, 68, 65, 65)),
                ),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedSpecialty = value!;
        });
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 16.0,
        ),
      ),
    );
  }

  Widget _buildShiftDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedShift,
      hint: Text(
        'Selecciona un turno',
        style: TextStyle(color: Colors.white70),
      ),
      items: ['AM', 'PM']
          .map((shift) => DropdownMenuItem<String>(
                value: shift,
                child: Text(
                  shift,
                  style: TextStyle(color: Color.fromARGB(255, 68, 65, 65)),
                ),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedShift = value;
        });
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 16.0,
        ),
      ),
    );
  }

  Future<void> _fetchAppointmentDetails() async {
    if (_selectedSpecialty != null) {
      final appointmentSnapshot = await _firestore
          .collection(_selectedSpecialty!)
          .doc(_selectedShift)
          .get();

      if (appointmentSnapshot.exists) {
        final appointmentData =
            appointmentSnapshot.data() as Map<String, dynamic>;
        _showAppointmentDialog(appointmentData);
      } else {
        print('No se encontraron datos para la cita seleccionada.');
      }
    } else {
      print('No se ha seleccionado una especialidad.');
    }
  }

  void _showAppointmentDialog(Map<String, dynamic> appointmentData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Detalles de la Cita',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3B5998),
              ),
            ),
          ),
          content: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Color(0xFF3B5998),
                      size: 20.0,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'Día: ${appointmentData['dia']}',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Color(0xFF3B5998),
                      size: 20.0,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'Doctor(a): ${appointmentData['doctor']}',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(
                      Icons.date_range,
                      color: Color(0xFF3B5998),
                      size: 20.0,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'Fecha: ${appointmentData['fecha']}',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Color(0xFF3B5998),
                      size: 20.0,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'Horario: ${appointmentData['horario']}',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      color: Color(0xFF3B5998),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                TextButton(
                  onPressed: () {
                    // _confirmAppointment(); // Lógica para confirmar la cita

                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/thanks');
                  },
                  child: Text(
                    'Confirmar',
                    style: TextStyle(
                      color: Color(0xFF3B5998),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
