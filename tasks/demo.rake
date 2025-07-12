#!/usr/bin/env rake

desc 'Generate the HTML demo pages including drafts'
task :demo do
  sh 'hugo server --buildDrafts -w --bind 192.168.10.102 -b 192.168.10.102 --disableFastRender'
end
