#!/usr/bin/env rake

desc 'Create new post: rake new [article-name]'
task :new do
  # calculate post md file name:
  day = Time.now
  title = ARGV.last.downcase

  postname = "posts/#{day.year}/#{day.year}-#{day.strftime("%m")}-#{day.strftime("%d")}-#{title}.md"

  # generate the post md file:
  sh "hugo new #{postname}"

  # workaround
  ARGV.slice(1, ARGV.size).each{|v| task v.to_sym do; end}
end
