#!/usr/bin/env rake

require 'find'

desc 'Deploy the hugo contents to the server'
task :stag => [:prep] do
  sh 'hugo -e staging -v --minify'

  sh 'find public -type f -name "*.gz" -delete'

  Find.find("#{Dir::pwd}/public") do |f|
    if f =~ /\.(css|js|png|jpg|JPG|PNG|CSS|JS)$/ && FileTest.file?(f)
      sh "gzip -c #{f} > #{f}.gz"
      sh "rm #{f}"
    end
  end

  sh 'ssh -p 10022 webadm@10.0.1.166 "rm -rf /var/www/test/*"'
  sh 'rsync -e "ssh -p 10022" -rltvz --omit-dir-times --delete public/ webadm@10.0.1.166:/var/www/test'
end
