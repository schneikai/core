module Core
  class Engine < ::Rails::Engine
    # Load core extensions from <tt>lib/core</tt> and all sub folders
    # as the very first initializer.
    initializer 'core.extensions', before: :load_config_initializers do |app|
      Dir.glob(Engine.root.join('lib', 'core', 'extensions', '**', '*.rb')).each{ |f| require f}
    end
  end
end
