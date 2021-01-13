class MyPlugin {
  constructor(plugin) {
    this.plugin = plugin;

    plugin.registerCommand('SetMyLine', [this, this.setLine]);
  }

  setLine() {
    this.plugin.nvim.setLine('A line, for your troubles');
  }
}

module.exports = MyPlugin;
