#npm init --yes

cat > package.json <<DELIM
{
  "name": "react-es6",
  "description": "A React.js project",
  "version": "1.0.0",
  "author": "Roberto C. Navarro",
  "private": true,
  "scripts": {
    "dev": "cross-env NODE_ENV=development webpack-dev-server --open --inline --hot",
    "build": "cross-env NODE_ENV=production webpack --progress --hide-modules"
  },
  "dependencies": {
  },
  "devDependencies": {
  }
}
DELIM

npm install --save react react-dom
npm install --save-dev webpack@beta webpack-dev-server@beta babel-loader babel-preset-es2015 babel-core babel-preset-react cross-env
npm install --save-dev json-loader style-loader css-loader autoprefixer-loader sass-loader node-sass

# Configure Babel
echo '{ "presets": ["react","es2015"] }' > .babelrc

cat > webpack.config.js <<DELIM
var path = require('path');
var webpack = require('webpack');

module.exports = {
  entry: './app/main.jsx',
  output: {
    path: path.resolve(__dirname, './dist'),
    publicPath: '/dist/',
    filename: 'build.js'
  },
  module: {
    loaders: [
        {
          test: /\.jsx$/,
          exclude: /(node_modules)/,
          loader: 'babel-loader',
          query: {
            presets: ['es2015', 'react']
          }
        },
        {
          test: /\.json$/,
          exclude: /(node_modules)/,
          loader: 'json-loader'
        },
        {
          test: /\.css$/,
          loader: 'style-loader!css-loader!autoprefixer-loader'
        },
        {
          test: /\.scss$/,
          loader: 'style-loader!css-loader!autoprefixer-loader!sass-loader'
        }
    ]
  },
  devServer: {
    historyApiFallback: true,
    noInfo: true
  },
  performance: {
    hints: false
  },
  devtool: '#inline-source-map' //see: bit.ly/2i0EF8h '#eval-source-map'
};

if (process.env.NODE_ENV === 'production') {
  module.exports.devtool = '#source-map';
  // http://vue-loader.vuejs.org/en/workflow/production.html
  module.exports.plugins = (module.exports.plugins || []).concat([
    new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: '"production"'
      }
    }),
    new webpack.optimize.UglifyJsPlugin({
      sourceMap: true,
      compress: {
        warnings: false
      }
    }),
    new webpack.LoaderOptionsPlugin({
      minimize: true
    })
  ]);
}
DELIM

cat > index.html <<DELIM
<!DOCTYPE html>
<html>
  <head>
      <meta charset="UTF-8">
      <title>Title</title>
  </head>
  <body>
    <div id="root"></div>
     
    <script type="text/javascript" src="/dist/build.js"></script>
     
  </body>
</html>
DELIM

mkdir app
cat > app/main.jsx <<DELIM
import React ,{Component} from 'react';
import ReactDOM from 'react-dom';

import text from './data/values.json';
import './stylesheets/hello.scss';
 
class App extends Component {
    render(){
        return(
            <div>
                <h1 className='hello'>{text.message}</h1>
            </div>
        );
    }
}
 
ReactDOM.render(<App />,document.getElementById('root'));
DELIM

mkdir app/stylesheets
cat > app/stylesheets/hello.scss <<DELIM
@import url('https://fonts.googleapis.com/css?family=Exo');

.hello {
    font-family: 'Exo', monospace;
}
DELIM

