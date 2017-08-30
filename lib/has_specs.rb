require "has_specs/version"
require "has_specs/configuration"
require 'has_specs/base'
require 'has_specs/path_builder'

module HasSpecs
  class MatchingSpecFileDoesNotExist < StandardError;   end

  class << self
    def verify
      missing = HasSpecs::Base.verify(self.configuration)
      if missing != []
        puts "\n======== Missing Spec Files ========\n"
        puts missing.join("\n")
        puts   "====================================\n"
      end
      missing.length
    end

    def verify!
      num_missing = verify
      if num_missing > 0
        abort("There are #{num_missing} missing files")
      end
    end

    def configure
      yield configuration if block_given?
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def root=(root)
      self.configuration.root=root
    end

    def root
      self.configuration.root
    end

    def spec_root=(spec_root)
      self.configuration.spec_root=spec_root
    end

    def spec_root
      self.configuration.spec_root
    end

    def exclude=(exclude)
      self.configuration.exclude=exclude
    end

    def exclude
      self.configuration.exclude
    end

    def ignore=(ignore)
      self.configuration.ignore=ignore
    end

    def ignore
      self.configuration.ignore
    end

    def suffix=(suffix)
      self.configuration.suffix=suffix
    end

    def suffix
      self.configuration.suffix
    end

    def extension
      self.configuration.extension
    end

    def included
      self.configuration.included
    end
  end
end
