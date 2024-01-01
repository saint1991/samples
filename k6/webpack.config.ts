import * as webpack from 'webpack';
import * as path from 'path';

const config: webpack.Configuration = {
    mode: 'production',
    entry: path.join(__dirname, "src", "index.ts"),
    output: {
        path: path.join(__dirname, 'dist'),
        libraryTarget: 'commonjs',
        filename: '[name].js',
        clean: true
    },
    resolve: {
        extensions: ['.ts', '.js'],
    },
    module: {
        rules: [
            {
                test: /\.ts$/,
                use: 'babel-loader',
                exclude: /node_modules/,
            }
        ]
    },
    target: 'web',
    externals: /^(k6|https?\:\/\/)(\/.*)?/,
    stats: {
        colors: true
    },
    optimization: {
        minimize: false,
    }
};

export default config;
