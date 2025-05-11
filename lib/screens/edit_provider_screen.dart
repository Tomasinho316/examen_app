import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/provider_service.dart';
import '../models/proveedor.dart';

class EditProviderScreen extends StatefulWidget {
  const EditProviderScreen({Key? key}) : super(key: key);

  @override
  State<EditProviderScreen> createState() => _EditProviderScreenState();
}

class _EditProviderScreenState extends State<EditProviderScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _lastNameCtrl;
  late TextEditingController _mailCtrl;
  String _state = 'Activo';

  @override
  void initState() {
    super.initState();
    final p = Provider.of<ProviderService>(context, listen: false).selectedProvider!;
    _nameCtrl = TextEditingController(text: p.providerName);
    _lastNameCtrl = TextEditingController(text: p.providerLastName);
    _mailCtrl = TextEditingController(text: p.providerMail);
    _state = p.providerState;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _lastNameCtrl.dispose();
    _mailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<ProviderService>(context);
    final p = service.selectedProvider!;

    return Scaffold(
      appBar: AppBar(
        title: Text(p.proveedorId == 0 ? 'Crear Proveedor' : 'Editar Proveedor'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: service.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                      validator: (v) => (v==null||v.trim().isEmpty) ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _lastNameCtrl,
                      decoration: const InputDecoration(labelText: 'Apellido'),
                      validator: (v) => (v==null||v.trim().isEmpty) ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _mailCtrl,
                      decoration: const InputDecoration(labelText: 'Correo'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v==null||v.trim().isEmpty) return 'Requerido';
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) return 'Inválido';
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _state,
                      decoration: const InputDecoration(labelText: 'Estado'),
                      items: ['Activo','Inactivo']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (v) => setState(() => _state = v!),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('Guardar'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;
                        p.providerName = _nameCtrl.text.trim();
                        p.providerLastName = _lastNameCtrl.text.trim();
                        p.providerMail = _mailCtrl.text.trim();
                        p.providerState = _state;
                        await service.editOrCreateProvider(p);
                        Navigator.pop(context);
                      },
                    ),
                    if (p.proveedorId != 0) ...[
                      const SizedBox(height: 10),
                      TextButton.icon(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        label: const Text('Eliminar',
                            style: TextStyle(color: Colors.red)),
                        onPressed: () async {
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Eliminar proveedor'),
                              content: const Text(
                                  '¿Estás seguro de eliminarlo?'),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Cancelar')),
                                TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text('Eliminar')),
                              ],
                            ),
                          );
                          if (ok == true) {
                            await service.deleteProvider(p, context);
                            Navigator.pop(context);
                          }
                        },
                      )
                    ]
                  ],
                ),
              ),
            ),
    );
  }
}
