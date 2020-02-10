require 'puppet/util/network_device/base'
require 'puppet/util/network_device/netscaler'
require 'puppet/util/network_device/netscaler/facts'
require 'puppet/util/network_device/transport/netscaler'

class Puppet::Util::NetworkDevice::Netscaler::Device
  attr_reader :connection
  attr_accessor :url, :transport

  def initialize(url, options = {})
    @autoloader = Puppet::Util::Autoload.new(
      self,
      "puppet/util/network_device/transport"
    )
    autoloader_params = ['netscaler']
    # As of Puppet 6.0, environment is a required autoloader parameter: (PUP-8696)
    if Gem::Version.new(Puppet.version) >= Gem::Version.new('6.0.0')
      autoloader_params << Puppet.lookup(:current_environment)
    end
    if @autoloader.load(*autoloader_params)
      @transport = Puppet::Util::NetworkDevice::Transport::Netscaler.new(url,options[:debug])
    end
  end

  def facts
    @facts ||= Puppet::Util::NetworkDevice::Netscaler::Facts.new(@transport)

    return @facts.retrieve
  end
end
