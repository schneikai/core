# Make empty strings nil and remove leading and trailing white space when
# writing activerecord attributes.
# TODO: Add tests.
#
# Consider
# Maybe this should be moved to the params object?
# Becasue overwriting +write_attribute+ works for database backed attributes but
# not for simple +attr_accessor+ attributes...

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
