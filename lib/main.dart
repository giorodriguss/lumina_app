import 'package:flutter/material.dart';
import 'dart:async';

class MockDatabase {
  // Singleton: garante que sempre usamos a mesma instância do banco na memória
  static final MockDatabase _instance = MockDatabase._internal();
  factory MockDatabase() => _instance;
  MockDatabase._internal();

  // Lista para armazenar os eventos (Acontecimentos)
  final List<Map<String, String>> _events = [
    {
      'id': '1',
      'date': '26/11/25 10:30',
      'title': 'Reunião tensa',
      'description': 'Meu chefe criticou meu projeto na frente de todos.',
      'thoughts': 'Achei que ia ser demitido na hora.',
      'feelings': 'Vergonha, Medo',
      'reaction': 'Fiquei calado e baixei a cabeça.',
    },
    {
      'id': '2',
      'date': '25/11/25 18:00',
      'title': 'Academia cancelada',
      'description': 'Não consegui ir treinar porque choveu.',
      'thoughts': 'Sou um fracasso por não ter disciplina.',
      'feelings': 'Frustração',
      'reaction': 'Comi doce para compensar.',
    },
  ];

  // chamada de API para pegar eventos (GET)
  Future<List<Map<String, String>>> getEvents() async {
    await Future.delayed(const Duration(milliseconds: 800)); // Fake loading
    return List.from(_events); // Retorna uma cópia para segurança
  }

  // criar evento (POST)
  Future<void> addEvent(Map<String, String> event) async {
    await Future.delayed(const Duration(seconds: 1));
    event['id'] = DateTime.now().millisecondsSinceEpoch.toString(); // Gera ID
    event['date'] =
        "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}";
    _events.insert(0, event); // Adiciona no topo da lista
  }

  // editar evento (PUT)
  Future<void> updateEvent(String id, Map<String, String> newEvent) async {
    await Future.delayed(const Duration(seconds: 1));
    final index = _events.indexWhere((element) => element['id'] == id);
    if (index != -1) {
      _events[index] = {
        ...newEvent,
        'id': id,
        'date': _events[index]['date']!, // Mantém a data original ou atualiza
      };
    }
  }

  // deletar evento (DELETE)
  Future<void> deleteEvent(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _events.removeWhere((element) => element['id'] == id);
  }

  // Login
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1, milliseconds: 500));
    // Aceita qualquer login para teste, desde que não seja vazio
    return email.isNotEmpty && password.isNotEmpty;
  }
}

void main() {
  runApp(const LuminaApp());
}

class LuminaApp extends StatelessWidget {
  const LuminaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lumina',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[50],
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black87),
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.teal, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

// TELA 1: LOGIN (Autenticação)
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _isLoading = false;

  void _doLogin() async {
    setState(() => _isLoading = true);
    bool success = await MockDatabase().login(
      _emailController.text,
      _passController.text,
    );
    setState(() => _isLoading = false);

    if (success) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha os campos para entrar.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo
                Image.asset(
                  'assets/logo.png',
                  height: 100,
                  errorBuilder: (c, e, s) => const Icon(
                    Icons.psychology,
                    size: 100,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Lumina',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'O caminho para o autoconhecimento.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 40),

                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ForgotPasswordScreen(),
                      ),
                    ),
                    child: const Text('Esqueci a senha'),
                  ),
                ),
                const SizedBox(height: 16),

                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _doLogin,
                        child: const Text('Entrar'),
                      ),

                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Colors.teal),
                  ),
                  child: const Text(
                    'Criar conta',
                    style: TextStyle(color: Colors.teal),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// TELA 2: CADASTRO (Formulário)
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isLoading = false;

  void _register() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // Simula criação
    setState(() => _isLoading = false);

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Conta criada com sucesso!')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar Conta')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TextField(
              decoration: InputDecoration(labelText: 'Nome completo'),
            ),
            const SizedBox(height: 16),
            const TextField(decoration: InputDecoration(labelText: 'E-mail')),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(labelText: 'Data de Nascimento'),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Senha',
                suffixIcon: Icon(Icons.visibility_off),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(labelText: 'Confirmar Senha'),
            ),
            const SizedBox(height: 32),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _register,
                    child: const Text('Cadastrar'),
                  ),
          ],
        ),
      ),
    );
  }
}

// TELA 3: ESQUECI A SENHA (Feedback)
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.lock_reset, size: 80, color: Colors.teal),
            const SizedBox(height: 24),
            const Text(
              'Esqueceu sua senha?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Digite seu e-mail abaixo e enviaremos um link para redefinição.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            const TextField(
              decoration: InputDecoration(
                labelText: 'E-mail cadastrado',
                prefixIcon: Icon(Icons.mail),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('E-mail de recuperação enviado!'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text('Enviar Link'),
            ),
          ],
        ),
      ),
    );
  }
}

