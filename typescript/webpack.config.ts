import * as webpack from "webpack";
import * as CleanWebpackPlugin from "clean-webpack-plugin";
import * as path from "path";

const config = {
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
    resolve: {
       extensions: [".ts", ".js"],
    },
    plugins: [
        new CleanWebpackPlugin(["dist"]),
        new webpack.NoEmitOnErrorsPlugin(),
    ],
    optimization: {
        minimize: true
    }
};

export default config;
