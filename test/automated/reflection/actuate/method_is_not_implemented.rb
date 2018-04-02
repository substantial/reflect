require_relative '../../automated_init'

context "Reflect" do
  context "Reflection" do
    context "Actuate" do
      context "Method Is Not Implemented" do
        subject = Reflect::Controls::Subject.example

        reflection = Reflect.(subject, :SomeConstant, strict: true)

        random_method_name = Reflect::Controls::Namespace::Random.get

        test "Is an error" do
          assert proc { reflection.(random_method_name) } do
            raises_error? Reflect::Error
          end
        end
      end
    end
  end
end
