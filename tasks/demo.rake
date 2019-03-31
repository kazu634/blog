#!/usr/bin/env rake

desc 'Generate the HTML demo pages including drafts'
task :demo do
  sh 'hugo server --buildDrafts -w'
end
