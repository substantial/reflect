module Reflect
  class Reflection
    attr_reader :subject
    attr_reader :constant
    attr_reader :strict

    def subject_constant
      @subject_constant ||= Reflect.subject_constant(subject)
    end

    def initialize(subject, constant, strict)
      @subject = subject
      @constant = constant
      @strict = strict
    end

    def self.call(subject, constant_name, strict: nil)
      build(subject, constant_name, strict: strict)
    end

    def self.build(subject, constant_name, strict: nil)
      strict = Default.strict if strict.nil?

      subject_constant = Reflect.subject_constant(subject)

      constant = Reflect.get_constant(subject_constant, constant_name, strict: strict)
      return nil if constant.nil?

      instance = new(subject, constant, strict)
    end

    def constant_accessor?(name)
      constant.respond_to?(name)
    end

    def get(accessor_name)
      result = get_constant(accessor_name)
      return nil if result.nil?

      constant = Reflect.subject_constant(result)
      self.class.new(subject, constant, strict)
    end

    def get_constant(accessor_name)
      if !constant_accessor?(accessor_name)
        if strict
          raise Reflect::Error, "Constant #{constant.name} does not have accessor #{accessor_name}"
        else
          return nil
        end
      end

      constant.send(accessor_name)
    end

    module Default
      def self.strict
        true
      end
    end
  end
end