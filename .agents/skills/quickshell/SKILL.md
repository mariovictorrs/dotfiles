---
name: quickshell
description: >-
  Use esta skill para configuração, troubleshooting e desenvolvimento com
  Quickshell/QML (ShellRoot, PanelWindow, Variants, serviços, widgets, layouts,
  IPC, animações e boas práticas de QML no Qt 6).
---

# Quickshell Skill

Guia prático para responder e implementar mudanças em Quickshell com base em:

- Quickshell v0.3.0 Guide: https://quickshell.org/docs/v0.3.0/guide/
- QML Coding Conventions (Qt 6): https://doc.qt.io/qt-6/qml-codingconventions.html

## Quando usar esta skill

Use esta skill quando a solicitação envolver:

1. Estrutura de shell em Quickshell (`ShellRoot`, `PanelWindow`, `FloatingWindow`, `Variants`).
2. Componentes QML (barra, launcher, notificações, lockscreen, overlays, popups).
3. Serviços e estado (`pragma Singleton`, `PersistentProperties`, `FileView`, timers).
4. Integração com sistema (Hyprland, PipeWire, Notifications, subprocessos/`Process`).
5. Refatoração/diagnóstico de código QML seguindo convenções oficiais do Qt.

## Regras de implementação (seguir sempre)

1. **Priorize documentação oficial** do Quickshell e do Qt; evite padrões antigos sem confirmar versão.
2. **Mantenha o QML idiomático**: legível, declarativo e com bindings claros (sem JS excessivo em linha).
3. **Use componentes e serviços reutilizáveis** em vez de duplicar lógica em múltiplos arquivos.
4. **Preserve hot-reload e estado** com `PersistentProperties` quando houver estado de UI relevante.
5. **Evite polling constante**: timers devem ser condicionais ao uso/visibilidade.
6. **Ao diagnosticar**, verifique imports, tipos Quickshell, propriedades `required` e acesso por `id`.

## Convenções obrigatórias de QML (Qt 6)

Dentro de cada objeto QML, mantenha esta ordem:

1. `id`
2. declarações de `property`
3. `signal`
4. funções JavaScript
5. propriedades do objeto (bindings/anchors/layout)
6. objetos filhos

Boas práticas adicionais:

- Referencie propriedades do pai com `id` explícito (`root.foo`) para clareza e performance.
- Prefira `required property` para dependências externas do componente.
- Em handlers de sinal, prefira função com parâmetros nomeados (`onClicked: event => { ... }`).
- Use group notation quando melhorar legibilidade (`anchors { ... }`, `font { ... }`).
- Uma propriedade por linha, com espaçamento consistente.

## Padrões Quickshell recomendados

1. **Entry point enxuto**: `shell.qml` apenas compõe módulos principais.
2. **Serviços singleton** para estado global e integração com sistema.
3. **UI modular** em componentes pequenos (containers, controls, effects).
4. **Config centralizada** (arquivo + adapter), com debounce para escrita.
5. **Carga preguiçosa** (`Loader`/`LazyLoader`) em painéis e diálogos pesados.
6. **Animações por `Behavior` e `Transition`**, sem lógica imperativa desnecessária.

## Troubleshooting rápido

Quando houver erro ou comportamento estranho:

1. Confirme versão/compatibilidade com Quickshell v0.3.0 docs.
2. Revise `import`s e nomes de tipos.
3. Verifique `required property` não preenchida.
4. Procure bindings com acesso implícito (sem `root.`) e referências nulas.
5. Valide fluxo de estado (timers, loaders, propriedades persistentes).
6. Em integração de sistema, teste comandos/processos isoladamente antes de culpar UI.

## Exemplos de temas que esta skill cobre bem

- Criar/ajustar barra Wayland com `PanelWindow`.
- Construir launcher com busca, estado e navegação por teclado.
- Implementar service de áudio (PipeWire) com controle e feedback visual.
- Organizar arquitetura de módulos (`components/`, `modules/`, `services/`, `config/`).
- Corrigir warnings e anti-patterns de QML conforme Qt 6.