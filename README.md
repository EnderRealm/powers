# Beadpowers
Claude Code skills for [Beads](https://github.com/steveyegge/beads) based workflows. Largely inspired by [Superpowers](https://github.com/obra/superpowers) with beads specific modifications. 

## Why?
Superpowers is great but will generate markdown files within `docs/plans` without explicit instruction not to (and sometimes still does). With beads, work can be tracked within beads structued "memory", this plugin specializes (some) of the superpower skills for beads.

## Install
### Claude Code
In Claude Code, register the marketplace first:

```/plugin marketplace add pprice/beadpowers```

Then install the plugin from this marketplace:

```/plugin install beadpowers@beadpowers```

### Verify
After restarting `claude` you should see `/beadpowers:brainstorm` in `/skills`

## Commands
 
 - `beadpowers:brainstorm` - Like `superpowers:brainstorm` but beads epics and tasks are generated instead of plan files.

## Skills

 - `brainstorming` - Socratic design refinement
 - `create-beads` - Invoked after brain storming to create epics and tasks.

## Updating
Skills update automatically when you update the plugin:

```/plugin update beadpowers```

## Licence
MIT License - see LICENSE file for details.