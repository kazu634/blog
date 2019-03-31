#!/usr/bin/env rake

desc 'Textlint the .md'
task :lint do
  sh 'find . -type f -name "*.md" -mtime -1 | xargs -t -n 1 textlint'
end
