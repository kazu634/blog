#!/usr/bin/env rake

require 'find'

desc 'Deploy the hugo contents to the server'
task :deploy => [:build] do
  sh 'find public -type f -name "*.gz" -delete'

  Find.find("#{Dir::pwd}/public") do |f|
    if f =~ /\.(css|js|png|jpg|JPG|PNG|CSS|JS)$/ && FileTest.file?(f)
      sh "gzip -c #{f} > #{f}.gz"
    end
  end

  sh 'rsync -e "ssh -p 10022" -az --delete public webadm@10.0.1.234:~/works'

  sh 'ssh -p 10022 webadm@10.0.1.234 "rm -rf /var/www/blog/*"'
  sh 'ssh -p 10022 webadm@10.0.1.234 "cp -pr ~/works/public/* /var/www/blog/"'
end
