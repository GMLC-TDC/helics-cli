const path = require('path');
const webpack = require('webpack');
const {CleanWebpackPlugin} = require('clean-webpack-plugin');
const HtmlWebpackPlugin = require('html-webpack-plugin')


module.exports = {
    entry: {
        index: './src/js/index.js'
    },
    output: {
        filename: '[name].bundle.js',
        chunkFilename: '[name].bundle.js',
        path: path.resolve(__dirname, 'dist'),
        libraryTarget: 'var',
        library: 'EntryPoint'
    },
    optimization: {
        chunkIds: 'named',
        splitChunks: {
            chunks: "all"
        }
    },
    plugins: [
        new CleanWebpackPlugin({
            cleanAfterEveryBuildPatterns: ['dist']
        }),
        new HtmlWebpackPlugin({
            filename: "index.html",
            template: "./src/html/index.html"
        }),
        new webpack.ProvidePlugin({
            jQuery: 'jquery',
            $: 'jquery',
            jquery: 'jquery'
        })
    ],
    module: {
        rules: [
            // use the url loader for font files
            {
                test: /\.(woff2?|ttf|eot|svg)$/,
                use: [
                    {
                        loader: 'url-loader',
                        options: {
                            limit: 10000
                        }
                    }
                ]
            },
            {
                test: /\.(scss)$/,
                use: [
                    {
                        // Adds CSS to the DOM by injecting a `<style>` tag
                        loader: 'style-loader'
                    },
                    {
                        // Interprets `@import` and `url()` like `import/require()` and will resolve them
                        loader: 'css-loader'
                    },
                    {
                        // Loader for webpack to process CSS with PostCSS
                        loader: 'postcss-loader',
                        options: {
                            plugins: function () {
                                return [
                                    require('autoprefixer')
                                ];
                            }
                        }
                    },
                    {
                        // Loads a SASS/SCSS file and compiles it to CSS
                        loader: 'sass-loader'
                    }
                ]
            }
        ]
    }
};


