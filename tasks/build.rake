#!/usr/bin/env rake

def os
  @os ||= (
    host_os = RbConfig::CONFIG['host_os']
    case host_os
    when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
      :windows
    when /darwin|mac os/
      :macosx
    when /linux/
      :linux
    when /solaris|bsd/
      :unix
    else
      :unknown
    end
  )
end

desc 'Generate the HTML pages'
task :build do
  sh 'hugo'

  cd 'content/post' do
    if os == :linux
      sh 'grep -l ecx.images-amazon.com *.md | sort | uniq | xargs --no-run-if-empty sed -ie "s/http:\/\/ecx.images-amazon.com/https:\/\/images-na.ssl-images-amazon.com/g"'
      sh 'grep -l "http://www.amazon.co.jp/exec" *.md | sort | uniq | xargs --no-run-if-empty sed -i -e "s/http:\/\/www.amazon.co.jp\/exec/https:\/\/www.amazon.co.jp\/exec/g"'
    else
      sh 'grep -l ecx.images-amazon.com *.md | sort | uniq | xargs d -ie "s/http:\/\/ecx.images-amazon.com/https:\/\/images-na.ssl-images-amazon.com/g"'
      sh 'grep -l "http://www.amazon.co.jp/exec" *.md | sort | uniq | xargs sed -i -e "s/http:\/\/www.amazon.co.jp\/exec/https:\/\/www.amazon.co.jp\/exec/g"'
    end
    sh 'rm *.mde || true'
    sh 'rm *.md-e || true'
  end
end
