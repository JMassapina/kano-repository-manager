require "dr/logger"
require "dr/shellcmd"

module Dr
  class Package
    attr_reader :name

    include Logger
    class << self
      include Logger
    end

    def initialize(name, repo)
      @name = name
      @repo = repo
    end

    def history
      versions = []
      Dir.foreach "#{@repo.location}/packages/#{name}/builds/" do |v|
        versions.push v unless v =~ /^\./
      end

      versions.sort.reverse
    end

    def build_exists?(version)
      File.directory? "#{@repo.location}/packages/#{@name}/builds/#{version}"
    end

    def remove_build(version)
      raise "Build #{version.fg("blue")} not found" unless build_exists? version
      FileUtils.rm_rf "#{@repo.location}/packages/#{@name}/builds/#{version}"
    end

    def <=>(o)
      self.name <=> o.name
    end
  end
end
