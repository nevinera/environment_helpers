RSpec.describe EnvironmentHelpers::BooleanHelpers do
  subject(:env) { ENV }

  describe "#array" do
    let(:params) { {} }
    let(:env_var) { "FOO" }
    subject(:array) { env.array(env_var, **params) }

    with_env "FOO" => "a,bc,d"

    describe "parameters" do
      context "when passed an `of' param" do
        let(:params) { {of: type} }

        context "when it is set to `strings'" do
          let(:type) { :strings }
          it { should eq %w[a bc d] }
        end

        context "when it is set to `symbols'" do
          let(:type) { :symbols }
          it { should eq %i[a bc d] }
        end

        context "when it is set to `integers'" do
          let(:type) { :integers }
          with_env "FOO" => "1,2,3"
          it { should eq [1, 2, 3] }
        end

        context "when it is set to an unsupported type" do
          let(:type) { :booleans }
          with_env "FOO" => "1,2,3"

          it "raises an error" do
            expect { subject }.to raise_error(EnvironmentHelpers::InvalidType, /Valid types: .+\. Got: booleans\./)
          end
        end

        context "when it is set to `file_paths'" do
          let(:type) { :file_paths }
          it { should eq [Pathname.new("a"), Pathname.new("bc"), Pathname.new("d")] }
        end
      end

      context "when not passed an `of' param" do
        it { should eq %w[a bc d] }
      end

      context "when passed a `delimiter' param" do
        let(:params) { {delimiter: ";"} }
        with_env "FOO" => "a;b,c;d"
        it { should eq %w[a b,c d] }
      end

      context "when not passed a `delimeter' param" do
        with_env "FOO" => "a;b,c;d"
        it { should eq %w[a;b c;d] }
      end

      context "when passed a default value" do
        let(:params) { {default: [42]} }

        context "but there is a value present at the key" do
          with_env("FOO" => "a,b,c")
          it { should eq %w[a b c] }
        end

        context "and there is not a value present at the key" do
          let(:env_var) { "FOOBAR" }
          it { should eq [42] }
        end

        context "but it is of the wrong type" do
          let(:params) { {default: 42} }

          it "raises an error" do
            expect { subject }.to raise_error(EnvironmentHelpers::BadDefault)
          end
        end
      end
    end
  end
end
