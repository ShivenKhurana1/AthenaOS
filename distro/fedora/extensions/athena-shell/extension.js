import * as Main from 'resource:///org/gnome/shell/ui/main.js';

let enabled = false;

export function enable() {
  if (enabled) {
    return;
  }
  enabled = true;
  if (Main.panel?.actor) {
    Main.panel.actor.add_style_class_name('athena-panel');
  }
}

export function disable() {
  if (!enabled) {
    return;
  }
  enabled = false;
  if (Main.panel?.actor) {
    Main.panel.actor.remove_style_class_name('athena-panel');
  }
}
