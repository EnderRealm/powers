# Powers

Claude Code skills for [ticket](https://github.com/wedow/ticket/) based workflows.

## Install

In Claude Code:

```
/plugin marketplace add powers file://./.claude-plugin/marketplace.json
/plugin install powers@powers
```

After restarting `claude` you should see `/brainstorm` in `/skills`.

## Commands

- `/brainstorm` - Start a Socratic design session
- `/tk-ready` - Show tickets ready to work on
- `/tk-list` - List tickets with optional filters
- `/tk-ticket` - Create a single ticket
- `/tk-tickets` - Create structured tickets from a design

## Skills

- `powers:brainstorming` - Socratic design refinement before implementation
- `powers:create-tickets` - Convert designs into tk epics and tasks

## Updating

```
/plugin update powers
```

## License

MIT
