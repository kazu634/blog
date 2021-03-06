#!/usr/bin/env rake

URL = 'https://github.com/yuru7/HackGen/releases/download/v2.3.0/HackGenNerd_v2.3.0.zip'
TMP_FILE = '/tmp/font.zip'
TMP_DIR = '/tmp/font'
TARGET = 'assets/font/'

desc 'Download the necessary assets.'
task :init do
  unless File.exist?('assets/font/HackGen35Nerd-Bold.ttf')
    sh "wget #{URL} -O #{TMP_FILE}"
    sh "rm -rf #{TMP_DIR} && unzip #{TMP_FILE} -d #{TMP_DIR}"
    sh "find #{TMP_DIR} -type f -name *.ttf | xargs -I% -n 1 cp -p % #{TARGET}"
  end
end
