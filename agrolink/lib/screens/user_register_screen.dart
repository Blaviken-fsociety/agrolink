import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme/colors.dart';

class UserRegisterScreen extends StatefulWidget {
  const UserRegisterScreen({super.key});

  @override
  State<UserRegisterScreen> createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController zoneCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  final TextEditingController confirmPassCtrl = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  List<String> selectedDays = [];

  final List<String> daysOfWeek = [
    'Domingo',
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [_buildHeader(), _buildRegisterForm(), _buildFooter()],
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
          // Botón de regreso
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 20),

          // Logo o ícono principal
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const Icon(Icons.person_add, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 16),

          // Título principal
          const Text(
            'Crear Cuenta',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 8),

          // Subtítulo
          const Text(
            'Únete a nuestra comunidad agrícola',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Container(
      margin: const EdgeInsets.all(20),
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
          // Título del formulario
          const Row(
            children: [
              Icon(Icons.person_add, color: AppColors.primaryGreen, size: 24),
              SizedBox(width: 12),
              Text(
                'Información Personal',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Campo de nombre
          _buildInputField(
            label: 'Nombres y Apellidos',
            controller: nameCtrl,
            icon: Icons.person_outline,
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 20),

          // Campo de email
          _buildInputField(
            label: 'Correo Electrónico',
            controller: emailCtrl,
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),

          // Campo de teléfono
          _buildInputField(
            label: 'Teléfono',
            controller: phoneCtrl,
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),

          // Campo de zona
          _buildInputField(
            label: 'Zona de Residencia',
            controller: zoneCtrl,
            icon: Icons.location_on_outlined,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 20),

          // Campo de disponibilidad
          _buildAvailabilityField(),
          const SizedBox(height: 20),

          // Campos de contraseña
          _buildPasswordField(
            label: 'Contraseña',
            controller: passCtrl,
            obscureText: _obscurePassword,
            onToggle:
                () => setState(() => _obscurePassword = !_obscurePassword),
          ),
          const SizedBox(height: 20),

          _buildPasswordField(
            label: 'Confirmar Contraseña',
            controller: confirmPassCtrl,
            obscureText: _obscureConfirmPassword,
            onToggle:
                () => setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                ),
          ),
          const SizedBox(height: 30),

          // Botón de registro
          _buildRegisterButton(),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
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
            color: AppColors.softBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.lightGreen),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 16, color: AppColors.darkGreen),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.primaryGreen),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              hintText: 'Ingresa tu $label',
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

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggle,
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
            color: AppColors.softBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.lightGreen),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: const TextStyle(fontSize: 16, color: AppColors.darkGreen),
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: AppColors.primaryGreen,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.primaryGreen,
                ),
                onPressed: onToggle,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              hintText: 'Ingresa tu $label',
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

  Widget _buildAvailabilityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Días de Disponibilidad',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGreen,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _showMultiSelectDialog,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.softBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.lightGreen),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: AppColors.primaryGreen),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedDays.isEmpty
                        ? 'Selecciona los días disponibles'
                        : selectedDays.join(', '),
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          selectedDays.isEmpty
                              ? AppColors.greyText.withOpacity(0.7)
                              : AppColors.darkGreen,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.primaryGreen,
                ),
              ],
            ),
          ),
        ),
        if (selectedDays.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children:
                selectedDays.map((day) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.greenGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          day,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDays.remove(day);
                            });
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleRegister,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          disabledBackgroundColor: AppColors.greyText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child:
            _isLoading
                ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Registrando...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
                : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_add, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Crear Cuenta',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Beneficios de registrarse
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Column(
              children: [
                Text(
                  'Beneficios de Unirte',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGreen,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _BenefitItem(
                        icon: Icons.group,
                        text: 'Comunidad\nAgrícola',
                      ),
                    ),
                    Expanded(
                      child: _BenefitItem(
                        icon: Icons.support_agent,
                        text: 'Soporte\nPersonalizado',
                      ),
                    ),
                    Expanded(
                      child: _BenefitItem(
                        icon: Icons.school,
                        text: 'Recursos\nEducativos',
                      ),
                    ),
                  ],
                ),
              ],
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

  void _showMultiSelectDialog() async {
    final List<String> tempSelected = List.from(selectedDays);

    final selectedResult = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Row(
                children: [
                  Icon(Icons.calendar_today, color: AppColors.primaryGreen),
                  SizedBox(width: 12),
                  Text(
                    'Días de Disponibilidad',
                    style: TextStyle(
                      color: AppColors.darkGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children:
                      daysOfWeek.map((day) {
                        return CheckboxListTile(
                          title: Text(
                            day,
                            style: const TextStyle(color: AppColors.darkGreen),
                          ),
                          value: tempSelected.contains(day),
                          activeColor: AppColors.primaryGreen,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                if (!tempSelected.contains(day)) {
                                  tempSelected.add(day);
                                }
                              } else {
                                tempSelected.remove(day);
                              }
                            });
                          },
                        );
                      }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, selectedDays),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: AppColors.greyText),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, tempSelected),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Aceptar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (selectedResult != null) {
      setState(() {
        selectedDays = selectedResult;
      });
    }
  }

  Future<void> _handleRegister() async {
    // Validación de campos
    if (nameCtrl.text.trim().isEmpty ||
        emailCtrl.text.trim().isEmpty ||
        phoneCtrl.text.trim().isEmpty ||
        zoneCtrl.text.trim().isEmpty ||
        passCtrl.text.trim().isEmpty ||
        confirmPassCtrl.text.trim().isEmpty) {
      _showSnackBar('Por favor completa todos los campos');
      return;
    }

    if (passCtrl.text.trim() != confirmPassCtrl.text.trim()) {
      _showSnackBar('Las contraseñas no coinciden');
      return;
    }

    if (selectedDays.isEmpty) {
      _showSnackBar('Selecciona al menos un día de disponibilidad');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = await AuthService().registerUser(
        emailCtrl.text.trim(),
        passCtrl.text.trim(),
        name: nameCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        zone: zoneCtrl.text.trim(),
        availability: selectedDays,
      );

      if (user != null) {
        _showSnackBar('Registro exitoso. ¡Bienvenido a AgroLink!');
        Navigator.pop(context);
      } else {
        _showSnackBar('Error en el registro. Inténtalo nuevamente');
      }
    } catch (e) {
      _showSnackBar('Error al crear la cuenta. Verifica tu información');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.primaryGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    zoneCtrl.dispose();
    passCtrl.dispose();
    confirmPassCtrl.dispose();
    super.dispose();
  }
}

class _BenefitItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _BenefitItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: AppColors.greenGradient,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.greyText,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
