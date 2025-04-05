module PgTaggable
  class PredicateHandler < ActiveRecord::PredicateBuilder::ArrayHandler
    attr_reader :taggable_attributes

    def initialize(predicate_builder, taggable_attributes)
      @taggable_attributes = taggable_attributes
      super(predicate_builder)
    end

    def call(attribute, query)
      taggable_attribute = taggable_attributes[attribute.name]
      if taggable_attribute
        attribute.name, type, operator = taggable_attribute
        query_attribute = ActiveRecord::Relation::QueryAttribute.new(attribute.name, query, type)
        bind_param = Arel::Nodes::BindParam.new(query_attribute)
        if operator == '='
          operator = '@>'
          Arel::Nodes::NamedFunction.new('ARRAY_LENGTH', [ attribute, 1 ]).eq(query.size).and(
            Arel::Nodes::InfixOperation.new(operator, attribute, bind_param)
          )
        else
          Arel::Nodes::InfixOperation.new(operator, attribute, bind_param)
        end
      else
        super(attribute, query)
      end
    end
  end
end
