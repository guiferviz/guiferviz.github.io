# Run Jekyll server in Cloud9.
#jekyll server --watch --drafts --host $IP --port $PORT

export JEKYLL_VERSION=3.8
docker run --rm \
  --volume="$PWD:/srv/jekyll" \
  -p "4000:4000" \
  -it jekyll/jekyll:$JEKYLL_VERSION \
  jekyll server --watch --drafts -port 4000
