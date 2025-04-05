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
      @@taggable_attributes ||= {}
      @@taggable_attributes = @@taggable_attributes.merge(
        "any_#{name}" => [ name, type, '&&' ],
        "all_#{name}" => [ name, type, '@>' ],
        "#{name}_in" => [ name, type, '<@' ],
        "#{name}_eq" => [ name, type, '=' ]
      )

      if unique
        if type.type == :citext
          before_save { assign_attributes(name => read_attribute(name).uniq { |t| t.downcase }) }
        else
          before_save { assign_attributes(name => read_attribute(name).uniq) }
        end
      end

      scope name, -> { unscope(:where).from(select("UNNEST(#{table_name}.#{name}) AS tag"), table_name) }
      scope "uniq_#{name}", -> { public_send(name).distinct.pluck(:tag) }
      scope "count_#{name}", -> { public_send(name).group(:tag).count }
    end
  end
end
