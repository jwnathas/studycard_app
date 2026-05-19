## Studycards 🚀

Plataforma mobile de memorização ativa e repetição espaçada por meio de flashcards interativos. Este projeto foi concebido e implementado de forma nativa e multiplataforma utilizando o ecossistema **Flutter** e a linguagem **Dart**.

---

## 🎓 Contexto Acadêmico

Este projeto representa o artefato de avaliação prática desenvolvido para a disciplina de **Desenvolvimento para Dispositivos Móveis** no **Instituto Federal de Brasília (IFB)**.

* **Desenvolvedor:** Jônathas Batista Silva
* **Instituição:** Instituto Federal de Brasília (IFB)
* **Escopo:** Aplicação de conceitos avançados de gerenciamento de estado, persistência de dados local, ciclo de vida de componentes e fidelidade de design de alta fidelidade (*Pixel-Perfect*).

---

## ✨ Funcionalidades Principais

O aplicativo foi modularizado e construído sob três pilares de experiência do usuário (UX):

### 1. Gerenciamento Avançado de Módulos (Home)
* **CRUD Completo e Reativo:** Fluxo integral para criação, leitura, atualização e exclusão (com exclusão em cascata automatizada para os flashcards correlacionados).
* **Design de Três Colunas:** Estrutura interna refinada contendo Ícone dinâmico com cor semântica do tema, Bloco central adaptativo e Coluna compacta de ações de segurança.
* **Barra de Progresso:** Feedback visual imediato computando o percentual exato do nível de domínio atual de cada tópico.

### 2. Painel e Sessão de Estudos (`/estudar`)
* **Índice de Revisão Direta:** Aba centralizada exibindo metadados consolidados no formato canônico: `{total} cards • {progresso}% dominado`.
* **Feedback Tátil Premium:** Injeção de física adaptativa de toque com escala reduzida a `scale(0.99)` por meio de `AnimatedScale` em transições ultrarrápidas de 80 milissegundos.
* **Sessão Ativa:** Acoplamento com fluxo de revisão interativo para transição de níveis de domínio dos flashcards.

### 3. Tela do Conteúdo do Módulo
* **Métricas de Controle:** Blocos estatísticos analíticos segregando cartões por status: `TOTAL`, `DÚVIDA` e `DOMINEI`.
* **Cabeçalho Seamless:** Layout horizontal alinhado contendo botão de navegação circular integrado ao título dinâmico, blindado contra quebras de viewport ou estouros de área.

---

## 🛠️ Tecnologias e Arquitetura

O ecossistema técnico do projeto foi selecionado para garantir máxima performance de runtime e facilidade de manutenção de código:

* **Framework:** Flutter (Versão estável e moderna 3.27+)
* **Linguagem:** Dart 3 (Aproveitando tipagem estrita, null-safety nativa e operadores seguros de espalhamento `...`).
* **Gerenciamento de Estado:** `Provider` acoplado ao padrão reativo de `ChangeNotifier` para atualizações limpas sem reconstruções desnecessárias da árvore de renderização.
* **Persistência Local:** `SharedPreferences` com serialização e desserialização em objetos JSON estruturados em formato string.
* **Iconografia:** `Lucide Icons` integrados de forma customizada com espessura de traço e tamanho escalável de `20px`.

---

## 🎨 Sistema de Design e Design Tokens

A especificação de design baseou-se em guias rigorosos mobile-first otimizados para viewports com largura máxima controlada de `448px`.

* ** tokens de Borda e Raio:** Uso consistente de curvaturas complexas de `22px` (cards principais) e `16px` (modais estruturais e listas de estudo).
* **Efeito Glassmorphism/Blur:** Cabeçalhos com opacidades calculadas (`.withValues(alpha: ...)`) gerando efeito fosco de sobreposição de scroll.
* **Esquema de Cores Semânticas:**
    * `AppColors.primary`: Azul Real da marca (`#4963DE`)
    * `AppColors.purple`: Roxo vibrante de interface (`#8B5CF6`)
    * `AppColors.green`: Indicador de sucesso/domínio (`#10B981`)
    * `AppColors.orange`: Indicador de dúvida (`#F59E0B`)
    * `AppColors.red`: Indicador de perigo/exclusão (`#EF4444`)

---

## 📁 Estrutura de Pastas do Projeto

lib/
├── data/
│   └── study_store.dart       # Cérebro da app: Estado central e Persistência SharedPreferences
├── models/
│   ├── flashcard.dart         # Modelo e conversões JSON do Flashcard
│   ├── nivel_dominio.dart     # Enum com os níveis (novo, emDuvida, dominei)
│   └── study_module.dart      # Modelo e conversões JSON do Módulo de estudo
├── screens/
│   ├── about_screen.dart      # Aba "Sobre": Informações do autor e institucionais do IFB
│   ├── module_detail_screen.dart # Tela de detalhe: Estatísticas e lista de cards do módulo
│   ├── module_list_screen.dart   # Aba "Módulos": Tela inicial com o CRUD de módulos
│   └── study_index_screen.dart   # Aba "Estudar": Escolha rápida de módulos com feedback tátil
├── theme/
│   └── app_colors.dart        # Dicionário e tokens centrais de cores do app
└── widgets/
    ├── app_shell.dart         # Estrutura unificada: IndexedStack de gerenciamento do BottomNav
    └── custom_header.dart     # Cabeçalho global fixado com efeitos foscos de sobreposição