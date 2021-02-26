#!/usr/bin/env rake

desc 'Generate OGP images'
task :tcard do
  sh 'find static/ogp/ -type f -name "*.png" | grep -v "base.png" | xargs -t --no-run-if-empty rm'
  sh 'find content/ -type f -name "*.md" | xargs -t -I % tcardgen -f ~/repo/sample-font/ -o static/ogp/ -c config/tcardgen.yaml %'
end
