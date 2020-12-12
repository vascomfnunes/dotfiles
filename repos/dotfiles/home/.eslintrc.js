module.exports = {
  env: {
    browser: true,
    es6: true,
    jquery: true,
    commonjs: true,
  },
  extends: ["plugin:prettier/recommended"],
  globals: {
    Atomics: "readonly",
    SharedArrayBuffer: "readonly",
  },
  parserOptions: {
    ecmaVersion: 2018,
    sourceType: "module",
  },
  rules: {
    quotes: [2, "single", { avoidEscape: true }],
  },
};
