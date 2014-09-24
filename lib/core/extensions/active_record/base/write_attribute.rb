# Make empty strings nil and remove leading and trailing white space when
# writing activerecord attributes.
# TODO: Add tests.
#
# Consider: Maybe this should be moved to the params object?
# Becasue overwriting +write_attribute+ works for database backed attributes but
# not for simple +attr_accessor+ attributes...

# Furthen research makes me believe this should be removed. Main problem is that
# when you do where.not queries the databse would not return columns with null
# values. For example where.not(name: 'kai') would not returns columns without a
# name (name is null). You would need to write where('name <> ? or name is null', 'kai').
# http://www.bignerdranch.com/blog/coding-rails-with-data-integrity/
# http://brettu.com/ruby-daily-ruby-tips-106-sensible-rails-database-migration-defaults/
# http://stackoverflow.com/questions/13542065/is-better-use-an-empty-value-as-a-or-as-null
# It is also bad because it affects other Gems because it changes ARs default behavior.
# For example in the ComfortableMexicanSofa Gem some tests where failing because of this.

class ActiveRecord::Base
  def write_attribute(attr_name, value)
    if value.class == FalseClass # Added because false.presence returns nil.
      new_value = false
    else
      new_value = value.presence
    end

    new_value.strip! if new_value.respond_to?(:strip!)
    super(attr_name, new_value)
  end
end
