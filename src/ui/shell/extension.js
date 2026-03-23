import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import Shell from 'gi://Shell';

let enabled = false;
let blurEffect = null;

export function enable() {
  if (enabled) return;
  enabled = true;

  if (Main.panel) {
    Main.panel.add_style_class_name('athena-panel');
    
    // Add Blur Effect
    blurEffect = new Shell.BlurEffect({
      brightness: 0.85,
      sigma: 30,
      mode: Shell.BlurMode.BACKGROUND
    });
    Main.panel.add_effect_with_name('athena-blur', blurEffect);
  }
}

export function disable() {
  if (!enabled) return;
  enabled = false;

  if (Main.panel) {
    Main.panel.remove_style_class_name('athena-panel');
    Main.panel.remove_effect('athena-blur');
  }
  blurEffect = null;
}
