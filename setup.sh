#npm init --yes

cat > package.json <<DELIM
{
  "name": "react-es6",
  "description": "A React.js project",
  "version": "1.0.0",
  "author": "Roberto C. Navarro",
  "private": true,
  "scripts": {
    "dev": "cross-env NODE_ENV=development webpack-dev-server --open --colors --inline --hot --progress",
    "build": "cross-env NODE_ENV=production webpack --progress --hide-modules"
  },
  "dependencies": {
  },
  "devDependencies": {
  }
}
DELIM

npm install --save react react-dom
npm install --save bootstrap@3 react-bootstrap
npm install --save-dev webpack@beta webpack-dev-server@beta babel-loader babel-preset-es2015 babel-core babel-preset-react cross-env
npm install --save-dev json-loader style-loader css-loader autoprefixer-loader sass-loader node-sass file-loader url-loader img-loader

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
          test: /\.jsx?$/,
          exclude: /(node_modules)/,
          loader: 'babel-loader'
        },
        {
          test: /\.json$/,
          exclude: /(node_modules)/,
          loader: 'json-loader'
        },
        {
          test: /\.css$/,
          loader: 'style-loader!css-loader?sourceMap!autoprefixer-loader'
        },
        {
          test: /\.scss$/,
          loader: 'style-loader!css-loader?sourceMap!autoprefixer-loader!sass-loader?sourceMap'
        },
        {
          test: /\.(svg|ttf|woff|woff2|eot)(\?v=\d+\.\d+\.\d+)?$/,
          loader: "url-loader"
        },
        {
          test: /\.png$/,
          loader: "url-loader!img-loader"
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
  //inspired by: http://vue-loader.vuejs.org/en/workflow/production.html
  module.exports.plugins = (module.exports.plugins || []).concat([
    new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: 'production'
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
      <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">      
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
import 'bootstrap/dist/css/bootstrap.css';
import {Grid, Row, Col, PageHeader, Button, Input} from 'react-bootstrap';

import './stylesheets/hello.scss';

import React ,{Component} from 'react';
import ReactDOM from 'react-dom';

import text from './data/values.json';

class App extends Component {
    render(){
        return(
            <Grid>
                <Row>
                    <Col sm={12}>
                        <PageHeader className="hello">{text.message}</PageHeader>
                        <Button bsStyle="success">Success</Button>                        
                    </Col>
                </Row>              
            </Grid>
        );
    }
}
 
ReactDOM.render(<App />,document.getElementById('root'));
DELIM

mkdir app/data
cat > app/data/values.json <<DELIM
{
  "message": "Hello World!"
}
DELIM

mkdir app/stylesheets
cat > app/stylesheets/hello.scss <<DELIM
@import url('https://fonts.googleapis.com/css?family=Exo');

.hello {
    font-family: 'Exo', monospace;
}
DELIM

