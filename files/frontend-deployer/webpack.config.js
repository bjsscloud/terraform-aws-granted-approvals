const path = require("path");

module.exports = {
  target: 'node',

  entry: './index.js',

  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'handler.js',
    libraryTarget: 'commonjs',
  },

  mode: 'production',

  // This is specifically to deal with an error in
  // aws-sdk/lib/event_listeners.js (line 594) where "util" is "required"
  // instead of "./util"
  resolve: {
    preferRelative: true,
  },

  devtool: "source-map",

  // During development - to get sane line numbers
  optimization: {
    minimize: false
  },

};
