#!/usr/bin/env rake

desc 'Create new post: rake new [article-name]'
task :new do
  # calculate post md file name:
  day = Time.now
  title = ARGV.last.downcase

  postname =  "post/#{day.year}-#{day.strftime("%m")}-#{day.strftime("%d")}-#{title}.md"

  # generate the post md file:
  sh "hugo new #{postname}"

  # Replace the url string:
  cmd = %Q!sed -i -e "s/url = \\"\\"/url = \\"\\/#{day.year}\\/#{day.strftime("%m")}\\/#{day.strftime("%d")}\\/#{title}\\/\\"/" content/#{postname}!
  sh cmd

  # Remove `*.md-e` file:
  sh 'find content/post/ -type f -name "*.md-e" -delete'

  # workaround
  ARGV.slice(1, ARGV.size).each{|v| task v.to_sym do; end}
end
