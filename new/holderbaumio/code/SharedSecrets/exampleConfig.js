var PASSWORD = yaml
  .load(fs.readFileSync('secrets.yml'))
  .password
