$:.unshift File.dirname(__FILE__) and require 'pry'
unless defined? Pry::Plugins
  Pry.const_set :Plugins, Class.new
end

unless RbConfig::CONFIG['host_os'] =~ /mswin/
  Pry::Commands.block_command /\.(.*)/, '.shell commands' do |cmd|
    if defined?(Pry::Plugins::VTerm) && Pry::Plugins::VTerm.aliases.include?(cmd)
      cmd = Pry::Plugins::VTerm.aliases[cmd]
    end

    Pry.config.system.call Pry.output, cmd, _pry_
  end

  class Pry::Plugins::VTerm
    class << self
      def version
        '0.0.7'
      end

      def aliases
        return @@aliases || {}
      end
    end
  end

  case ENV['SHELL']
    when %r!/(?:bash|zsh)\Z! then require 'pry/aliases/common'
  end
end
