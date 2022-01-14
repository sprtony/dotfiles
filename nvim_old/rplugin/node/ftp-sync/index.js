module.exports = (plugin) => {
  plugin.setOptions({ dev: false });

  plugin.registerCommand(
    "EchoMessage",
    async () => {
      try {
        await plugin.nvim.outWrite("Dayman (ah-ah-ah) \n");
      } catch (err) {
        console.error(err);
      }
    },
    { sync: false }
  );

  plugin.registerFunction(
    "SetLines",
    () => {
      return plugin.nvim
        .setLine("May I offer you an egg in these troubling times")
        .then(() => console.log("Line should be set"));
    },
    { sync: false }
  );
};
