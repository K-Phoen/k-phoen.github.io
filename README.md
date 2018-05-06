# My Blog

## Installation

- Fork this repository
- Clone it: `git clone https://github.com/K-Phoen/k-phoen.github.io`
- Run the dockerized jekyll server: `docker run --rm -it --volume="$PWD:/srv/jekyll" --volume="/tmp/jekyll:/usr/local/bundle" -p 127.0.0.1:4000:4000 jekyll/jekyll jekyll serve --drafts`

You should have a server up and running locally at <http://localhost:4000>.

## Deployment

You should deploy with [GitHub Pages](http://pages.github.com) — it's just easier.

All you should have to do is create a repository on GitHub named
`username.github.io`, push on it and voilà.
