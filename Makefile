serve:
	docker run --rm -it --volume="$(shell pwd):/srv/jekyll" --volume="$(shell eval 'echo ~')/tmp/jekyll:/usr/local/bundle" -p 127.0.0.1:4000:4000 jekyll/jekyll jekyll serve --drafts
