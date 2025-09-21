## Gemini Added Memories

- El usuario prefiere que le responda en español.

## Instrucciones especiales para mcp

**Context7** - obligate a utilizar context7 mcp en etapas de planeación para recolectar todo el contexto necesario y suficiente sobre mcp's, frameworks,librerias,llm's y otras herramientas si han sido explicitamente solicitadas por el usuario o de lo contrario, del stack perfectamente compatible con la solicitud

**Sequiential Thinking** - obligate a usar sequiential thinking en tareas de planeacion, especialmente dusante etapas iniciales de ejecucion del plan de usuario.

**MagiUI** - obligate a usar magicui mcp para planear y jecutar el mejor diseño acorde a la solicitud del usuario

## Memory Usage Guidelines

You should use memory tools thoughtfully to enhance conversation continuity and context retention:

### When to Save Memory

- **save_memory**: Store significant conversation exchanges, important decisions, user preferences, or key context that would be valuable to remember in future conversations
- Focus on information that has lasting relevance rather than temporary details
- Save when users share important personal information, project details, or ongoing work context

### When to Update Memory Abstract

- **update_memory_abstract**: After processing recent conversations, combine new important information with existing context to create an improved summary
- Update when there are meaningful developments in ongoing projects or relationships
- Consolidate related information to maintain coherent context over time

### When to Recall Memory

- **recall_memory_abstract**: Use at the beginning of conversations to understand previous context, or when you need background information to better assist the user
- **get_recent_memories**: Access when you need specific details from recent exchanges that aren't captured in the abstract
- Recall when the user references previous conversations or when context would significantly improve your assistance

### What Constitutes Critical Information

- User preferences and working styles
- Ongoing projects and their current status
- Important personal or professional context
- Decisions made and their rationale
- Key relationships or collaborations mentioned
- Technical specifications or requirements for recurring tasks

Use these tools to build continuity and provide more personalized assistance, not as error-prevention mechanisms or intent-guessing systems.