// TELA 4: HOME (Dashboard, Listagem e Menu)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> _events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Recarrega os dados do "banco"
  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final data = await MockDatabase().getEvents();
    setState(() {
      _events = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menu Lateral (Drawer)
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              accountName: Text('Estudante Teste'),
              accountEmail: Text('usuario@lumina.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.teal),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Meu Perfil'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configurações'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Sair', style: TextStyle(color: Colors.red)),
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Olá, Estudante'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Card de Humor
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Como você está se sentindo hoje?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Icon(
                          Icons.sentiment_very_dissatisfied,
                          color: Colors.red,
                          size: 32,
                        ),
                        Icon(
                          Icons.sentiment_neutral,
                          color: Colors.amber,
                          size: 32,
                        ),
                        Icon(
                          Icons.sentiment_very_satisfied,
                          color: Colors.green,
                          size: 32,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AddEventScreen(),
                            ),
                          );
                          _loadData(); // Recarrega ao voltar
                        },
                        child: const Text('Registrar acontecimento'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Últimos registros',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Lista de Registros
            _isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : _events.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhum registro ainda.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _events.length,
                    itemBuilder: (context, index) {
                      final event = _events[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          title: Text(
                            event['title'] ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                event['description'] ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                event['date'] ?? '',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.teal[700],
                                ),
                              ),
                            ],
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                          onTap: () async {
                            // Navega para Detalhes
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EventDetailScreen(event: event),
                              ),
                            );
                            _loadData(); // Recarrega se deletou ou editou
                          },
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

// TELA 5: ADICIONAR/EDITAR ACONTECIMENTO
class AddEventScreen extends StatefulWidget {
  final Map<String, String>? eventToEdit; // Se vier preenchido, é edição
  const AddEventScreen({super.key, this.eventToEdit});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _thoughtsController = TextEditingController();
  final _feelingsController = TextEditingController();
  final _reactionController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Se for edição, preenche os campos
    if (widget.eventToEdit != null) {
      _titleController.text = widget.eventToEdit!['title'] ?? '';
      _descController.text = widget.eventToEdit!['description'] ?? '';
      _thoughtsController.text = widget.eventToEdit!['thoughts'] ?? '';
      _feelingsController.text = widget.eventToEdit!['feelings'] ?? '';
      _reactionController.text = widget.eventToEdit!['reaction'] ?? '';
    }
  }

  void _save() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dê um título para o acontecimento.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final eventData = {
      'title': _titleController.text,
      'description': _descController.text,
      'thoughts': _thoughtsController.text,
      'feelings': _feelingsController.text,
      'reaction': _reactionController.text,
    };

    if (widget.eventToEdit != null) {
      await MockDatabase().updateEvent(widget.eventToEdit!['id']!, eventData);
    } else {
      await MockDatabase().addEvent(eventData);
    }

    setState(() => _isSaving = false);
    if (!mounted) return;
    Navigator.pop(context); // Volta para Home
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registro salvo com sucesso!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.eventToEdit != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Registro' : 'Novo Registro'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título Curto (Ex: Nota baixa)',
              ),
            ),
            const SizedBox(height: 20),
            _buildSection(
              'O que aconteceu?',
              'Descreva a situação...',
              _descController,
            ),
            const SizedBox(height: 16),
            _buildSection(
              'O que passou pela sua mente?',
              'Seus pensamentos...',
              _thoughtsController,
            ),
            const SizedBox(height: 16),
            _buildSection(
              'O que sentiu?',
              'Emoções (Ex: Raiva, Medo)...',
              _feelingsController,
            ),
            const SizedBox(height: 16),
            _buildSection(
              'Qual foi sua reação?',
              'O que você fez...',
              _reactionController,
            ),
            const SizedBox(height: 32),

            _isSaving
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _save,
                    child: Text(isEditing ? 'Atualizar' : 'Salvar Registro'),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    String label,
    String hint,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
          ),
        ),
      ],
    );
  }
}

// TELA 6: DETALHES DO ACONTECIMENTO
class EventDetailScreen extends StatelessWidget {
  final Map<String, String> event;
  const EventDetailScreen({super.key, required this.event});

  void _delete(BuildContext context) async {
    // Diálogo de confirmação
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir registro?'),
        content: const Text('Essa ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await MockDatabase().deleteEvent(event['id']!);
      if (!context.mounted) return;
      Navigator.pop(context); // Volta para Home
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Registro excluído.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navega para edição e substitui a tela atual ao voltar? Não, apenas empilha.
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => AddEventScreen(eventToEdit: event),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _delete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event['date'] ?? '',
              style: TextStyle(
                color: Colors.teal[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              event['title'] ?? '',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Divider(height: 32),
            _buildDetailItem('O Acontecimento', event['description']),
            _buildDetailItem('Pensamentos', event['thoughts']),
            _buildDetailItem('Sentimentos', event['feelings']),
            _buildDetailItem('Reação', event['reaction']),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String? content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content ?? '-',
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }
}

// TELA 7: PERFIL DE USUÁRIO
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu Perfil')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundColor: Colors.teal,
                child: Icon(Icons.person, size: 80, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                'Estudante Teste',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text(
                'usuario@lumina.com',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),
              ListTile(
                leading: const Icon(Icons.cake),
                title: const Text('Data de Nascimento'),
                subtitle: const Text('01/01/1990'),
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text('Membro desde'),
                subtitle: const Text('Novembro de 2025'),
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// TELA 8: CONFIGURAÇÕES
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Notificações Diárias'),
            subtitle: const Text('Lembretes para registrar seu dia'),
            value: _notifications,
            activeColor: Colors.teal,
            onChanged: (val) => setState(() => _notifications = val),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Modo Escuro'),
            subtitle: const Text('Economizar bateria e relaxar a vista'),
            value: _darkMode,
            activeColor: Colors.teal,
            onChanged: (val) {
              setState(() => _darkMode = val);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tema simulado alterado (apenas visual)'),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Versão do App'),
            subtitle: const Text('1.0.0 (Beta)'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Termos de Uso'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
