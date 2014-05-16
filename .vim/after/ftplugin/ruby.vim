if has('ruby')
  ruby << EOS
if File.exists? 'Gemfile'
  require 'bundler'
  Bundler.require
end

VIM::command("setlocal path=" + $LOAD_PATH.join(","))
EOS
endif
