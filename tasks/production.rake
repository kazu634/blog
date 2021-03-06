#!/usr/bin/env rake

require 'find'

desc 'Deploy the hugo contents to the server'
task :prod => [:prep] do
  sh 'hugo -v'

  sh 'find public -type f -name "*.gz" -delete'

  Find.find("#{Dir::pwd}/public") do |f|
    if f =~ /\.(css|js|png|jpg|JPG|PNG|CSS|JS)$/ && FileTest.file?(f)
      sh "gzip -c #{f} > #{f}.gz"
      sh "rm #{f}"
    end
  end

  sh 'ssh -p 10022 webadm@10.0.1.234 "rm -rf /var/www/blog/*"'
  sh 'ssh -p 10022 webadm@10.0.1.234 "rm -rf /home/webadm/works/public/*"'
  sh 'rsync -e "ssh -p 10022" -rltvz --omit-dir-times --delete public/ webadm@10.0.1.234:/var/www/blog'
  sh 'rsync -e "ssh -p 10022" -rltvz --omit-dir-times --delete public/ webadm@10.0.1.234:/home/webadm/works/public'
end
