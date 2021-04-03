module.exports = {
  vmware: {
    singleQuote: true,
    arrowParens: "always",
    printWidth: 120,
  },
  carbon: {
    singleQuote: true,
  },
}[process.env.HOST]
