module PgTaggable
  module Taggable
    @@taggable_attributes = nil

    def predicate_builder
      register_taggable_handler
      super
    end

    def register_taggable_handler
      return if @register_taggable_handler || !@@taggable_attributes

      @register_taggable_handler = true
      predicate_builder.register_handler(Array, PgTaggable::PredicateHandler.new(predicate_builder, @@taggable_attributes))
    end

    def taggable(name, unique: true)
      type = type_for_attribute(name)
      taggable_attributes = {
        "any_#{name}" => [ name, type, '&&' ],
        "all_#{name}" => [ name, type, '@>' ],
        "#{name}_in" => [ name, type, '<@' ],
        "#{name}_eq" => [ name, type, '=' ]
      }
      @@taggable_attributes ||= {}
      @@taggable_attributes = @@taggable_attributes.merge(taggable_attributes)

      if unique
        if type.type == :citext
          before_save { assign_attributes(name => read_attribute(name).uniq { |t| t.downcase }) }
        else
          before_save { assign_attributes(name => read_attribute(name).uniq) }
        end
      end

      scope name, -> { unscope(:where).from(select("UNNEST(#{table_name}.#{name}) AS tag"), table_name) }
      scope "distinct_#{name}", -> { public_send(name).select(:tag).distinct }
      scope "uniq_#{name}", -> { public_send("distinct_#{name}").pluck(:tag) }
      scope "count_#{name}", -> { public_send(name).group(:tag).count }
      taggable_attributes.keys.each do |key|
        scope key, ->(value, delimiter = ',') { where(key => value.is_a?(Array) ? value : value.split(delimiter)) }
        scope "not_#{key}", ->(value, delimiter = ',') { where.not(key => value.is_a?(Array) ? value : value.split(delimiter)) }
      end
    end
  end
end
