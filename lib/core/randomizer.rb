module Core
  class Randomizer
    # Returns a random string of the given length with characters from
    # a-z and numbers from 0-9.
    #
    # ==== Options
    # * <tt>:variant</tt> - <tt>:upper</tt>, <tt>:lower</tt>, <tt>:mixed</tt> (default)
    # * <tt>:without_ambiguous</tt> - If +true+ will not return without ambiguous chars like 0/o, i/l. Defaults to +false+.
    def self.random_latin_string(length, options={})
      options[:variant] ||= :mixed
      options[:without_ambiguous] ||= true

      if options[:variant] == :lower || options[:variant] == :upper
        charset = %w(a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9 )
        charset.upcase if options[:variant] == :upper
      else
        charset = %w(a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 0 1 2 3 4 5 6 7 8 9)
      end

      charset.reject{|c| %w(i l o 1 0).include?(c.downcase) } if options[:without_ambiguous] = true

      (0...length).map{ charset.to_a[rand(charset.size)] }.join
    end

    class << self
      alias_method :random_string, :random_latin_string
    end
  end
end
