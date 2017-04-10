module.exports = {
  files: {
    javascripts: {
      joinTo: 'app.js'
    },
    stylesheets: {
      joinTo: 'app.css'
    },
    templates: {
      joinTo: 'app.js'
    }
  },
  paths: {
    public: '../priv/static'
  },
  plugins: {
    babel: {
      presets: ['latest', 'stage-3']
    },
    vue: {
      extractCSS: true,
      out: '../priv/static/components.css'
    }
  },
  modules: {
    autoRequire: {
      'app.js': ['index']
    }
  }
}