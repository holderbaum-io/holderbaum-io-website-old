# holderbaum.io website

[![Build Status](https://gitlab.com/holderbaum/holderbaum-io/badges/master/pipeline.svg)](https://gitlab.com/holderbaum/holderbaum-io/pipelines)

Built with [hugo](https://gohugo.io/), deployed with [gitlab-ci](https://gitlab.com/), hosted at [hetzner](https://www.hetzner.com/).

## Run locally

To work on the website (including live reload) run:

```sh
./go watch
```

## Bring it online

For publishing, run thos two steps:

```sh
./go build
./go deploy
```
