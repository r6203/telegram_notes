// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration
module.exports = {
  content: ["./js/**/*.js", "../lib/*_web.ex", "../lib/*_web/**/*.*ex"],
  theme: {
    container: {
      center: true,
      padding: "2rem",
    },
    extend: {
      boxShadow: {
        box: "0 4px 16px rgba(0,0,0,.1)",
      },
    },
  },
  plugins: [require("@tailwindcss/forms")],
};
