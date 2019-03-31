#!/usr/bin/env rake

desc 'test'
task :test do
  cd 'content/post' do
    sh 'grep -l ecx.images-amazon.com *.md | sort | uniq | xargs sed -ie "s/http:\/\/ecx.images-amazon.com/https:\/\/images-na.ssl-images-amazon.com/g"'
    sh 'grep -l "http://www.amazon.co.jp/exec" *.md | sort | uniq | xargs sed -i -e "s/http:\/\/www.amazon.co.jp\/exec/https:\/\/www.amazon.co.jp\/exec/g"'
    sh 'rm *.mde || true'
    sh 'rm *.md-e || true'
  end
end
