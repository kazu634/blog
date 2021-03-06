#!/usr/bin/env rake

OGP_DIR = 'static/ogp/'
CONTENT_DIR = 'content/'
FONT_DIR = 'assets/font/'
CONFIG = 'assets/tcardgen.yaml'

desc 'Generate OGP images'
task :tcard do
  sh "find #{OGP_DIR} -type f -name '*.png' | xargs -t --no-run-if-empty rm"

  Dir.glob("**/*.md", File::FNM_DOTMATCH, base: CONTENT_DIR).each do |article|
    unless article =~ /_index\.md/
      target = File.join(CONTENT_DIR, article)
      sh "tcardgen -f #{FONT_DIR} -o #{OGP_DIR} -c #{CONFIG} #{target}"
    end
  end

  Dir.glob("*.png", File::FNM_DOTMATCH, base: OGP_DIR).each do |png|
    src = File.join(OGP_DIR, png)

    tmp = File.basename(src, ".*") + ".webp"
    dest = File.join(OGP_DIR, tmp)

    sh "img2webp -lossy -q 50 #{src} -o #{dest}"
  end

  sh "find #{OGP_DIR} -type f -name '*.png' | xargs -t --no-run-if-empty rm"
end
