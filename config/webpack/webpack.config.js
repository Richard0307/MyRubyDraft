const { webpackConfig: baseWebpackConfig, merge } = require('shakapacker')

const options = {
  resolve: {
    extensions: ['.css', '.scss']
  }
}

module.exports = merge({}, baseWebpackConfig, options)