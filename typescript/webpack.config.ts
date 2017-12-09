import * as webpack from "webpack";
import * as CleanWebpackPlugin from "clean-webpack-plugin";
import * as path from "path";

const config: webpack.Configuration = {
    context: path.resolve(__dirname, "src"),
    entry: "./index.ts",
    output: {
        path: path.resolve(__dirname, "dist"),
        filename: "index.js"
    },
    module: {
        rules: [
            { test: /\.ts$/, use: "awesome-typescript-loader", exclude: ["webpack.config.ts"] },
            { test: /\.json$/, use: "json-loader" }
        ]
    },
    plugins: [
        new CleanWebpackPlugin(["dist"]),
        new webpack.NoEmitOnErrorsPlugin(),
        new webpack.optimize.UglifyJsPlugin({
            sourceMap: true
        })
    ]
};

export default config;
