import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../theme/colors.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Controladores para los campos de texto
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _zoneController = TextEditingController();

  // Variables de estado
  bool _isLoading = true;
  bool _isEditing = false;
  bool _isSaving = false;
  String _userRole = 'user';
  List<String> _availability = [];

  // Opciones de disponibilidad
  final List<String> _availabilityOptions = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _zoneController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final user = _authService.currentUser;
      if (user != null) {
        final userData = await _authService.getUserData(user.uid);
        final userRole = await _authService.getUserRole(user.uid);

        if (userData != null) {
          setState(() {
            _nameController.text = userData['name'] ?? '';
            _phoneController.text = userData['phone'] ?? '';
            _zoneController.text = userData['zone'] ?? '';
            _availability = List<String>.from(userData['availability'] ?? []);
            _userRole = userRole;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Error al cargar los datos: $e');
    }
  }

  Future<void> _saveChanges() async {
    if (_nameController.text.trim().isEmpty) {
      _showErrorSnackBar('El nombre no puede estar vacío');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final user = _authService.currentUser;
      if (user != null) {
        await _db.collection('users').doc(user.uid).update({
          'name': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'zone': _zoneController.text.trim(),
          'availability': _availability,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        setState(() {
          _isEditing = false;
          _isSaving = false;
        });

        _showSuccessSnackBar('Perfil actualizado correctamente');
      }
    } catch (e) {
      setState(() {
        _isSaving = false;
      });
      _showErrorSnackBar('Error al guardar cambios: $e');
    }
  }

  void _toggleAvailability(String day) {
    setState(() {
      if (_availability.contains(day)) {
        _availability.remove(day);
      } else {
        _availability.add(day);
      }
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _signOut() async {
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.logout, color: Colors.red, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Cerrar sesión',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGreen,
                  ),
                ),
              ],
            ),
            content: const Text(
              '¿Estás seguro de que quieres cerrar sesión?',
              style: TextStyle(fontSize: 14, color: AppColors.greyText),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.greyText,
                ),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Cerrar sesión',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );

    if (shouldSignOut == true) {
      await _authService.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.primaryGreen,
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [_buildHeader(), _buildProfileForm(), _buildFooter()],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        gradient: AppColors.greenGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Avatar y acciones
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              Row(
                children: [
                  if (!_isEditing)
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () => setState(() => _isEditing = true),
                    ),
                  if (_isEditing) ...[
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => setState(() => _isEditing = false),
                    ),
                    IconButton(
                      icon:
                          _isSaving
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                              : const Icon(Icons.check, color: Colors.white),
                      onPressed: _isSaving ? null : _saveChanges,
                    ),
                  ],
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Avatar principal
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 3,
              ),
            ),
            child: const Icon(Icons.person, size: 50, color: Colors.white),
          ),

          const SizedBox(height: 16),

          // Email del usuario
          Text(
            _authService.currentUser?.email ?? '',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          // Chip de rol
          if (_userRole == 'admin')
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: const Text(
                'Administrador',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

          const SizedBox(height: 20),

          // Mensaje informativo
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(
                  _isEditing ? Icons.edit : Icons.person_outline,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _isEditing
                        ? 'Editando perfil - Guarda los cambios cuando termines'
                        : 'Gestiona tu información personal y disponibilidad',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileForm() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Información Personal
          _buildSection(
            title: 'Información Personal',
            icon: Icons.person_outline,
            child: Column(
              children: [
                _buildInputField(
                  label: 'Nombre completo',
                  controller: _nameController,
                  icon: Icons.person_outline,
                  enabled: _isEditing,
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  label: 'Teléfono',
                  controller: _phoneController,
                  icon: Icons.phone_outlined,
                  enabled: _isEditing,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  label: 'Zona',
                  controller: _zoneController,
                  icon: Icons.location_on_outlined,
                  enabled: _isEditing,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Disponibilidad
          _buildSection(
            title: 'Disponibilidad',
            icon: Icons.schedule,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isEditing) ...[
                  const Text(
                    'Selecciona los días en los que estás disponible:',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.greyText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        _availabilityOptions.map((day) {
                          final isSelected = _availability.contains(day);
                          return GestureDetector(
                            onTap: () => _toggleAvailability(day),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? AppColors.primaryGreen
                                        : AppColors.softBackground,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color:
                                      isSelected
                                          ? AppColors.primaryGreen
                                          : AppColors.lightGreen,
                                ),
                              ),
                              child: Text(
                                day,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : AppColors.darkGreen,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ] else ...[
                  if (_availability.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.softBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.lightGreen),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.greyText,
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'No hay días de disponibilidad configurados',
                            style: TextStyle(
                              color: AppColors.greyText,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          _availability
                              .map(
                                (day) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryGreen.withOpacity(
                                      0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: AppColors.primaryGreen.withOpacity(
                                        0.3,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    day,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.primaryGreen,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryGreen, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool enabled,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGreen,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: enabled ? AppColors.softBackground : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: enabled ? AppColors.lightGreen : Colors.grey.shade200,
            ),
          ),
          child: TextField(
            controller: controller,
            enabled: enabled,
            keyboardType: keyboardType,
            style: TextStyle(
              fontSize: 16,
              color: enabled ? AppColors.darkGreen : AppColors.greyText,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: enabled ? AppColors.primaryGreen : AppColors.greyText,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              hintText: enabled ? 'Ingresa tu $label' : label,
              hintStyle: TextStyle(
                color: AppColors.greyText.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Botón de cerrar sesión
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton.icon(
              onPressed: _signOut,
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar sesión'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Copyright
          Text(
            '© 2025 AgroLink - Todos los derechos reservados',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.greyText.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
